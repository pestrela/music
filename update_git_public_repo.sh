#!/bin/bash

# simple script to update the public git repo, out of the local ~/bin working copies


set -u
set -e
#set -x

function copy_files()
{
  local files_in="$1"
  local folder_out="$2"
  local file
  local file_in
  local dst_out
  
  
  for file in $files_in ; do
    file_in="${root_src}/${file}"
    file_out="${root_dst}/${folder_out}/${file}"
    
    echo cp "${file_in}" "${file_out}"  
    cp "${file_in}" "${file_out}"  
  done
}


root_src="/home/pestrela/bin"
root_dst="/mnt/c/Root/0_linux_home/git/music_scripts"

####
cue_files_in="cue_convert_timestamps.sh  cue_merge_cues.py   cue_renumber_files.py  cue_make_tracklist.sh      cue_rename_cue_files.sh "
cue_folder_out="traktor/tracklist_tools"

mp3_files_in="mp3_analyse_fhg_offset.sh  mp3_check_encoder.sh   mp3_get_lame_indexes.py"
mp3_folder_out="traktor/26ms_offsets/bin"

download_files_in="youtube_dl.sh"
download_folder_out="downloads"


## main program here
copy_files "$cue_files_in" "$cue_folder_out"
copy_files "$mp3_files_in" "$mp3_folder_out"
copy_files "$download_files_in" "$download_folder_out"

git pull
git status

exit 0
