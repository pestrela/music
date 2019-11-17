

# Traktor_clone_cues.py

This script clones CUEs and merges collections of your Traktor collection.nml files.

## Main feature: clone CUEs

  This script is able to clone CUEs of the Duplicate files in your Collection.
	
  This is useful when you organise your music using OS folders (instead of traktor playlists).
  In that case, you physically copy files to have them in different "playlists".
  Ignoring the wasted space, the biggest issue is that the CUEs do not propagate to the other duplicates.
  This script fixes this by matching the files by AUDIO_ID [1], and copy the one that has the biggest number of CUEs into their duplicates.
  
  The script is also useful when you have shared files in separate Club and Wedding collections.
  To split collection either creating multiple users, or if you manually rename collection.nml.

	INPUT: -c "main_collection.nml"

## Secondary feature: merge collections

	Using the same method as above, this script can merge CUEs from multiple collections.

	This is useful when you had an old collection that had CUEs, and somehow they have been lost.
	Simply load both the old and the current collection, and the script will carry missing CUEs forward into the latest collection.
  Note that as above the merging criteria is again the file with the biggest number of CUEs - not the time of last update!!
	
	INPUT: -c "collection.nml" [*.nml]
  
# CUE tools

I use a set of tools to generate a CUE file with the timings of my sets.
Once I have this file, I can generate tracklists with timestamps like [in this example](https://www.mixcloud.com/dj_estrela/mix-17-cd07-trance-jun-2019/).
The tools can also scrape lyrics and search youtube.


Overview of the Cue tools:

* cue_renumber_files.py:
  * physically renumbers mp3 files, in sequence. This is useful to make a sequenced playlist in your operating system folders, outside Traktor.

* cue_make_tracklist.sh:
  * generates a basic tracklist text files from the contents of a folder

* cue_convert_timestamps.sh:
  * convert MMM:SS to HH:MM:SS format. Winamp uses the first format, Adobe audition uses the second 

* cue_merge_cues.py: 
  * this is the main tool. It merge back and forth any CUE file with any tracklist text file.\
    It can read either case from seperate or single files. It also cleans the artist - title fields, and generates timestamped tracklists 

* cue_scrape_lyrics.sh: 
  * this scrapes multiple providers for the lyrics of every track of a set. 
  * Supported: Genius, MusixMatch, MetroLyrics, LyricsWorld, FlashLyrics

* cue_search_youtube.sh:
 * This opens a whole tracklist in separate youtube tabs
 * see also the generic keyboard shortcuts to [search anything in youtube](../README.md#What-generic-software-tools-did-you-built-for-Windows)
  
  

# DJ conversion VM aids  
  
These scripts help running DJ conversion macOS programs in Windows.
I no longer run these utilities as I now use native Windows converters.
  
## Rekorbuddy aid

* This program runs Rekordbuddy in Windows (n a macOC VM). It depends on having a share with the same structure. 
* It aggregates all involved files in a work directory, converts between windows and macOS formats, and places the final rekordbox file in the appropriate final location
   
Please see help text in program for more details, usage and links to overviews   
   
## DJCU+RECU aid

* same idea as above, but for DJCU instead (please note that I'm only maitaining the above rekordbuddy process)
 