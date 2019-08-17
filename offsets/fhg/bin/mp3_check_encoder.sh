#!/bin/bash

#set -e
set -u

media_files_extensions="mp3|mp4|avi|m4a|opus|webm|wav|flac|alac|aiff"
tag_comment=0
tag_filename=0
debug=0
output_type=2
wrote_csv_header=0
full_output=0
field_separator="|"
subfield_separator="_"
do_uniq=1
justify=80

dump_key_values=0

run_tool1=1
run_tool2=1
run_tool3=1

do_vbr=0
do_deep_analysis=0
do_recursive=1
only_do_find=0
do_run_dd=1

# main operations follows
do_operation="check_headers"
do_raw_mp3guessenc=0

file_out_csv="mp3_headers.csv"
file_out_raw="mp3_headers.raw"

do_csv=1    
do_stdout=1
save_output_files=0
append_output_file=1
dump_raw_tools=0
do_only_one_file=0

 

#####

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


operation:
  --headers             check mp3guessenc values (default)
  --ffprobe_json        dump ffprobe
  --encoder             only guess encoder (3x tools)
  
options:
  --fast                do NOT run VBR check
  --slow                run VBR check
  
  --raw|-r              dump raw mp3guessenc / mediainfo output
  --no_recursive        skip recursive 
  --recursive           recursive (still needs '.')    

  --image               runs DD to cover images
  
output files:  
  -OO                   do not save output files (CSV, RAW)
  -O                    append output files in folder  (CSV, RAW)
  -o                    overwrite output files in folder    (CSV, RAW)
  -q                    no stdout output (only save files)
  
key-value pairs:  
  (default)             append CSV to file, no key/vlue
  -c                    skip CSV output (to stdout or file)
  -1                    dump key-values (only cases)
  -2                    dump key-values (cases and tags)
  
  -9                   dump all values
  
  
    
old options:    
  -j                    size to justify one-liner output
  --uniq_tags           filter out repeated tags    (default)
  --repeated_tags       show repeated tags 
  
sub-tools:
  --ffmpeg|--ffprobe    ONLY run ffprobe 
  --mp3guessenc         ONLY run mp3guessenc
  --mediainfo           ONLY run mediainfo

  
To open CSV in excel:
  - double click, data, text to column, delimiter, add delimiter "|", save XLS  
  
  
  
  
CURRENT AGORITHM:
 if mp3guessenc does NOT see a Xing/INFO tag:
     case = 'A'
     correction = 0ms
 
 elif eyeD3 does NOT see a LAME tag at all:
     case = 'B'
     correction = 26ms
 
 elif eyeD3 sees an INVALID LAME tag:
     case = 'C'
     correction = 26ms
     
 elif eyeD3 sees a VALID LAME tag:
     case = 'D'
     correction = 0ms
   
  
 "
  exit 1

}

function pass()
{
  local nop="nop"
}


#
# Syntactic sugar to declare global variables explicitly
#
# locals are used:
#   primary parameters into functions (readonly)
# 
# globals are used:
#   return variables
#   secondary parameters into functions (convenience)
#
# 
# template of function:
#   function swap()
#   {
#      local param1="$1"
#      local param2="$2"
#
#      global ret1
#      global ret2
#  
#      ret1="$param2"
#      ret2="$param1"
#   }

#   function do_outer()
#   {
#      global ret1
#      global ret2
#       
#      ret1=""
#      ret2=""
#
#      do_inner "aaa" "bbb"
#      echo "The result was: $ret1 / $ret2"     
#   }
#
#
#
#
function global()
{
  local var="$1"
  
}


