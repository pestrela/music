#!/bin/bash

#
# Command line options: https://github.com/ytdl-org/youtube-dl/blob/master/README.md#output-template-examples
# How To See All Youtube Videos: 	   goto the user's Youtube home page / "uploads" / "Play all"  
#

# more scripts: https://github.com/TheFrenchGhosty/TheFrenchGhostys-YouTube-DL-Archivist-Scripts
# youtube-dl alternatives:
#  https://source.netsyms.com/Mirrors/youtube-dl
#  https://github.com/l1ving/youtube-dl/
#  https://github.com/Athlon1600/youtube-downloader
#  https://github.com/jweslley/youtube-dl-mp3/blob/master/youtube-dl-mp3

set -u
#set -e

function display_help()
{
  echo "

usage: `basename $0` <url|-> [format_specifier]

Url specifier:
 a) either an URL starring with HTTP, 
 b) or '-' to read list of urls from stadin (CTRL+D to exit)
 
Format Specifier:
 3: mp3 file
 4: mp4 file
 both: mp3+mp4
 281: opus
 q: query format
 

Options:
 -k      keep intermediate files
 -Q      query formats and download 
 -q      ONLY query formats, and exit
 -B      rename backup extensions to windows style (version before the extension)
 
 -r HH:MM  get a range on postprocess. Specify hhours:minutes start point
 
General options: 
 -h      help
 -d      debug trace
  
  
  "
  exit 1

}


# downgrading:
#   https://github.com/ytdl-org/youtube-dl/releases
# curl: 
#    https://ytdl-org.github.io/youtube-dl/download.html
#

argc=0
declare -a argv

function add_argv()
{
	(( argc ++ ))		|| true
	argv[$argc]="$1"
}



function echo_var()
{
  local var="$1"
  echo "${var} -> ${!var}"
}



function assert_command_exists ()
{
	local FILE="$1"
	local RET=0
	check_command_exists "$FILE"  || RET=1

	if [ $RET -ge 1 ]; then
		echo_var PATH
		die "assert_command_exists: '${1:-}' command was not found"
	fi

	return 0
}

#
# this code supports broken "which" of sun machines
# $1 - command name
#
# returns 1 of error
# returns 0 if Ok
function check_command_exists ()
{
	local FILE="`which "${1:-}" `"
		
	if [[ -z "$FILE" || ! -r "$FILE" ]]; then
		return 1
	else
		return 0
	fi
}


#
# $@ - tools names
#
function require_tools ()
{
	local FILE=""

	for FILE in "$@" ; do
		assert_command_exists "$FILE"
	done
}


function echo_stderr ()
{
	echo -e "$@" >&2
}



#
# Generic die function. 
# Shows a message, then exits the program
#
function die()
{
	set +x
  echo_stderr ""
	echo_stderr "********************"
	echo_stderr "ERROR: ${1:-}"
	echo_stderr "********************"
	echo_stderr ""
	
  
	exit 99
}



function die_if_failure()
{
  local ret="$1"
  if [ "$ret" -ge 1 ]; then
    echo "exiting."
    exit "$ret"
  fi
}

function do_sleep()
{
  local time="$1"
  echo "(slepping for $time seconds)"
  sleep "$time"
}

require_tools "ffmpeg"  "youtube-dlc"


dry_run=0

force_query_format=0
only_query_format=0
    
dump_format=0
need_format=0
tool="youtube-dlc"
tool="youtube-dl"

tool_disabled_options="--verbose  --embed-thumbnail --restrict-filenames --add-metadata --merge-output-format mp4"

filename_options_default="-o %(title)s-%(id)s.%(ext)s"
filename_options=" -o %(title)s.%(ext)s "

tool_global_options=" --ignore-errors   --ignore-config --no-playlist --quiet "
tool_local_options=""
keep=0
keep_opt=""

do_range=0
range_start="00:00"
#range_duration="01:00"
range_duration="15:00"

