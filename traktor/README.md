
# Software Contents

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

## Why is Traktor my software of choice

Traktor has two major features that other softwares don't have. And I built my whole work-flows around these two features. 
As I use the DDJ-1000 (see below), this comparison will be mostly about Rekordbox, but other softwares are similar in these aspects.

* a) Mass-relocate: Traktor finds both RENAMED and MOVED files fully automatically. 
This is because Traktor identifies files by CONTENT, not by filename. This is crucial to manage music using operating system folders, and not DJ software playlists.
Also, it has a search box on your Operating System folders, so that you can see them without playlists. This feature was requested for years in Rekordbox.
More info: see below for a whole blog post on "How to manage your collection using operating systems folders and without DJ playlists"
  * Comparison to Rekorbox: if you MOVE your files, you have to relocate FOLDER by FOLDER. If you RENAME your files, you have to relocate FILE by FILE.
This tool finds moved files automatically, but not renamed files (https://github.com/edkennard/rekordbox-repair)
Hotcue doesnt move temporary cue as well. No search box on explorer node (access directly your OS files)
Ups: video, smart playlists, related tracks, plug and play for pioneer gear, GUI to remap pads very easily

* b) MIDI mapping with variables and multiple actions: this is crucial to make complex FX chains on the jog Wheels. 
For a demo, see at 6:30 of this video: https://www.youtube.com/watch?v=h9tQZEHr8hk&t=392s
MIDI Variables is also crucial to create more layers with additional shifts (one physical button = many functions). 
Both Rekordbox and Serato lack completely this ability. They only allow you to assign a single command to a single button. 
  * note: the gold standard in MIDI scripting is VDJscript (https://www.virtualdj.com/wiki/VDJscript.html). Having said this, the jog screens can only be mapped using BOME midi translator pro (https://www.bome.com/products/miditranslator)

There are some other smaller reasons. In general these are related to the above-mentioned main reasons. 
* Example: I use the hotcues as internal "bookmarks". In Traktor, presing a hotcue moves the temporary cue as well. Very useful when previewing a tagged song.  This is not the case in Rekordbox, which causes massive confusion. 
Even this was not the case in Trakor, this would be trivial to fix via MIDI mapping; such is impossible to address in both Rekordbox and Serato.
* On the Con side, the other softwares have great features that Traktor lacks: Video, smart playlists, related tracks, plug and play for pioneer gear, a great GUI to remap the pads very easily. But these do not offset the mass-relovate and midi mapping limitations.


## Why is DDJ-1000 my hardware of choice

Above I explained I why use Traktor. So why do I use it with a Rekorbox controller, instead of the S4Mk3??

Before we discuss this, please note that some years ago DJs could use any Software with any Hardware combination. 
This was a fully supported (and encouraged!) model by the vendors, which used this model to make real money from real customers. 

Having said this, the DDJ-1000 has major features that I personally value significantly over the S4Mk3:

* A) actual BIG+mechanical jogs. I use the jogs for Cueing, not Scratching. Even so, I've optimized significantly the MIDI latency of the jogs in my mapping. 
  The S4 jogs are still way too small for my hands. Moving jogs are cool, but not a dealbreaker. Haptic feedback is basically a gimmick for me.
  I've now mapped the jog screens to have the most important info, so it looks like the 1000SRT.
  
* B) more pad modes. All my most useful functions are a maximum of 2 clicks away - and without using any shifts. 
  Main Pad modes are a) Hotcue, b) Roll/padFX, c) MacroFX, d) JogFX. 
  Pressing twice the same pad mode cycles the top 2 sub-pages of that pad mode. This is way the reloop Elite mixer works. 
  I’ve got even more stuff on the secondary pad modes, accessible with a shift+mode. 

* C) two USB ports. This is crucial for seamless handovers between DJs; and for safety of connecting a backup laptop ready at any time.
  
* D) jogFX combos on the jogs. Please see them in my demo videos (eg 6:32 of https://www.youtube.com/watch?v=h9tQZEHr8hk&t=392s ). 
  This is turnkey in my mapping, i’m not familiar if they have it on the S4mk3 (it was present for sure on the S4MK1 DJTT mappings)

* E) beatFx in the correct place of the mixer (lower right corner = right hand of the DJ), with a FX selector knob to select the effect by name

* F) more inputs and outputs, microphones etc. In particular, the mixer has a full FX suite for any external inputs (colorFX + beatFX)

Note: the S4mk3 is a fantastic controller - I have recommended it to several people before. In particular the loop/beatjump encoders implementation is the gold standard for that. 
The overall integration is better, of course, which is a plus if you prefer plug-and-play vs customization. 

