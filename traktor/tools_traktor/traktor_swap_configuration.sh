#!/bin/bash


# Disabled
traktor_root_folder=""

# MacOS
#traktor_root_folder="$HOME/Documents/Native Instruments/Traktor <version>"


# WSL - Windows Subsystem Linux
# traktor_root_folder="/mnt/c/Root/Sync_Traktor/Traktor Config/4_Configuration_Dir"



###
### Program starts here
###

function swap_files()
{
    local TMPFILE="/tmp/traktor_swap_tmp.$$"
    
    echo "Swapping: $1"
    echo "with:     $2"
    
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE "$2"
    
    echo "All done"
}


filename_main="Traktor Settings.tsi"
filename_disabled="Traktor Settings.disabled.tsi"

file_main="${traktor_root_folder}/${filename_main}"
file_disabled="${traktor_root_folder}/${filename_disabled}"


if [ -z "$traktor_root_folder" ]; then
  echo "Error."
  echo "Please set 'traktor_root_folder' with your Traktor Root Folder"
  echo "(this is typically '$HOME/Documents/Native Instruments/Traktor <version>')"
  exit 1
fi

if [ ! -r "$file_main" ]; then
  echo "Error: $file_main does not exist."
  echo "Please confirm the 'traktor_user_folder' variable on $0"
  exit 1
fi

if [ ! -r "$file_disabled" ]; then
  cp -f "$file_main" "$file_disabled"
fi

swap_files "$file_main" "$file_disabled"

