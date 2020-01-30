#!/bin/bash



#pwd
#read



set -u
set -e

###
### User-configurable parameters here
###

# Default config: Disabled
traktor_root_folder=""

# MacOS
#traktor_root_folder="$HOME/Documents/Native Instruments/Traktor <version>"

# WSL - Windows Subsystem Linux
traktor_root_folder="/mnt/c/Root/Sync_Traktor/Traktor Config/4_Configuration_Dir"


# to do a shortcut on windows, use "wslusc" from https://github.com/wslutilities/wslu
# and then rename the shortcut target to:   ... ubuntu.exe run  "/home/pestrela/bin/traktor_swap_configuration.sh --swap --collection"


###
### Program starts here
###

if [ -z "$traktor_root_folder" ]; then
  echo "Error."
  echo "Please set 'traktor_root_folder' with your Traktor Root Folder"
  echo "(this is typically '$HOME/Documents/Native Instruments/Traktor <version>')"
   echo "Please check the user-defined variable on top of the script"
 exit 1
fi


if [ ! -r "$traktor_root_folder" ]; then
  echo "Error."
  echo "PCannot read traktor root folder 'traktor_root_folder' "
  echo "Please check the user-defined variable on top of the script"
  exit 1
fi


function display_help()
{
  echo "$0 [-s|-c|] [-S|-e|-f|]

Summary:
  Toggles Traktor Settings between two known configurations. 
  This is useful when using different audio devices (eg, sometimes using an controller, othertimes using an audio built-in).

  Use options to operate in the Collection instead, and/or to set files to either Empty or Full states.
  Do not forget that Traktor creates a timestamped Backup in <Traktor Root>/Backup/{Collection,Settings}


Options - target:   
  -s: operate in traktor settings  (<<<< default)
  -c: operate in traktor collection
  
Operation - operation:  
  -S: Swaps files                  (<<<< default)
  -e: sets to empty version
  -p: sets to production version 

interactive/automatic:
  -i: interactive mode             (<<<< default)
  -f: force
  
  "
  exit 1
}

function die()
{
  echo -n "error: "
  echo "$@"
  exit 1

}

function do_interactive_prompt()
{
  local answer
  
  if [ "$do_interactive" -ge 1 ]; then
    echo "Press 'y' to continue: "
    
    read answer
    if [ "$answer" != "y" ]; then
      exit 0
    fi
  
  fi
}

function set_files()
{
    local file1="$1"
    local file2="$2"
    
    assert_file_exists "$file1"

    echo "Copying: $file1"
    echo "Into: $file2"
    
    do_interactive_prompt
    
    
    cp -f "$file1" "$file2"
}


function swap_files()
{
    local TMPFILE="/tmp/traktor_swap_tmp.$$"
    local file1="$1"
    local file2="$2"
    
    
    assert_file_exists "$file1"
    assert_file_exists "$file2"

    
    echo "Swapping: $file1"
    echo "with:     $file2"
    
    do_interactive_prompt
    
    
    mv "$file1" $TMPFILE && mv "$file2" "$file1" && mv $TMPFILE "$file2"
    
}


function assert_file_exists()
{
  local file="$1"
  
  if [ ! -r "$file" ]; then
    die "Unreadable or missing file: $file"
  fi

}




do_interactive="1"

filename_settings_main="Traktor Settings.tsi"
filename_settings_disabled="Traktor Settings.Inactive.tsi"
filename_settings_empty="Traktor Settings.Empty.tsi"
filename_settings_full="Traktor Settings.Production.tsi"

filename_collection_main="collection.nml"
filename_collection_disabled="collection.Inactive.nml"
filename_collection_empty="collection.Empty.nml"
filename_collection_full="collection.Production.nml"


operation="swap"
target="settings"


while [ "$#" -ge 1 ]; do
  case "$1" in
  # Targets
  -s|--settings)
    target="settings"
    ;;
  -c|--collection)
    target="collection"
    ;;
    
  # Operations
  -S|--swap)
    operation="swap"
    ;;
  -e|--set_to_empty)
    operation="set_to_empty"
    ;;
  -p|--set_to_production)
    operation="set_to_production"
    ;;
    
  # Interactivity  
  -f|--force) 
    do_interactive=0
    ;;
  -i|--interactive) 
    do_interactive=1
    ;;
    
  -h)
    display_help
    ;;
  
  *)
    die "Unknown parameter: $1"
    
  esac
  
  shift
done

traktor_backup_folder="${traktor_root_folder}/Backup_Swap/"
mkdir -p "$traktor_backup_folder"

if [ "$target" == "settings" ]; then
  filename_main="$filename_settings_main"
  filename_disabled="$filename_settings_disabled"  
  filename_empty="$filename_settings_empty"
  filename_full="$filename_settings_full"
  
elif [ "$target" == "collection" ]; then
  filename_main="$filename_collection_main"
  filename_disabled="$filename_collection_disabled"
  filename_empty="$filename_collection_empty"
  filename_full="$filename_collection_full"

else 
  die ""
fi  



file_main="${traktor_root_folder}/${filename_main}"
file_disabled="${traktor_backup_folder}/${filename_disabled}"
file_empty="${traktor_backup_folder}/${filename_empty}"
file_full="${traktor_backup_folder}/${filename_full}"

 

#####
if [ "$operation" == "swap" ]; then
  if [ ! -r "$file_disabled" ]; then
    cp -f "$file_main" "$file_disabled"
  fi

  
  swap_files "$file_main" "$file_disabled"
  
elif [ "$operation" == "set_to_empty" ]; then
   set_files "$file_empty" "$file_main"
   
elif [ "$operation" == "set_to_production" ]; then
   set_files "$file_full" "$file_main"

   
else
  die "unk"
fi   
   
echo "All done"
  