function echo_var()
{
  local var
  
  for var in "$@" ; do
    #if [ "${!var:-}" == "" ]; then
    #  die "unknown variable: $var"
    #fi
  
    echo "${var} -> ${!var:-}"
  done
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


function last_field_or_unk()
{
  to_unk="$1"
  
  awk '{print $NF}' | awk -v to_unk="$to_unk" '{if(NF){A=1}} {if(NF){print }} END{if(A==0){print to_unk }}'

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
    cat - | awk '{print $NF }' | do_uniq | paste -s -d "$subfield_separator" | last_field_or_unk
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


function sed_out()
{
  # TODO: warn if separator appears in string!
  local what
  what="${1:-}"

  if [ "$what" == "" ]; then
    cat -
  else
    sed "s|${what}||"
  fi
}


function get_line_field()
{
  #
  # greps stdin. returns the last field if present (typically "yes" or "no"), and "unk" if not there
  #  has optional sed expression to make another last field
  #  
  # parameters: 
  #  $1 = what to grep
  #  $2 = what to sed
  #  $3 = what to return if not there
  #
  
  to_grep="$1"
  
  to_sed="${2:-}"
  to_unk="${3:-unk}"

  egrep "$to_grep" | sed_out "$to_sed" | last_field_or_unk "$to_unk"
}



function see_if_line_present_upper()
{
  to_upper | see_if_line_present "$@"
  
}

function see_if_line_present()
{
  #
  # greps stdin. returns "yes" if present, "no" if not present
  #  
  # parameters: 
  #   $1 = what to grep
  #
  to_grep="$1"

  filter="`egrep "$to_grep" | head -n 1 `"
  if [ "$filter" == "" ]; then
    echo "no"
  else
    echo "yes"
  fi
}


function do_guess_encoder()
{
  local file="$1"
  global csv_header 
  global tags

  ####
  tag1=""
  tag2=""
  tag3=""
  
  if [ "$run_tool1" -ge 1 ]; then
    tag1="`run_tool "$file" ffprobe -hide_banner -loglevel verbose `"
  fi
  
  if [ "$run_tool2" -ge 1 ]; then
    tag2="`run_tool "$file" mp3guessenc -s `"
  fi
 
  if [ "$run_tool3" -ge 1 ]; then
    tag3="`run_tool "$file" mediainfo `"
  fi

  tags=()

  tags+=( "${tag1}" )
  tags+=( "${tag2}" )
  tags+=( "${tag3}" )

  csv_header=( "ffprobe" "mp3guessenc"  "mediainfo" )
}


function tf_to_yn()
{
  local input="$1"
  
  case "$input" in
  *unk*)
    ret="unk"
    ;;
  
  *true*)
    ret="yes"
    ;;
  *)
    ret="no"
    ;;
  esac
  
  echo "$ret"

}

function passed_to_yn()
{
  local input="$1"
  
  case "$input" in
  *unk*)
    ret="unk"
    ;;
    
  *passed*)
    ret="yes"
    ;;
  *)
    ret="no"
    ;;
  esac
  
  echo "$ret"

}


function to_upper()
{
  tr '[:lower:]' '[:upper:]' 
}


########################
########################
########################

function do_check_dd()
{
  if [ "$do_run_dd" -eq 0 ]; then
  
    raw_dd_anything="not_run"
    return
  fi


  mp3guessenc_tag="`mp3guessenc -v "$file" `"  
  mp3guessenc_tag_offset="`echo "$mp3guessenc_tag" | grep "Tag offset"  | head -n 1 | \
    awk 'BEGIN{OFFSET=0} {OFFSET=$(NF-1)} END{print OFFSET}' `"


  ### run DD
  raw_dd_go_back="3000" 
  raw_dd_what_to_read="10000" 
  
  raw_dd_starting_point=$(( $mp3guessenc_tag_offset - $raw_dd_go_back ))  || true
  if [[  "$raw_dd_starting_point" -lt 0 ]]; then
    raw_dd_starting_point=0
  fi
 
  raw_dd_block="`dd if="$file" bs=1 skip="$raw_dd_starting_point" count="$raw_dd_what_to_read"      2>/dev/null | strings `"   
  raw_dd_insensitive_opt="-i"
  
  raw_dd_strings_strict="^Info$|^Xing$|^VBRi$"   # very strict. There are a lot of exceptions!
  raw_dd_strings_loose="INFO|XING|VBRI|LAME|LAVC|LAVF|LA"    # loose. use with -i as well
  
  raw_dd_1="`echo "$raw_dd_block" |  sed 's|UUUUU|\n|g' | egrep -i "$raw_dd_strings_loose" `"
  #   tr '[:lower:]' '[:upper:]'  | head -n 5
  raw_dd_case_insensitive=0
  
  raw_dd_outcome="`echo "$raw_dd_1" | head -n 5 `"
  
 
 
  raw_dd_info="`echo  "$raw_dd_outcome" | see_if_line_present_upper "INFO"`"
  raw_dd_xing="`echo  "$raw_dd_outcome" | see_if_line_present_upper "XING"`"
  raw_dd_vbri="`echo  "$raw_dd_outcome" | see_if_line_present_upper "VBRI"`"
  raw_dd_lavc="`echo  "$raw_dd_outcome" | see_if_line_present_upper "LAVC" `"
  raw_dd_lavf="`echo  "$raw_dd_outcome" | see_if_line_present_upper "LAVF" `"
  raw_dd_lame="`echo  "$raw_dd_outcome" | see_if_line_present_upper "LAME" `"
  raw_dd_id3v2="`echo "$raw_dd_outcome" | see_if_line_present_upper "ID3" `"

  raw_dd_anything="` echo "$raw_dd_outcome" | paste -s -d "_" `"
  if [ "$raw_dd_anything" == "" ]; then
    raw_dd_anything_any="no"
  else
    raw_dd_anything_any="yes"
  fi 
}



