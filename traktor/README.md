
# Table of Contents

* [MindMap Summary](#MindMap-Summary)
* [OS-Folders](#OS-Folders)
  * [How large is your collection? How complex is your collection?](  #How-large-is-your-collection-How-broad-is-your-collection)
  * [Why I manage music using OS-folders only](
  #why-i-manage-music-using-os-folders-only
  #why-i-manage-music-using-os-folders-only)
  * [How to manage your collection using operating systems folders and without DJ playlists](#how-to-manage-your-collection-using-operating-systems-folders-and-without-dj-playlists-ie-using-only-finder-windows-explorer-etc)
  
* [Traktor software](#Traktor-software)
  * [Why is Traktor my software of choice](#why-is-traktor-my-software-of-choice)
    * [Database Repair](#why-is-traktor-my-software-of-choice-a-database-repair)
    * [OS Search](#why-is-traktor-my-software-of-choice-b-os-search)
    * [Advanced MIDI mapping and Lots of FX](#why-is-traktor-my-software-of-choice-c-advanced-midi-mapping-and-lots-of-fx)
    * [Hotcues move the temporary cue as well](#why-is-traktor-my-software-of-choice-d-hotcues-move-the-temporary-cue-as-well)
    * [Why is Traktor my software of choice: e) Stronger Sync than others](#Why-is-Traktor-my-software-of-choice-e-Stronger-Sync-than-others)
    
  * [Which features I miss in Traktor](#Which-features-I-miss-in-Traktor)
 
  
* [BOME migration](#BOME-migration)
  * [Why I moved to BOME midi mapping: Impossible features](#Why-I-moved-to-BOME-midi-mapping-Impossible-features)
  * [Why I moved to BOME midi mapping: Traktor Limits](#Why-I-moved-to-BOME-midi-mapping-Traktor-limits)
  * [How I see the future of Traktor mappings](#How-I-see-the-future-of-Traktor-mappings)

* [Hardware Controllers](#Hardware-Controllers)
  * [Why is DDJ-1000 my hardware of choice](#why-is-ddj-1000-my-hardware-of-choice)
  * [Why i like BIG jogwheels](#why-i-like-big-jogwheels)
  * [But can I still scratch using MIDI? How much is the latency of your maps?](#But-can-i-still-scratch-using-MIDI-How-much-is-the-latency-of-your-maps)

* [Custom Mappings](#Custom-Mappings)
  * [What are your main Traktor mappings?](#What-are-your-main-Traktor-mappings)
    * [DDJ-1000 mapping](#What-are-the-features-of-your-DDJ-1000-Traktor-mapping)
    * [DDJ-SX2 / DDJ-SZ mapping](#what-are-the-features-of-your-ddj-sx2--ddj-sz--ddj-srt-traktor-mapping)
    * [AKAI AMX Traktor mapping](#what-are-the-features-of-your-akai-amx-traktor-mapping)
  * [What documentation comes with your mappings?](#what-documentation-comes-with-your-mappings)
  * [Can I see a video demo of your mappings?](#can-i-see-a-video-demo-of-your-mappings)
  * [Can I test your mappings for free?](#can-i-test-your-mappings-for-free)
  * [Is the DDJ-1000SRT also mappable to Traktor?](#is-the-ddj-1000srt-also-mappable-to-traktor)
  * [Does (random DDJ controller) works with your mapping? Are the jogs good?](#Does-random-DDJ-controller-works-with-your-mapping-Are-the-jogs-good)
 
 
* [DJ collection converters](#DJ-collection-converters)
  * [What is the 26ms shift issue when converting cues/loops between softwares?](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares)
  * [Which DJ converters avoid the 26ms shift issue?](#which-dj-converters-avoid-the-26ms-shift-issue)

* [Other topics](#Other-topics)
  * [How to avoid crackle / glitches / noise on Windows by disabling Intel turbo boost?](#how-to-avoid-crackle--glitches--noise-on-windows-by-disabling-intel-turbo-boost)
  * [How I build perfect tracklists using CUE files](#how-i-build-perfect-tracklists-using-cue-files)
  * [How I recorded my old radio show recordings and found the IDs](#How-I-recorded-my-old-radio-show-recordings-and-found-the-IDs)
  * [How I edited my videos showing the Traktor screen](#How-I-edited-my-videos-showing-the-Traktor-screen)
  * [How I synchronize and backup my whole Traktor structure across laptops and a NAS](#how-i-synchronize-and-backup-my-whole-traktor-music-and-configuration-across-laptops-and-a-nas)
  * [How to replace the DDJ-1000 filter knobs with Silver knobs](#How-to-replace-the-DDJ-1000-filter-knobs-with-Silver-knobs)
  * [What scripts and documentation did you built for Traktor?](#what-scripts-and-documentation-did-you-built-for-traktor)

     

# MindMap Summary

This page has my knowledge sharing about Traktor, Mappings, Hardware, DJing, DJ Set, etc.\
The picture below summarizes the main ideas and dependencies explained in these blog posts.
![traktor_mindmap](various/traktor_mindmap.png?raw=true "Traktor Mindmap")

# OS-Folders

## How large is your collection? How broad is your collection?

I have a large collection with thousands of files. It is also quite broad, featuring hundreds of playlists, and dozens of genres / sub-genres / decades combinations.

My numbers are:
* 7000x individual tracks
* 300x individual playlists
* 50x sub-genres
* 10x major-genres
* 5x decades
* 2x separate DJs

To manage this complexity I've build my own set of personal tags that I fully trust.
As such, the first action on new files is to tag them into my structure. This ignores any previous tags made by someone else.

Below an example how my structure looks like; the full tree is far larger.
![DJ Genres](various/dj_genres.png?raw=true)

See also [Why I manage music using OS-folders only](#why-i-manage-music-using-os-folders-only).
  

## Why I manage music using OS-folders only

Above, I've explained [the size and complexity of my collection](#How-large-is-your-collection-How-broad-is-your-collection).\
This is nothing new; I know many DJs with [the same "problem"](https://code.google.com/archive/p/serato-itch-sync/). The difference is on the *how*; In my case I manage the collection only in OS-folders, instead of DJ-playlists.

Main reasons are:
* **#1: Multiple Windows:** File explorer opens instantaneously with Win+E, and allows any number of windows, monitors and [tabs](http://qttabbar.wikidot.com/). 
* **#2: Tree Tagging:** More crucially, all windows have the whole tree visible. This is essential to quickly tag my files by just moving them to the correct correct folder. Similarly, the structure grows just by creating new sub-folders as needed.
* **#3: Simpler Folders**: OS-Folders contain either files, sub-folders, or both. [This 2-step organization](https://en.wikipedia.org/wiki/Path_(computing)#History) is simpler is than the iTunes 3-step model of "folders -> playlists -> files" (later copied by almost all DJ softwares).
* **#4: Local Searches:** By far my most common task is to check if I already have a particular track, and where is it tagged. File explorer allows local searches on a folder and its sub-folders only. This enables me to quickly find things by just typing a few letters of the filename. AFAIK only Serato has this feature (called ["include subcrates"](https://support.serato.com/hc/en-us/articles/227626268-Subcrates))
* **#5: Tags Cleanup:** Before tagging the file, I rename the filenames to correct its artist / title. [MP3tag](https://www.mp3tag.de/en/) helps a lot to clean up the formattingm, using [my own scripts](collections_without_playlists/Mp3tagSettings.zip) to automatically capitalize the names as “ARTIST1 ft. ARTIST2 - Capitalized Title - Remix”, and to update the internal mp3 tags. 
* **#6: Software Independence:** Using OS-folders you are independent of any possible DJ software and itunes. It also trivial to [sync between laptops](#how-i-synchronize-and-backup-my-whole-traktor-music-and-configuration-across-laptops-and-a-nas) and make perfect backups [to my NAS](https://www.synology.com/en-global/products/DS718+). It is also trivial to load a whole genres to USB sticks to listen in cars.


See also [this blog post for more details on my workflow between DJ softwares ](#how-to-manage-your-collection-using-operating-systems-folders-and-without-dj-playlists-ie-using-only-finder-windows-explorer-etc).
  

## How to manage your collection using operating systems folders and without DJ playlists (ie, using only Finder, Windows Explorer, etc) 

Above I've described [Why I manage music using OS-folders only](#why-i-manage-music-using-os-folders-only). In this post I will describe *how* I manged to **fully automate** my workflow between DJ softwares.

* **#0: File operations:** [As explained above](#why-i-manage-music-using-os-folders-only) I continuously search files, change the filenames and move the files around left and right.
* **#1: Traktor Repair:** When I first open Traktor, it automatically [repairs its own database](#why-is-traktor-my-software-of-choice-a-database-repair). For this I just run a mass-relocate on my whole music root folder, which refinds all moved and renames files in a single go.
* **#2: Update collection:** The second step is just to import the whole music root folder into Traktor. As this skips previous files, in practice it only imports the New files. The last step is to delete the remaining missing files (that are really deleted - otherwise they would been found on step #1) 
* **#3: Duplicate Cues**: For the rare cases that a file is in multiple sub-genres, I just copy them physically in different folders.  Then I run a [python script](collections_without_playlists/traktor_clone_cues.py) to automatically duplicate the CUEs for these files. This tool is similar to [the traktor Librarian](http://www.flowrl.com/librarian).
* **#4: Dj Converter:** I use the [DJ Data Converter](#which-dj-converters-avoid-the-26ms-shift-issue) to generate the rekordbox.xml file without the [26ms shift problem](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares).
* **#5: Rekordbox Import:** On rekordox first I delete all missing files, then import the whole collection "as-is", and then update the collection with the XML file that came from the (repaired) Traktor collection. These steps are fully automatic and it ensures the Rekordbox collection matches the Traktor collection.
* **#6: Rekordbox Search:** I only use rekordbox for video gigs. There I use the explorer node to see my files, and search for files in the whole collection. For the rare case I need to search inside a "playlist", I use a real File Explorer window in parallel when needed (because rekordbox [still lacks a search box in OS-folders](#why-is-traktor-my-software-of-choice-b-os-search))
* **#7: CDJ export:** I only really need playlists for CDJs. There are scripts to mass-convert all folders to DJ playlists. Then I do the usual rekordbox step to prepare USBs pens.
  * Windows version is http://samsoft.org.uk/iTunes/ImportFolderStructure.vbs; 
  * Mac version is https://dougscripts.com/itunes/scripts/ss.php?sp=droptoaddnmake; 
  * A Serato-specific version is in https://code.google.com/archive/p/serato-itch-sync/
  
See also the [DJCU workflow from ATGR](https://www.youtube.com/watch?v=d4QO6xxGovQ).
 
  
# Traktor software
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
[An external tool](https://github.com/edkennard/rekordbox-repair) helps the moved files case. [Example of Pioneer forum request](https://forums.pioneerdj.com/hc/en-us/community/posts/115018095303-Reasons-to-think-i-leave-from-rekordbox-?page=1#community_comment_360000392646)
* Comparison to VDJ: Everything need to be relocated FILE by FILE.
* Comparison to Serato: To test.


## Why is Traktor my software of choice: b) OS-search

Traktor allows searching inside any OS folders. I don't have DJ playlists inside Traktor; instead, my OS-folders are my "virtual playlists".\
I have a very large collection with dozens of genres, sub-genres and decades. For that I've created a structure where each decade is a separate folder, inside a parent genre/sub-genre folders.\
When I'm playing a specific genre I can search only that decade (=OS folder). If I want something else I can always search the whole collection at any time.\
([See this blog post for more detail on these methods](#how-to-manage-your-collection-using-operating-systems-folders-and-without-dj-playlists-ie-using-only-finder-windows-explorer-etc))
* Comparison to Rekordbox: Rekordbox displays OS folders, but you can't search inside them. [Example of Pioneer forum request](https://forums.pioneerdj.com/hc/en-us/community/posts/115018095303-Reasons-to-think-i-leave-from-rekordbox-?page=1#community_comment_360000392646)
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

## Why is Traktor my software of choice: e) Stronger Sync than others

Traktor features a very strong master clock that was built for the remix decks. As such its sync is in general stronger than the other softwares I tested. 
Using Beatsync the phrasing is always kept for any action I might do to the track: Beatjump, Hot cues, Temporary Cue, Pitch bend, Tempo change, Scratch, etc.

* Comparison to Serato: see [this comparison video](https://www.youtube.com/watch?v=pyAj4IyFNCs). Even there I still found myself having the "gold" sync instead of the desired "blue" sync
* Comparison to Rekordbox: It has the best sync outside Traktor 
* Comparison to VDJ: untested

    
## Which features I miss in Traktor

Specific features:
* **#1: Include subcrates** just like [serato](https://support.serato.com/hc/en-us/articles/227626268-Subcrates)
* **#2: Elastic beatgrids**: This is crucial as I play very old music and many music styles
* **#3: Pioneer DDJ**: Plug-and-Play to Pioneer gear / DDJ controllers, because this is the [most popular equipment today](../census_graphs)
* **#4: Pad modes**: I have multiple pad modes in my mappings, but would love to see them on screen, and have an associated pad editor just like Rekordbox and VirtualDJ
* **#5: Turntable FX**: Turntable start&stop on the [play/pause button](https://www.youtube.com/watch?v=EPnmyDiaJTE)
* **#6: Video support**
* **#7: [VDJscript](https://www.virtualdj.com/wiki/VDJscript.html)**, with a lot more than 8x variables and 2x conditions
* **#8: Smart playlists** and related tracks

In general I fully agree with [this Digital DJ Tips article](https://www.digitaldjtips.com/2019/10/what-next-for-traktor/). Generic comments:
* #1: “Please embrace hardware partners again…”
* #2: “Please speed up software development!”
* #3: “Please, no more reinventing the wheel :)”

But in the end Traktor has [has unique features that I depend on](#why-is-traktor-my-software-of-choice).

See also the [most popular DJ softwares census](../census_graphs).


# BOME migration

## Why I moved to BOME midi mapping: Impossible features

As [explained above](#why-is-traktor-my-software-of-choice-c-advanced-midi-mapping-and-lots-of-fx), Traktor mapping rocks. However it lacks essential features required on the [DDJ-1000 screens mapping](ddj_1000_traktor_mapping).

* **#1: 14-bit out messages**: Trakor supports *receiving* high resolution midi messages. I need to *send* them as well [on my DDJ-1000 mapping](../ddj/1%20MIDI%20codes/DDJ-1000RB%20-%20MIDI%20Messages.pdf)
* **#2: Sequence of Events**: For PadFX, I *first* need to change the FX, and *then* need to turn it on. This is not something Traktor support; both actions are tried simultaneously resulting in something else. More info: page 88 of the [Rudi Elephant mapping](various/RUDI-Js%20ELEPHANT%20TSI%20for%20VCI-400SE%20%2B%20Maschine%20(MK1)%20%2B%20BCR%202000%20v2.0.pdf).
* **#3: Timers**: Something simple as end-of-track blinking require timers to schedule actions for later. Same story for [vinyl break on the play/pause button](https://www.youtube.com/watch?v=EPnmyDiaJTE), as implemented by [Traktor Mapping Service](http://traktormappingservice.com/)
* **#4: Any event as a Conditional**: Some events can be inputs to conditionals, like "is in active loop". However many events are missing, for example "which deck is master." To implement this, please see page 87 of the [Rudi Elephant mapping](various/RUDI-Js%20ELEPHANT%20TSI%20for%20VCI-400SE%20%2B%20Maschine%20(MK1)%20%2B%20BCR%202000%20v2.0.pdf).


## Why I moved to BOME midi mapping: Traktor Limits

Also, I've also hit the limits of Traktor mappings multiple times. Below are the features that are possible in Traktor but only by significantly increasing the mapping complexity.

* **A) More modifiers**: I use a lot more than [8 modifiers](https://www.native-instruments.com/forum/threads/controllerism-more-modifiers-more-bits-more-conditions.329045/). I use a lot more than 3 bits per modifier state. To go around this I add a lot of complexity to my mappings.
* **B) More conditionals**: I use a lot more than [2 conditions in my mappings](https://www.native-instruments.com/forum/threads/add-3rd-slot-for-modifier-conditions-in-controller-manager.325569/#post-1622169). To go around this I [squeezed multipe states into each modifier](https://www.traktorbible.com/en/squeezing-modifiers.aspx). Again, this added a lot of complexity to my mappings.
* **C) Global modifiers:** I miss [global modifiers](https://www.native-instruments.com/forum/threads/named-variables-operators.326339/#post-1628411), to link the state in multiple pages. More info: page 87 of the [Rudi Elephant mapping](various/RUDI-Js%20ELEPHANT%20TSI%20for%20VCI-400SE%20%2B%20Maschine%20(MK1)%20%2B%20BCR%202000%20v2.0.pdf).
* **D) Preferences window freeze:** To add more variables, you need to add extra mapping pages. Having more than 6 pages [freeze your preferences window](https://www.native-instruments.com/forum/threads/preferences-window-freeze.328315/) **even if they are completely empty**.

## Some Limitations of BOME mappings

[BOME](https://www.bome.com/products/miditranslator) is essential to [build my new mappings](#Why-I-moved-to-BOME-midi-mapping-Impossible-features). But it also have some improvement points.

In importance order:

* **A) Arrays**: [forum request](https://www.bome.com/support/kb/mt-pro-script-arrays). See also Bug#3 from the FAQ file.
* **B) Cascaded devices**: [forum request](https://www.bome.com/support/kb/cascaded-presets-loopback-devices)
* **C) More variables**: this is a lot more than Traktor, but still not enough as I'm emulating arrays


## How I see the future of Traktor mappings

A major Traktor strength is the MIDI mappings system. Very flexible and powerful.\
Traktor maps are by far the most popular in https://maps.djtechtools.com \
Large mappings are really complex to build - but once this is done other users immediately benefit by just installing them.

However the Traktor mappings system didn't get improvements for years, and [is is now quite old](#Why-I-moved-to-BOME-midi-mapping).
It now is also not powerful enough [to map recent controllers](#Why-I-moved-to-BOME-midi-mapping).

For example in my DDJ-1000 mapping I had to use BOME midi translator as a middle man:\
https://maps.djtechtools.com/mappings/9279

In my view the mappings are a unique sucess story of Traktor. This could continue to give great results with just some quality-of-life improvements.



# Hardware Controllers

## Why is DDJ-1000 my hardware of choice

Previously I explained [I why use Traktor](#why-is-traktor-my-software-of-choice). So why do I use it with a controller made for Rekordbox, instead of the S4Mk3??

Before we discuss this, please note that some years ago DJs could use any Software with any Hardware combination. 
This was a fully supported (and encouraged!) model by the vendors, which used this model to make real money from real customers. 

Having said this, the DDJ-1000 has major features that I personally value significantly over the S4Mk3:

* **A) BIG jogs wheels:** This is so important that [it gets a dedicated blog post ](#why-i-like-big-jogwheels)
  
* **B) More pad modes.** All my most useful functions are a maximum of 2 clicks away - and without using any shifts. 
  Main Pad modes are a) Hotcue, b) Roll/padFX, c) MacroFX, d) JogFX. 
  Pressing twice the same pad mode cycles the top 2 sub-pages of that pad mode. This is way the Reloop Elite mixer works. 
  I’ve got even more stuff on the secondary pad modes, accessible with a shift+mode. 

* **C) Two USB ports.** This is crucial for seamless hand-overs between DJs; and for safety of connecting a backup laptop ready at any time.
  
* **D) JogFX combos on the jogs.** Please see them in my demo videos (eg 6:32 of https://www.youtube.com/watch?v=h9tQZEHr8hk&t=392s ). 
  This is turnkey in my mapping, i’m not familiar if they have it on the S4mk3 (it was present for sure on the S4MK1 DJTT mappings)

* **E) BeatFx**. This is in the correct place of the mixer (lower right corner = right hand of the DJ), with a FX selector knob to select the effect by name

* **F) Connectivity**. Thr DDJ-1000 has more inputs and outputs, microphones etc. In particular, the mixer has a full FX suite for any external inputs (colorFX + beatFX)

Note: the S4mk3 is a fantastic controller - I have recommended it to several people before. In particular the loop/beatjump encoders implementation is the gold standard for that.\
The overall integration is better, of course, which is a plus if you prefer plug-and-play vs customization. 

But in the end its really the big jogwheels that is the crucial deal breaker; This was completely abandoned by NI in 2014 with the release of the S8, and was only picked-up in 2018 with the S4MK3 (although, in my opinion, still not the same as the DDJ-1000).


## Comparison to DDJ-SZ1 and AKAI AMX

Besides [my DDJ-1000](#why-is-ddj-1000-my-hardware-of-choice), I have several other controllers fully [mapped to Traktor](#What-are-your-main-Traktor-mappings). 

Differences are:
DDJ-1000:
* CDJ big Jogwheels 
* Jog screens
* More portable than SZ, but more cramped as well
* BeatFX in the lower right corner to the mixer

DDJ-SZ:
* Very spacious. A joy to use!
* Extra-smooth big Jogwheels
* Real soundcolor FXs, including the Pioneer filter with a lot of Resonance

AKAI AMX:
* ** A) Ultra portable:** A single device is equivalent of a Z1+X1+TwisterFighter
* ** B) DVS** This is the cheapest and smallest way to unlock DVS 
* ** C) Mapping** to control all TP3 functions

See also [this DDJ-SZ comparison](https://www.reddit.com/r/Beatmatch/comments/c6vquf/help_me_ddj_sz_vs_ddj_1000/)



## Why I like BIG jogwheels

Spoiler: its not scratching!

I use jogs all the time in a controller - full list below. 
As I have big hands, I love them to be as BIG as possible.

There are the usages sorted by frequency:
* **#1: Tempo**: Adjusting tempo drift for older tracks (because of no elastic beatgrid)
* **#2: Cueing**: / fast preview to the exact spot where the track will start
* **#3: JogFX chains**: I do effects on the jog - see 6:32 of https://www.youtube.com/watch?v=h9tQZEHr8hk&t=392s
* **#4: Beagrids**: by far the quickest way to adjust beatgrids on the fly
* **#5: Scratch**: Very occasional live scratching / tricks  (see also [this post](#But-can-you-still-scratch-using-MIDI))

What I dont use on jogs:
* **Moving jogs**: these are cool, but not a deal-breaker for me
* **Haptic feedback**: this is basically a gimmick for me

## But can I still scratch using MIDI? How much is the latency of your maps?

**TL;DR:** YES you can scratch - as long you have a fast computer. Please see at 4:10 of [this video](https://www.youtube.com/watch?v=h9tQZEHr8hk&t=249) for a demo.\
Even better, try it [completely for free](#can-i-test-your-mappings-for-free), and see for youself.

**Long answer:**

Of course that If you are a 100% scratch DJ, then you should look for a native HID solution.\
But for the extreme vast majority of DJs I know, this solution is more than enough.

Some relevant points:
* Scratching is [only the 5th criteria for my jogwheels](#why-i-like-big-jogwheels)
* The [latest DDJ-1000 mapping](#What-are-the-features-of-your-DDJ-1000-Traktor-mapping) helps a lot. You can now can see the jog needle and your hand simultaneously.
* Pioneer has sold products with this solution for many years ([example](https://www.pioneerdj.com/en/support/software-information/archive/ddj-sz/#traktor))



# Custom Mappings

## What are your main Traktor mappings?

* DDJ-1000: https://maps.djtechtools.com/mappings/9279
* DDJ-SZ / DDJ-SX2 / DDJ-SRT: https://maps.djtechtools.com/mappings/9222
* AKAI AMX: https://maps.djtechtools.com/mappings/9323


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

**Links:**
* Download Link: https://maps.djtechtools.com/mappings/9279
* Documentation: https://github.com/pestrela/music_scripts/blob/master/traktor/ddj_1000_traktor_mapping/
*	Video demo: https://youtu.be/h9tQZEHr8hk

**About this mapping:**
* This is the *only mapping* for the DDJ-1000 supporting Jog Screens. It works on both Traktor 3 and 2. It requires the 3rd-party BOME Pro MIDI translator. Free trial versions are available to test everything. 
*	It is also the most complete by far. It supports MixerFX, MacroFX, JogFX chains, padFX, Keyboard mode, Rolls, and a Preview Player. Latest features are CDJ-emulation, Loops adjust and Beatjump shortcuts.


## What are the features of your DDJ-SX2 / DDJ-SZ / DDJ-SRT Traktor mapping?


**Feature list:**
*	7x Jogwheel FX chains
*	5x TP3 MixerFX
*	11x MacroFX
*	21x padFX (“instant gratification”)
*	4x Rolls modes
*	Slicer
*	Dedicated preview player
*	Reverse Flux
*	Vinyl Stop
*	Beatjump controls
*	All  functions reachable without shifts

**Links:**
*	Download Link: https://maps.djtechtools.com/mappings/9222 
*	Documentation: https://www.facebook.com/pedro.vale.estrela/media_set?set=a.2263179753734551 
*	Video demo: http://youtu.be/H_TE2mtuM6Q 


**About this mapping:**
*	This a 2019 mapping for the Pioneer DDJ family of controllers. It works on both Traktor 3 and 2. The mapping was **tested extensively** in both the **DDJ-SX2** and **DDJ-SZ**. Other DDJs are supported as well (please see below).
*	It is also the most complete by far. It supports TP3 MixerFX, MacroFX, JogFX chains, padFX, Keyboard mode, Rolls, Slip reverse, and a Preview Player. Be sure to see the documentation for all the features.


## What are the features of your AKAI AMX Traktor mapping?

**Feature list:**
*	DVS TP3
*	10x shift layers
*	Full Transport controls
*	Full Tempo controls
*	6x Cues
*	4x Decks
*	Loops
*	BeatJump
*	Preview player
\
*	5x MixerFX
*	7x MacroFX
*	1x Resonant Filter
*	10x PadFX 
*	4x BeatMasher
*	3x UserFX
*	Slip Reverse
*	3x Sampler
*	Key Adjust
*	Filter Roll

**Links:**
*	Download Link: https://maps.djtechtools.com/mappings/9323 
*	Documentation: https://www.facebook.com/pedro.vale.estrela/media_set?set=a.2271291466256713 
*	Video demo: https://www.youtube.com/watch?v=TzAgENM55DE 

**About this mapping:**
*	This is a 2019 mapping for the Akai AMX. This is by far the cheapest and smallest way to unlock both DVS and almost all Traktor Pro 3 functions. In a single device you have the equivalent of a Z1+X1+TwisterFighter, at least.
*	It is also the most complete by far. It supports 10x layers, 4 decks, full transport and tempo control, TP3 MixerFX, MacroFX, Cues, Loops, beatjump,  Rolls, Slip reverse, Sampler, Key adjust, and a Preview Player. 

## What documentation comes with your mappings?

My zip files have **a lot** of documentation besides the TSI file.\
IMO it has no comparison to the typical mappings available on https://maps.djtechtools.com/ or https://www.traktorbible.com/freaks 

Included is:
* Quick reference (pictures only): [example](ddj_1000_traktor_mapping/DDJ-1000%20v6.5.1%20TP3%20-%20Quick%20overview.pdf)
* User manual: [example](ddj_1000_traktor_mapping/DDJ-1000%20v6.5.1%20TP3%20-%20Full%20manual.pdf)
* Installation manual: [example](ddj_1000_traktor_mapping/Installation%20Help/DDJ-1000%20-%20Installation%20and%20Verification%20of%20the%20two%20required%20mappings.pdf)
* FAQ: [example](ddj_1000_traktor_mapping/Installation%20Help/DDJ-1000%20-%20Frequently%20Asked%20Questions.pdf)

Plus:
* Technical info (to extend the mapping): [example](ddj_1000_traktor_mapping/Support%20files/Technical%20Info%20-%20BOME%20DDJ%201000%20Screens.txt)
* Every single function: [example](ddj_1000_traktor_mapping/Support%20files/Source%20files/DDJ-1000%20-%20Detailed%20reference.xlsx)


## Can I see a video demo of your mappings?

Yes, please see the below Youtube videos. I have both long 30m videos where I cover every single function step-by-step, plus short "update" 5m video with the latest stuff only.

All videos are timestamp tagged in Minute:second format, for you to find explanations of all specific. 


* DDJ-1000/800 playlist: https://www.youtube.com/playlist?list=PLIlvTGzSxI0XHlFyINdT6P42noqvkPISD
  * DDJ-1000 v6.3 - **main video** - http://youtu.be/EkSJ9Ug9Zuk
  * DDJ-1000 V6.5 - **jog screens** - https://youtu.be/h9tQZEHr8hk
  
* DDJ-SX2/SZ/SRT playlist: https://www.youtube.com/playlist?list=PLIlvTGzSxI0V3SUnYFYq4hpeu0o_XyP2l
  * DDJ-SX2/SZ/SRT v6.0 - **main video** - http://youtu.be/H_TE2mtuM6Q
  * DDJ-SX2/SZ/SRT v6.1 - **update** - http://youtu.be/sanF35CYeSg

* AKAI AMX playlist: https://www.youtube.com/playlist?list=PLIlvTGzSxI0Vi7aguzxbmOJdVQCW6CohR
  * AMX v1.0 - **main video** - http://youtu.be/TzAgENM55DE
   
  
## Can I test your mappings for free?

Yes. All my mappings work fine with the demo versions of both Traktor and BOME. So if you have these controllers you can just try them in no time. 

If you are considering buying equipment then I recommend that you test the mapping yourself in a shop showroom. I do this all the time before I buy anything (just mention this to the shop personnel).

Finally, all my mappings are a free gift to the community, to enable DJs to use their preferred Software with their preferred. If you want further appreciation, PayPal donations are welcome (pedro.estrela@gmail.com)
  

## Is the DDJ-1000SRT also mappable to Traktor?

### UPDATE 25 Oct 2019:

I've now tested my SZ map to the SRT in a shop. It worked surprisingly well! See below for the notes.

* Jog screens are NOT supported. This is because they are not documented on the Pioneer MIDI map file 
  * https://github.com/pestrela/music_scripts/blob/master/ddj/1%20MIDI%20codes/DDJ-1000SRT%20-%20MIDI%20Messages.pdf
* Audio device runs very well in external mode. This means that ALL the pioneer effects (both colorFX and beatFX work for USB sources
* Please put your jog weight to “heavy”.  This will significantly improve scratching and jogFX.
* Please avoid VINYL OFF mode. The TSI disables jog touch in this case, but the jog loses resolution compared to VINYL ON mode
* Beatjump buttons added. Please use shift+IN/OUT to configure the loop size (=jump size)
* BeatFX ON/OFF is now for pioneer beatFX only
* Automatic layout changing was removed


### OLD POST FOLLOWS:

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
  
## Does (random DDJ controller) works with your mapping? Are the jogs good?

Pioneer has **dozens** of controllers. I own 3x of them, so ONLY there the mappings are 100% tight:
* DDJ-1000
* DDJ-SZ
* DDJ-SX2

The other controllers [are compatible](../ddj/1%20MIDI%20codes) - but there are always differences.\
**So for these [please try the mapping FOR FREE](#can-i-test-your-mappings-for-free) in a shop/friend.**

Once in a while I test controllers in a shop myself; ONLY in this case I describe the results in the first page of the mapping manual.\
The DDJ-1000SRT is a special case, [which I cover in detail here](#is-the-ddj-1000srt-also-mappable-to-traktor)


Regarding the Jogs: this is exactly the same story, plus the [all the comments about MIDI jogs](#But-can-i-still-scratch-using-MIDI-How-much-is-the-latency-of-your-maps)

  
# DJ collection converters
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
All softwares take different approaches to solve the [26ms shift problem](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares).

This is the current situation as far as I tested it myself:
* **[DJ Data Converter](https://github.com/digital-dj-tools/dj-data-converter)**: This is a command line tool for Windows, WSL, and macOS. This is where the full research of the [26ms shift problem](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares) was done, and where it was first implemented. This is [another python converter](https://github.com/ErikMinekus/traktor-scripts/blob/master/playlist-export.py).
* **[Rekord Cloud](https://rekord.cloud/wiki/convert-library)**: This is a web application, so it supports all OSes. It also has many other useful features other than DJ conversion. The authors have [read the research](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares), implemented it for the 26ms case, and then extended it for virtualDJ with a 50ms value. As it is a web app, it created added an offline optional app just to scan shift mp3s.
* **[DJCU](https://www.facebook.com/DJConversionUtility/posts/568896026977298)**: This is a macOS-only application. Recently it got the hability to convert windows files, but still from macOS only. They have a manual tool to correct the shifts after conversion (REKU). More recently they correct shifts automatically using the encoder strings. This is something that I researched before and replaced with LAME/LAVC/LAVF tags instead.
* **[Rekordbuddy](https://next.audio/)**: This is also a macOS-only application. A Windows version is on the works for many years. This app corrects some shift cases correctly automaticlaly, but it misses others as well (when I tested it on a macOS VM).
* **[MIXXX](https://github.com/mixxxdj/mixxx/pull/2119#issuecomment-533952875)**: A new upcoming feature is reading Rekordbox-prepared USB sticks nativelly. This is of course affected by the 26ms problem. Like rekordcloud, the developers have [read the research](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares) and implemented it for their case (which depends on the several mp3 libraries they use).

# Other topics
  
## How to avoid crackle / glitches / noise on Windows by disabling Intel turbo boost?

Every year laptops get faster. As people want them lighter, it can only be done by using all kinds of Power saving tricks. These tricks are very damaging for DJ software.

If you have random crackle / glitches / noise - especially when you move the jogwheels - then please disable Intel turbo boost or anything related to power saving everywhere you can.

To fix this:
* Use the "Quick CPU" software: https://www.coderbag.com/product/quickcpu
* Change your BIOS config: https://support.serato.com/hc/en-us/articles/203057850-PC-Optimization-Guide-for-Windows
* Change your Windows Power settings: https://forums.pioneerdj.com/hc/en-us/articles/360015455971-To-those-who-have-crackling-noise-when-using-DDJ-1000-with-rekordbox-dj

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
    It can read either case from separate or single files. It also cleans the artist - title fields, and generates timestamped tracklists 
* cue_rename_cue.sh: 
  *  matches the CUE file contents with the FILE tag. This is useful when you rename the files externally.

## How I recorded my old radio show recordings and found the IDs

I had old K7s mixtapes from around 1996 from local radio shows that I really liked. 
These shows have significantly shaped my electronic music tastes. 
Recently I've took the time to preserve these relics, and find the IDs for the tracks that I've been looking for 22 years. 

The steps were:
* I've first recorded all my 15 cassettes in a single go. 
* Then added the cues in adobe audition. 
* Then split it by mix sessions. Sometimes it were just isolated tracks, sometimes it was a sequence of 10 tracks. 
* Then I've combined these into packs of 2 hours each. The first pack is now online: https://www.mixcloud.com/Dj_Estrela_House/radio-cidade-superpista-1997-recordings/ 
* Them made the known tracklist and exact timestamps using a CUE file

Regrading the IDs:
* I've first extracted JUST the IDs into yet another pack. 
* This was uploaded to mixcloud:   https://www.mixcloud.com/Dj_Estrela_House/superpista-ids-1997-recordings-full-versions/
* Benefits:
  * its much easier to show to knowledgeable DJs in a single go
  * mixcloud is able to identify some tracks for you
 
 
## How I edited my videos showing the Traktor screen 

On my latest demo videos I show both the controller and the traktor screen simultaneously. It looks pretty cool.
To get the basic idea, see this DJ tech tools article: https://djtechtools.com/2012/06/24/how-to-make-a-great-dj-video/

Concrete steps:

* Equipment
  * Smartphone
  * As much illumination as possible
  * Buy a microphone stand with a strong hold: [example](https://www.amazon.com/Adjustable-Microphone-Suspension-Broadcasting-Voice-Over/dp/B00DY1F2CS/)
  * Buy a smartphone flexible tripod:  [example](https://www.amazon.com/Universal-Octopus-Adjustable-Cellphone-Smartphone/dp/B06XRFC75Y/)

* Recording  
  * Put the smartphone as high as possible, and with the most illumination possible. 
  Ideally, grab the microphone stand on **ANOTHER** desk, so that your scratching will not vibrate the smartphone.
  * Record the controller image in 16:9 format
  * Record the laptop screen using [this free tool](https://www.freescreenrecording.com/)
  * If its a spoken video, record the audio from the smartphone. If its pure DJing use from the mixer output, or internal Traktor.

* Editing part 1: merge everything to a single video
  * Download [openshot](https://www.openshot.org). Read this [tutorial for basics](https://www.howtoforge.com/tutorial/an-introduction-to-video-editing-in-openshot-2-0/). [this is another tutorial](https://gist.github.com/peanutbutterandcrackers/f0f666243133e0ed25abbc12a4ba23d7)
  * change profile to a 4:3 format. This is crucial to fit both the controller and the top traktor screen
  * Add the Controller video on Track 1. Click in the very first frame. Use effects / crop to crop the controller to size. Use right click / transform to center and scale it to the bottom of the screen
  * move the video to the middle of the timeline. lock track 1 so that it no longer moves
  * Add the Traktor video to Track 2. Do the same steps as before to crop and scale / center the video on the top part of the screen
  * Sync the two videos by finding somthing unique (eg press play). Zoom in a lot. Disable snap for precise aligment. Confirm aligment in the end of the video
  * Render the video to a 4:3 format (1024x728, 30fps, MP4). Create a profile in your documents / .openshot / profiles folder, based on 
  

* Editing part 2: cuts, effects, transitions, etc
  * get windows essentials 2012 [archive link](https://www.tenforums.com/software-apps/104887-can-i-get-movie-maker-win10-again.html#post1304260); install only windows movie maker 2012.
  * To create separators: home / add / title; Then animations / wipe right / normal
  * To create captions: home / add / caption; then set legtth
  * to add arrows: add a caption with windings 3 font
  * change project to 4:3 format 
  * ...
 


## How I synchronize and backup my whole Traktor music and configuration across laptops and a NAS

I have **all** my Traktor files synchronized between laptops. This includes [100Gb of music](#why-i-manage-music-using-os-folders-only)
 and all Traktor files.
 
I can use any laptop at any time, one at the time, and my whole collection is there fully analyzed. As my NAS is just another client, I get automatic RAID-0 backups as well.\
In a nutshell this is like having everything inside your own private google drive, without size limits.

My folder structure is:
* C:\Main - Contains all my private files
  * \Traktor - Whole folder synchronized by resilio sync
    * \Samples  - All samples go here
    * \Remix_sets - all remix sets go here
    * \Root_dir  - All settings, stripes, etc go here
      * \Logs
      * \Stripes
      * etc
    * \Music  - all my music goes here. Organization is [by genres](#why-i-manage-music-using-os-folders-only)
      * \Genre_1
      * \Genre_2
      * etc
      
Steps were:
* Install [resilio sync](https://www.resilio.com/individuals/)
* Point your traktor root folder to "C:\Main\Traktor\Root_dir" (Settings / File / Directories / Root_dir)
* Restart traktor
* Do the same for samples and remix sets  (Settings / File / Directories / Samples | Remixe_sets)
* Move your files to "C:\Main\Traktor\Music"
* Share the whole "C:\Main\Traktor" folder in resilio sync

**Warning:** do a manual backup first before changing your traktor files and music collection!
    
[more info #1](https://www.resilio.com/blog/sync-hacks-how-to-use-bittorrent-sync-for-djs-and-producers) / [more info #2](https://www.native-instruments.com/forum/threads/resilio-sync-synchronizing-traktor-libraries-across-computers.355599) / [more info #3](https://www.native-instruments.com/forum/threads/syncing-traktor-across-multiple-computers-with-resilio-sync.348405)
  
See also the [DJ Freshfluke’s Traktor tutorial](https://www.native-instruments.com/forum/attachments/tsp2_tutorial-01_sidebysideinstalls_ver1-0_web-pdf.46430)
  
  
## How to replace the DDJ-1000 filter knobs with Silver knobs.

Both 1000 and 1000SRT have extremely [dull filter knobs](../pics/silver_knobs/DDJ-1000RB.jpg). Which is a pity.\
For now the best fit is [DAA1309](https://www.pacparts.com/part.cfm?part_no=DAA1309&mfg=Pioneer) from the DDJ-SZ or DJM-900. This is an almost perfect fit.

Folder with pictures of the knobs: [here](../pics/silver_knobs)

* [DAA1309](../pics/silver_knobs/DAA1309.png):
  * This has the best fit overall. The knob is slightly higher than desired.
  * [Part list](https://www.pacparts.com/part.cfm?part_no=DAA1309&mfg=Pioneer): \
    DJM-900NX2/2000NX1/750\
    DDJ-SZ/ DDJ-RZ/ DDJ-RZX
  
* [DAA1320/DAA1350](../pics/silver_knobs/DAA1320.jpg):
  * this was confirmed NOT to work
  * [parts list]((https://www.pacparts.com/part.cfm?part_no=DAA1320&mfg=Pioneer)): DJM-S9 / DJM-900SRT / XDJ-RX / XDJ-RX2

* [100-SX3-3009](../pics/silver_knobs/100-SX3-3009.jpg):
  * not tested
  * [part list](https://www.pacparts.com/part.cfm?part_no=100-SX3-3009&mfg=Pioneer): DDJ-RX
  
* [DAA1373](../pics/silver_knobs/DAA1373.jpg):
  * not tested
  * [parts list](https://www.pacparts.com/part.cfm?part_no=DAA1373&mfg=Pioneer): DJM750 MK2 / 250MK2 / 450 / S3
  
* [Rane 2015](../pics/silver_knobs/rane%202015%20filters.jpg):
  * this was confirmed to work [by another user](https://www.facebook.com/photo.php?fbid=3050933838255437&set=gm.672781936578130&type=3&theater&ifg=1)

    
  
## What scripts and documentation did you built for Traktor?

This github folder contains my Traktor tools, and the documentation of the mappings.
Please note that the *mapping themselves* are only available on https://maps.djtechtools.com


* ddj_1000_traktor_mapping
  * A backup of the my Traktor+BOME mapping for the DDJ-1000 with jog screens support.
  * Main page: https://maps.djtechtools.com/mappings/9279
* collections_without_playlists
   * Tools to manage your collection using Operating System folders. See the below blog post as well.
* tracklist_tools
  * Tools to generate CUE files and timestamped tracklists. See the below blog post as well
* 26ms offsets
  * Finding mp3 cue shifts in DJ conversion apps. Main ticket: https://github.com/digital-dj-tools/dj-data-converter/issues/3
* macos_converters
  * Scripts able to run the DJCU and Rekordbuddy tools in Windows. (these convert collections from Traktor to Rekordbox)

  
 
 
 
 