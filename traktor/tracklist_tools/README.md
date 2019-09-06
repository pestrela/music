
I use a set of tools to generate a CUE file with the timings of my sets.
Once I have this file, I can generate tracklists with timestamps like in this example: https://www.mixcloud.com/dj_estrela/mix-17-cd07-trance-jun-2019/


Overview of the Cue tools:

* cue_renumber_files.py:
  * renumbers mp3 files, in sequence. This is useful to make a sequenced playlist in your operating system folders, outside Traktor.

* cue_make_tracklist.sh:
 *   from a folder, generates basic tracklist text files

* cue_convert_timestamps.sh:
  *  convert MMM:SS to HH:MM:SS format. Winamp uses the first format, Adobe audition uses the second 

* cue_merge_cues.py: 
  * this is the main tool. It merge back and forth any CUE file with any tracklist text file. 
    It can read either case from seperate or single files. It also cleans the artist - title fields, and generates timestamped tracklists 

* cue_rename_cue.sh: 
  *  matches the CUE file contents with the FILE tag. This is useful when you rename the files externally.


  