function do_check_headers_slow()
{
  ### OLD VERSION. ONLY FOR DD and MP3GUESSENC

  local file="$1"
  global csv_header 
  global tags
  
  do_check_headers_fast_only_tools "$file"

  
  
    
  #################3
  ### run mpgguessenc
  mp3guessenc_anciliary="`mp3guessenc -a "$file" `"  
  mp3guessenc_tag="`mp3guessenc -v "$file" `"  
  mp3guessenc_errors="`mp3guessenc -p "$file" `"  
  
  mp3guessenc_tag_offset="`echo "$mp3guessenc_tag" | grep "Tag offset"  | head -n 1 | \
    awk 'BEGIN{OFFSET=0} {OFFSET=$(NF-1)} END{print OFFSET}' `"
  

  do_run_dd=1
  do_check_dd

 
 
  
  #######
 
  if [ $dump_raw_tools -ge 1 ]; then
    do_vbr=1      # confusing
  fi
  
  
  if [ "$do_vbr" -ge 1 ]; then
    mediainfo="`mediainfo "$file" `"
  else
    mediainfo="<MEDIA INFO WAS NOT RUN>"
  fi

  
  if [ "$dump_raw_tools" -ge 1 ]; then
    mp3guessenc_full="`mp3guessenc -e "$file" `"  


  (
    echo "

*************
FILE: 
-----
$file




MP3PARSER FULL:
---------------
$mp3parser_full



MP3GUESSENC FULL:
-----------------
$mp3guessenc_full



EYED3 FULL:
-----------
$eyed3_full



MEDIAINFO FULL:
---------------
$mediainfo




RAW DD:
-------
$raw_dd_outcome


*************

"
    ) | do_save_output "$file_out_raw"
    
  fi
  
  ### massage outputs
  sep="___"


 
  
  
  
  ##
  ## Massage stdout from tool. This relies heavily on the following functions:
  ##
  ##  function: see_if_line_present "string"
  ##  returns:  yes" if present, "no" if not present  
  ##
  ##  function: get_line_field "string" "to_sed" "unk"
  ##  returns:  yes" if present, "no" if not present  
  ##
  mp3guessenc_unexpected_data="`echo "$mp3guessenc_errors" | see_if_line_present "^Unexpected data at 0" `"
  mp3guessenc_xing_or_info_tag_present="`echo "$mp3guessenc_tag" | see_if_line_present "^Xing tag detected" `"
  mp3guessenc_vbri_tag_present="`echo "$mp3guessenc_tag" | see_if_line_present "^VBRI tag detected" `"

  if [ "$mp3guessenc_xing_or_info_tag_present" == "yes" ]; then
    mp3guessenc_lame_present="`echo "$mp3guessenc_tag" | get_line_field "^  Lame tag" `"
  else
    mp3guessenc_lame_present="no"
  fi
  
  mp3guessenc_lame_tag_valid="`echo "$mp3guessenc_tag"   | get_line_field "^  Tag verification " `"
  lame_tag_revision="`echo "$mp3guessenc_tag"   | get_line_field "^  Tag revision " `"
  lame_short_string="`echo "$mp3guessenc_tag"   | get_line_field "^  Lame short string " `"
  
  mpeg_padding="`echo "$mp3guessenc_anciliary"   | get_line_field "^Padding used" `"
  
  encoder_delay="`echo "$mp3guessenc_tag"    | get_line_field "^  Encoder delay" "samples" `"
  encoder_padding="`echo "$mp3guessenc_tag"  | get_line_field "^  Encoder padding" "samples" `"
  nogap_continued="`echo "$mp3guessenc_tag"  | get_line_field "^  nogap continued" `"
  nogap_continuation="`echo "$mp3guessenc_tag"  | get_line_field "^  nogap continuation" `"
  
  bitrate_mode="`echo "$mediainfo"       | get_line_field "^Bit rate mode" `"
  bitrate_value="`echo "$mediainfo"      | get_line_field "^Bit rate     " "kb/s" `"

  
  #### derived fields
  # https://github.com/digital-dj-tools/dj-data-converter/issues/3
  
  highest_tag_present="unk"
  case="unk"
  problem="unk"
  
  lame_derived_bitrate="unk"
  lame_derived_crc="unk"
  tools_lame_present_agree="unk"
  tools_lame_tag_valid_agree="unk"
  lame_summary="unk"
  
  
  # NULL STREAMS PROBLEM
  #if [ "$mp3guessenc_unexpected_data" == "yes" ]; then
  #  highest_tag_present="null_stream"
  #  
  #  if [ $raw_dd_anything_any == "no" ]; then
  #    case="E"
  #  else
  #    case="F"
  #  fi

  
  
  
  ##
  ## MAIN ALGORITHM HERE - https://github.com/digital-dj-tools/dj-data-converter/issues/3
  ##
      
  
  # VBRI CASES
  if [ "$mp3guessenc_vbri_tag_present" == "yes" ]; then
    highest_tag_present="vbri"
    case="Z"
    
    if [ "$mp3guessenc_xing_or_info_tag_present" == "yes" ]; then
        die "VBRI + XING/INFO problem"
    fi

  # NO TAGS PRESENT
  elif [ "$mp3guessenc_xing_or_info_tag_present" == "no" ]; then
    highest_tag_present="none"
    case="A"
    
    # either nothing, or broken lame tag
    
  elif [ "$mp3guessenc_xing_or_info_tag_present" != "yes" ]; then
      die "mp3guessenc_xing_or_info_tag_present error"

  # HAS XING/INFO TAG?  ->  __GO DEEPER__
  elif [ "$mp3guessenc_xing_or_info_tag_present" == "yes" ]; then

    # simple translations here
    if [ "$mp3guessenc_lame_tag_valid" == "passed" ]; then
      mp3guessenc_lame_tag_valid="yes"
      
    elif [ "$mp3guessenc_lame_tag_valid" == "failed" ]; then
      mp3guessenc_lame_tag_valid="no"
      
    else
      #die "unk lame_tag_valid: $lame_tag_valid"
      mp3guessenc_lame_tag_valid="unk"
    fi
 
 
  
    # catch disagreement
    if [ "$eyed3_lame_present" == "$mp3guessenc_lame_present" ]; then
      tools_lame_present_agree="yes"
    else
      tools_lame_present_agree="no"
    fi
    
    if [ "$eyed3_lame_valid" == "$mp3guessenc_lame_tag_valid" ]; then
      tools_lame_tag_valid_agree="yes"
    else
      tools_lame_tag_valid_agree="no"
    fi    

    
    ##
    ## MAIN ALGORITHM HERE - https://github.com/digital-dj-tools/dj-data-converter/issues/3
    ##
        

    # ONLY XING TAG?  (as seen by eyeD3)
    if [ "$eyed3_lame_present" == "no" ]; then
      highest_tag_present="xing"
      case="B"
      
    elif [ "$eyed3_lame_present" != "yes" ]; then
      die "eyed3_lame_present error"

    elif [ "$eyed3_lame_present" == "yes" ]; then
      
      if [ "$eyed3_lame_valid" == "yes" ]; then
        case="D"
        highest_tag_present="lame.ok"
      else
        case="C"
        highest_tag_present="lame.error"
      fi

    fi
    
    

    lame_derived_tag="unk"
    if [[ "$raw_dd_lavc" == "yes" ||  "$raw_dd_lavf" == "yes" ]]; then
      
      lame_derived_tag=""
      if [[ "$raw_dd_lavc" == "yes" ]]; then
        lame_derived_tag="LAVC"
      fi
      
      if [[ "$raw_dd_lavf" == "yes" ]]; then
        lame_derived_tag="${lame_derived_tag}LAVF"
      fi
      
      if [ "$raw_dd_lame" == "yes" ]; then
        lame_derived_tag="${lame_derived_tag}LAME" 
      fi
    elif [ "$raw_dd_lame" == "yes" ]; then
      lame_derived_tag="lame"
    fi
    
    # see one level above what is going on
    if [ "$raw_dd_info" == "yes" ]; then
      lame_derived_bitrate="CBR(INFO)"
    elif [ "$raw_dd_xing" == "yes" ]; then
      lame_derived_bitrate="VBR(XING)"
    else
      die "still processing cover art"
    fi
  
    # CRC check
    if [ "$mp3guessenc_lame_tag_valid" == "passed" ]; then
      lame_derived_crc="CRC(GOOD)"
      
    elif [ "$mp3guessenc_lame_tag_valid" == "failed" ]; then
      lame_derived_crc="CRC(BAD)"
      
    else
      #die "unk lame_tag_valid: $lame_tag_valid"
      lame_derived_crc="unk"
      
    fi
      
    lame_summary="${lame_derived_tag}.${lame_derived_bitrate}.${lame_derived_crc}.${lame_tag_revision}"

    
  fi
  
   
  case_to_problem
  
  tags=()

  tags+=( "$case" )
  tags+=( "$problem" )
  tags+=( "$correction" )
  
  tags+=( "$sep" )
  tags+=( "$mp3guessenc_unexpected_data" )
  tags+=( "$sep" )
  
  tags+=( "$highest_tag_present" )
  tags+=( "$mp3guessenc_xing_or_info_tag_present" )
  tags+=( "$eyed3_lame_present" )
  tags+=( "$mp3guessenc_lame_present" )
  tags+=( "$sep" )

  tags+=( "$mp3guessenc_lame_tag_valid" )
  tags+=( "$lame_tag_revision" )
  tags+=( "$lame_summary" )
  tags+=( "$sep" )

  tags+=( "$mpeg_padding" )
  tags+=( "$encoder_delay" )
  tags+=( "$encoder_padding" )
  tags+=( "$nogap_continued" )
  tags+=( "$nogap_continuation" )
  tags+=( "$sep" )
  
  tags+=( "$bitrate_mode" )
  tags+=( "$bitrate_value" )
  tags+=( "$sep" )
  
  tags+=( "$mp3guessenc_tag_offset" )
  tags+=( "$raw_dd_anything" )
  tags+=( "$raw_dd_xing" )
  tags+=( "$raw_dd_info" )
  tags+=( "$raw_dd_vbri" )
  tags+=( "$raw_dd_id3v2" )
  tags+=( "$sep" )
  
  csv_header=( 
  
    "case" "problem"  "correction"  "sep1" \
    \
    "mp3guessenc_unexpected_data" "sep2" \
    \
    "highest_tag_present"  "mp3guessenc_xing_or_info_tag_present"  "eyed3_lame_present" "eyed3_lame_valid" "mp3guessenc_lame_present" "mp3guessenc_lame_tag_valid""sep3" 
    \
    "lame_tag_valid" "lame_tag_revision" "lame_summary" "sep4" \
    \
    "mpeg_padding", "encoder_delay" "encoder_padding" "nogap_continued" "nogap_continuation"  "sep5" \
    \
    "bitrate_mode" "bitrate_value" "sep6" \
    \
    "mp3guessenc_tag_offset"   "raw_dd_anything" "raw_dd_xing" "raw_dd_info"  "raw_dd_vbri"  "raw_dd_id3v2"  "sep7" \
    )
    
  if [ $dump_key_values -ge 1 ]; then
      echo ""
      echo "**********************"
      echo_var file
      echo ""
      
      
    case $dump_key_values in
     1)
      echo_var  case
      echo_var  mp3parser_case      
      echo_var  eyed3_case
      ;;


    2)      
      echo_var  mp3parser_case   mp3parser_xing_present  mp3parser_lame_present   mp3parser_lame_valid
      echo ""
      echo_var  eyed3_case       eyed3_xing_present      eyed3_lame_present       eyed3_lame_valid 
      
      echo ""
      echo_var raw_dd_anything 
      ;;
     
     
     
    3)      
      echo_var  case mp3guessenc_xing_or_info_tag_present
      echo_var  eyed3_lame_present   eyed3_xing_present   eyed3_lame_valid 
      echo_var  mp3guessenc_lame_present  mp3guessenc_lame_tag_valid 
      
      echo_var eyed3_case
      ;;
     
     
     
    4)
      echo_var  highest_tag_present 
      echo_var  case
      echo_var  correction  lame_tag_revision
      
      echo ""
      
      echo_var  eyed3_lame_present  eyed3_lame_valid   
      echo_var  mp3guessenc_lame_present mp3guessenc_lame_tag_valid
      echo ""
      echo_var  tools_lame_present_agree tools_lame_tag_valid_agree
      
      echo ""
      echo_var raw_dd_anything 
      ;;

      
    
    9)
        echo ""
        echo ""
        echo_var "case"
        echo_var "problem" 
        echo_var "correction"
        echo ""
    
        echo_var "first_frame_bad"
        echo ""
        
        echo_var "highest_tag_present"
        echo_var "mp3guessenc_xing_or_info_tag_present"
        echo_var "mp3guessenc_lame_present"
        echo_var "lame_tag_valid"
        echo_var "lame_tag_revision"
        echo ""
        
        echo_var "mpeg_padding"
        echo_var "encoder_delay"
        echo_var "encoder_padding"
        echo_var "nogap_continued"
        echo_var "nogap_continuation"
        echo ""
        
        echo_var "bitrate_mode"
        echo_var "bitrate_value"
        echo ""
    
    
        echo_var "mp3guessenc_tag_offset"
        echo_var "raw_dd_anything"
        echo ""
        echo_var "raw_dd_vbri"
        echo_var "raw_dd_xing"
        echo_var "raw_dd_info"
        echo ""
        echo_var "raw_dd_lame"
        echo_var "raw_dd_lavc"
        echo_var "raw_dd_lavf"
        echo_var "raw_dd_id3v2"
        echo ""
        echo ""
        ;;
   
    esac
    
    echo ""
  fi
  
}








