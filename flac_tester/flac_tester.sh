#!/bin/bash

#echo $PATH

media_files_extensions="mp3|mp4|avi|m4a|opus|webm|wav|flac|alac|aiff"
limit_seconds="120"
tag_comment=0
tag_filename=0
debug=0

tester_tool="flac_tester.py"
convert_tool="`which ffmpeg`"
if [ "$?" -eq 1 ]; then
  echo "please ensure that ffmpeg command is installed"
  exit -1
fi

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

usage: `basename $0` file1 [file2]

options:
 -m      add result to metadata COMPOSER field
 -f      add result to end of filename
 -t sec  seconds to consider
 
 -d      show sub-command execution
 -dd     full trace
 "
  exit 1

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



test_1_file()
{
	#set -x
	tmp_wav_file="/tmp/flac_tester_$$.wav"

  if [ $debug -ge 1 ]; then
    echo ""
    set -x
  fi
  
	$convert_tool -loglevel panic $limit_seconds_opt -i "$file" "$tmp_wav_file" &> /dev/null
  
  if [ $debug -le 1 ]; then
    set +x
  fi
  
	if [ ! -f "$tmp_wav_file" ]; then
    exit 1
  fi
  
	cutoff="` "$tester_tool" "$tmp_wav_file"  "$file" `"
  echo -n "${file}: $cutoff        "
  
	rm "$tmp_wav_file"
  
  #set -x
  if [ "$tag_comment" -ge 1 ]; then
    # https://askubuntu.com/questions/899383/how-would-i-batch-edit-video-file-metadata-for-an-mp4 
    # https://wiki.multimedia.cx/index.php/ffmpeg_metadata
    # https://superuser.com/questions/326629/how-can-i-make-ffmpeg-be-quieter-less-verbose
    
    ext="`extension "$file" `"
    new_file="$file.new.$ext"
    
    if [ $debug -ge 1 ]; then
      echo ""
      set -x
    fi

    # FIXME: check alternatives that doesn't rewrite the mp3
    # issue is support for mp4
    #
    # https://unix.stackexchange.com/questions/4961/which-mp3-tagging-tool-for-linux
    # https://askubuntu.com/questions/226773/how-to-read-mp3-tags-in-shell
    ffmpeg -y -loglevel warning -hide_banner   -i "$file"  -codec copy -metadata composer="$cutoff"  "$new_file"

    if [ $debug -le 1 ]; then
      set +x
    fi
    
    mv "$new_file" "$file"
    echo -n "(tag: composer)   "
  fi
    
  if [ "$tag_filename" -ge 1 ]; then
    case "$file" in
    *[0-9]" khz."*)
      echo "(tag: no_filename)"
      ;;
      
    *)
      new_file="`add_posttag "$file" "$cutoff" `"
      mv -b "$file" "$new_file"
      echo -n "(tag: filename)"
      ;;
    esac 
  fi
  
  echo ""
    
}


while [ "$#" -ge 1 ]; do
  case "$1" in
  -d|--debug)
    debug=1
    ;;
    
  -dd)
    debug=2
    set -x
    ;;
    
  -t|--time)
    limit_seconds="$2"
    shift
    ;;
    
  -m|--tag_metadata|--tag_composer)
    tag_comment=1
    ;;
    
  -f|--tag_filename)
    tag_filename=1
    ;;
    
  *)
    add_argv "$1"
    ;;
    
  esac
  
  shift
done

if [ "$argc" -eq 0 ]; then
  display_help
fi


if [ "$limit_seconds" -ge 1 ]; then
  limit_seconds_opt="-t $limit_seconds"
fi


for file in "${argv[@]}" ; do
  if [ ! -f "$file" ]; then
    continue
  fi
  
  ext="`extension_lower "$file" `"
  #echo "$ext"
  
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


exit 0

