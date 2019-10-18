
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

# Table of Contents
  * [Why I manage music using OS-folders only](#why-i-manage-music-using-os-folders-only)
  * [How to manage your collection using operating systems folders and without DJ playlists](#how-to-manage-your-collection-using-operating-systems-folders-and-without-dj-playlists-ie-using-only-finder-windows-explorer-etc)

  * [Why is Traktor my software of choice](#why-is-traktor-my-software-of-choice)
  
    * [database repair](#why-is-traktor-my-software-of-choice-a-database-repair)
    * [OS Search](#why-is-traktor-my-software-of-choice-b-os-search)
    * [Advanced MIDI mapping and Lots of FX](#why-is-traktor-my-software-of-choice-c-advanced-midi-mapping-and-lots-of-fx)
    * [Hotcues move the temporary cue as well](#why-is-traktor-my-software-of-choice-d-hotcues-move-the-temporary-cue-as-well)
 
  * [Which features I miss in Traktor](#Which-features-I-miss-in-Traktor)
  * [Why I moved to BOME midi mapping](#Why-I-moved-to-BOME-midi-mapping)
  * [The future of Traktor mappings](#The-future-of-Traktor-mappings)

  * [Why i like BIG mechanical jogwheels](#why-i-like-big-mechanical-jogwheels)
  
  * [Why is DDJ-1000 my hardware of choice](#why-is-ddj-1000-my-hardware-of-choice)
  
  
  * [What are the features of your DDJ-1000 Traktor mapping](#What-are-the-features-of-your-DDJ-1000-Traktor-mapping)


  * [Is the DDJ-1000SRT mappable to Traktor?](#is-the-ddj-1000srt-also-mappable-to-traktor)
  
  * [What documentation comes with your mappings?](#what-documentation-comes-with-your-mappings)
  * [Can I see a video demo of your mappings?](#can-i-see-a-video-demo-of-your-mappings)
  
  
  * [What is the 26ms shift issue when converting cues/loops between softwares?](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares)
  * [Which DJ converters avoid the 26ms shift issue?](#which-dj-converters-avoid-the-26ms-shift-issue)
  
  * [How to avoid crackle / glitches / noise on Windows by disabling Intel turbo boost?](#how-to-avoid-crackle--glitches--noise-on-windows-by-disabling-intel-turbo-boost)
  * [How I build perfect tracklists using CUE files](#how-i-build-perfect-tracklists-using-cue-files)
      
# Mindmap summary

The picture below summarizes the main ideas and dependencies explained in these blog posts.
![traktor_mindmap](various/traktor_mindmap.png?raw=true "Traktor Mindmap")

# Blog posts

## Why I manage music using OS-folders only

I have a large collection composed of multiple genres / sub-genres / decades. It covers:
 * 2 seperate DJs
 * 10 major-genres
 * 50 sub-genres
 * 300 playlist folders
 * 7000 individual tracks

This is an example of how my "playlists" look like. The full tree is far larger.
![DJ Genres](various/dj_genres.png?raw=true)

Playlists are supported by all DJ softwares, but I find far easier to do it OS-filesystem instead. Main reasons:

* **Multiple views:** this allows me have many Windows Explorer windows open, and move files in-between them. Explorer windows are always available, and [now support tabs](http://qttabbar.wikidot.com/)
* **Grouping**: Folders can contain both sub-folders or files. I find this a very natural model to organize genres and sub-genres. It is also a proven mode, it was [was invented in the 1960s](https://en.wikipedia.org/wiki/Path_(computing)#History). Itunes a more bureaucratic model with 3 levels instead (folders -> playlists -> files). This 3-step model was later copied to all DJ softwares.
* **Easy file renaming:** Using multiple Explorers, I change filenames continuously to correct the artist/title. My [MP3tag](https://www.mp3tag.de/en/) scripts automatically capitalize the names as “ARTIST1 ft. ARTIST2 - Capitalized Title - Remix”, and update the internal mp3 tags to match this. [Link to mp3tag scripts](collections_without_playlists/Mp3tagSettings.zip) 
* **Software Independence:** Using OS-folders you are independent of any possible DJ software, and also itunes. It also trivial to sync between DJ collections and make perfect backups to my NAS using [resilio sync](https://www.resilio.com/individuals/). It is also trivial to load a whole genres to USB sticks to listen in cars.

See also [this blog post for more details on this workflow](#how-to-manage-your-collection-using-operating-systems-folders-and-without-dj-playlists-ie-using-only-finder-windows-explorer-etc).
  

## How to manage your collection using operating systems folders and without DJ playlists (ie, using only Finder, Windows Explorer, etc) 

Above I've described [why I use OS-folders only](#how-to-manage-your-collection-using-operating-systems-folders-and-without-dj-playlists-ie-using-only-finder-windows-explorer-etc). In this post I will describe how this workflow works and how it can be have **fully automated**.

* **#1: Mp3tag:** Using multiple Explorers, I change filenames continuously to correct the artist/title. My [MP3tag](https://www.mp3tag.de/en/) scripts automatically capitalize the names as “ARTIST1 ft. ARTIST2 - Capitalized Title - Remix”, and update the internal mp3 tags to match this. [Link to mp3tag scripts](collections_without_playlists/Mp3tagSettings.zip)
* **#2: Database repair:** Traktor repairs the internal database to match what is on disk. [more info on mass-relocate](#why-is-traktor-my-software-of-choice)
* **#3: Duplicate Cues**: I made a [small python script](collections_without_playlists/traktor_clone_cues.py) to duplicate the cues for the physically duplicated files. This is comparable to [the traktor Librarian](http://www.flowrl.com/librarian).
* **#4: Dj Converter:** I use the [DJ Data Converter](#which-dj-converters-avoid-the-26ms-shift-issue) to generate the rekordbox.xml file without the [26ms shift problem](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares).
* **#5: Rekordbox Video:** When playling video gigs I use the explorer node inside Rekordbox. As this one still lacks a search box ([see point B) of this post](#why-is-traktor-my-software-of-choice)), I use a real File Explorer window in parallel when needed.
* **#6: CDJ export:** I only really need playlists for CDJs. There are scripts to mass-convert all folders to DJ playlists. Windows version is http://samsoft.org.uk/iTunes/ImportFolderStructure.vbs; Mac version is https://dougscripts.com/itunes/scripts/ss.php?sp=droptoaddnmake; Then I do the usual rekordbox step to prepare USBs pens.

See also the [DJCU workflow from ATGR](https://www.youtube.com/watch?v=d4QO6xxGovQ).
 
## Why is Traktor my software of choice

Below the 4x main reasons that I love Traktor.

See also [which features I miss in Traktor](#Which-features-I-miss-in-Traktor).
See also the graph showing the [most popular DJ softwares over time](../census_graphs).


## Why is Traktor my software of choice: a) Database repair

Traktor is above to find RENAMED files fully automatically without losing CUE points, beat grid or re-analysis.

I RENAME and MOVE files very regularly at the OS-folders level, using Windows Explorer/macOS finder.

When Traktor starts, it does a "consistency check" to confirm if all files are still there. (demo: [0:24 of this video](https://www.youtube.com/watch?v=i_zYavcCa7k&t=24s)). This finds all missing files in a single go (demo: [0:50 of this video](https://www.youtube.com/watch?v=i_zYavcCa7k&t=50))\
Then, the mass-relocate process fixes everything in a single go as well; you just select the root folder that contains your files "somewhere". In the extreme worst case this would be your whole hard drive. (demo: [5:36 of this video](https://www.youtube.com/watch?v=i_zYavcCa7k&t=320s)).

The relocate process is reasonably straightforward for MOVED files. However it is much much harder for RENAMED files.\
Traktor is the only software that achives that because it fingerprints everything in a private field called "[AudioId](https://www.mail-archive.com/mixxx-devel@lists.sourceforge.net/msg05061.html)")

When the mass-relocate process ends, everything is magically found again. Crucially all metadata is kept: CUE points, beat grid, analysed BPM, stripe, etc.\
Together with the OS-search feature described below, this enables me to use folders as "virtual playlists".
  * Comparison to Rekordbox: Renamed files need to be relocated FILE by FILE.\
  Moved files can be done FOLDER by FOLDER.\
  If this manual process is skipped, the files are seen as brand new, losing all meta-data.\
  [An external tool](https://github.com/edkennard/rekordbox-repair) helps the moved files case.
  * Comparison to VDJ: Everyhting need to be relocated FILE by FILE.
  * Comparison to Serato: To test.

## Why is Traktor my software of choice: b) OS-search

Traktor allows searching inside any OS folders. I don't have DJ playlists inside Traktor; instead, my OS-folders are my "virtual playlists".\
I have a very large collection with dozens of genres, sub-genres and decades. For that I've created a structure where each decade is a separate folder, inside a parent genre/sub-genre folders.\
When I'm playing a specific genre I can search only that decade (=OS folder). If I want something else I can always search the whole collection at any time.\
([See this blog post for more detail on these methods](#how-to-manage-your-collection-using-operating-systems-folders-and-without-dj-playlists-ie-using-only-finder-windows-explorer-etc))
  * Comparison to Rekordbox: Rekordbox displays OS folders, but you can't search inside them
  * Comparison to Serato: Serato has a nicer way to display OS folders, but you can't search inside them
  * Comparison to VDJ: VDJ has really good OS-searches, better than traktor, by having a "recurse" option to see all sub-folder files in a flat view
  
## Why is Traktor my software of choice: c) Advanced MIDI mapping and Lots of FX
  
Traktor supports complex MIDI mapping with 8x variables, 2x conditionals and any number of actions per MIDI input

My [AKAI AMX mapping has 10 layers built using shifts and states](https://github.com/pestrela/music_scripts/blob/master/traktor/akai_amx_traktor_mapping/AMX%20v1.0.1%20TP3_TP2%20-%20Quick%20overview.pdf) to cram A LOT more functionality than the existing buttons.\
My [DDJ-1000 mapping has FX chains of the Jogwheel](https://github.com/pestrela/music_scripts/blob/master/traktor/ddj_1000_traktor_mapping/DDJ-1000%20v6.5.1%20TP3%20-%20Quick%20overview.pdf). For a demo, see at 6:30 of this video: https://www.youtube.com/watch?v=h9tQZEHr8hk&t=392s \
This is only possible if midi mapping has variables and multiple actions per physical input.
  * Comparison to Rekordbox: No variables at all, no multiple actions. They only allow you to assign a single command to a single button. 
  * Comparison to Serato: No variables at all, no multiple actions. They only allow you to assign a single command to a single button. 
  * Comparison to VDJ: VDJ is even better than traktor, has it has a full scripting language built-in ([VDJscript](https://www.virtualdj.com/wiki/VDJscript.html)). It features infinite variables, conditions and states; Traktor only has 8 variables, 2 conditions and 8 states.

See also ["Why I moved to BOME midi mapping"](#Why-I-moved-to-BOME-midi-mapping).

## Why is Traktor my software of choice: d) Hotcues move the temporary cue as well

I use the hotcues as internal "bookmarks". In Traktor, pressing a hotcue moves the temporary cue as well.\
This is very useful for  previewing an old song that you dont remember anymore. When you are done, you just move it to the last point using the big round button.
  * Comparison to Rekordbox: No option to move the temporary cue when pressing a hotcue. This causes massive confusion to me every single time. This would be trivial to fix using advanced MIDI mapping. [This was requested in their forum](https://forums.pioneerdj.com/hc/en-us/community/posts/360021313752-Is-there-any-way-at-all-to-reassign-the-cue-button-to-cue-to-the-most-recently-selected-hot-cue-rather-than-only-being-used-to-make-cue-points-)
  * Comparison to Serato: untested
  * Comparison to VDJ: untested, but not a problem for sure (trivial to change using advanced MIDI mapping)

## Which features I miss in Traktor

Specific features:
* #1: Elastic beatgrids 
* #2: Plug-and-Play to Pioneer gear / DDJ controllers ([because this is the most popular equipment today](../census_graphs))
* #3: Multiple pad modes on screen, and an associated pad editor (like Rekordbox and VirtualDJ)
* #4: Turntable start&stop on the play/pause button
* #5: Video support
* #6: [VDJscript](https://www.virtualdj.com/wiki/VDJscript.html), with a lot more than 8x variables and 2x conditions
* #7: Smart playlists and related tracks

In general I fully agree with [this Digitial DJ Tips article](https://www.digitaldjtips.com/2019/10/what-next-for-traktor/). Generic comments:
* #1: “Please embrace hardware partners again…”
* #2: “Please speed up software development!”
* #3: “Please, no more reinventing the wheel :)”

But in the end Traktor has [has unique features that I depend on](#why-is-traktor-my-software-of-choice).

See also the [most popular DJ softwares census](../census_graphs).

## Why I moved to BOME midi mapping

As [explained above](#Why-is-Traktor-my-software-of-choice:-c)-Advanced-MIDI-mapping-and-Lots-of-FX), Traktor mapping rocks.\
Sadly I've hit its limits multiple times :). It also lacks essential features required on the [DDJ-1000 screens mapping](ddj_1000_traktor_mapping).

* **Impossible features in Traktor:**
  * **#1: 14-bit out messages**: Trakor supports *receiving* high resolution midi messages. I need to *send* them as well [on my DDJ-1000 mapping](../ddj/1%20MIDI%20codes/DDJ-1000RB%20-%20MIDI%20Messages.pdf)
  * **#2: Sequence of Events**: For PadFX, I *first* need to change the FX, and *then* need to turn it on. This is not something Traktor support; both actions are tried simultaneously resulting in something else. More info: page 88 of the [Rudi Elephant mapping](various/RUDI-Js%20ELEPHANT%20TSI%20for%20VCI-400SE%20%2B%20Maschine%20(MK1)%20%2B%20BCR%202000%20v2.0.pdf).
  * **#3: Timers**: Something simple as end-of-track blinking require timers to schedule actions for later. Same story for [vinyl break on the play/pause nutton](https://www.youtube.com/watch?v=EPnmyDiaJTE), as implemented by [Traktor Mapping Service](http://traktormappingservice.com/)
  * **#4: Any event as a conditional**: Some events can be inputs to conditionals, like "is in active loop". However many events are missing, for example "which deck is master." To implement this, please see page 87 of the [Rudi Elephant mapping](various/RUDI-Js%20ELEPHANT%20TSI%20for%20VCI-400SE%20%2B%20Maschine%20(MK1)%20%2B%20BCR%202000%20v2.0.pdf).\
\
* **Possible features in Traktor (with a lot of hacking!):**
  * **A) More modifiers**: I use a lot more than [8 modifiers](https://www.native-instruments.com/forum/threads/controllerism-more-modifiers-more-bits-more-conditions.329045/). I use a lot more than 3 bits per modifier state. To go around this I add a lot of complexity to my mappings.
  * **B) More conditionals**: I use a lot more than [2 conditions in my mappings](https://www.native-instruments.com/forum/threads/add-3rd-slot-for-modifier-conditions-in-controller-manager.325569/#post-1622169). To go around this I [squeezed multipe states into each modifier](https://www.traktorbible.com/en/squeezing-modifiers.aspx). Again, this added a lot of complexity to my mappings.
  * **C) Global modifiers:** I miss [global modifiers](https://www.native-instruments.com/forum/threads/named-variables-operators.326339/#post-1628411), to link the state in multiple pages. More info: page 87 of the [Rudi Elephant mapping](various/RUDI-Js%20ELEPHANT%20TSI%20for%20VCI-400SE%20%2B%20Maschine%20(MK1)%20%2B%20BCR%202000%20v2.0.pdf).
  * **D) Preferences window freeze:** To add more variables, you need to add extra mapping pages. Having more than 6 pages [freeze your preferences window](https://www.native-instruments.com/forum/threads/preferences-window-freeze.328315/) **even if they are completely empty**.

## The future of Traktor mappings

A major Traktor strength is the MIDI mappings system. Very flexible and powerful.\
Traktor maps are by far the most popular in https://maps.djtechtools.com \
Large mappings are really complex to build - but once this is done other users immediately benefit by just installing them.

However the Traktor mappings system didn't get improvements for years, and [is is now quite old](#Why-I-moved-to-BOME-midi-mapping).
It now is also not powerful enough [to map recent controllers](#Why-I-moved-to-BOME-midi-mapping).

For example in my DDJ-1000 mapping I had to use BOME midi translator as a middle man:\
https://maps.djtechtools.com/mappings/9279

In my view the mappings are a unique sucess story of Traktor. This could continue to give great results with just some quality-of-life improvements.

## Why I like BIG mechanical jogwheels

Spoiler: its not scratching!

I use jogs all the time in a controller - full list below. As I have big hands, I love them to be as BIG as possible.

Sorted by usage frequency:
* Adjusting tempo drift for older tracks
* Cueing / fast preview to the exact spot where the track will start
* Doing effects on the jog - see 6:32 of https://www.youtube.com/watch?v=h9tQZEHr8hk&t=392s
* Adjusting beatgrids on the fly
* Very occasional live scratching / tricks

What I dont use:
* Moving jogs are cool, but not a dealbreaker
* Haptic feedback is basically a gimmick for me

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

Note: the S4mk3 is a fantastic controller - I have recommended it to several people before. In particular the loop/beatjump encoders implementation is the gold standard for that.\
The overall integration is better, of course, which is a plus if you prefer plug-and-play vs customization. 
\
But in the end its really the big jogswheels that is the crucial deal breaker; This was completely abandoned by NI in 2014 with the release of the S8, and was only picked-up in 2018 with the S4MK3 (although, in my opinion, still not the same as the DDJ-1000).
\
Result: I've built a huge DDJ-1000 mapping for Traktor, using [BOME](https://www.bome.com/products/miditranslator) to support the jog screens.
* Main page: https://maps.djtechtools.com/mappings/9279
* Documentaton: https://github.com/pestrela/music_scripts/blob/master/traktor/ddj_1000_traktor_mapping/

## What are the features of your DDJ-1000 Traktor mapping?

**Feature list:**
*	Jog Screens
*	7x Jogwheel FX chains
*	5x MixerFX
*	11x MacroFX
*	21x padFX (“instant gratification”)
*	3x tone play modes (“keyboard mode”)
*	8x Rolls
*	Slicer
*	Dedicated preview player
*	Loops manual adjust (via jogs)
*	Beatjump and Loops pages
*	End of track warning blinks and other CDJ emulation
*	All functions reachable without shifts\
\
*	Download Link: https://maps.djtechtools.com/mappings/9279
*	Video demo: https://youtu.be/h9tQZEHr8hk

\

**About this mapping:**
* This is the only mapping for the DDJ-1000 supporting Jog Screens. It works on both Traktor 3 and 2. It requires the 3rd-party BOME Pro MIDI translator. Free trial versions are available to test everything. 
*	It is also the most complete by far. It supports MixerFX, MacroFX, JogFX chains, padFX, Keyboard mode, Rolls, and a Preview Player. Latest features are CDJ-emulation, Loops adjust and Beatjump shortcuts.

## What documentation comes with your mappings?

My zip files have **a lot** of documentation besides the TSI file.\
IMO it has no comparision to the typical mappings available on https://maps.djtechtools.com/ or https://www.traktorbible.com/freaks/default.aspx. 

Included is:
* Quick reference (pictures only): [example](ddj_1000_traktor_mapping/DDJ-1000%20v6.5.1%20TP3%20-%20Quick%20overview.pdf)
* User manual: [example](ddj_1000_traktor_mapping/DDJ-1000%20v6.5.1%20TP3%20-%20Full%20manual.pdf)
* Installation manual: [example](ddj_1000_traktor_mapping/Installation%20Help/DDJ-1000%20-%20Installation%20and%20Verification%20of%20the%20two%20required%20mappings.pdf)
* FAQ: [example](ddj_1000_traktor_mapping/Installation%20Help/DDJ-1000%20-%20Frequently%20Asked%20Questions.pdf)

Plus:
* Technical info (to extend the mapping): [example](ddj_1000_traktor_mapping/Support%20files/Technical%20Info%20-%20BOME%20DDJ%201000%20Screens.txt)
* Every single function: [example](ddj_1000_traktor_mapping/Support%20files/Source%20files/DDJ-1000%20-%20Detailed%20reference.xlsx)



## Is the DDJ-1000SRT also mappable to Traktor?

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
  


## Can I see a video demo of your mappings?

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
   
  
## What is the 26ms shift issue when converting cues/loops between softwares?

* We have found that 6% of the files have a shift of 26 milliseconds when going from Traktor to Rekordbox. The other 94% of the files will be fine.
* This shift is very noticeable and breaks beatgrids/loops. See below for a graphical example of this issue.
* Root issue is different interpretations of the **tricky MP3 LAME tag** (and their derivations  LACV/LAVF). Issues are:
* **Zero LAME CRC ("case c"):**
  * Traktor doesn't accept the LAME tag, but interprets the whole MPEG frame as "music", producing 26ms of garbage; 
  * Rekordbox the same, but skips the whole MPEG frame instead.
* **LAVC/LAVF reduced tags ("case b"):**
  * Traktor produces 26ms of garbage because it doesnt understand this tag; 
  * Rekordbox accepts the tag as a control frame
* Please see [this blog post](#which-dj-converters-avoid-the-26ms-shift-issue) to know who implemented this work

### links
* 26ms research work: https://github.com/digital-dj-tools/dj-data-converter/issues/3
* Examples of corner cases: https://github.com/pestrela/music_scripts/tree/master/traktor/26ms_offsets/examples_tagged
* Analysis code: https://mybinder.org/v2/gh/pestrela/music_scripts/master
  
  
![26ms_problem](various/26ms_problem.png?raw=true "26ms_problem")

## Which DJ converters avoid the 26ms shift issue?

Historically, there was no way to convert your collection on Windows. The only converters available were for MacOS. This has now changed recently.\
All softwares take different approaches to solve the [26ms shift problem](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares).\
\
This is the current situation as far as I tested it myself:
* **[DJ Data Converter](https://github.com/digital-dj-tools/dj-data-converter)**: This is a command line tool for Windows, WSL, and macOS. This is where the full research of the [26ms shift problem](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares) was done, and where it was first implemented. This is [another python converter](https://github.com/ErikMinekus/traktor-scripts/blob/master/playlist-export.py).
* **[Rekord Cloud](https://rekord.cloud/wiki/convert-library)**: This is a web application, so it supports all OSes. It also has many other useful features other than DJ conversion. The authors have [read the research](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares), implemented it for the 26ms case, and then extended it for virtualDJ with a 50ms value. As it is a web app, it created added an offline optional app just to scan shift mp3s.
* **[DJCU](https://www.facebook.com/DJConversionUtility/posts/568896026977298)**: This is a macOS-only application. Recently it got the hability to convert windows files, but still from macOS only. They have a manual tool to correct the shifts after conversion (REKU). More recently they correct shifts automatically using the encoder strings. This is something that I researched before and replaced with LAME/LAVC/LAVF tags instead.
* **[Rekordbuddy](https://next.audio/)**: This is also a macOS-only application. A Windows version is on the works for many years. This app corrects some shift cases correctly automaticlaly, but it misses others as well (when I tested it on a macOS VM).
* **[MIXXX](https://github.com/mixxxdj/mixxx/pull/2119#issuecomment-533952875)**: A new upcoming feature is reading Rekordbox-prepared USB sticks nativelly. This is of course affected by the 26ms problem. Like rekordcloud, the developers have [read the research](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares) and implemented it for their case (which depends on the several mp3 libraries they use).


  
## How to avoid crackle / glitches / noise on Windows by disabling Intel turbo boost?

Every year laptops get faster. As people want them lighter, it can only be done by using all kinds of Power saving tricks. These tricks are very damaging for DJ software.\
\
If you have random crackle / glitches / noise - especially when you move the jogwheels - then please disable Intel turbo boost or anything related to power saving everywhere you can.\
\
To fix this:
* Use the "Quick CPU" software: https://www.coderbag.com/product/quickcpu
* Change your BIOS config: https://support.serato.com/hc/en-us/articles/203057850-PC-Optimization-Guide-for-Windows
* Change your Windows Power settings: https://forums.pioneerdj.com/hc/en-us/articles/360015455971-To-those-who-have-crackling-noise-when-using-DDJ-1000-with-rekordbox-dj
\
For a demo of this issue, please see at 1:20 of https://www.youtube.com/watch?time_continue=85&v=ijFJZf_KSM8


 
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
  * note: this software fails on files bigger than 2Gb (https://forums.adobe.com/thread/309254). Workaround is splittingthe file at the 3hour mark, exactly, then use an option in cue_merge_cues.py to add this offset back in the second file
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

## How I recorded my old radio show recordings and found the IDs

I had old K7s mixtapes from around 1996 from local radio shows that I really liked. 
These shows have significantly shaped my electronic music tastes. 
Recently I've took the time to preserve these relics, and find the IDs for the tracks that I've been looking for 22 years. 

The steps were:
* I've first recorded all my 15 cassttes in a single go. 
* Then added the cues in adobe audition. 
* Then split it by mix sessions. Sometimes it were just isolated tracks, sometimes it was a sequence of 10 tracks. 
* Then I've combined these into packs of 2 hours each. The first pack is now online: https://www.mixcloud.com/Dj_Estrela_House/radio-cidade-superpista-1997-recordings/ 
* Them made the known tracklist and exact timestamps using a CUE file

Regrading the IDs:
* I've first extracted JUST the IDs into yet another pack. 
* This was uploaded to mixcloud:   https://www.mixcloud.com/Dj_Estrela_House/superpista-ids-1997-recordings-full-versions/
* Benefits:
  * its much easier to show to knowleageble DJs in a single go
  * mixcloud is able to identify some tracks for you
 


