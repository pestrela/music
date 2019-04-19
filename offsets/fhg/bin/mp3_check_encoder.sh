#!/bin/bash

set -e
set -u

media_files_extensions="mp3|mp4|avi|m4a|opus|webm|wav|flac|alac|aiff"
tag_comment=0
tag_filename=0
debug=0
output_type=1
wrote_csv_header=0
full_output=0
field_separator="|"
subfield_separator="_"
do_uniq=1
justify=80

run_tool1=1
run_tool2=1
run_tool3=1
do_ffprobe_json=0

argc=0
declare -a argv
function add_argv()
{
	(( argc ++ ))		|| true
	argv[$argc]="$1"
}


display_help()
{
  echo "

check encoder of files, using several tools
usage: `basename $0` file1 [file2]

output format:
  -f     full output
  -s     short output
  -1     one-line ouput  (default)
  -c     csv output
  -C     csv output (no header)

repeated tags:
  -u     filter out repeated tags    (default)
  -r     show repeated tags 
  
options:
  -j     size to justify one-liner output
  
sub-tools:
  --ffmpeg|--ffprobe    ONLY run ffprobe 
  --mp3guessenc         ONLY run mp3guessenc
  --mediainfo           ONLY run mediainfo
  
ffprobe json:
  --ffprobe_json|-J   files        (full dump only)
  
 "
  exit 1

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




function do_sleep()
{
  local time="$1"
  echo "slepping $time seconds"
  sleep "$time"
}



function die_if_failure()
{
  local ret="$1"
  if [ "$ret" -ge 1 ]; then
    echo "exiting."
    exit "$ret"
  fi
}

# library functions follow

#
# A.B.C -> C
#
function extension()
{
	#echo "${1##*.}"
	echo "$1" | awk -F . '{print $NF}'

}

function extension_lower()
{
	#echo "${1##*.}"
	echo "$1" | awk -F . '{print $NF}' | tr '[:upper:]' '[:lower:]'
}


#
# A.B.C -> A.B
#
function remove_extension()
{
	echo "${1%.*}"
}

#
# A.B.C X -> A.B - X.C
#
function add_posttag()
{
	local FILE="$1"
	local ADD="$2"
	local SEP="${3:- - }"

	local B="`remove_extension "${FILE}"`"
	local E="`extension "${FILE}"`"

	echo "${B}${SEP}${ADD}.${E}"
}

function do_uniq()
{
  if [ $do_uniq -ge 1 ]; then 
    uniq 
  else
    cat -
  fi

}

function join_seperator()
{
  #sed 's/ $//' | 
  sed 's/ /\n/g' | paste -s -d "$field_separator"
}

function array_to_csv () 
{
  # https://stackoverflow.com/questions/11180714/how-to-iterate-over-an-array-using-indirect-reference
  #https://mywiki.wooledge.org/BashFAQ/005  
  #IFS=/; echo "${!arr[*]}"; unset IFS

  local arrayname="$1"
  local tmp="$arrayname[@]"
  local array=( "${!tmp}" )
  local FS="$field_separator"
  local var
  

  local quote=""
  local do_quote=0
  
  # Print each element enclosed in quotes and separated by $FS
  if [ $do_quote -ge 1 ]; then
    printf -v var "\"%s\"$FS"  "${array[@]}"
  else
    printf -v var "%s$FS"  "${array[@]}"
  
  fi
  
  # Chop trailing $FS
  var=${var%$FS}
  
  tee_to_file=0
  
 
  echo "$var" | if [ "$tee_to_file" -ge 1 ]; then
    tee -a "$out_csv1"
  else
    cat -
  fi
}



function massage_output()
{
  if [ $full_output -ge 1 ]; then
    cat -
    return 
  fi

  egrep -i "encoder|librar" | do_uniq | \
  if [ $output_type -eq 0 ]; then
    cat - 
  else
    cat - | awk '{print $NF }' | do_uniq | paste -s -d "$subfield_separator" | awk '{if(NF){A=1}} {if(NF){print }} END{if(A==0){print "UNK"}}'
  fi
}


# sub-tools to check:
# sudo apt-get install ffmpeg lltag eyed3 mp3info id3v2 libimage-exiftool-perl libid3-tools id3tool
# https://askubuntu.com/questions/226773/how-to-read-mp3-tags-in-shell



function run_tool()
{
  local file="$1"
  local tool="$2"

  shift 2
  
  if [ $output_type -eq 0 ]; then
    echo ""
    echo "********************************"
    echo "Running ${tool}:"
  fi
  
  "$tool" "$@" "$file" 2>&1 | massage_output #"$tool"
}



function get_tags()
{
  local file="$1"
  
  tag1=""
  tag2=""
  tag3=""
  tags=()
  
  if [ "$run_tool1" -ge 1 ]; then
    tag1="`run_tool "$file" ffprobe -hide_banner -loglevel verbose `"
    tags+=("${tag1}")
  fi
  
  if [ "$run_tool2" -ge 1 ]; then
    tag2="`run_tool "$file" mp3guessenc -s `"
    tags+=("${tag2}")
    
    #tag2="`run_tool "$file" mp3guessenc -s `"
    #tags+=("${tag2}")
  fi
 
  if [ "$run_tool3" -ge 1 ]; then
    tag3="`run_tool "$file" mediainfo `"
    tags+=("${tag3}")
  fi
  
  tags+=("$file")
  
  # nogap: 
  #eyeD3 -P lameinfo r.mp3  2>/dev/null | grep -a -c nogap
  
  joined_tags="`echo ${tags} "$file" | join_seperator `"
  
  
  case $output_type in
  0)
    # full output
    echo ""
    echo ""
    echo "*************************************************"
    echo "Checking: $file"
    echo "$tag1"
    echo "$tag2"
    echo "$tag3"
    return 
    ;;
    
  1)
    # short output
    
    #tag="`echo "${tag1} ${tag2} ${tag3}" | join_seperator `"

    #paste -s -d "$field_separator"
    printf "%-*s %s\n" "$justify" "$file" "$joined_tags"
    ;;
    
  2)
    # csv or one-liner output
    if [ $wrote_csv_header -eq 0 ]; then
      csv_header=( "ffprobe" "mp3guessenc"  "mediainfo" "file" )
      array_to_csv   csv_header
      wrote_csv_header=1
    fi
    
    array_to_csv tags
    ;;
  *)
    die "Unk output type"
    ;;
  esac
  
}