########################
########################
########################







function case_to_problem()
{
  global case

  case "$case" in
  A|D|Z)
    correction="0"
    problem="no"
    ;;
  B|C)
    correction="26"
    problem="yes"
    ;;
   
  *)
    correction="unk"
    problem="unk"
    ;;
    
  esac
}



function do_dump_raw_values()
{

  if [ "$dump_raw_tools" -ge 1 ]; then

  (
    echo "

*************
FILE: 
-----
$file


MP3PARSER FULL:
---------------
$mp3parser_full

 

EYED3 FULL:
-----------
$eyed3_full



MP3GUESSENC FULL:
-----------------
$mp3guessenc_full



*************

"
    ) | do_save_output "$file_out_raw"
  fi


}


function do_check_headers_fast_only_tools()
{

  local file="$1"
  global csv_header 
  global tags
  
  do_check_dd

  ################
  ### mp3 parser
  mp3parser_full="`mp3-parser-linux-beta  "$file" | strings `"
  
  mp3parser_xing_present_tmp="`echo "$mp3parser_full" | get_line_field "xing-tag?" `"
  mp3parser_xing_present="`tf_to_yn "$mp3parser_xing_present_tmp" `"
  mp3parser_lame_present="`echo "$mp3parser_full" | see_if_line_present "lame-tag?" `"
  mp3parser_lame_valid_tmp="`echo "$mp3parser_full" | get_line_field "lame-tag?" `"
  mp3parser_lame_valid="`tf_to_yn "$mp3parser_lame_valid_tmp" `" 

  if [ "$mp3parser_xing_present" == "no" ]; then
    mp3parser_case="A"
  
  elif [ "$mp3parser_lame_present" == "no" ]; then
    mp3parser_case="B"
    
  elif [ "$mp3parser_lame_valid" == "no" ]; then
    mp3parser_case="C"
    
  else
    mp3parser_case="D"
    
  fi  
  
 
 
  ####################
  ### eyeD3
  eyed3_full="`eyeD3 -P lameinfo "$file" -l debug  2>&1 | strings | grep -v "eyed3.id3" `"  
  
  eyed3_vbri_tag_present="NOT IMPLEMENTED"
  eyed3_xing_present="`echo "$eyed3_full" | see_if_line_present "'Xing' header detected|'Info' header detected" `"
  eyed3_no_lame_present="`echo "$eyed3_full" | see_if_line_present "No LAME Tag" `"
  eyed3_lame_corrupt="`echo "$eyed3_full" | see_if_line_present "Lame tag CRC check failed" `"

  if [[ "$eyed3_no_lame_present" == "yes"  ]]; then
    eyed3_lame_present="no"
    eyed3_lame_valid="unk"
    
  elif [ "$eyed3_lame_corrupt" == "yes" ]; then
    eyed3_lame_present="yes"
    eyed3_lame_valid="no"
      
  else
    eyed3_lame_present="yes"
    eyed3_lame_valid="yes"
      
  fi
 
  
  if [ "$eyed3_vbri_tag_present" == "yes" ]; then
    # not implemented!
    eyed3_case="Z"
    
  elif [ "$eyed3_xing_present" == "no" ]; then
    eyed3_case="A"
    
  elif [ "$eyed3_lame_present" == "no" ]; then
    eyed3_case="B"
    
  elif [ "$eyed3_lame_valid" == "no" ]; then
    eyed3_case="C"

  elif [ "$eyed3_lame_valid" == "yes" ]; then
    eyed3_case="D"
    
  else
    die "uncatched error - bad eyeD3 case"
    
  fi

  
  ####################
  ### mp3guessenc
  
  
  mp3guessenc_full="` mp3guessenc -e "$file" | strings `"  
  
  mp3guessenc_vbri_present="`echo "$mp3guessenc_full" | see_if_line_present "^VBRI tag detected" `"
  mp3guessenc_xing_present="`echo "$mp3guessenc_full" | see_if_line_present "^Xing tag detected" `"

  mp3guessenc_lame_present="`echo "$mp3guessenc_full" | get_line_field "^  Lame tag" `"
  mp3guessenc_lame_verification="`echo "$mp3guessenc_full"   | get_line_field "^  Tag verification " `"
  mp3guessenc_lame_valid="`passed_to_yn "$mp3guessenc_lame_verification" `" 

  
  if [ "$mp3guessenc_vbri_present" == "yes" ]; then
    # not implemented!
    mp3guessenc_case="Z"
    
  elif [ "$mp3guessenc_xing_present" == "no" ]; then
    mp3guessenc_case="A"
    
  elif [ "$mp3guessenc_lame_present" == "no" ]; then
    mp3guessenc_case="B"
    
  elif [ "$mp3guessenc_lame_valid" == "no" ]; then
    mp3guessenc_case="C"

  elif [ "$mp3guessenc_lame_valid" == "yes" ]; then
    mp3guessenc_case="D"
    
  else
    die "uncatched error - bad mp3guessenc case"
    
  fi
  
  
  
  do_dump_raw_values
   
}