But in the end its really the big jogswheels that is the crucial deal breaker; This was completely abandoned by NI in 2014 with the release of the S8, and was only picked-up in 2018 with the S4MK3 (although, in my opinion, still not the same as the DDJ-1000).


## Is the DDJ-1000SRT mappable to Traktor? how does it compare to the original DDJ-1000-RB?

Physically, the 1000SRT look physically the same as the original 1000. However there are quite big differences inside that impact the mappings. 
I only own the 1000RB, and did not yet tested the SRT in a shop. When I test it I will update the below list.

* MIDI codes: 
  * the SRT has the classic SX2/SZ pad codes, which are different from the 1000RB style. This means the proper mapping for this device is my SX2/SZ map, and not the 1000 mapping. 
  * The SX2/SZ map is on version v6.1 (https://maps.djtechtools.com/mappings/9222), the 1000 is on version v6.5 (https://maps.djtechtools.com/mappings/9279).
  * More info: https://github.com/pestrela/music_scripts/tree/master/ddj/1%20MIDI%20codes
  
* Jog Screens:
  * While the screens look to be MIDI (no waveforms & cover art), there is no public MIDI codes like in the original 1000 RB version
  * Only when I can test this in a shop I can derive if the current 1000 BOME screens work could be ported to the SRT
  * More info: https://github.com/pestrela/music_scripts/tree/master/ddj/1%20MIDI%20codes
  
* Effects: 
  * the SRT runs in external mode, the 1000RB ran in internal mode. This means that all Pioneer effects are there, for both color FX and beat FXmper channel. This is not the case for the 1000, which 
  * potentially this means the SRT could be the first controller with **ALL** the Pionner effects (ColorFX, BeatFX), plus **ALL** the  Traktor effects (jogFX, mixerFX, macroFX, padFX)
  * comparison of HW and SW effects: [here](ddj_1000_traktor_mapping/Support%20files/Traktor%20mappings%20for%20DDJ%20Controllers%20-%20HW%20vs%20SW%20Effects.xlsx)
  * more info:  https://github.com/pestrela/music_scripts/tree/master/ddj/3%20Signal%20flows
  

## What documentation comes with the Traktor mappings?

My zip files have a lot of documentation besides the TSI file. IMO it has no comparision to the typical mappings avalaible on https://maps.djtechtools.com/ or https://www.traktorbible.com/freaks/default.aspx. 

Included is:
* Quick reference (pictures only): [example](ddj_1000_traktor_mapping/DDJ-1000%20v6.5.1%20TP3%20-%20Quick%20overview.pdf)
* User manual: [example](ddj_1000_traktor_mapping/DDJ-1000%20v6.5.1%20TP3%20-%20Full%20manual.pdf)
* Installation manual: [example](ddj_1000_traktor_mapping/Installation%20Help/DDJ-1000%20-%20Installation%20and%20Verification%20of%20the%20two%20required%20mappings.pdf)
* FAQ: [example](ddj_1000_traktor_mapping/Installation%20Help/DDJ-1000%20-%20Frequently%20Asked%20Questions.pdf)

Plus:
* Technical info (to extend the mapping): [example](ddj_1000_traktor_mapping/Support%20files/Technical%20Info%20-%20BOME%20DDJ%201000%20Screens.txt)
* Every single function: [example](ddj_1000_traktor_mapping/Support%20files/Source%20files/DDJ-1000%20-%20Detailed%20reference.xlsx)

## Can I get a demo of the mappings?

Please see the below Youtube videos. 
I have both long 30m videos where I cover every single function step-by-step, plus short "update" 5m video with the latest stuff only.

* DDJ-1000/800 playlist: https://www.youtube.com/playlist?list=PLIlvTGzSxI0XHlFyINdT6P42noqvkPISD
  * DDJ-1000 v6.3 - **main video** - http://youtu.be/EkSJ9Ug9Zuk
  * DDJ-1000 V6.5 - **jog screens** - https://youtu.be/h9tQZEHr8hk
  
* DDJ-SX2/SZ/SRT playlist: https://www.youtube.com/playlist?list=PLIlvTGzSxI0V3SUnYFYq4hpeu0o_XyP2l
  * DDJ-SX2/SZ/SRT v6.0 - **main video** - http://youtu.be/H_TE2mtuM6Q
  * DDJ-SX2/SZ/SRT v6.1 - **update** - http://youtu.be/sanF35CYeSg

* AKAI AMX playlist: https://www.youtube.com/playlist?list=PLIlvTGzSxI0Vi7aguzxbmOJdVQCW6CohR
  * AMX v1.0 - **main video** - http://youtu.be/TzAgENM55DE
   
 

 
## How to manage your collection using operating systems folders and without DJ playlists (ie, using only Finder, Windows Explorer, etc) 


My multi-genre, large collection is organized on OS folders (Operating System folders), instead of Playlists. 

This is to be independent of any possible DJ software, and also itunes. I find A LOT easier just to have many Windows Explorer windows open, plus logically group and sub-group files on folders on the folder tree. 

Because of this is use the “explorer” node of the DJ programs all the time instead of DJ playlists.

My workflow is fully automated:
* b) I change filenames continuously to correct artist/title. I use MP3tag_scripts to a) capitalize the names (format is “ARTIST1 ft. ARTIST2 - Capitalized Title - Remix” and b) rename the internal tags  [1].
* c) Traktor mass-relocate finds files everywhere by AUDIO-ID (ie, content). This is much superior than rekordbox and others [2].
* d) I made a custom python script that duplicates cues of the duplicated files inside the Traktor collection.nml [1]. This is comparable to [3].
* e) I use DJCU+RECU/Rekordbuddy2 to generate the rekordbox.xml file. This is done inside a MacOS VM [4] [5]. There were some manual steps, so I made a script to convert the filenames [1]. A Windows-only alternative is [6]
* f) I only need playlists for CDJs. To make playlists, I mass-convert all folders to itunes playlists, recursively. Mac version is [7]; A windows version is [8]. Then I do the usual rekordbox step to prepare USBs pens.