function test_1_file()
{
  local file="$1"

  if [ "$do_ffprobe_json" -ge 1 ]; then
    ffprobe -v error -print_format json -show_format -show_streams  "$file"
    echo ","
  else
    get_tags "$file"
  fi
  
  
}


#####
#####

require_tools "mpg123"  "mp3guessenc" "ffprobe" "ffmpeg" "mediainfo" 


    
while [ "$#" -ge 1 ]; do
  case "$1" in
  -d|--debug)
    debug=1
    ;;
    
  -dd)
    debug=2
    set -x
    ;;
  
  -s)
    output_type=0
    full_output=0
    ;;
    
  -f)
    output_type=0
    full_output=1
    ;;
    
  -1)
    output_type=1
    ;;
    
  -c)
    output_type=2
    ;;
    
  -C)
    output_type=2
    wrote_csv_header=1
    ;;
    
  -r)
    do_uniq=0
    ;;
    
  -u)
    do_uniq=1
    ;;

  -j)
    justify="$2"
    shift
    ;;
    
  --tag_metadata|--tag_composer)
    tag_comment=1
    ;;
    
  --tag_filename)
    tag_filename=1
    ;;

  --ffmpeg|--ffprobe)
    run_tool1=1
    run_tool2=0
    run_tool3=0
    ;;
    
  --mp3guessenc)
    run_tool1=0
    run_tool2=1
    run_tool3=0
    ;;

  --mediainfo)
    run_tool1=0
    run_tool2=0
    run_tool3=1
    ;;
  
  --ffprobe_json|-J)
    do_ffprobe_json=1
    ;;
    
  -h)
    display_help
    ;;
    
  *)
    add_argv "$1"
    ;;
    
  esac
  
  shift
done

if [ "$argc" -eq 0 ]; then
  echo "Error: no files specified"
  echo ""
  display_help
fi


if [ "$do_ffprobe_json" -ge 1 ]; then
  echo "["
fi



for file in "${argv[@]}" ; do
  if [ ! -f "$file" ]; then
    continue
  fi
  
  ext="`extension_lower "$file" `"
  
  case "$ext" in
  mp3|mp4|avi|m4a|opus|webm|wav|flac|alac|aiff)
    test_1_file "$file"
    ;;
  *)
    nop="nop"
    #echo "ignoring $file"
    ;;
  esac
  
done

if [ "$do_ffprobe_json" -ge 1 ]; then
  echo "{ }]"
fi



exit 0

