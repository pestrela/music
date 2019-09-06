
# Contents

This folder contains my Traktor tools and mappings

* ddj_1000_traktor_mapping
  * A backup of the my Traktor+BOME mapping for the DDJ-1000 with jog screens support.
  * Main page: https://maps.djtechtools.com/mappings/9279
*  collections_without_playlists
   * Tools to manage your collection using Operating System folders. See the below blog post as well.
* tracklist_tools
  * Tools to generate CUE files and timestamped tracklists. See the below blog post as well
* 26ms offsets
  * Finding mp3 cue shifts in DJ conversion apps. Main ticket: https://github.com/digital-dj-tools/dj-data-converter/issues/3
* macos_converters
  * Scripts able to run the DJCU and Rekordbuddy tools in Windows. (these convert collections from Traktor to Rekordbox)



# Blog posts

## Why is Traktor my main DJ system

Traktor has two major features that other softwares don't have. And I builtmy whole workflows around these two features:

* a) Mass-relocate: Traktor finds moved files across folders, and of the filename is changed, fully automatically. 
This is because it identifies files by AUDIO_ID content, not by filename. This is crucial to manage music using operating system folders, and not DJ software playlists.
This is also made possible because Traktor has a search box to search any file in your operating system folders. This was requested for years in Rekorxbox.
More info: whole blog post on "How to manage your collection using operating systems folders and without DJ playlists"

* b) MIDI mapping with variables: this is crucial to make complex FX chains on the jog Wheels. 
For a demo, see at 6:30 of this video: https://www.youtube.com/watch?v=h9tQZEHr8hk&t=392s
MIDI Variables is also crucial to create more layers with additional shifts (one physical button = many functions). 
Either Rekordbox and Serato lack this ability at all, and only allow you to assign a single command to a single button.
 
  * note: the gold standard in MIDI scripting is VDJscript (https://www.virtualdj.com/wiki/VDJscript.html). Having said this, the jog screens can only be mapped using BOME midi translator pro (https://www.bome.com/products/miditranslator)

There are some smaller specific reasons, but which are related to the above-mentioned reasons. 
* For example, pressing a hotcue moves the temporary cue as well. This is not the case in other softwares.
Even if that was not the case, this would be trivial to fix with MIDI mapping, and impossible in eg Rekordbox.
 

## Why is DDJ-1000 my main controller

Above I explained I why use Traktor. So why do I use it with a Rekorbox controller, instead of the S4Mk3?

First, please note that some years ago, DJs could use any Software with any Hardware; this was a fully suppoted model by the vendors. 
This no longer the case, so thats why I've used this model using mappings.

Second, the DDJ-1000 has the following features that I value signifiantly over the S4Mk3:

* A) actual BIG+mechanical jogs. I use the jogs for cueing, not scratching. Even so, I've optimized significantly the MIDI latency. 
  The S4 jogs are still way too small for my hands. Moving jogs are cool, but not a dealbreaker. Haptic feedback is basically a gimmick for me.
  I've mapped the jog screens that have the most important info (just like the 1000SRT)
  
* B) more pad modes. All my most useful functions are a maximum of 2 clicks away - and without using any shifts. 
  Main Pad modes are hot cue, roll/padFX, macroFX, jogFX. Pressing twice the same pad mode cycles the top 2 sub-pages of that pad mode. This is way the new reloop elite mixer works. 
  I’ve got even more stuff on the secondary pad modes, accessible with a shift 

* C) jogFX combos on the jogs. Please see them in my demo videos. This is turnkey in my mapping, i’m not familiar if they have it on the S4mk3 (it was present for sure on the S4MK1 DJTT mappings)

* D) beatFx in the correct place of the mixer (lower right corner = right hand of the DJ), with a FX selector knob to select by name

* E) more inputs and outputs, microphones etc. In particular, full FX suite for any external inputs

Note: the S4mk3 is a fantastic controller - I have recommended it to several people before. In particular the loop/beatjump encoders implementation is the gold standard for that. 
The overall integration is better, of course, which is a plus if you prefer plug and play vs customization. 
In the end its really the big jogswheels that is the crucial deal breaker.

 
## How to manage your collection using operating systems folders and without DJ playlists (ie, using only Finder, Windows Explorer, etc) 

	My multi-genre, large collection is organized on OS folders (Operating System folders), instead of Playlists. 
  
  This is to be independent of any possible DJ software and itunes. I find a lot easier to have many Windows Explorer windows open, plus grouping and sub-grouping files on folders. 
  As such I use the “explorer” node of the DJ programs instead of playlists.

	My workflow is fully automated:
	 b) I change filenames continuously to correct artist/title. I use MP3tag_scripts to a) capitalize the names (format is “ARTIST1 ft. ARTIST2 - Capitalized Title - Remix” and b) rename the internal tags  [1].
	 c) Traktor mass-relocate finds files everywhere by AUDIO-ID (ie, content). This is much superior than rekordbox and others [2].
	 d) I made a custom python script that duplicates cues of the duplicated files inside the Traktor collection.nml [1]. This is comparable to [3].
	 e) I use DJCU+RECU/Rekordbuddy2 to generate the rekordbox.xml file. This is done inside a MacOS VM [4] [5]. There were some manual steps, so I made a script to convert the filenames [1]. A Windows-only alternative is [6]
   f) I only need playlists for CDJs. To make playlists, I mass-convert all folders to itunes playlists, recursivelly. Mac version is [7]; Windows version is [8]. Then I do the ususal rekordbox step to prepare USBs pens.

   
	[1] My scripts: https://github.com/pestrela/music_scripts 
	[2] AUDIO_ID: https://www.mail-archive.com/mixxx-devel@lists.sourceforge.net/msg05061.html
	[3] Duplicate tool: http://www.flowrl.com/librarian/
	[4] MacOS VM: https://saintlad.com/install-macos-sierra-in-virtualbox-on-windows-10/
	[5] rekordbuddy VM: https://www.reddit.com/r/Beatmatch/comments/52dvst/how_to_transfer_your_windowsbased_dj_library_from/
	[6] Windows conversion:	https://github.com/ErikMinekus/traktor-scripts/blob/master/playlist-export.py
	[7] MAC folders to itunes playlist: https://dougscripts.com/itunes/scripts/ss.php?sp=droptoaddnmake
	[8] Windows folders to itunes playlists: http://samsoft.org.uk/iTunes/scripts.asp
 
 
## How I build perfect tracklists using CUE files

I use a set of tools to generate a CUE file with the timings of my sets.
Once I have this file, I can generate tracklists with timestamps like in this example: https://www.mixcloud.com/dj_estrela/mix-17-cd07-trance-jun-2019/


Overview of the Cue tools:

* cue_renumber_files.py:
  * renumbers mp3 files, in sequence. This is useful to make a sequenced playlist in your operating system folders, outside Traktor.

* cue_make_tracklist.sh:
  * from a folder, generates basic tracklist text files

* cue_convert_timestamps.sh:
  * convert MMM:SS to HH:MM:SS format. Winamp uses the first format, Adobe audition uses the second 

* cue_merge_cues.py: 
  * this is the main tool. It merge back and forth any CUE file with any tracklist text file. 
    It can read either case from seperate or single files. It also cleans the artist - title fields, and generates timestamped tracklists 

* cue_rename_cue.sh: 
  *  matches the CUE file contents with the FILE tag. This is useful when you rename the files externally.



  