function do_check_headers_fast()
{
  local file="$1"
  global csv_header 
  global tags
  
  do_check_headers_fast_only_tools "$file"
  
  case="$eyed3_case"
  case_to_problem
  
  sep="___"
   
  tags=()
  tags+=( "$case" )
  tags+=( "$problem" )
  tags+=( "$correction" )
  
  tags+=( "$sep" )
  tags+=( "$eyed3_case"        "$eyed3_xing_present"        "$eyed3_lame_present"        "$eyed3_lame_valid" ) 

  tags+=( "$sep" )
  tags+=( "$mp3parser_case"    "$mp3parser_xing_present"    "$mp3parser_lame_present"    "$mp3parser_lame_valid" )
  
  tags+=( "$sep" )
  tags+=( "$mp3guessenc_case"  "$mp3guessenc_xing_present" "$mp3guessenc_lame_present"  "$mp3guessenc_lame_valid" ) 
  
  tags+=( "$sep" )
  tags+=( "$raw_dd_anything" ) 
  
  csv_header=( 
    "case" "problem"  "correction"  "sep1" \
    \
    "eyed3_case"      "eyed3_xing_present"      "eyed3_lame_present"       "eyed3_lame_valid"       "sep2" \
    \
    "mp3parser_case"  "mp3parser_xing_present"  "mp3parser_lame_present"   "mp3parser_lame_valid"   "sep3" \
    \    
    "mp3guessenc_case"  "mp3guessenc_xing_present" "mp3guessenc_lame_present"  "mp3guessenc_lame_valid" \
    \
    "raw_dd_anything" \
    
    )    
  
    
  if [ $dump_key_values -ge 1 ]; then
      echo ""
      echo "**********************"
      echo_var file
      echo ""
      
      
    case $dump_key_values in
     1)
      echo_var  case problem correction
      echo ""
      echo_var  eyed3_case
      echo_var  mp3parser_case      
      echo_var  mp3guessenc_case
      ;;

    2)      
      echo_var  eyed3_case       eyed3_xing_present      eyed3_lame_present       eyed3_lame_valid 
      echo ""
      echo_var  mp3parser_case   mp3parser_xing_present  mp3parser_lame_present   mp3parser_lame_valid
      echo ""
      echo_var  mp3guessenc_case       mp3guessenc_xing_present      mp3guessenc_lame_present       mp3guessenc_lame_valid 
      echo ""
      echo_var  raw_dd_anything  
      ;;
      
    esac
    
    echo ""
  fi
     
     
  
}




