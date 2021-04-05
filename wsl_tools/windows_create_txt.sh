#!/bin/bash

#
# QQTabBAr launcher:
#
#  path:      %windir%\system32\wsl.exe
#  arguments: --cd %cd% -- "/home/pestrela/bin/ffmpeg_convert_win.sh" -f %f%
#

# this command creates a text file for every single file given
# if no files are given, it creates a text file with the current dirname 

#set -x
#read

function die()
{
  echo "Error: $@"
  exit_ 1
}

function tag_file_to_delete()
{
  local file_in="$1"
  
  local dirname_in="$( dirname "$file_in" )"
  local basename_in="$( basename "$file_in" )"
  
  
  local file_out="${dirname_in}/__delete_me__${basename_in}"

  mv "$file_in" "$file_out"
}

function recycle()
{
  local file="$1"
  local recycle_folder="/mnt/c/Root/0_linux_home/recycle_bin"
  
  mv -b "$file" "$recycle_folder"
}

function exit_()
{
  code=$1

  echo "press any key to exit"
  read
  
  exit $code
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

function fileexists ()
{
	if [ -r "$1" ]; then
		return 0
	else
		return 1
	fi

}

function current_dir_name()
{
	echo "$( basename "$( pwd )" )"
	
}



function create_text_file()
{
  local file_out_linux="$1"

  if fileexists "$file_out_linux" ; then
    echo ""
    echo "Skipping file $file_out_linux"
    echo ""
  else
    echo ""
    echo "Adding file $file_out_linux"
    echo ""
    
    (
    echo ""
    echo ""
    echo ""
    ) >> "$file_out_linux"
  fi
}


################
################
################

#set -x
#read

necessary_option="$1"
shift

if [ "$necessary_option" != "-f" ]; then 
  die "need option -f"
fi

set -e
set -u

do_final_read=0
do_read_target=1
fail_on_existing_target=1

target="0_group"

echo "received arguments:" "$@"
pwd

set -x

if [ $# -eq 0 ]; then
  file_out_linux="`current_dir_name`.txt"
  
  create_text_file "$file_out_linux" 
fi


while [ "$#" -ge 1 ]; do
  file_in_win="$1"
  shift

  file_in_linux="$( wslpath "$file_in_win" )"
  file_out_linux="`replace_extension "$file_in_linux" "txt"`"
  
  create_text_file "$file_out_linux" 
done


echo ""
echo "All done"

do_final_read=0
#do_final_read=1
if [ $do_final_read -ge 1 ]; then
  read
fi


exit 0

