#!/bin/bash

# simple script to update the public git repo. Source is the local ~/bin working copies


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

### DESTINATION 
root_dst_all="/mnt/c/Root/0_linux_home/git/music_scripts"


### /BIN  files
root_src_bin="/home/pestrela/bin"

cue_files_in="cue_convert_timestamps.sh  cue_merge_cues.py   cue_renumber_files.py  cue_make_tracklist.sh      cue_rename_cue_files.sh "
cue_folder_out="traktor/tracklist_tools"

mp3_files_in="mp3_analyse_fhg_offset.sh  mp3_check_encoder.sh   mp3_get_lame_indexes.py"
mp3_folder_out="traktor/26ms_offsets/bin"

download_files_in="youtube_dl.sh"
download_folder_out="downloads"

### MAPPING FILES
root_src_mappings="/mnt/c/Root/google_drive/Pedro/2 Music - Controllers/0_MAPS_Traktor/DDJ Pioneer/v6.6.0 - DDJ-1000 - TP3_TP2 BOME"

ddj_files_in='  "DDJ-1000 v6.5.0 - User manual.pdf" "DDJ-1000 v6.6.0 - User quickstart.pdf"   "Installation Help/DDJ-1000 - Frequently Asked Questions.pdf"    "Installation Help/DDJ-1000 - Installation Guide.pdf"  '
ddj_folder_out="traktor/ddj_1000_traktor_mapping"


## main program here
copy_files "$root_src_bin"   "$cue_files_in"      "$cue_folder_out"
copy_files "$root_src_bin"   "$mp3_files_in"      "$mp3_folder_out"
copy_files "$root_src_bin"   "$download_files_in" "$download_folder_out"

#copy_files "$root_src_mappings"   "$ddj_files_in" "$ddj_folder_out"

#exit 0

git pull
#git diff
git status

exit 0
