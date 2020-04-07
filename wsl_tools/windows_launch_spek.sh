#!/bin/bash

#
# QQTabBAr launcher:
#
#  path:      %windir%\system32\wsl.exe
#  arguments: --cd %cd% -- "/home/pestrela/bin/ffmpeg_convert_win.sh" -f %f%
#

function die()
{
  echo "Error: $@"
  read
  exit 1
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

set -x


necessary_option="$1"
shift

#read

if [ "$necessary_option" != "-f" ]; then 
  die "need option -f"
fi

spek="/mnt/c/Program Files (x86)/Spek/spek.exe" 

set -e
set -u

do_final_read=0
#do_final_read=1


#echo "arguments:" "$@"
#read

 

while [ "$#" -ge 1 ]; do
  file_in_win="$1"
  shift

  "$spek" "$file_in_win" &
  
done


echo ""
echo "All done"

if [ $do_final_read -ge 1 ]; then
  read
fi

sleep 0.3


