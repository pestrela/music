#!/bin/bash



# 
# Overview of the Cue tools:
#
# cue_renumber_files.py:
#   - renames  mp3 files, in sequence
# 
# cue_make_tracklist.sh:
#   - from a folder, generates basic text files
#
# cue_convert_timestamps.sh:
#   - convert MMM:SS to HH:MM:SS format 
#
# cue_merge_cues.py: 
#   - merges tracklist and a cue. Can input tracklist from itself or seperate file.
#    also converts cue to txt
#
# cue_rename_cue.sh: 
#   - matches the CUE file contents with the FILE tag
#



set -e
set -u

do_backup_opt="--in-place"   # no backup by default

media_files_extensions="mp3|mp4|avi|m4a|opus|webm|wav|flac|alac|aiff"
debug=0
do_rename=0

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
usage: `basename $0` file1.mp3 [file2.mp3]

Rewrites the FILE line of each CUE to its associated mp3.
MP3 and CUE need to have the  have the same basefilename!

options:
   <default>     Inplace operation
  -b             do backup as .bak 
  -d             debug
  
  -r|-rename  BASE1 BASE2  - wrapper to mmv
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
# $1:  A.B.C
# $2:  D
#
# Ret: A.B.X
#
function replace_extension()
{
	echo "`remove_extension "${1}"`.${2}"
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



function test_1_file()
{
  local file="$1"

  cue_file="`replace_extension "$file" "cue"`"
  
  if [ ! -r "$cue_file" ]; then
    die "unredable cue $cue_file"
  fi
  
  new_line="FILE \"$file\" MP3"
  sed_cmd="s|^FILE.*MP3.*$|$new_line|"
  
  sed  "$do_backup_opt" -e  "$sed_cmd" "$cue_file"
}


#####
#####

#require_tools "mpg123"  "mp3guessenc" "ffprobe" "ffmpeg" "mediainfo" 

    
while [ "$#" -ge 1 ]; do
  case "$1" in
  -d|--debug)
    debug=1
    ;;
    
  -dd)
    debug=2
    set -x
    ;;

  -b)
    do_backup_opt="--in-place='bak'"
    ;;
    
  -h)
    display_help
    ;;
    
  -r|--rename)
    do_rename=1
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
 
if [ $do_rename -ge 1 ]; then
  if [ "$argc" -ne 2 ]; then
    echo "Error: need 3 filespecs for rename"
    echo ""
    display_help
  fi

  base1="${argv[1]}"
  base2="${argv[2]}"
 
  #set -x
  mmv "${base1}*" "${base2}#1"
  
  $0 "${base2}mp3"
  
  exit 0
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



exit 0