References:   
* [1] My scripts: https://github.com/pestrela/music_scripts 
* [2] AUDIO_ID: https://www.mail-archive.com/mixxx-devel@lists.sourceforge.net/msg05061.html
* [3] Duplicate tool: http://www.flowrl.com/librarian/
* [4] MacOS VM: https://saintlad.com/install-macos-sierra-in-virtualbox-on-windows-10/
* [5] rekordbuddy VM: https://www.reddit.com/r/Beatmatch/comments/52dvst/how_to_transfer_your_windowsbased_dj_library_from/
* [6] Windows conversion:	https://github.com/ErikMinekus/traktor-scripts/blob/master/playlist-export.py
* [7] MAC folders to itunes playlist: https://dougscripts.com/itunes/scripts/ss.php?sp=droptoaddnmake
* [8] Windows folders to itunes playlists: http://samsoft.org.uk/iTunes/scripts.asp
 
 
## How I build perfect tracklists using CUE files

I use a set of tools to generate a CUE file with the timings of my sets.
Once I have this file, I can generate tracklists with timestamps like in this example: https://www.mixcloud.com/dj_estrela/mix-17-cd07-trance-jun-2019/

Steps BEFORE the set (for prepared sets):
* group the files in folders, per style (Vocal Trance, Uplitfing trance, etc)
* select the tracks and their order using winamp; Once this is OK, run "cue_renumber_files.py" and "cue_make_tracklist.sh".

Steps AFTER the set (both live sets and prepared sets):
* convert the NML to a text tracklist using https://slipmat.io/playlists/
* listen the recording in winamp to spot major mistakes. Tag the locations in MMM:SS format. At the end, use "cue_convert_timestamps.sh" to convert to HH:MM:SS format
* open the huge WAV file in Adobe audition, and perform the following:
  * normalize volume of all tracks
  * fix any obvious mistakes if necessary (eg, track ended too early when playing live, etc)
  * tag the divisions of the tracks inside the wav file
* convert the tags inside the WAV into a CUE file, using this software: http://www.stefanbion.de/cuelisttool/index_e.htm
  * note: this sowftare fails on files bigger than 2Gb. Workaround is splittingthe file at the 3hour mark, exactly, then use an option in cue_merge_cues.py to add this offset back in the second file
* convert the tags inside the WAV into a CUE file, using this software: http://www.stefanbion.de/cuelisttool/index_e.htm
* merge the CUE file with the Tracklist file using cue_merge_cues.py
* upload the mix to http://mixcloud.com/dj_estrela
  
  
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

## What is the 26ms shift issue when converting cues/loops between softwares?

* We have found that 6% of the files have a shift of 26 milliseconds when going from Traktor to Rekordbox. The other 94% of the files will be fine.
* This shift is very noticeable and breaks beatgrids/loops. See below for a graphical example of this issue.
* Root cause is that different MP3 decoders treat differently the tricky MP3 LAME tag (+the derived LACV tag).
* After a lot of research we found a way to predict this difference by interpreting the eyeD3 tool. See below for the current algorithm.
* Now that we understand what is going, we are adding this capability to the dj-data-converter, a free command-line tool that works in all systems (Windows, Mac, Linux, WSL)

Main ticket: https://github.com/digital-dj-tools/dj-data-converter/issues/3
To run the analysis code in an ipython notebook: https://mybinder.org/v2/gh/pestrela/music_scripts/master

  
  