function get_tags()
{
  local file="$1"
  global tags
  global csv_header
  
  if [ "$do_operation" == "check_headers" ]; then
    if [ $do_deep_analysis -ge 1 ]; then
      do_check_headers_slow "$file"
    else
      do_check_headers_fast "$file"
    fi
    
  elif [ "$do_operation" == "guess_encoder" ]; then
    do_guess_encoder "$file"
    
  else
    die "unk oper"
    
  fi

  if [ "$do_raw_mp3guessenc" -ge 1 ]; then
    return
  fi
  
  
  #####
  csv_header+=("sep99" "file")
  tags+=( "$sep" "$file")
  
  
  ##########
  if [ $do_csv -ge 1 ]; then
    if [ $wrote_csv_header -eq 0 ]; then
      array_to_csv   csv_header | do_save_output "$file_out_csv"

      wrote_csv_header=1
      
    fi
      
    array_to_csv tags | do_save_output "$file_out_csv"
  fi
  
}


function do_save_output()
{
  local file_out="$1"

  if [ $save_output_files -ge 1 ]; then
    tee -a "$file_out"
  else
    cat -
  fi | if [ $do_stdout -ge 1 ]; then
    cat -
  else
    cat - > /dev/null
  fi
  
}


function test_1_file()
{
  local file="$1"

  if [ $only_do_find -ge 1 ]; then
    echo "$file" 
    return
  fi    
  
     
  
  if [ "$do_operation" == "ffprobe_json" ]; then
    ffprobe -v error -print_format json -show_format -show_streams  "$file"
    echo ","
    return
  fi
  

  get_tags "$file" 
  
  if [ $do_only_one_file -ge 1 ]; then
    exit 0
  fi
   
}


