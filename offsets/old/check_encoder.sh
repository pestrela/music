#!/bin/bash


media_files_extensions="mp3|mp4|avi|m4a|opus|webm|wav|flac|alac|aiff"
tag_comment=0
tag_filename=0
debug=0
output_type=1
wrote_csv_header=0
full_output=0
field_separator=","
subfield_separator="_"
do_uniq=1
justify=80


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

repeated tags:
  -u     filter out repeated tags    (default)
  -r     show repeated tags 
  
options:
  -j     size to justify one-liner output
  
sub-tools)
  --ffmpeg|--ffprobe    ONLY run ffprobe 
  --mp3guessenc         ONLY run mp3guessenc
  --mediainfo           ONLY run mediainfo
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
  
  "$tool" "$@" "$file" 2>&1 | massage_output
}


function join_seperator()
{
  #sed 's/ $//' | 
  sed 's/ /\n/g' | paste -s -d "$field_separator"
}

function get_tags()
{
  local file="$1"
  
  tag1=""
  tag2=""
  tag3=""
  tags=""
  
  if [ "$run_tool1" -ge 1 ]; then
    tag1="`run_tool "$file" ffprobe -hide_banner -loglevel verbose `"
    tags+="${tag1} "
  fi
  
  if [ "$run_tool2" -ge 1 ]; then
    tag2="`run_tool "$file" mp3guessenc -s `"
    tags+="${tag2} "
  fi
  
  if [ "$run_tool3" -ge 1 ]; then
    tag3="`run_tool "$file" mediainfo `"
    tags+="${tag3} "
  fi
  
  joined_tags="`echo ${tags} | join_seperator `"
  
  case $output_type in
  0)
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
    #tag="`echo "${tag1} ${tag2} ${tag3}" | join_seperator `"

    #paste -s -d "$field_separator"
    printf "%-*s %s\n" "$justify" "$file" "$joined_tags"
    ;;
    
  2)
    if [ $wrote_csv_header -eq 0 ]; then
      echo "ffprobe mp3guessenc mediainfo file" | join_seperator
      wrote_csv_header=1
    fi
    
    echo "$joined_tags"
    ;;
  *)
    die "Unk outputtype"
    ;;
  esac
  
}



function test_1_file()
{
  local file="$1"

  get_tags "$file"
  
  
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
  display_help
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

