#!/bin/bash


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
skip_wav=0

regenerate_cache=0
populate_cache=0

check_encoder=0

run_tool1=1
run_tool2=1
run_tool3=1

argc=0
declare -a argv
function add_argv()
{
	(( argc ++ ))		|| true
	argv[$argc]="$1"
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
  echo "slepping $time seconds"
  sleep "$time"
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




display_help()
{
  echo "

analyse mp3 offsets between traktor and rekordbox

usage: `basename $0` file1 [file2]


CSV output:
  -C  skip csv header

caching:
  <default> never run decoders (only depend on cache)
  -p  run decoders if needed   (populate cache)
  -f  always re-ren decoders   (regenerate cache)
    
other:
  -e  also generate mp3_encoder.csv
  -d  debug
  -dd debug trace

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

function do_uniq()
{
  if [ $do_uniq -ge 1 ]; then 
    uniq 
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
    cat - | awk '{print $NF }' | do_uniq | paste -s -d "$subfield_separator" | awk '{if(NF){A=1}} {print } END{if(A==0){print "UNK"}}'
  fi
}


# sub-tools to check:
# sudo apt-get install ffmpeg lltag eyed3 mp3info id3v2 libimage-exiftool-perl libid3-tools id3tool
# https://askubuntu.com/questions/226773/how-to-read-mp3-tags-in-shell



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
  
  tee_to_file=1
  
 
  echo "$var" | if [ "$tee_to_file" -ge 1 ]; then
    tee -a "$out_csv1"
  else
    cat -
  fi
}



function get_duration()
{
  local file="$1"
  
  mediainfo --Inform="Audio;%Duration%" "$file"
}
  
function run_tool()
{
  local file_in="$1"
  local file_out="$2"
  local sep="$3"

  shift 3

  tmp_folder="tmp_DECODED_wavs"
  mkdir -p "$tmp_folder"
  cache_file="${tmp_folder}/${file_out}"

  ###
  if [ $regenerate_cache -ge 1 ]; then
    rm "$cache_file"
  fi
  
  if [ ! -f "$cache_file" ]; then
     #echo " cache not found: $cache_file "
     if [ $populate_cache -ge 1 ]; then
        # https://stackoverflow.com/questions/8110530/check-free-disk-space-for-current-partition-in-bash
        free_bytes="`echo $(($(stat -f --format="%a*%S" .)))`"
        free_mb=$(( free_bytes / 1000000 ))
        min_mb=700
        if [ $free_mb -lt $min_mb ]; then
          echo_stderr "NO MORE DISK SPACE "
          
          echo "0"   # this is catched by the calling function
          return
        fi
      
        "$@"
        mv "$file_out" "${tmp_folder}"
     fi
  else
    # echo "cache was found"
    nop=1
  fi
  
  if [ ! -f "$cache_file" ]; then
    echo "0"
  else
    get_duration "$cache_file"
  fi
}


function test_1_file()
{
  local full_file="$1"
  local file="`basename "$file"`"
  
  file_fhg_default="$file.fhg.default.wav"
  file_fhg_of1="$file.fhg.of1.wav"
  file_mpg_default="$file.mpg.default.wav"
  file_mpg_nogapless="$file.mpg.nogapless.wav"

  dur1="`run_tool "$file" "$file_fhg_default"    -- mp3sDecoder -if "$full_file" -of "$file_fhg_default" -classic `"
  #dur2="`run_tool "$file" "$file_fhg_of1"        -- mp3sDecoder -if "$full_file" -of "$file_fhg_of1"     -classic -of1 `"
  dur2="0"
  dur3="`run_tool "$file" "$file_mpg_default"    -- mpg123              -w "$file_mpg_default"   "$full_file" `"
  dur4="`run_tool "$file" "$file_mpg_nogapless"  -- mpg123 --no-gapless -w "$file_mpg_nogapless" "$full_file" `"
  
  durs=()
  durs+=("${dur1}")
  
  if [ "${durs[*]}" == "0" ]; then
    echo_stderr "ending processing because of size=0 "
    return 
  fi
  
  durs+=("${dur2}")
  durs+=("${dur3}")
  durs+=("${dur4}")
 
  durs+=("${full_file}")
  
  #declare -p durs

  #echo "$wrote_csv_header"
  
  if [ $wrote_csv_header -eq 0 ]; then
    csv_header=( "fhg_default" "fhg_of1" "mpg_default" "mpg_nogapless" "file" )
    array_to_csv   csv_header
    wrote_csv_header=1
  fi

  #joined_durs="`echo ${durs} ${file} | join_seperator `"
  array_to_csv durs   
 
}


#####

require_tools "mpg123"  "mp3sDecoder"


    
while [ "$#" -ge 1 ]; do
  case "$1" in
  -d|--debug)
    debug=1
    ;;
    
  -dd)
    debug=2
    set -x
    ;;
 
  -C)
    wrote_csv_header=1
    ;;

  -p)
    populate_cache=1
    ;;

  -f)
    populate_cache=1
    regenerate_cache=1
    ;;
    
  #-w)
  #  skip_wav=1
  #  ;;
    
  -h)
    display_help
    ;;
    
  -e)
    check_encoder=1
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

out_csv1="mp3_offset.csv"
out_csv2="mp3_encoder.csv"

rm -f "$out_csv1"  

for file in "${argv[@]}" ; do
  if [ ! -f "$file" ]; then
    continue
  fi
  
  ext="`extension_lower "$file" `"
  
  case "$ext" in
  mp3)
    test_1_file "$file"
    ;;
  *)
    nop="nop"
    #echo "ignoring $file"
    ;;
  esac
  
  #exit 
done

if [ "$check_encoder" -ge 1 ]; then
  check_encoder.sh -c "${argv[@]}" | tee "$out_csv2"
fi

exit 0