post_processor_args=""

#set -x

function display_formats()
{
	local url="$1"

	$tool -F "$url"
}


function rename_backup_extension()
{
  shopt -s nullglob
  
  for f_name in *.~*~; do 
      f_bak_ext="${f_name##*.}"
      f_bak_num="${f_bak_ext//[^0-9]/}"
      f_orig_name="${f_name%.*}"
      f_only_name="${f_orig_name%.*}"
      f_only_ext="${f_orig_name##*.}"
      mv --backup=numbered  "$f_name" "$f_only_name ($f_bak_num).$f_only_ext"
  done

}


while [ "$#" -ge 1 ]; do
  case "$1" in
  -d|--debug)
    debug=1
    set -x
    ;;
 
  -r|--range|--start|-s)
    do_range=1
    range_start="$2"
    shift 1
    ;;
    
  -S)
    do_range=1
    range_start="$2"
    shift 1
    range_duration="01:00"
    ;;

    
  -q|--also_query)
     force_query_format=1
     ;;
      
  -i|-Q|--only_query_format)
     only_query_format=1
     force_query_format=1
     ;;
     
     
  --qqtabbar)
     ## this will download videos on windows explorer
     set -x
     download_folder="/mnt/c/Root/2 Downloads/youtube-dl"
     cd "$download_folder"
     
     # will read stdin
     ;;
    
  -k)
    keep=1
    keep_opt="--keep-video"
    filename_options=" -o %(title)s-%(format_id)s.%(ext)s "
	  ;;
    
  -B)    
    rename_backup_extension
    exit 0
    ;;
    
  -h)
    display_help
    ;;
    
  # this is to input list as stdin
  -)  
    add_argv "$1"
    ;;
    
  -*)
    die "unknown parameter $1"
    ;;
  
    
  *)
    add_argv "$1"
    ;;
    
  esac
  
  shift
done


case $argc in
0)
	url="-"
	need_format=0
  format="3"
  ;;
  
1)
	url="${argv[1]}"
	need_format=0
  format="3"
	;;

2)
	url="${argv[1]}"
	need_format=0
	format="${argv[2]}"
	;;
	
*)
	echo "too many args specified"
	exit 1
	;;
esac





if [ $force_query_format -ge 1 ]; then
	need_format=0
	format="q"
fi
  

if [ "$url" == "-" ]; then

	playlist="/tmp/youtube_dl_playlist.txt"
  error_summary="youtube_dl_errors.txt"
  got_errors=0
  

  #  echo "please enter urls"
  cat - | egrep "http" > "$playlist"

  # https://mywiki.wooledge.org/bashfaq/005#loading_lines_from_a_file_or_stream
  mapfile -t files < "$playlist"
    
  
  for file in "${files[@]}" ; do 
    
    echo ""
    echo ""
    echo "********************"
    echo "processing:  $file"
    if [ $dry_run -ge 1 ]; then
      echo $0 "$file" "$format"
      
    else
      ret=0
      #set -x
      $0 "$file" "$format" || ret=$?
      #set +x
      
      if [ $ret -ge 1 ]; then
        (
        echo "" 
        echo "*******" 
        echo "$file"
        ) >> "$error_summary"
        
        got_errors=1
        #exit 1
      fi
      
      do_sleep 1
    fi
    
  done
  
  if [ "$got_errors" -ge 1 ]; then
    echo ""  
    echo ""  
    echo ""  
    echo "***********************"
    echo " WARNING: THERE WERE ERRORS "  
    cat "$error_summary"
    echo "***********************"
    
    exit 1
  fi
  
  exit 0
fi

#url="`echo "$url" | sed 's/&.*$/ /' | awk '{print $1}'`"
url="`echo "$url" | awk '{print $1}'`"

case "$url" in 
http*)
  ok=1
  ;;
*)
  echo "ERROR: URL doesnt start with httpt    ($url)"
  exit 1
  ;;
esac