#####
#####

require_tools "mpg123"  "mp3guessenc" "ffprobe" "ffmpeg" "mediainfo"  

    
while [ "$#" -ge 1 ]; do
  case "$1" in
  -d|--debug|--d)
    debug=1
    #set -x
    ;;
    
  -dd|--dd)
    debug=2
    set -x
    ;;
  

    
  -C)
    wrote_csv_header=1
    ;;
    
  --repeated_tags)
    do_uniq=0
    ;;
    
  --uniq_tags)
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
    do_operation="guess_encoder"

    ;;
    
  --mp3guessenc)
    run_tool1=0
    run_tool2=1
    run_tool3=0
    do_operation="guess_encoder"

    ;;

  --mediainfo)
    run_tool1=0
    run_tool2=0
    run_tool3=1
    do_operation="guess_encoder"
    ;;


  --no_vbr)
    do_vbr=0
    ;;

  --vbr)
    do_vbr=1
    ;;
    
  --slow|deep)
     do_deep_analysis=1
     ;;  

  --fast|no_deep)
     do_deep_analysis=0
     ;;  
     
  --recursive|-R)
    do_recursive=1
    ;;

  --no_recursive|+R)
    do_recursive=0
    ;;
    
  --find|--only_find)
    only_do_find=1
    
    ;;

    
  +dd)
    do_run_dd=0
    do_operation="check_headers"
    ;;
    
  --dd)
    do_run_dd=1
    do_operation="check_headers"
    ;;

  --dump|--raw|-r)
    dump_raw_tools=1
    do_operation="check_headers"
    ;;

    
  --headers)
    dump_raw_tools=0
    do_operation="check_headers"
    ;;

  
  --ffprobe_json|-J)
    do_operation="ffprobe_json"
    ;;
    
  -q)
    do_stdout=0
    save_output_files=1
    ;;

  -c)
    do_csv=0
    ;;
 
  -o)
    save_output_files=1
    append_output_file=0
    wrote_csv_header=0
    
    ;;
    
  -O)
    save_output_files=1
    append_output_file=1
    wrote_csv_header=0
    ;;
    
  -OO)
    save_output_files=1
    save_output_files=0
    ;;

  --image)
    raw_dd_what_to_read="500000"    # 1 megabyte, to skip a possible cover art image
    ;;
    
  -h)
    display_help
    ;;
    
  --only_one|--single)
     do_only_one_file=1
     ;;
    
    
  # this is suitable for manual debugging
  -0)
    dump_key_values=1
    dump_raw_tools=1
    do_stdout=1
    do_csv=1
    ;;

  # Numbers
  -[1-9])
    #echo "$1" 
    dump_key_values="${1:1}"
    ;;
    

  -*)  
    die "unk argument: $1"
    ;;
    
  *)
    add_argv "$1"
    ;;
    
  esac
  
  shift
