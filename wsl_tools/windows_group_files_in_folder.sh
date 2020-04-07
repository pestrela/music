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

if [ "$necessary_option" != "-f" ]; then 
  die "need option -f"
fi

set -e
set -u

do_final_read=0
fail_on_existing_target=1

target="0_group"

echo "arguments:" "$@"
#read


pwd
if [ -d "$target" ]; then
  if [ "$fail_on_existing_target" -ge 1 ]; then
    echo "folder $target already exists"
    exit 1
  fi
fi

mkdir -p "$target"

while [ "$#" -ge 1 ]; do
  file_in_win="$1"
  shift

  file_in_linux="$( wslpath "$file_in_win" )"

  mv -b "$file_in_linux" "$target"
  
done


echo ""
echo "All done"

if [ $do_final_read -ge 1 ]; then
  read
fi