####
if [ $do_range -ge 1 ]; then
  set -x
  #https://unix.stackexchange.com/questions/230481/how-to-download-portion-of-video-with-youtube-dl-command
 
  post_processor_args="-ss ${range_start}:00.00 -t $range_duration"
  format="raw_audio"
fi


if [ "$format" == "q" ]; then
	need_format=1
fi

if [ $need_format -ge 1 ]; then
	display_formats "$url"

  if [ $only_query_format -ge 1 ]; then
    exit 0
  fi  
  
	echo "please input format:"
	read format
fi


case $format in
both|b)
  ret=0
	$0 "$url" mp4  || ret=$?
  die_if_failure "$ret"
  
  do_sleep 1

        
	$0 "$url" mp3  || ret=$?
  die_if_failure "$ret"

	exit 0
	;;

v|video)
    format="bestvideo[height<=?1080]/best"
    ;;
    
  
mp4_full_HQ)
	
	#FORMAT="bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4"
	#TOOL_LOCAL_OPTIONS="--recode-video mp4  --postprocessor-args '-vcodec copy -b:a 256k'  --audio-quality 0   --keep-video --add-metadata "
	
	#Rekordbox requirements:
	# Video
	# 　Extension: avi, mpg, mp4, m4v, mov, qtz
	# Video format
	#   Codec: h.264, mpeg-4, mpeg-2
	#   Resolution: up to 1920 x 1080
	# Audio format
	#   LPCM (aiff), aac, mp3
  #
  # best_mp4_video:  'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'
	
	format="bestvideo[height<=?1080]+251/bestvideo[height<=?1080]+bestaudio/best"
	tool_local_options='--recode-video mp4  --audio-quality 0   --add-metadata --merge-output-format mp4'
	post_processor_args="-vcodec libx264 -b:a 256k"
	;;
	
	# todo:  [height <=? 720][tbr>500]"
	
mp4|4|v)
	# guide to merge mp4 and opus back to mp4
	# https://github.com/ytdl-org/youtube-dl/issues/12299

	format="bestvideo[ext=mp4][height<=?1080]+bestaudio[acodec=opus]/bestvideo[ext=mp4][height<=?1080]+bestaudio/best"
	tool_local_options='--recode-video mp4   --add-metadata ' 
	post_processor_args="-vcodec copy -b:a 256k"
	;;	
	
mp3|3|a)
	format="251/bestaudio"
	tool_local_options="--extract-audio --audio-format mp3 --audio-quality 0  --add-metadata "
	
	# generate vbr instead of cbr 
	# see also: https://appuals.com/why-converting-youtube-to-320kbps-mp3-is-a-waste-of-time/
	;;
  
wav|w|full|251|opus)
	format="251/bestaudio"
	tool_local_options="--extract-audio  --audio-format wav"
	;;

raw_audio|raw)
	format="251/bestaudio"
	tool_local_options=" --extract-audio "
	;;
  
  
default|raw_all)
	format=""
	tool_local_options=""
	;;

*)
	;;
esac




if [ $dump_format -ge 1 ]; then
	display_formats "$url"
fi


if [ "$format" != "" ]; then
	format_option="-f $format"
else
	format_option=""
fi

echo "format option: $format_option"
echo ""	
  
mkdir -p "/tmp/youtube_dl"
old_pwd="`pwd`"
cd "/tmp/youtube_dl"
rm /tmp/youtube_dl/*   2> /dev/null

  
ret=0
set -x
$tool $format_option $tool_local_options  --postprocessor-args "$post_processor_args"   $tool_global_options  $keep_opt $filename_options "$url"  < /dev/null || ret=$?
set +x
die_if_failure "$ret"

#flac_tester.sh  -m /tmp/youtube_dl/*

mv  --backup=numbered  --target-directory="$old_pwd" /tmp/youtube_dl/*

cd "$old_pwd"
rename_backup_extension

#read


exit 0

#flac_tester *