done

if [ $append_output_file -ge 1 ]; then
  wrote_csv_header=1
    
fi
    

if [ "$argc" -eq 0 ]; then
  echo "Error: no files specified"
  echo ""
  display_help
fi

if [ "$only_do_find" -ge 1 ]; then
  save_output_files=0
fi


if [ $do_recursive -ge 1 ]; then
  readarray -d '' tmp_array <  <(find "${argv[@]}"  -print0)
      
  argv=( "${tmp_array[@]}" )
fi


if [ "$do_operation" == "ffprobe_json" ]; then
  echo "["
fi

if [ $dump_key_values -ge 1 ]; then
    save_output_files=0
    #do_stdout=0
    
fi
    

if [ "$save_output_files" -ge 1 ]; then
  if [ "$append_output_file" -eq 0 ]; then
    rm -f "$file_out_csv"
    rm -f "$file_out_raw"
  fi
fi



for file in "${argv[@]}" ; do
  if [ ! -f "$file" ]; then
    continue
  fi
  
  ext="`extension_lower "$file" `"
  
  case "$ext" in
  mp3)
    test_1_file "$file"
    ;;

  mp3|mp4|avi|m4a|opus|webm|wav|flac|alac|aiff)
    pass
    ;;
    
  *)
    pass
    #echo "ignoring $file"
    ;;
  esac
  
done

if [ "$do_operation" == "ffprobe_json" ]; then
  echo "{ }]"
fi


exit 0


rawcat : break info


#define ID3V2_ID_STRING                      "ID3"

#define LYRICS3_BEGIN_SIGNATURE      "LYRICSBEGIN"
#define LYRICS3V1_END_SIGNATURE        "LYRICSEND"
#define LYRICS3V2_END_SIGNATURE        "LYRICS200"
#define APETAGEX_SIGNATURE              "APETAGEX"
#define WAVE_RIFF_DATA_ID                   "data"

#define VBRI_TAG_START_OFFSET                   36
#define VBRI_TAG_ID_STRING                  "VBRI"
#define LAME_TAG_ID_STRING                  "Info"
#define XING_TAG_ID_STRING                  "Xing"






## very simple parallel version to be faster
#!/bin/bash

set -e
set -u

DRY_RUN="echo"
DRY_RUN=""

dirs=( "1 Silvia" "3 Mixed_cds (fontes)" "8 Pedro Archived" "9 Pedro Last" )

for dir in "${dirs[@]}" ; do
	( cd "$dir" ; pwd; ${DRY_RUN} nohup mp3_check_encoder.sh -q . & )
done



differences between LAME-encoded and FFMPEG-encoded (both latest version):
 - nspsytune
 - nssafejoint   --nssafejoint it's a 'safe' joint stereo method which use more stereo frames: it use joint stereo only when the channels are very similar.
 - ATH type      ATH means 'Absolute threshold of hearing' 



 https://github.com/JamesHeinrich/getID3-testfiles/tree/master/mp3/VBRI
 
B|yes|26|___|D|yes|yes|yes|___|B|yes|no|unk|___|Info_Lavf|___|wrong/Adam Beyer, Bart Skils - Your Mind (Original Mix).mp3

 
 
  



for FILE in */*/03* ; do  printf "\n\n%s\n" "$FILE" ;  mp3-parser-linux-beta "$FILE" ; done > l.txt  
    
for DIR in */case* ; do   mp3_check_encoder.sh "$DIR"/* -1 -c --only_one ; done  > current_performance.txt
    
    
    