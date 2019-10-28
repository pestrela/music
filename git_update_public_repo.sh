#!/bin/bash

# simple script to update the public git repo. 
# Source is the local ~/bin working copies


set -u
set -e
#set -x

function copy_files()
{  
  local root_src="$1"
  local root_dst="$root_dst_all"
  local files_in="$2"
  local folder_out="$3"
  
  local file
  local file_in
  local file_out
   
  for file in $files_in ; do
    file_in="${root_src}/${file}"
    file_out="${root_dst}/${folder_out}/${file}"
    
    echo cp "${file_in}" "${file_out}"  
    cp "${file_in}" "${file_out}"  
  done
}

function copy_mapping_files()
{  
  # https://unix.stackexchange.com/questions/392536/how-can-i-sync-two-local-directories
  
  local root_src="$1"
  local root_dst="$2"

  rsync -av --progress  --delete "${root_src}/" "${root_dst}"
  
  #set -x
  
  # note: this will fail on purpose using "set -e"
  rm --verbose "${root_dst}"/*.tsi
  rm --verbose "${root_dst}"/*/*.tsi
  
}


function do_banner()
{  
  local msg="$1"

  echo ""
  echo ""
  echo "*************"
  echo "$msg"

  
}


#########
######### Options
#########
do_bin_files=1
do_mapping_files=1
do_lists=1
do_git_operations=1



### DESTINATION folder
root_dst_all="/mnt/c/Root/0_linux_home/git/music_scripts"


### BIN  files
root_src_bin="/home/pestrela/bin"

cue_files_in="cue_convert_timestamps.sh  cue_merge_cues.py   cue_renumber_files.py  cue_make_tracklist.sh      cue_rename_cue_files.sh "
cue_folder_out="traktor/cue_tools"

mp3_files_in="mp3_analyse_fhg_offset.sh  mp3_check_encoder.sh   mp3_get_lame_indexes.py"
mp3_folder_out="traktor/26ms_offsets/bin"

download_files_in="youtube_dl.sh"
download_folder_out="downloads"


### MAPPING FILES
google_drive_root="/mnt/c/Root/google_drive/Pedro"

mapping_all_root_src="${google_drive_root}/2 Music - Controllers/0_MAPS_Traktor"
mapping_1_root_src="${mapping_all_root_src}/DDJ Pioneer/v6.6.0 - DDJ-1000 - TP3_TP2 BOME"
mapping_1_root_dst="${root_dst_all}/traktor/mapping_ddj_1000"

mapping_2_root_src="${mapping_all_root_src}/DDJ Pioneer/v6.1.2 - DDJ-SX2_SZ_SRT - TP3_TP2"
mapping_2_root_dst="${root_dst_all}/traktor/mapping_ddj_sx2_sz_srt"

mapping_3_root_src="${mapping_all_root_src}/AKAI AMX/v1.0.1 - AKAI AMX TP2_TP3"
mapping_3_root_dst="${root_dst_all}/traktor/mapping_akai_amx"

### TECNICHAL FILES
tech_1_src="${mapping_all_root_src}/DDJ Pioneer/Technical Info - DDJ Controllers.txt"
tech_2_src="${mapping_all_root_src}/DDJ Pioneer/Technical Info - BOME DDJ 1000 Screens.txt"
tech_all_dst="${mapping_all_root_src}/DDJ Pioneer/v6.6.0 - DDJ-1000 - TP3_TP2 BOME/Support files"


### LIST FILES
list_all_root_src="${google_drive_root}/9 Listas/listas de discos"

list_1_src="${list_all_root_src}/vinyl list.txt"
list_2_src="${list_all_root_src}/CD and DVD list.txt"
list_all_dst="${root_dst_all}/lists"




##############################
## main program goes here


if [ $do_bin_files -ge 1 ]; then
  do_banner "COPYING BIN FILES"

  copy_files "$root_src_bin"   "$cue_files_in"      "$cue_folder_out"
  copy_files "$root_src_bin"   "$mp3_files_in"      "$mp3_folder_out"
  copy_files "$root_src_bin"   "$download_files_in" "$download_folder_out"
fi



if [ $do_lists -ge 1 ]; then
  do_banner "COPYING VINYL LISTS"

  # Copy specific files into the mapping in google drive
  cp -f "$list_1_src" "$list_all_dst"
  cp -f "$list_2_src" "$list_all_dst"
  
fi

exit 0

if [ $do_mapping_files -ge 1 ]; then
  do_banner "COPYING MAPPING FILES"

  # Copy specific files into the mapping in google drive
  cp -f "$tech_1_src" "$tech_all_dst"
  cp -f "$tech_2_src" "$tech_all_dst"
  
  # rsync the folders, then delete the TSIs
  copy_mapping_files   "$mapping_1_root_src"   "$mapping_1_root_dst"
  copy_mapping_files   "$mapping_2_root_src"   "$mapping_2_root_dst"
  copy_mapping_files   "$mapping_3_root_src"   "$mapping_3_root_dst"
fi


if [ $do_git_operations -ge 1 ]; then
  do_banner "DOING GIT OPERATIONS"
  
  git pull
  #git diff
  git status
fi

exit 0
