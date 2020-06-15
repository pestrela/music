
# TL;DR version

My biggest **Laptop** reasons are not having to manage USB sticks, and it has much more features than standalone.\
My biggest **DDJ-1000** reason is big jogwheels.\
My biggest **Traktor** reason is using my OS folders as "playlists", its effects and its advanced mapping possibilities.


# About this Knowledge Base

This page contains my DJ knowledge base. 
It covers dozens of questions that I've answered over the years in forums and Facebook groups.

These cover [why I'm using Traktor](#Traktor-software) instead of eg Rekordbox, 
what are [its limitations](#Which-features-I-miss-in-Traktor), info about [Effects](#Effects), workarounds to 
[elastic beatgrids](#Traktor-Elastic-Beatgrids) and the [Slow preferences window](#Traktor-Slow-preferences-Window);
closely related is how I [organize my files using OS-Folders only](#OS-Folders) without any playlists; 

I'm using [DDJ controllers](#Hardware-Controllers) from Pioneer and made [very large mappings](#Free-Mappings) free to use; 
specific info is on the [installation processs](#How-to-install-my-Traktor-mappings) 
and videos showing the [features step-by-step](#can-i-see-a-demo-video-of-your-mappings); 
on a technical level please find why I've moved to [BOME](#BOME-mappings-migration).

Also described is my free [DJ Software Tools](#Free-DJ-Software-Tools), 
including the latest [CMDR TSI editor](#What-features-did-you-add-to-the-CMDR-TSI-editor)
and many other tools for eg [CUE files](#how-i-build-perfect-tracklists-using-cue-files); 
there also info on the tricky process to [convert DJ collections](#DJ-collection-converters) 
between softwares without 26-ms shifts for free.

Recently I've written about the [Rekordbox v6](#Rekordbox-v6-topics) migration, 
and my first experience with [MIXXX](#mixxx-topics), which is fully open source.
I also found and listed multiple [DJ tutorials](#DJ-tutorials), in including [midi tutorials](#midi-mapping-tutorials).
Also read about unique [Music Styles](#Music-Styles) and how to find new music.

Finally, there is a lot of info on [how to optimize your laptop](#DJ-Software-optimization) to avoid audio glitches, 
general tips for [Windows](#Windows-usage), 
keyboard shortcuts to [search in Youtube and Discogs](#What-shortcuts-you-added-for-Youtube-Google-and-Discogs), 
plus more [other stuff](#Other-topics).


Below a detailed [table of contents](#Table-of-Contents) of the whole thing, 
and a [MindMap picture](#MindMap-Summary) to get you started.

# About DJ Estrela

I'm a DJ since year 2000. Some free contributions for you to enjoy:

a) A quite broad knowledge base that covers Traktor, Mappings, Laptop optimization, Controllers, etc...\
https://github.com/pestrela/music/blob/master/traktor/README.md#table-of-contents 

b) I've built the most popular traktor mapping for the DDJ-1000. It also works in all other SX2, SRT, SZ, etc\
https://maps.djtechtools.com/mappings/9279 


c) I'm the maintainier of the CMDR TSI mapping editor for Traktor\
https://github.com/cmdr-editor/cmdr/blob/master/README.md  

d) My specific music styles are Trance and 80s (Italo Disco). I also play commercial Top-40.\
https://djestrela.com/  


# Table of Contents

* [MindMap](#MindMap-Summary)
* [OS-Folders as virtual playlists](#OS-Folders)
* [Traktor software](#Traktor-software)
* [Effects](#Effects)
* [Traktor Elastic Beatgrids](#Traktor-Elastic-Beatgrids)
* [Traktor slow preferences window](#Traktor-Slow-preferences-Window)
* [BOME migration](#BOME-mappings-migration)
* [Hardware Controllers](#Hardware-Controllers)
* [Free Mappings](#Free-Mappings)
* [DJ Tutorials](#DJ-tutorials)
* [DJ collection converters](#DJ-collection-converters)
* [Free DJ Software Tools](#Free-DJ-Software-Tools)
* [DJ Software optimization](#DJ-Software-optimization)
* [Windows usage](#Windows-usage)
* [Rekordbox V6 topics](#Rekordbox-v6-topics)
* [MIXXX topics](#mixxx-topics)
* [Music Styles](#Music-Styles)
* [Other topics](#Other-topics)
  
See below for a longer Table of contents.  
  

# Table of Contents (detailed)


* [MindMap](#MindMap-Summary)
* [OS-Folders as virtual playlists](#OS-Folders)
  * [How large is your collection? How complex is your collection?](  #How-large-is-your-collection-How-broad-is-your-collection)
  * [Why I manage music using OS-folders only](#why-i-manage-music-using-os-folders-only)
  * [How to manage your collection using operating systems folders and without DJ playlists](#how-to-manage-your-collection-using-operating-systems-folders-and-without-dj-playlists-ie-using-only-finder-windows-explorer-etc)
  
* [Traktor software](#Traktor-software)
  * [Why is Traktor my software of choice](#why-is-traktor-my-software-of-choice)
    * [a) Automatic finds moved files](#why-is-traktor-my-software-of-choice-a-database-repair-mass-relocate)
    * [b) OS Search (no playlists)](#why-is-traktor-my-software-of-choice-b-os-search-no-playlists)
    * [c) Advanced MIDI mapping and Lots of FX](#why-is-traktor-my-software-of-choice-c-advanced-midi-mapping)
    * [d) Hotcues move the temporary cue as well](#why-is-traktor-my-software-of-choice-d-hotcues-move-the-temporary-cue-as-well)
    * [e) Stronger Sync than others](#Why-is-Traktor-my-software-of-choice-e-Stronger-Sync-than-others)
  * [Which features I miss in Traktor](#Which-features-I-miss-in-Traktor)
  * [STEMS automatic creation](#How-to-create-your-own-karaoke-files-automatically-using-Stems-and-AI)

* [Effects](#Effects)
  * [Description of the basic effects](#description-of-the-basic-effects)
  * [How to create unique effects by chaining base effects](#how-to-create-unique-effects-by-chaining-base-effects)
  * [List of FX Chains](#list-of-fx-chains)
  * [Which basic effects constitute Traktor mixerFX and macroFX?](#which-basic-effects-constitute-traktor-mixerfx-and-macrofx)
  * [Which basic effects constitute Pioneer SoundColorFX](#describing-the-basic-effects-that-constitute-pioneer-soundcolorfx)
  * [Which basic effects constitute VirtualDJ SoundColorFX](#describing-the-basic-effects-that-constitute-virtualdj-soundcolorfx)
  
* [Traktor Elastic Beatgrids](#Traktor-Elastic-Beatgrids)
  * [Which tracks have multiple BPMs](#Which-tracks-have-multiple-BPMs)
  * [What are Elastic Beatgrids](#What-are-Elastic-Beatgrids)
  * [Softwares with Elastic Beatgrids](#Which-softwares-support-Elastic-Beatgrids)
  * [Traktor emulated Elastic Beatgrids](#How-to-emulate-elastic-beatgrids-in-Traktor)
  * [Traktor emulated Elastic Beatgrids (more accurate)](#How-to-emulate-Elastic-Beatgrids-in-Traktor---More-complex-workflow)
  * [Which tracks benefit from emulated Elastic beatgrids](#Which-tracks-benefit-from-emulated-Elastic-beatgrids)

* [Traktor Slow preferences](#Traktor-Slow-preferences-Window)
  * [Issue explanation](#Why-MIDI-mappings-makes-the-preferences-window-slow)
  * [Measurements](#How-slow-does-the-preferences-window-get)
  * [Naive solution](#Could-we-just-move-all-entries-to-a-single-page)
  * [Swapping configurations](#How-to-swap-Traktor-configurations-without-the-slow-preferences-window)
  
* [BOME migration](#BOME-mappings-migration)
  * [Why I moved to BOME midi mapping: Impossible features](#Why-I-moved-to-BOME-midi-mapping-Impossible-features)
  * [Why I moved to BOME midi mapping: Traktor Limits](#Why-I-moved-to-BOME-midi-mapping-Traktor-limits)
  * [BOME limits](#Some-Limitations-of-BOME-mappings)
  * [How I see the future of Traktor mappings](#How-I-see-the-future-of-Traktor-mappings)

* [Hardware Controllers](#Hardware-Controllers)
  * [Why is DDJ-1000 my hardware of choice](#why-is-ddj-1000-my-hardware-of-choice)
  * [DDJ-1000 comparison to DDJ-SZ and AKAI AMX](#DDJ-1000-comparison-to-DDJ-SZ-and-AKAI-AMX)
  * [Why i like BIG jogwheels](#why-i-like-big-jogwheels)
  * [But can I still scratch using MIDI? How much is the latency of your maps?](#But-can-i-still-scratch-using-MIDI-How-much-is-the-latency-of-your-maps)
 
* [Free Mappings - Downloads](#Free-Mappings)
  * [What are your main Traktor mappings?](#Free-mappings)
    * [DDJ-1000 mapping](#What-are-the-features-of-your-DDJ-1000-Traktor-mapping)
    * [DDJ-SX2 / DDJ-SZ / 1000SRT mapping](#what-are-the-features-of-your-ddj-sx2--ddj-sz--ddj-srt-traktor-mapping)
    * [AKAI AMX Traktor mapping](#what-are-the-features-of-your-akai-amx-traktor-mapping)
  * [What are your other mappings?](#What-are-the-features-of-your-XDJ-XZ-Traktor-mapping)
    * [XDJ-XZ mapping](#What-are-the-features-of-your-XDJ-XZ-Traktor-mapping)
    * [Numark PartyMix mapping](#What-are-the-features-of-your-Numark-PartyMix-mapping)
    * [CDJ2000NX2](https://maps.djtechtools.com/mappings/9763)
  * [What are your keyboard mappings](#Which-are-your-Keyboard-mappings)
    * [Beatgrid preparation](#Which-are-your-Keyboard-mappings)
    * [Transitions-aligned Beatjumps](#Which-are-your-Keyboard-mappings)
  * [What are demos of advanced mapping tricks](#What-are-demos-of-advanced-mapping-tricks)
    * [Preview Player](#What-are-demos-of-advanced-mapping-tricks)
    * [Backwards loop and Reloop](#What-are-demos-of-advanced-mapping-tricks)
    * [BOME access all 9x mixerFX](#What-are-demos-of-advanced-mapping-tricks)
    
* [Free Mappings - Info](#Free-Mappings)
  * [How to download my Traktor mappings](#How-to-download-my-Traktor-mappings)
  * [How to install my Traktor mappings](#How-to-install-my-Traktor-mappings)
  * [What documentation comes with your mappings?](#what-documentation-comes-with-your-mappings)
  * [Can I see a demo video of your mappings?](#can-i-see-a-demo-video-of-your-mappings)
  * [Can I test your mappings for free?](#can-i-test-your-mappings-for-free)
  * [Is the DDJ-1000SRT also mappable to Traktor?](#is-the-ddj-1000srt-also-mappable-to-traktor)
  * [Is the DDJ-XP2 mappable to Traktor?](#is-the-ddj-xp2-mappable-to-traktor)
  * [Does (random DDJ controller) works with your mapping? Are the jogs good?](#Does-random-DDJ-controller-works-with-your-mapping-Are-the-jogs-good)
  
* [DJ Tutorials](#DJ-tutorials)
  * [List of Online DJ Courses](#List-of-Online-DJ-Courses)
  * [List of Technical Webinars](#List-of-Technical-Webinars)
  * [Midi mapping tutorials](#Midi-mapping-tutorials)
  * [List of advanced MIDI mappings](#List-of-advanced-MIDI-mappings)
 
* [DJ collection converters](#DJ-collection-converters)
  * [What is the 26ms shift issue when converting cues/loops between softwares?](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares)
  * [Which DJ converters avoid the 26ms shift issue?](#which-dj-converters-avoid-the-26ms-shift-issue)

  
* [Free DJ Software Tools](#Free-DJ-Software-Tools)
  * [Traktor tools overview](#what-software-tools-did-you-built-for-Traktor)
  * [CMDR TSI editor](#What-features-did-you-add-to-the-CMDR-TSI-editor)
  * [Elastic Beatgrids emulation](#How-to-emulate-elastic-beatgrids-in-Traktor)
  * [Tracklist and CUE tools](#how-i-build-perfect-tracklists-using-cue-files)
  * [Github Markdown tools](#Github-Markdown-tools)
  * [Youtube, Google an Discogs shortcuts](#What-shortcuts-you-added-for-Youtube-Google-and-Discogs)
  * [Programming libraries](#what-programming-libraries-and-technical-scripts-did-you-author)

  
* [DJ Software optimization](#DJ-Software-optimization)
  * [Optimization Quick fixes](#How-to-optimize-a-laptop-for-DJ-Software---Summary)
  * [Optimization Complex case](#How-to-optimize-a-laptop-for-DJ-Software---Complex-case)
  * [Audio Performance guides](#List-of-performance-guides-specific-to-audio)
  * [DDJ-1000 and turbo boost](#how-to-avoid-crackle--glitches--noise-on-windows-by-disabling-intel-turbo-boost)
  * [USB thin cables](#Read-this-if-you-have-erratic-USB-cable-problems)
  * [Dell pre-installed services issues](#dell-laptop-pre-installed-services-latency-issues)
  * [SMI hidden interrupts](#How-to-count-SMI-hidden-interrupts-in-Windows)
  * [Deep trace analysis](#How-to-make-a-deep-trace-of-everything-that-runs-in-your-laptop)
  * [Every possible optimization](#List-of-every-possible-performance-audio-optimization)
  * [Traktor verbose log](#How-to-enable-Traktor-verbose-log)
  * [Buying a laptop for Audio](#Buying-a-laptop-for-Audio)
  
* [Windows usage](#Windows-usage)
  * [Why I use Windows instead of Mac](#Why-I-use-Windows-instead-of-Mac)
  * [Generic Windows tweaks and programs I use](#Generic-Windows-tweaks-and-programs-I-use)
  * [How to use QQTabBar with multiple tabs, folder bookmarks and program launchers](#How-to-use-QQTabBar-with-multiple-tabs-folder-bookmarks-and-program-launchers)
  * [How to add WSL scripts to QQTabBar](#How-to-add-WSL-scripts-to-QQTabBar)


* [Rekordbox v6 topics](#Rekordbox-v6-topics)
  * [Issues of the V6 Rekordbox migration - Major](#issues-of-the-V6-Rekordbox-migration---major)
  * [Issues of the V6 Rekordbox migration - Minor](#issues-of-the-V6-Rekordbox-migration---minor)
  * [What is NOT unlocked in the Rekordbox V6 hardware options](#What-is-NOT-unlocked-in-the-Rekordbox-V6-hardware-options)
  * [How to ignore Rekordbox upgrades](#How-to-ignore-Rekordbox-upgrades-completely)


* [MIXXX topics](#mixxx-topics)
  * [What makes MIXXX unique](#what-makes-mixxx-unique)
  * [How complete is MIXXX?](#how-complete-is-mixxx)
  * [DDJ support in MIXXX](#ddj-support-in-mixxx)
  
  
* [Music Styles](#Music-Styles)
  * [Retro, Metal and Reggae remixes](#What-are-Retro-Metal-and-Reggae-remixes)
  * [Examples of Retro, Metal and Reggae remixes](#Examples-of-Retro-Metal-and-Reggae-remixes)
  * [Sets Reconstructing for learning purposes](#How-to-learn-good-transition-points-by-reconstructing-sets)

  
* [Other topics](#Other-topics)
  * [Issues of the V6 Rekordbox migration - Major](#issues-of-the-V6-Rekordbox-migration---major)
  * [Issues of the V6 Rekordbox migration - Minor](#issues-of-the-V6-Rekordbox-migration---minor)
  * [How to enable day skin in any software](#How-to-enable-day-skin-in-any-software)
  * [How I recorded my old radio show recordings and found the IDs](#How-I-recorded-my-old-radio-show-recordings-and-found-the-IDs)
  * [How I edited my videos showing the Traktor screen](#How-I-edited-my-videos-showing-the-Traktor-screen)
  * [How I synchronize and backup my whole Traktor structure across laptops and a NAS](#how-i-synchronize-and-backup-my-whole-traktor-music-and-configuration-across-laptops-and-a-nas)
  * [How to replace the DDJ-1000 filter knobs with Silver knobs](#How-to-replace-the-DDJ-1000-filter-knobs-with-Silver-knobs)
  * [DJ Census over time results](#DJ-Census-over-time-results)
  * [Some metrics of my free contributions](#Some-metrics-of-my-free-contributions)
  * [People that I learned a lot from the Global DJ community](#Some-people-from-which-Ive-learned-a-lot-from-the-Global-DJ-community)

  
  
     

# MindMap Summary

This page has my knowledge sharing about Traktor, Mappings, Hardware, DJing, DJ Set, etc.\
The picture below summarizes the main ideas and dependencies explained in these blog posts.
![traktor_mindmap](pics/traktor_mindmap.png?raw=true)

# OS-Folders

## How large is your collection? How broad is your collection?

I have a large collection with thousands of files. It is also quite broad, featuring hundreds of playlists, and dozens of genres / sub-genres / decades combinations.

My numbers are:
* **Tracks**: 7000
* **Playlists**: 300
* **Sub-genres:** 50 
* **Major-genres:** 10
* **Decades:** 5
* **DJs**: 2

To manage this complexity I've build my own set of personal tags that I fully trust.
As such, the first action on new files is to tag them into my structure. This ignores any previous tags made by someone else.

Below an example how my structure looks like; the full tree is far larger.
![DJ Genres](pics/folder_organization_dj_genres.png?raw=true)

See also [Why I manage music using OS-folders only](#why-i-manage-music-using-os-folders-only).
  

## Why I manage music using OS-folders only

Above, I've explained [the size and complexity of my collection](#How-large-is-your-collection-How-broad-is-your-collection).\
This is nothing new; I know many DJs with [the same "problem"](https://code.google.com/archive/p/serato-itch-sync/). The difference is on the *how*; In my case I manage the collection only in OS-folders, instead of DJ-playlists.

Main reasons are:
* **#1: Multiple Windows:** File explorer opens instantaneously with Win+E, and allows any number of windows, monitors and [tabs](http://qttabbar.wikidot.com/). 
* **#2: Tree Tagging:** More crucially, all windows have the whole tree visible. This is essential to quickly tag my files by just moving them to the correct correct folder. Similarly, the structure grows just by creating new sub-folders as needed.
* **#3: Simpler Folders**: OS-Folders contain either files, sub-folders, or both. [This 2-step organization](https://en.wikipedia.org/wiki/Path_(computing)#History) is simpler is than the iTunes 3-step model of "folders -> playlists -> files" (later copied by almost all DJ softwares).
* **#4: Local Searches:** By far my most common task is to check if I already have a particular track, and where is it tagged. File explorer allows local searches on a folder and its sub-folders only. This enables me to quickly find things by just typing a few letters of the filename. AFAIK only Serato has this feature (called ["include subcrates"](https://support.serato.com/hc/en-us/articles/227626268-Subcrates))
* **#5: Tags Cleanup:** Before tagging the file, I rename the filenames to correct its artist / title. [MP3tag](https://www.mp3tag.de/en/) helps a lot to clean up the formatting, using [my own scripts](tools_traktor/Mp3tagSettings.zip) to automatically capitalize the names as “ARTIST1 ft. ARTIST2 - Capitalized Title - Remix”, and to update the internal mp3 tags. 
* **#6: Software Independence:** Using OS-folders you are independent of any possible DJ software and itunes. It also trivial to [sync between laptops](#how-i-synchronize-and-backup-my-whole-traktor-music-and-configuration-across-laptops-and-a-nas) and make perfect backups [to my NAS](https://www.synology.com/en-global/products/DS718+). It is also trivial to load a whole genres to USB sticks to listen in cars.


See also [this blog post for more details on my workflow between DJ softwares ](#how-to-manage-your-collection-using-operating-systems-folders-and-without-dj-playlists-ie-using-only-finder-windows-explorer-etc).
  

## How to manage your collection using operating systems folders and without DJ playlists (ie, using only Finder, Windows Explorer, etc) 

Above I've described [Why I manage music using OS-folders only](#why-i-manage-music-using-os-folders-only). In this post I will describe *how* I manged to **fully automate** my workflow between DJ softwares.

* **#0: File operations:** [As explained above](#why-i-manage-music-using-os-folders-only) I continuously search files, change the filenames and move the files around left and right.
* **#1: Traktor Repair:** When I first open Traktor, it automatically [repairs its own database](#why-is-traktor-my-software-of-choice-a-database-repair-mass-relocate). For this I just run a mass-relocate on my whole music root folder, which refinds all moved and renames files in a single go.
* **#2: Update collection:** The second step is just to import the whole music root folder into Traktor. As this skips previous files, in practice it only imports the New files. The last step is to delete the remaining missing files (that are really deleted - otherwise they would been found on step #1) 
* **#3: Duplicate Cues**: For the rare cases that a file is in multiple sub-genres, I just copy them physically in different folders.  Then I run a [python script](tools_traktor/traktor_clone_cues.py) to automatically duplicate the CUEs for these files. This tool is similar to [the traktor Librarian](http://www.flowrl.com/librarian).
* **#4: Dj Converter:** I use the [DJ Data Converter](#which-dj-converters-avoid-the-26ms-shift-issue) to generate the rekordbox.xml file without the [26ms shift problem](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares).
* **#5: Rekordbox Import:** On rekordox first I delete all missing files, then import the whole collection "as-is", and then update the collection with the XML file that came from the (repaired) Traktor collection. These steps are fully automatic and it ensures the Rekordbox collection matches the Traktor collection.
* **#6: Rekordbox Search:** I only use rekordbox for video gigs. There I use the explorer node to see my files, and search for files in the whole collection. For the rare case I need to search inside a "playlist", I use a real File Explorer window in parallel when needed (because rekordbox [still lacks a search box in OS-folders](#why-is-traktor-my-software-of-choice-b-os-search-no-playlists))
* **#7: CDJ export:** I only really need playlists for CDJs. There are scripts to mass-convert all folders to DJ playlists. Then I do the usual rekordbox step to prepare USBs pens.
  * Windows version is http://samsoft.org.uk/iTunes/ImportFolderStructure.vbs; 
  * Mac version is https://dougscripts.com/itunes/scripts/ss.php?sp=droptoaddnmake; 
  * A Serato-specific version is in https://code.google.com/archive/p/serato-itch-sync/
  
See also the [DJCU workflow from ATGR](https://www.youtube.com/watch?v=d4QO6xxGovQ).
 
  
# Traktor software


## Why is Traktor my software of choice

Traktor has unique features - big and small - that I depend on.\
Other softwares have nice unique features too, but I built my workflows on these specific ones.

Posts:
* [a) Automatic database repair (mass relocate)](#why-is-traktor-my-software-of-choice-a-database-repair-mass-relocate)
* [b) OS Search (no playlists)](#why-is-traktor-my-software-of-choice-b-os-search-no-playlists)
* [c) Advanced MIDI mapping](#why-is-traktor-my-software-of-choice-c-advanced-midi-mapping)
* [d) Hotcues move the temporary cue as well](#why-is-traktor-my-software-of-choice-d-hotcues-move-the-temporary-cue-as-well)
* [e) Stronger Sync than others](#Why-is-Traktor-my-software-of-choice-e-Stronger-Sync-than-others)

more info: https://github.com/pestrela/music_scripts/tree/master/traktor#why-is-traktor-my-software-of-choice

See also [which features I miss in Traktor](#Which-features-I-miss-in-Traktor), and [STEMS info](#How-to-create-your-own-karaoke-files-automatically-using-Stems-and-AI).


## Why is Traktor my software of choice: a) Automatic finds Moved / Renamed files (mass relocate)

Traktor is above to find RENAMED files fully automatically without losing CUE points, beat grid or re-analysis.

I RENAME and MOVE files very regularly at the OS-folders level, using Windows Explorer/macOS finder.

When Traktor starts, it does a "consistency check" to confirm if all files are still there. (demo: [0:24 of this video](https://www.youtube.com/watch?v=i_zYavcCa7k&t=24s)). This finds all missing files in a single go (demo: [0:50 of this video](https://www.youtube.com/watch?v=i_zYavcCa7k&t=50))\
Then, the mass-relocate process fixes everything in a single go as well; you just select the root folder that contains your files "somewhere". In the extreme worst case this would be your whole hard drive. (demo: [5:36 of this video](https://www.youtube.com/watch?v=i_zYavcCa7k&t=320s)).

The relocate process is reasonably straightforward for MOVED files. However it is much much harder for RENAMED files.\
Traktor is the only software that achives that because it fingerprints everything in a private field called "[AudioId](https://www.mail-archive.com/mixxx-devel@lists.sourceforge.net/msg05061.html)")

When the mass-relocate process ends, everything is magically found again. Crucially all metadata is kept: CUE points, beat grid, analysed BPM, stripe, etc.\
Together with the OS-search feature described below, this enables me to use folders as "virtual playlists".
* **Comparison to Rekordbox v6:** V6 fixed this problem, well done! However it is not a solution because of the [missing XML export issue](#issues-of-the-V6-Rekordbox-migration---major)
* **Comparison to Rekordbox v5:** Renamed files need to be relocated FILE by FILE.\
Moved files can be done FOLDER by FOLDER.\
If this manual process is skipped, the files are seen as brand new, losing all meta-data.\
[An external tool](https://github.com/edkennard/rekordbox-repair) helps the moved files case. [Example of Pioneer forum request](https://forums.pioneerdj.com/hc/en-us/community/posts/115018095303-Reasons-to-think-i-leave-from-rekordbox-?page=1#community_comment_360000392646)
* **Comparison to VDJ:** Everything need to be relocated FILE by FILE.
* **Comparison to Serato:** To test.


## Why is Traktor my software of choice: b) OS-search to use (no playlists)

Traktor allows searching inside any OS folders. I don't have DJ playlists inside Traktor; instead, my OS-folders are my "virtual playlists".\
I have a very large collection with dozens of genres, sub-genres and decades. For that I've created a structure where each decade is a separate folder, inside a parent genre/sub-genre folders.\
When I'm playing a specific genre I can search only that decade (=OS folder). If I want something else I can always search the whole collection at any time.\
([See this blog post for more detail on these methods](#how-to-manage-your-collection-using-operating-systems-folders-and-without-dj-playlists-ie-using-only-finder-windows-explorer-etc))
* **Comparison to Rekordbox:** Rekordbox displays OS folders, but you can't search inside them. [Example of Pioneer forum request](https://forums.pioneerdj.com/hc/en-us/community/posts/115018095303-Reasons-to-think-i-leave-from-rekordbox-?page=1#community_comment_360000392646)
* **Comparison to Serato:** Serato has a nicer way to display OS folders, but you can't search inside them
* **Comparison to VDJ:** VDJ has really good OS-searches, better than traktor, by having a "recurse" option to see all sub-folder files in a flat view



## Why is Traktor my software of choice: c) Advanced MIDI mapping
  
Traktor supports complex MIDI mapping with 8x variables, 2x conditionals and any number of actions per MIDI input

My [DDJ-1000 mapping has FX chains of the Jogwheel](https://github.com/pestrela/music_scripts/blob/master/traktor/ddj_1000_traktor_mapping/DDJ-1000%20v6.5.1%20TP3%20-%20Quick%20overview.pdf). For a demo, see at 6:30 of this video: https://www.youtube.com/watch?v=h9tQZEHr8hk&t=392s \
My [AKAI AMX mapping has 10 layers built using shifts and states](https://github.com/pestrela/music_scripts/blob/master/traktor/akai_amx_traktor_mapping/AMX%20v1.0.1%20TP3_TP2%20-%20Quick%20overview.pdf) to cram A LOT more functionality than the existing buttons.\
This is only possible if midi mapping has variables and multiple actions per physical input.
\
* **Comparison to Rekordbox:** No variables at all, no multiple actions. They only allow you to assign a single command to a single button. 
* **Comparison to Serato:** No variables at all, no multiple actions. They only allow you to assign a single command to a single button. 
* **Comparison to VDJ:** VDJ is even better than traktor, has it has a full scripting language built-in ([VDJscript](https://www.virtualdj.com/wiki/VDJscript.html)). 
It features infinite variables, conditions and states; Traktor only has 8 variables, 2 conditions and 8 states.\
  VDJ also features extremely nice [mapping editor](https://www.youtube.com/watch?v=4SU2OyDB9PQ&t=200),
  [pad editor](https://www.youtube.com/watch?v=eT1nZVpUUr8&t=50),
  and [custom button editor](https://www.youtube.com/watch?v=nGbw2RHV_j0&t=180), all with dropdowns and chained together.

See also ["Why I moved to BOME midi mapping"](#BOME-mappings-migration).


## Why is Traktor my software of choice: d) Hotcues move the temporary cue as well

**Update:** I've now made a video to show this  request: https://www.youtube.com/watch?v=tINljMwc4Co

I use the hotcues as internal "bookmarks". In Traktor, pressing a hotcue moves the temporary cue as well.\
This is very useful for  previewing an old song that you dont remember anymore. When you are done, you just move it to the last point using the big round button.
* **Comparison to Rekordbox:** No option to move the temporary cue when pressing a hotcue. This causes massive confusion to me every single time. This would be trivial to fix using advanced MIDI mapping. [This was requested in their forum](https://forums.pioneerdj.com/hc/en-us/community/posts/360021313752-Is-there-any-way-at-all-to-reassign-the-cue-button-to-cue-to-the-most-recently-selected-hot-cue-rather-than-only-being-used-to-make-cue-points-)
* **Comparison to Serato:** untested
* **Comparison to VDJ:** untested, but not a problem for sure (trivial to change using advanced MIDI mapping)

## Why is Traktor my software of choice: e) Stronger Sync than others

Traktor features a very strong master clock that was built for the remix decks. As such its sync is in general stronger than the other softwares I tested. 
Using Beatsync the phrasing is always kept for any action I might do to the track: Beatjump, Hot cues, Temporary Cue, Pitch bend, Tempo change, Scratch, etc.

* **Comparison to Serato:** see [this comparison video](https://www.youtube.com/watch?v=pyAj4IyFNCs). Even there I still found myself having the "gold" sync instead of the desired "blue" sync
* **Comparison to Rekordbox:** It has the best sync outside Traktor 
* **Comparison to VDJ:** untested

    
## Which features I miss in Traktor

Specific features:
* **#1: Elastic beatgrids**: This is crucial as I play very old music and many music styles. [tool](#how-to-emulate-elastic-beatgrids-in-traktor)
* **#2: Include subcrates** just like [serato](https://support.serato.com/hc/en-us/articles/227626268-Subcrates)
* **#3: Pioneer DDJ**: Plug-and-Play to Pioneer gear / DDJ controllers, because this is the [most popular equipment today](../census_graphs)
* **#4: Pad modes**: I have multiple pad modes in my mappings, but would love to see them on screen, and have an associated pad editor just like Rekordbox and VirtualDJ
* **#5: Turntable FX**: Turntable start&stop on the [play/pause button](https://www.youtube.com/watch?v=EPnmyDiaJTE)
* **#6: Video support**
* **#7: [VDJscript](https://www.virtualdj.com/wiki/VDJscript.html)**, with a lot more than 8x variables and 2x conditions
* **#8: Smart playlists** and related tracks

In general I fully agree with [this Digital DJ Tips article](https://www.digitaldjtips.com/2019/10/what-next-for-traktor/). Generic comments:
* **#1:** “Please embrace hardware partners again…”
* **#2:** “Please speed up software development!”
* **#3:** “Please, no more reinventing the wheel :)”

But in the end Traktor has [has unique features that I depend on](#why-is-traktor-my-software-of-choice).

See also the [most popular DJ softwares census](../census_graphs).


## How to create your own karaoke files automatically using Stems and AI


[Stems](https://www.youtube.com/watch?v=grgjIhs-OC8) is a new file format that contains 4 sub-tracks you can mix on your own. 
This is read and manipulted nativelly by Traktor.
 
[Spleeter](https://www.theverge.com/2019/11/5/20949338/vocal-isolation-ai-machine-learning-deezer-spleeter-automated-open-source-tensorflow)
 is a open-source AI tool that quickly isolates the vocals in any song, producing four seprate audio files. 
 ([Another link](https://deezer.io/releasing-spleeter-deezer-r-d-source-separation-engine-2b88985e797e)).
 

[Stemgen](https://github.com/axeldelafosse/stemgen) is a script that groups several programs to generate a stem file automaticalyy

Want to hve a quick go with  stems? [This pack](https://www.native-instruments.com/en/specials/stems-for-all/free-stems-tracks/) has example tracks.\
Of which I recommend these files:
* LM_StockholmSyndrome.stem.mp4
* NR_FeverLine.stem.mp4
* PR_OhNo.stem.mp4


# Effects 

This section covers advanced usage of effects.

Posts:
* [Description of the basic effects](#description-of-the-basic-effects)
* [How to create unique effects by chaining base effects](#how-to-create-unique-effects-by-chaining-base-effects)
* [List of FX Chains](#list-of-fx-chains)
* [Which basic effects constitute Traktor mixerFX and macroFX?](#which-basic-effects-constitute-traktor-mixerfx-and-macrofx)
* [Which basic effects constitute Pioneer SoundColorFX](#describing-the-basic-effects-that-constitute-pioneer-soundcolorfx)
* [Which basic effects constitute VirtualDJ SoundColorFX](#describing-the-basic-effects-that-constitute-virtualdj-soundcolorfx)
      


## Description of the basic effects 

These are definitions from the basic effects. This will be useful later to describe the FX chains (combos).

* Basic FX:
  * https://en.wikipedia.org/wiki/Audio_signal_processing#Audio_effects
  * Delay = repeat sound once after X beats (can be fractional)
  * Echo = repeat sound multiple times, with decreasing intensity
  * Reverb = repeat sound multiple times heavily very soon
  * Flanger = a single delay with very short duration (short phase)
  * Filter = lower/cut or raise specific frequencies
  * Overdrive = clipping to increase loudness
  * Pitch = changing tone with same tempo
  * Resonators = emphasize harmonic frequency content on specified frequencies.
  * Modulation = change frequency in relation to a signal
  * Compression = reduction of dynamic range
  * Gate = ON/OFF synced to BPM
  
## How to create unique effects by chaining base effects 

You can easily create unique effects by chaining existing effects in very specific ways.

This is called the "Fader FX theory" as invented by Ean Golden in 2008
* **Article:** https://djtechtools.com/2008/12/15/fader-fx-theory/
* **Demo video:** https://www.youtube.com/watch?v=pjjA0xPkXMs
  
This uses 3x effects in a chain:
* **Slot 1:** Repeating effect 
  * eg: Beatmasher, Gater, Delays
* **Slot 2:** Shaping effect 
  * eg: Filter, Lo-fi, Peak filter
* **Slot 3:** Dimensional effect 
  * eg: Reverb, delay
  
Below, blog posts on a) lists of FX chains and b) descriptions of MixerFX / MacroFX / SoundColorFX.


## List of FX Chains 

This is the original article where Ean Golden applied these FX chains to the jogwheels (JogFX):

* **Article:** https://djtechtools.com/2008/06/20/re-use-your-jog-wheel-4-fx/
* **Demo video:** (see at 7:31) https://www.youtube.com/watch?v=H_TE2mtuM6Q&t=451  
  
* DJ Estrela / JaJa DDJ jogFX:
	* JogFX1: Beatmasher2 / Digital filter / Gater
	* JogFX2: Beatmasher2 / Filter / Reverb
	* JogFX3: Eventhorizon / Filter / Gater
	* JogFX4: Gater / Beatmasher / Reverb
	* JogFX5: Flanger / Filter / Gater
	* JogFX6: Beatmasher2 / Peak filter / Gater
	* JogFX7: FormatFilter / Peak filter / Flightest
	
* Ean Goldmen VCI-100:
  * VCI-100 3_4 SE: https://www.youtube.com/watch?v=Du9UAARJe8I
	* demo: https://www.youtube.com/watch?v=HUBEN-0b2cY
	*	#1: BeatMasher2 / Filter / FlangerPulse
	*	#2: Beatmasher / Delay / ReversGrain
	*	#3: Beatmasher / Lofi  / TurntableFX
	*	#4: Gater / FormantFilter / Reverb
	
* DJTT VCI-400 (same as S2/S4)
	* demo: 13:00 https://www.youtube.com/watch?v=2AeX3qZqj7M
	* #1 Echo:  delay (single)
	* #4 Detox: Beatmasher2 / Lofi / PeakFilter
	* #3 Build: Gater / Beatmasher2 / PeakFilter 
	* #2 Swirl: FlangerFlux / Filter92:LFO / Reverb 

		
* DJTT S2/S4 JogFx:
	* S4: https://www.youtube.com/watch?v=YJyYeTagTWg
	* S2: https://www.youtube.com/watch?time_continue=55&v=KJcbaN87IBQ
	* #1 Detox: BeatMasher2 / Lofi / PeakFilter
		* set: 0.6 / 0.1 / 0.2
		* rot: 68%/25% / 88%/19% / 48%/35% 
	* #2 Build: Gater / BeatMasher2 / PeakFilter
		* set: 0.5 / 0.1 / 0.2
		* rot: 68%/25% / 88%/19% / 50%/35% 
	* #2 Swirl: FlangerFlux / PeakFilter / Reverb
		* set: 0.5 / 0.4 / 0.0
		* rot: 68%/25% / 60%/37% / 50%/35% 
    
* jwill 4TRAK platter FX:
	* demo: 2:12 https://www.youtube.com/watch?v=wVQxa8rbjeA
	* #1: BeatMasher / Lofi / delay
	* #2: Flangerflux / gater / reverbT3
	* #3: Gater / peakfilter / delayT3 
	* #4: Gater / t3delay / peakfilter
	* #5: FlangerFlux / FilterPulse / delayT3
	* #6: Iceverb / peakFilter / Reverb
	* #7: Filter / reverb / iceverb / key  <<<<<
	* #8: Beatmasher / transpose_Strech / mullhoand_drive
	
* Koolis FX combos: 
	* http://blog.dubspot.com/8-free-traktor-fx-combos-koolis	
	* #1	BeatSlicer / Filter:92 LFO / Delay
	* #2	Beatmasher2 / Transpose Stretch / Reverb
	* #3	PolarWind / Gater / Digital Lofi
	* #4	Reverb T3 / Delay T3 / Digital Lofi
	* #5	Reverb T3 / Delay T3 / Filter
	* #6	Beatmasher2 / Gater / Flanger
	* #7	Beatmasher2 / Phaser / Digital Lofi
	* #8	Delay / Phaser Flux / Reverb T3 

* Viper:
	* #1 Beatmasher / Reverb / DelayT3
	* #2 Sweep Drama: iceverb / PeakFilter / Delay 
	* #3 Delay like Ean Golden: Delay
  * #4 Gater / Beatmasher / ReverbT3
  * #5 DelayT3 / PeakFilter / Flanger 
	* #6 Detox (E.G): Beatmasher2 / Lofi /Reverb
  * #7 Build (E.G): Gater / Beatmasher2 / PeakFilter
  * #8 Swirl (E.G): FlangerFlux / Filter92:LFO / Reverb 
		
* Scamo S4:
	* Mode 1 - Ean's Beat Masher:  beatmasher + peakFilter + T3 reverb / muloun drive + pftr + reverb
  * Mode 2 - Transbeater: beatmasher / transposeStretch / TTFX 
	* Mode 3 - Delayorama: T3Delay
	* Mode 4 - The Belofo: beatmasher / Lofi / FilterLFO. 
	* Mode 5 - Flangeritis: FlangerFlux / Reverb
	* Mode 6 - The Riffer:  gator / beatmasher / ReverbT3   (filter?)
	* Mode 7 - Reverbogator: 	reverb / gator
	* Mode 8 - Army of Me's (Priscilla's) Sweep Drama Effect
	* Mode 9 - LOFI Sweep
	* Mode 10 - Flanger Sweep
	* Mode 11 - Pulse Sweep
	* Mode 12 - Beat Slicer
	* Mode 13 - LOFI Masher
			
* elephant jogFX:
	* 2-M: Beatslicer / Gater / LaserSlicer 
	* 2-L: Gater / Beatlicer / ZZurrp 
	* 2-R: Reverb / Gater / Wormhole 
	* 3-M: Gater / Beatmasher2 / Beatslicer 
	* 3-L: Gater / Beatmasher2 / Delay 
	* 3-R: Gater / Beatmasher2 / Srrrettch Slow 
	* 4-M: Gater / RampDelay / Iceverb 
	* 4-L: Gater / TapeDelay / Reverb 
	* 4-R: Beatmasher2 / RampDelay / PolarWind 

  
* DA VE:
  * Beatmasher 2 / Reverb / Transpose stretch  
  
* L.G.MUZIK - TP3 F1 sidekick 
  * 1-1) Iceverb / Peak Filter / Reverb    <<<<<
  * 1-2) Reverb T3 / Delay T3 / Filter 92 
  * 1-3) Delay / Flanger Flux / Reverb 
  * 1-4) Stretch slow / Transpose Stretch / Wormhole 
  * 2-1) Iceverb / Mullholland Drive / Peak Filter 
  * 2-2) Reverb / Delay T3 / Digital Lofi  
  * 2-3) Reverb T3 / Flanger / Gater 
  * 2-4) Ringmodulator / Reverb T3 / Flanger Pluse 

  
* Raycotek 2x2RD:
  * 0:24 https://www.youtube.com/watch?v=--U3Ngp5RyI&feature=emb_logo
  * #1 Iceverb / Peak Filter / Reverb   <<<
  * #2 Iceverb / Digital LoFi / Peak Filter 
  * #3 Reverse Grain / Peak Filter / Iceverb Smart FX 
  * #4 Mulholland-Drive / Transpose Stretch/ Peak Filter   ...
  * #5 Tape Delay / Gater / Filter:92 LFO 
  * #8 Delay / Beatmasher 2 
  * #12 Delay T3 / Filter:92 / Beatmasher 2 
  * #16 Transpose Stretch / Delay / Reverb 
  
* Raycotek 4FD
  * 1:22 https://www.youtube.com/watch?v=DhHzcGEa3yg&feature=emb_logo
  * jogFX :
  * #1 / Flanger Pulse	/ Delay	 / Peak Filter	
  * #2 Delay	 / Flanger Pulse/ Wormhole
  * #3 Laser Slicer	/ Delay T3/ Filter	
  * #4 Beatmasher 	/ Laser Slicer	/ Peak Filter	
  * 
  * smart cue:
  * #1 Beatmasher 2/ Transpose Stretch/ Delay
  * #2 Beatmasher 2/ Tape Delay/ Filter
  * #3 Laser Slicer/ Filter:92 Pulse/ Reverb
  * #4 Delay/ Mulholland-Drive/ Peak Filter

  
## Which basic effects constitute Traktor mixerFX and macroFX?
  
MixerFX / MacroFX are essentially FX chains with specific defaults and behavior.\
This post describes the basic elements of MixerFX using simpler base effects (delay, echo, filter, reverb, flanger, beatmasher, bitcrush, white noise).


* TP3.0 MIXERFX:
  * https://djtechtools.com/2018/10/18/traktor-pro-3-out-now-heres-whats-new/
  * Reverb: resonant reverb + heavy filter
  * Dual Delay: 1/2 delay + filter
  * Dotted Delay: heavy delay (staccato)
  * Noise: white noise + filter
  * Time Gater: ON/OFF BPM-sync + filter
  * Flanger: 4-beat flanger + filter
  * Barber Pole: soft Shepard Tone
  * Crush: bit crush (no pitch increase) + filter
  * Filter: Filter + Light resonance

* TP2.6 MACROFX:
  * https://techtools.zendesk.com/hc/en-us/articles/202165534-NEW-MACRO-FX
  * https://crossfadr.com/2012/11/21/overhauling-the-traktor-native-instruments-new-traktor-pro-2-6-release/
  * Wormhole = heavy filter + heavy flanger + delay (Buildup//breakdown)
  * PolarWind = heavy flanger (coloring) + light filter + reverb (Mixing/punch in)
  * FlightTest = heavy echo + resonant filter (Punch In)
  * LaserSlicer = heavy beatmasher + flanger (Punch in/buildup/breakdown)
  * DarkMatter = heavy crush + delay + compression (for Mixing)
  * Zzzurp = related to Ringmodulator (masher + flanger + crush + reverb) (Punch in/breakdown)
  * EventHorizon = heavy filter + echo (Breakdown/punch in)
  * Bass-o-Matic = heavy triplets slicer (Punch in/breakdown)
  * Strrretch (Slow) = loop sampler (Buildup/breakdown)
  * Strrretch (Fast) = loop sampler (Buildup/breakdown)
  * GranuPhase = delay to 2nd and 4th beat (Punch in/buildup/breakdown)

* Normal effects:
  * https://www.digitaldjtips.com/reviews/native-instruments-traktor-kontrol-z2/
  * Transpose Stretch = Dubstep-style
  * Ringmodulator = Josh Wink “tweak”
  * Tape Delay = “chillwave”

To test these effects, loop a simple beat and characterize what you hear based on basic FX concepts.
To test delay/echo/reverb presence, stop the track to hear the FX tail.
  
[original thread](https://www.native-instruments.com/forum/threads/describing-the-basic-effects-that-constitute-mixerfx-and-macrofx.375351/ )

## Describing the basic effects that constitute Pioneer SoundColorFX

SoundColorFX are similar FX chains with specific defaults and behavior.
This post describes their basic elements as well.
 

* DJM-900NX2 ColourFX:
  * https://docs.pioneerdj.com/Manuals/DJM_900NXS2_DRI1300A_manual/#/
  * Space = reverb
  * dub echo = echo
  * sweep = gate (left) / filter (right)
  * noise = white noise + filter
  * crush = reduce bit resolution + filter
  * filter = filter + resonance
  * jet = flanger
  * pitch = tone change
  * gate comp = gate (left) / compressor (right)

* DJM-900NX2 Beat FX:
  * https://docs.pioneerdj.com/Manuals/DJM_900NXS2_DRI1300A_manual/#/
  * Delay = delay
  * multi tap delay = delay
  * Echo = echo
  * low cut echo = echo
  * Ping Pong = delay
  * Reverb = reverb
  * Spiral = reverb + pitch
  * Trans(form) = Gate
  * Filter = Filter
  * Flanger = Flanger
  * Phaser = Flanger
  * Pitch = Pitch
  * Roll = loop sampler (once)
  * Slip Roll = Loop Sampler (can be restarted)
  * Rev Rol = Loop sampler reversed
  * Helix = Loop Sampler
  * melodic = Sampler
  * Vinyl Brake = Constant tempo down
  * robot = vocoder (?)
  * enigma jet = Shepard Tone + flanger
  * Mobius saw = Shepard Tone
  * Mobius triangle = Shepard Tone

* RMX-1000:
  * https://djtechtools.com/2016/08/02/rekordbox-4-2-1-rmx-effects-vinyl-recording/
  * https://djtechtools.com/2012/05/06/pioneer-rmx-1000-effects-unit-review/
  * BPF Echo – Adds the sound that has passed through the band pass filter to the original sound and adds echo.
  * Noise – Adds white noise generated internally to the sound.
  * Spiral Up – Raises pitch of the sound while changing echo reverberation time.
  * Reverb Up – Adds a reverberation effect to the sound and raises the pitch of the echo as time passes.

* RMX-1000 - Effects for inserting breaks into tracks:
  * HPF Echo – Passes the sound through the high pass filter and adds echo.
  * LPF Echo – Passes the sound through the low pass filter and adds echo.
  * Crush Echo – Creates a sound as if the sound were crushed and adds echo.
  * Spiral Down – Lowers the pitch of the sound while changing echo reverberation time.
  * Reverb Down – Adds a reverberation effect to the sound and lowers the pitch of the echo as time passes.”

  
## Describing the basic effects that constitute VirtualDJ SoundColorFX
  
  
VirtualDJ has similar FX chains, with specific defaults and behavior.
This post describes their basic elements as well.
 
* VirtualDJ SoundColorFX:
  * https://www.virtualdj.com/manuals/virtualdj/interface/mixer/audio/index.html
  * https://www.virtualdj.com/manuals/virtualdj/appendix/nativeeffects.html
  * Cut
  * Distortion
  * Echo
  * Flanger
  * Filter (default)
  * Noise
  * Loop Roll
  * Pitch
  * Reverb
  * Spiral

  
# Traktor Elastic Beatgrids  

This section covers Elastic beatgrids in Traktor
* [Which tracks have multiple BPMs](#Which-tracks-have-multiple-BPMs)
* [What are Elastic Beatgrids](#What-are-Elastic-Beatgrids)
* [Softwares with Elastic Beatgrids](#Which-softwares-support-Elastic-Beatgrids)
* [Traktor emulated Elastic Beatgrids](#How-to-emulate-elastic-beatgrids-in-Traktor)
* [Traktor emulated Elastic Beatgrids (more accurate)](#How-to-emulate-Elastic-Beatgrids-in-Traktor---More-complex-workflow)
* [Which tracks benefit from emulated Elastic beatgrids](#Which-tracks-benefit-from-emulated-Elastic-beatgrids)



## Which tracks have multiple BPMs

Two types of tracks have multiple BPMs:
* **Unsteady BPMs:** 
  * Definition: these tracks floats around a single BPM (+-1% range). Examples:
  * Live drummers: [Guns N' Roses - Sweet Child O' Mine](https://www.youtube.com/watch?v=1w7OgIMMRc4)
  * Old disco / 80s Pop tracks: [Matia Bazar - Ti Sento](https://www.youtube.com/watch?v=uk7bR54G2BA)
* **Transition Tracks:**
  * Definition: these tracks have clear BPM changes (+-10% range). Examples:
  * Abrupt 85->115 bpm: [Magic Drum Orchestra - Drop it like its Hot](https://youtu.be/W-nrHptw4Ow) 
  * Smooth 126->98 bpm: [Planet Soul - Set me Free](https://www.youtube.com/watch?v=v5HEfbxk7Mw)

more lists:
[list1](https://www.reddit.com/r/DJs/comments/2hmtgc/do_you_know_of_any_house_songs_that_increase_in/)
[list2](https://www.reddit.com/r/DJs/comments/ybt30/transition_tracks/)


## What are Elastic Beatgrids

"Elastic beatgrids" is a feature that explicitly allows **multiple BPMs** in each track.

Without elastic beatgrids, the following becomes impossible to perform without the audience noticing:
* **Beatjumps:** 
  * Impossible to fix in advance because the jump happens instantaneously
* **FX BPM-synced effects:** (eg delay)
  * Impossible to fix in any situation, because FX fully depend on the beatgrid
* **AutoLoops:**
  * IN point: with quantize off, you have to enable the loop at precisely the right time
  * OUT point: In this case you have to immediately enter "loop out adjust mode" to fix the out point as fast as you can    
* **Sync beatmatch:**
  * In this case you HAVE to compensate continuously using the jogwheels on the whole eg. 60s transition (manual beatmatch)


## Which softwares support Elastic Beatgrids

Traktor misses elastic beatgrids. This was the #1 request from the [Digital DJ Tips interview](https://www.youtube.com/watch?v=iFcnImYgsII&feature=youtu.be&t=199) as well.

| Software | Elastic Beatgrids | Multiple Beatmarkers | Video |
|-----------|-------------------|------------------------------|----------------------------------------------------------------------------------------|
| **RekordBox** | yes | yes (see note1) | https://youtu.be/aTHFpwSMsZI?t=499 |
| **Serato** | yes | yes | https://youtu.be/wLt5fhZJGps&t=420 |
| **VirtualDJ** | yes | yes | https://youtu.be/PrKBerB2n3I?t=49 |
| **Traktor** | no | yes | [main discussion thread](https://www.native-instruments.com/forum/threads/how-to-fix-tracks-with-unsteady-bpms-using-just-traktor-pro.114480/) |
| **Denon Prime** | no | no (see note2) | https://www.youtube.com/watch?v=bqhDRX6ghfM&t=598 |


**Note1:** Manually beatgriding tracks in rekordbox is tricky because its a strictly left-to-right operation.\
In other words: there is no way to put beatmarkers in front of the track without deleting them at the middle/end as well. 
[more info](https://forums.pioneerdj.com/hc/en-us/community/posts/115010528306)\
**Note2:** Denon Prime [wraps tracks](https://www.youtube.com/watch?v=bqhDRX6ghfM&t=598) and has problems with ID3tag [whole BPM numbers](https://www.reddit.com/r/DenonPrime/comments/cfxqr2/prime_4s_trusted_bpm_aka_why_using_the_bpm_tag_is/). 



## How to emulate Elastic Beatgrids in Traktor


Below a recipe to **approximate** Elastic beatgrids in Traktor, automatically using Rekordbox conversion.\
The simplest method is presented first, then a more accurate/faster method is presented second.

**Important:** this is only applicable for unsteady tracks 
([more info](#Which-tracks-benefit-from-emulated-Elastic-beatgrids)). 

**Simple method:** 
1. Download the free V5 rekordbox: [link](https://rekordbox.com/en/download5/)
1. Select the tracks with single, but unsteady, BPMs: [guide](https://rekord.cloud/blog/should-you-analyze-your-tracks-with-dynamic-bpm-in-rekordbox) 
1. Analyse these tracks in dynamic mode: [guide](https://rekord.cloud/blog/should-you-analyze-your-tracks-with-dynamic-bpm-in-rekordbox)
1. Export your collection.xml: [guide](https://rekord.cloud/wiki/library-import)
1. Convert your this file from Rekordbox format to Traktor format: [guide](#which-dj-converters-avoid-the-26ms-shift-issue)
1. Import your files into Traktor: [guide](https://rekord.cloud/wiki/library-export) 

![traktor_elastic_beatgrids2](pics/traktor_elastic_beatgrids2.jpg?raw=true)

 
## How to emulate Elastic Beatgrids in Traktor - More complex workflow

This is a revised version of the [basic workflow(#How-to-emulate-Elastic-Beatgrids-in-Traktor). 

Benefits are more accuracy of the end result because it adds additional beatmarkers every 4 beats, 
it avoids the [26ms mp3 shift issue](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares)
and its a lot faster by limiting the tracks and by directly patching the cues in the collection (instead of regular importing the files).


**Concrete differences:**
1. Download specifically v5.6.0 rekordbox. 
  * This was the last without an XML import bug: [guide](https://www.youtube.com/watch?v=JV89dj1hDWM)
1. Manually remove the non-dynamic tracks from the XML.
  * There is no way to export specific playlists/tracks, you always get the whole collection
  * so by manually removing the tracks the later stages will be a lot faster  
1. Use [rekordbox_add_beatmarkers.py](tools_traktor/rekordbox_add_beatmarkers.py) 
  * This will force a beatmarker every 4 beats. 
  * These beatmarkers are very accurate because it still uses the dynamic BPM **before** conversion. 
1. Use a converter that specifically addresses the 26-ms shift issue: [guide](#which-dj-converters-avoid-the-26ms-shift-issue)
1. Patch your files into Traktor using [Traktor_clone_cues.py](#what-software-tools-did-you-built-for-Traktor)

![traktor_elastic_beatgrids3](pics/traktor_elastic_beatgrids3.jpg?raw=true)
 
[Traktor forum post](https://www.native-instruments.com/forum/threads/how-to-emulate-elastic-beatgrids-in-traktor-via-rekordbox-conversion.375229/)

## Which tracks benefit from emulated Elastic beatgrids?

**Unsteady tracks: YES**
* **Examples:** 80s Pop, 70s DiscoSound, Live drummers (any decade)
* **Typical range:** +- 1% bpm error
* **Error:** Very small; the error is reset every 4th beat will always reset it

**Transition tracks: NO**
* **Examples:**
  * [Magic Drum Orchestra - Drop it like its Hot](https://youtu.be/W-nrHptw4Ow) 85->115 bpm, Abrupt change
  * [Planet Soul - Set me Free](https://www.youtube.com/watch?v=v5HEfbxk7Mw) 126->98 bpm, Smooth change
* **Typical range:** +- 15% bpm  (change from 3/4 to 4/4 signature)
* **Error:** Too much; the 3rd beat will have an half beat error (see picture)
  * Note: setting beatmarkers every 1 beat breaks Traktor sync dynamics
  
![traktor_elastic_beatgrids1](pics/traktor_elastic_beatgrids1.jpg?raw=true)



# Traktor Slow preferences Window
  
This section is all about the slow preferences window.\
I've been able to reduce this from 18 seconds to only 3 seconds.
 
* [Issue explanation](#Why-MIDI-mappings-makes-the-preferences-window-slow)
* [Measurements](#How-slow-does-the-preferences-window-get)
* [Naive solution](#Could-we-just-move-all-entries-to-a-single-page)
* [Swapping configurations](#How-to-swap-Traktor-configurations-without-the-slow-preferences-window)

  
## Why MIDI mappings makes the preferences window slow

Traktor has thousands of useless ["MidiDefinition structures"](https://github.com/ivanz/TraktorMappingFileFormat/blob/df5f544d10e3293b72b829841e654da0db71c4b0/Tools/TSI%20Mapping%20Template.bt#L130) 
for every possible midi combination that **COULD** be used.\
This set is much much larger than the entries that are **actually used**.

Worse, these entries are replicated in every single "empty page".

In practice this makes [the preferences window very slow](https://www.native-instruments.com/forum/threads/preferences-window-freeze.328315/). 
For example [Pioneer DDJ-SZ mapping take 18 seconds to load](#How-slow-does-the-preferences-window-get).
A second sign is that it makes the TSI file much larger.

The [CMDR editor](https://github.com/cmdr-editor/cmdr#2020-improvements) removes this overhead 
(see [line 337 of this file](https://github.com/cmdr-editor/cmdr/blob/master/cmdr/cmdr.TsiLib/Device.cs#L337)).\
However Traktor still recreates these entries **per page** anyway.


## How slow does the preferences window get?

Having many midi pages makes the [preferences window slow](#Why-MIDI-mappings-makes-the-preferences-window-slow).

The biggest offender is the Pioneer mappings for the SX2 and SZ controllers. 
They have 14 pages, so it takes >18 seconds for it to load in my laptop.

My mappings are have more functions, but only take ~5 seconds to load because I only use 5 pages.

On my next version I managed to go to 3 pages, for a ~3 second delay.


|            | Version     | Pages | Delay (s) | | Entries (K) | Size (Mb) | Optimized (Mb) |
|------------|-------------|-------|-----------|-----|---------|-----------|----------------------|
| Pionner    | v1.0.0      | 14    | 18.4         |  | 9.3    | 10.9     | 2.7                 |
| DJ Estrela | v6.7.0      | 5     | 5.2          |  | 9.7    | 5.7      | 2.8                 |
| DJ Estrela | v6.8.0 beta | 3     | 3.2          |  | 10.0   | 4.4      | 2.7                 |

[Table Source](pics/traktor_slow_preferences_-_measurements.xlsx)


## Could we just move all entries to a single page?

No. Any complex behavior needs state variables, and each page only has 8 variables per page.

When you run out of variables the simplest action is to add a new page. 

My mappings are [much faster than the Pioneer ones](#How-slow-does-the-preferences-window-get) 
because I specifically shared variables, and I [moved functionality to BOME](#Why-I-moved-to-BOME-midi-mapping-Traktor-limits).

## How to swap Traktor configurations without the slow preferences window

[This script](tools_traktor/traktor_swap_configuration.sh) lets you swap between two traktor configurations easily. 

This is useful when you sometimes use a controller as your audio device, but other times use your internal sound card. 
This saves you to having to open the preferences window to change the audio device, 
which is [very slow when you have large mappings](https://www.native-instruments.com/forum/threads/preferences-window-freeze.328315/page-2#post-1870879).

**Script installation:**
* save [this script](https://raw.githubusercontent.com/pestrela/music_scripts/master/traktor/tools_traktor/traktor_swap_configuration.sh) in your desktop with "right-click"/"save-as"
* make the script executable with 'chmod +x traktor_swap_configuration.sh '
* redefine the 'traktor_root_folder' variable to your documents traktor root
* *run it once* to copy the first config

**First time setup:**
* Open Traktor
* change the config to DDJ-1000
* close traktor
* *run script*
* open traktor
* change config to internal soundcard
* close traktor

**To Activate configuration #1:**
* *run the script*
* open traktor
* confirm the audio card is ddj-1000
* Close taktor

**To Activate configuration #2:**
* *run the script*
* open traktor
* confirm the audio card is Internal Soundcard
* Close taktor

  
  
  
  
# BOME mappings migration

Traktor has advanced MIDI mapping ([link](https://bit.ly/2NrlVzy)), which is important to extend its longevitity.

However every year Controllers get more complex, so doing mappings today ranges between hard to impossible ([link](https://bit.ly/2NrlVzy)).

Some other anedotic evidence on this are the [preferences freeze](https://www.native-instruments.com/forum/threads/preferences-window-freeze.328315/page-2#post-1870879), the turntable play/pause looper, the DDJ-1000SRT missing jog screens, 
and the HC-4500 mapping to get track details.

**Specific Blog posts:**
* [a) Impossible mapping features](#Why-I-moved-to-BOME-midi-mapping-Impossible-features)
* [b) Possible, but with major limits](#Why-I-moved-to-BOME-midi-mapping-Traktor-limits)
* [c) BOME limits](#Some-Limitations-of-BOME-mappings)
* [d) Future of Traktor mappings](#How-I-see-the-future-of-Traktor-mappings)

Because of this all my latest mappings require [BOME](https://www.bome.com/products/miditranslator).\
(The older versions do not require BOME and are simpler to install).


![bome_versions](pics/bome_versions.jpg?raw=true)

  
## Why I moved to BOME midi mapping: Impossible features

* **#1: 14-bit out messages**: Trakor supports *receiving* high resolution midi messages. I need to *send* them as well [on my DDJ-1000 mapping](../ddj/1%20MIDI%20codes/DDJ-1000RB%20-%20MIDI%20Messages.pdf)
* **#2: Sequence of Events**: For PadFX, I *first* need to change the FX, and *then* need to turn it on. This is not something Traktor support; both actions are tried simultaneously resulting in something else. More info: page 88 of the [Rudi Elephant mapping](pics/RUDI-Js%20ELEPHANT%20TSI%20for%20VCI-400SE%20%2B%20Maschine%20(MK1)%20%2B%20BCR%202000%20v2.0.pdf).
* **#3: Timers**: Something simple as end-of-track blinking require timers to schedule actions for later. Same story for [vinyl break on the play/pause button](https://www.youtube.com/watch?v=EPnmyDiaJTE), as implemented by [Traktor Mapping Service](http://traktormappingservice.com/)
* **#4: Any event as a Conditional**: Some events can be inputs to conditionals, like "is in active loop". However many events are missing, for example "which deck is master." To implement this, please see page 87 of the [Rudi Elephant mapping](pics/RUDI-Js%20ELEPHANT%20TSI%20for%20VCI-400SE%20%2B%20Maschine%20(MK1)%20%2B%20BCR%202000%20v2.0.pdf).


## Why I moved to BOME midi mapping: Traktor Limits

Also, I've also hit the limits of Traktor mappings multiple times. Below are the features that are possible in Traktor but only by significantly increasing the mapping complexity.

* **a) more modifiers**: I use a lot more than [8 modifiers](https://www.native-instruments.com/forum/threads/controllerism-more-modifiers-more-bits-more-conditions.329045/). I use a lot more than 3 bits per modifier state. To go around this I add a lot of complexity to my mappings. This in turn [freezes your preferences](https://www.native-instruments.com/forum/threads/preferences-window-freeze.328315/page-2#post-1870879) window - please see below.
* **b) preferences window freeze:** To add more variables, you need to add extra mapping pages. Having more than 6 pages [freeze your preferences window](https://www.native-instruments.com/forum/threads/preferences-window-freeze.328315/page-2#post-1870879) **even if they are completely empty**.
* **c) more conditionals**: I use a lot more than [2 conditions in my mappings](https://www.native-instruments.com/forum/threads/add-3rd-slot-for-modifier-conditions-in-controller-manager.325569/#post-1622169). To go around this I [squeezed multipe states into each modifier](https://www.traktorbible.com/en/squeezing-modifiers.aspx). Again, this added a lot of complexity to my mappings.
* **d) global modifiers:** I miss [global modifiers](https://www.native-instruments.com/forum/threads/named-variables-operators.326339/#post-1628411), to link the state in multiple pages. More info: page 87 of the [Rudi Elephant mapping](pics/RUDI-Js%20ELEPHANT%20TSI%20for%20VCI-400SE%20%2B%20Maschine%20(MK1)%20%2B%20BCR%202000%20v2.0.pdf).


## Some Limitations of BOME mappings

[BOME](https://www.bome.com/products/miditranslator) is essential to [build my new mappings](#Why-I-moved-to-BOME-midi-mapping-Impossible-features). But it also have some improvement points.

In importance order:

* **A) Arrays**: [forum request](https://www.bome.com/support/kb/mt-pro-script-arrays). See also Bug#3 from the FAQ file.
* **B) Cascaded devices**: [forum request](https://www.bome.com/support/kb/cascaded-presets-loopback-devices)
* **C) More variables**: this is a lot more than Traktor, but still not enough as I'm emulating arrays


## How I see the future of Traktor mappings

A major Traktor strength is the MIDI mappings system. They are over and over praised to be very flexible and powerful.\
Traktor maps are by far the most popular in https://maps.djtechtools.com \
Large mappings are really complex to build - but once this is done other users immediately benefit by just installing them.

However the Traktor mappings system didn't get improvements for years, and [is is now quite old](#Why-I-moved-to-BOME-midi-mapping-Traktor-limits).\
It now is also impossible to use it alone [to map the latest controllers](#Why-I-moved-to-BOME-midi-mapping-Impossible-features).

For example in my DDJ-1000 mapping I had to use BOME midi translator as a middle man:\
https://maps.djtechtools.com/mappings/9279

A second issue is that the most popular Traktor-ready controllers from NI did not got MIDI mapping capabilities at launch, and took quite a while to do so. 
In the case of the S5, this is still not possible (time of writing: May 2020)

In my view the mappings are a unique success story of Traktor. If improved, they could continue to give great results with just some minor quality-of-life changes.


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


## DDJ-1000 comparison to DDJ-SZ and AKAI AMX

Besides [my DDJ-1000](#why-is-ddj-1000-my-hardware-of-choice), I have several other controllers fully [mapped to Traktor](#Free-mappings). 

Main differences are:

**DDJ-1000:**
* **Jogs:** CDJ big Jogwheels 
* **Screens:** Jog screens
* **Size**: More portable than SZ, but more cramped as well
* **BeatFX:** BeatFX in the lower right corner to the mixer

**DDJ-SZ:**
* **Size:** Very spacious. A joy to use!
* **Jogs:** Extra-smooth big Jogwheels
* **Filter:** Pioneer soundcolor FXs in hardware, including the Pioneer filter with a lot of Resonance

**AKAI AMX:**
* **Ultra portable:** The AMX replaces 4x devices: Z1 Mixer + X1 controller + Twister Fighter + Audio2. 
Its so small I carry it everywhere I go. 
* **DVS:** The AMX is the cheapest and smallest way to unlock DVS 
* **Mapping:** My mapping unlocks all TP3 functions

See also [this DDJ-SZ comparison](https://www.reddit.com/r/Beatmatch/comments/c6vquf/help_me_ddj_sz_vs_ddj_1000/)
See also this general [comparison to CDJs](https://djtechtools.com/2017/07/23/ddj-cdjs-practicing-cdjs-pioneer-dj-controller/)



## Why I like BIG jogwheels

Spoiler: its not scratching!

I use jogs all the time in a controller - full list below. 
As I have big hands, I love them to be as BIG as possible.

There are the usages sorted by frequency:
* **#1: Tempo**: Adjusting tempo drift for older tracks (because of no elastic beatgrid)
* **#2: Cueing**: / fast preview to the exact spot where the track will start
* **#3: JogFX chains**: I do effects on the jog - see 6:32 of https://www.youtube.com/watch?v=h9tQZEHr8hk&t=392s
* **#4: Beagrids**: by far the quickest way to adjust beatgrids on the fly
* **#5: Scratch**: Very occasional live scratching / tricks  (see also [this post](#but-can-i-still-scratch-using-midi-how-much-is-the-latency-of-your-maps))

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



# Free Mappings

This section covers my free mappings on the DJTT site.\
Below the direct links, and after this the description of each mapping.

* **Main Traktor mappings**
  * **DDJ-1000 with jog screens:** https://maps.djtechtools.com/mappings/9279
  * **DDJ-SZ / DDJ-SX2 / DDJ-SRT:** https://maps.djtechtools.com/mappings/9222
  * **AKAI AMX:** https://maps.djtechtools.com/mappings/9323
    
* **Other mappings**
  * **XDJ-XZ:** https://maps.djtechtools.com/mappings/10305
  * **Numark PartyMix:** https://maps.djtechtools.com/mappings/9764
  * **CDJ2000NX2:** https://maps.djtechtools.com/mappings/9763
    
* **Keyboard mappings**
  * **Beatgrid helper:** https://maps.djtechtools.com/mappings/9760
  * **Transitions-Aligned Beatjumps:** https://maps.djtechtools.com/mappings/9762
    
* **Advanced tricks demos**
  * **Preview Player:** https://maps.djtechtools.com/mappings/10915
  * **Backwards loop and Reloop:** https://maps.djtechtools.com/mappings/10252
  * **BOME access all 9x mixerFX:** https://maps.djtechtools.com/mappings/10575
  

## How to DOWNLOAD my Traktor mappings:

TO DOWNLOAD: you can ONLY download my mappings from the DJ tech tools site (http://maps.djtechtools.com).\
To do this you MUST register and then verify your email there.

Note: sometimes that site is under maintenance. Please try later in this case.

## How to INSTALL my Traktor mappings:

TO INSTALL: Please see this video where I show how to install the mappings: https://youtu.be/MbGP_ECnWiQ\
See also this PDF file for step-by-step instructions: [installation guide](https://github.com/pestrela/music/blob/master/traktor/mapping_ddj_1000/Installation%20Help/DDJ%20Mappings%20-%20Installation%20Guide.pdf)\
See also the common questions: [FAQ](https://github.com/pestrela/music/blob/master/traktor/mapping_ddj_1000/Installation%20Help/DDJ%20Mappings%20-%20Frequently%20Asked%20Questions.pdf)

Some notes:
* **#1:** My guides covers all DDJ controllers. The only difference is the Aliases (page 10) and Output (page 28). The Annexes have specific pictures for specific DDJs.
* **#2:** This mapping requires the third-party BOME midi translator. It has a free trial for you to test this mapping before buying a license.
* **#3:** Issues? See the FAQ in a pdf, the “gotchas” on page 34, and reconfirm if you missed a step of this guide.


## What are the features of your DDJ-1000 Traktor mapping?

**Links:**
* Download Link: https://maps.djtechtools.com/mappings/9279
* Documentation: https://github.com/pestrela/music/blob/master/traktor/mapping_ddj_1000/
*	Video demo: https://youtu.be/h9tQZEHr8hk

**Feature list: Unique features**
*	Only mapping in the world with Jog Screens
*	7x Jogwheel FX chains
* Loop backward adjust
* All Leds blink as warnings
* Can be used with 2x laptops
* Much lighter ([3 seconds instead of 18 to load](#How-slow-does-the-preferences-window-get))

**Feature list: other features**
* Echo out (release FX)
*	5x MixerFX
*	11x MacroFX
*	21x padFX (“instant gratification”)
*	3x tone play modes (“keyboard mode”)
*	8x Rolls
*	Slicer
*	Dedicated preview player
*	Loops manual adjust (via jogs)
*	Beatjump and Loops pages
* Elastic beatgrid sync helpers
*	All functions reachable without shifts


**Summary:**
* This is the *only mapping* for the DDJ-1000 supporting Jog Screens. It works on both Traktor 3 and 2. It requires the 3rd-party BOME Pro MIDI translator. Free trial versions are available to test everything. 
*	It is also the most complete by far. It supports MixerFX, MacroFX, JogFX chains, padFX, Keyboard mode, Rolls, and a Preview Player. Latest features are CDJ-emulation, Loops adjust and Beatjump shortcuts.


![ddj_1000](mapping_ddj_1000/DDJ-1000%20-%20Single%20slide.jpg?raw=true)


## What are the features of your DDJ-SX2 / DDJ-SZ / DDJ-SRT Traktor mapping?

**Links:**
*	Download Link: https://maps.djtechtools.com/mappings/9222 
*	Documentation: https://github.com/pestrela/music/tree/master/traktor/mapping_ddj_sx2_sz_srt 
*	Video demo: http://youtu.be/H_TE2mtuM6Q 

**Feature list:**
* Much faster to load ([3 seconds instead of 18](#How-slow-does-the-preferences-window-get))
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

**Summary:**
*	This a 2019 mapping for the Pioneer DDJ family of controllers. It works on both Traktor 3 and 2. The mapping was **tested extensively** in both the **DDJ-SX2** and **DDJ-SZ**. Other DDJs are supported as well (please see below).
*	It is also the most complete by far. It supports TP3 MixerFX, MacroFX, JogFX chains, padFX, Keyboard mode, Rolls, Slip reverse, and a Preview Player. Be sure to see the documentation for all the features.

![ddj_sx2_sz](mapping_ddj_sx2_sz_srt/DDJ-SX2_SZ_SRT%20-%20single%20slide.jpg?raw=true)

## What are the features of your AKAI AMX Traktor mapping?

**Links:**
*	Download Link: https://maps.djtechtools.com/mappings/9323 
*	Documentation: https://github.com/pestrela/music/tree/master/traktor/mapping_akai_amx
*	Video demo: https://www.youtube.com/watch?v=TzAgENM55DE 

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


**Summary:**
*	This is a 2019 mapping for the Akai AMX. This is by far the cheapest and smallest way to unlock both DVS and almost all Traktor Pro 3 functions. In a single device you have the equivalent of a Z1+X1+TwisterFighter, at least.
*	It is also the most complete by far. It supports 10x layers, 4 decks, full transport and tempo control, TP3 MixerFX, MacroFX, Cues, Loops, beatjump,  Rolls, Slip reverse, Sampler, Key adjust, and a Preview Player. 

![mapping_akai_amx](mapping_akai_amx/AMX%20TP3_TP2%20-%20Single%20slide.jpg?raw=true)


## What are the features of your XDJ-XZ Traktor mapping?

**Links:**
*	Download Link: https://maps.djtechtools.com/mappings/10305
* Documentation: https://github.com/pestrela/music/blob/master/traktor/mapping_xdj_xz/ 
*	Video demo: https://youtu.be/7EPfY9bGGlw 

**Feature List:**
* Much faster to load ([3 seconds instead of 18](#How-slow-does-the-preferences-window-get))
* Jog Screens (firmware only supports Needle and Cue marker)
* 7x Jogwheel FX chains
* 5x TP3 MixerFX
*	11x MacroFX
*	21x padFX (“instant gratification”)
*	4x Rolls modes
*	Reverse Flux
*	Beatjump controls

**Summary:**
*	This a 2020 mapping for the XDJ-XZ. It works on both Traktor 3 and 2. The mapping was based on my previous mapping for the DDJ-SZ/SRT.
*	It is also the most complete by far. It supports TP3 MixerFX, MacroFX, JogFX chains, padFX, Rolls, Slip reverse. Be sure to see the documentation for all the features.
*	Mapping now works both WITH and WITHOUT bome. Without BOME it will miss jog screens and MacroFX/MixerFX.


![mapping_xdj_xz](mapping_xdj_xz/XDJ-XZ%20mapping%20-%20Single%20slide.jpg?raw=true)

## What are the features of your Numark PartyMix mapping?

Links:
*	Download: https://maps.djtechtools.com/mappings/9764
*	Demo video: https://youtu.be/W6yuVs0ah2k 
*	Installation video (starts at 7:30):  https://youtu.be/W6yuVs0ah2k
*	Documentation: https://github.com/pestrela/music/tree/master/traktor/mapping_party_mix 

FEATURE LIST:
*	2x shift layers
*	Filter knob
*	10x colorFX
*	Loop adjust
*	Cue delete
*	7x FX and FX control
*	Censor
*	Zoom and Tempo range
*	4x Rolls
*	Jog Search

Summary:
*	This is a 2019 mapping for the numark PartyMix for VirtualDJ 2020. Major feature are 2x shifts layers that adds more functions than the available buttons, and a dedicated Filter knob.
*	Other features are 10x ColorFX, Cues delete, Loop adjust, 4x Loop roll mode, and 7x FX control. Also available is Zoom, jog search, Tempo range
 	 
![mapping_party_mix](mapping_party_mix/PartyMix%20Mapping%20-%20Single%20slide.jpg?raw=true)



## Which are your Keyboard mappings?

### A) Beatgrid helper

**Links:**
*	Download Link: https://maps.djtechtools.com/mappings/9760

**Summary:**
*	Use this mapping to beatgrid your music in Traktor faster
*	Features: quick seek,  quick zoom, next song, shortcut, lock, auto, etc
*	All keys have a “faster” version using the shift

![](pics/beatgrid_helper_-_slide.jpg?raw=true)


### B) Transitions-Aligned Beatjumps

**Links:**
*	https://maps.djtechtools.com/mappings/9762

**Summary:**
*	Use this mapping to prepare transitions-aligned beatjumps. This mapping lets you beatjump on both deck A and B simultaneously, so that you can put CUEs to align them
*	Row “one” of your keyboard beatjumps deck A; row “two” beatjumps deck B; row “three” beatjumps both decks simultaneously. Row “zero” controls the crossfader as well. 
*	EXAMPLE: please the transition around 52m of this mix.Song “A” is singing when “B” starts entering at 52m07s. For 30s, song “A” is singing normally. When “A” stops singing at 52m41s, “B” starts singing exactly at that time. This mapping helps a lot these fun transitions.


![](pics/transitions_aligned_beatJumps_-_slide.jpg?raw=true)


## What are demos of advanced mapping tricks

In order of complexity:


### 0) Browse List or Tree (like rekordbox or Serato)

todo: make a simple demo of moving trough the browser list/tree like stewe:
https://forum.djtechtools.com/showthread.php?t=88950&p=731238#post731238
https://forum.djtechtools.com/attachment.php?attachmentid=25832&d=1440801074


### A) Preview Player: 

**Links:**
* Download Link: https://maps.djtechtools.com/mappings/10915

** Summary:**
* Hold a button to start listening the preview player
* Without moving your hand, turn the encoder to seek inside the preview player
* Release button to stop listening
* Without moving your hand, turn the encoder to seek to select another track
  
  
![](pics/mappings/preview_player_demo.jpg?raw=true)

  

### B) Backwards loop and Reloop: 

**Links:**
* Download Link: https://maps.djtechtools.com/mappings/10252

** Summary:**
* Use this mapping to adjust the LoopIn point (regular loops adjust the LoopOUT point
* Use cases:
  * extend a track that literally just ended;
  * extend a beat just before a breakdown
  * repeat a build-up several times
* Reloop: use this feature to return to a previous loop (just like CDJs)
  
![](pics/mappings/loops_adjust_backwards_reloop.jpg?raw=true)
  
  
### C) BOME access all 9x mixerFX: 

**Links:**
* Download Link:
https://maps.djtechtools.com/mappings/10575

** Summary:**
* Use this mapping to acecess all 9x mixerFX by sending mouse clicks directly to the preferences window
* the normal midi mode you can only use 4x mixerFX

![](pics/mappings/bome_change_traktor_mixerfx.jpg?raw=true)
 

## What documentation comes with your mappings?

My zip files have **a lot** of documentation besides the TSI file.\
IMO it has no comparison to the typical mappings available on https://maps.djtechtools.com/ or https://www.traktorbible.com/freaks 

Included is:
* Quick reference (pictures only): [example](mapping_ddj_1000/DDJ-1000%20-%20Quick%20overview.pdf)
* User manual: [example](mapping_ddj_1000/DDJ-1000%20-%20Detailed%20manual.pdf)
* Installation manual: [example](mapping_ddj_1000/Installation%20Help/DDJ%20Mappings%20-%20Installation%20Guide.pdf)
* FAQ: [example](mapping_ddj_1000/Installation%20Help/DDJ%20Mappings%20-%20Frequently%20Asked%20Questions.pdf)

Plus:
* Technical info (to extend the mapping): [traktor_side](mapping_ddj_1000/Support%20files/Technical%20Info%20-%20Traktor%20side.txt) [bome_side](mapping_ddj_1000/Support%20files/Technical%20Info%20-%20BOME%20side.txt)
* Every single function: [example](mapping_ddj_1000/Support%20files/Source%20files/DDJ%20-%20Detailed%20reference.xlsx)

## Can I see a Demo video of your mappings?

Yes, please see the below Youtube videos. I have both long 30m videos where I cover every single function step-by-step, plus short "update" 5m video with the latest stuff only.

All videos are timestamp-tagged in Minute:second format, for you to find explanations of all specific. 


* DDJ-1000/800 playlist: https://www.youtube.com/playlist?list=PLIlvTGzSxI0XHlFyINdT6P42noqvkPISD
  * DDJ-1000 v6.3 - **main video** - http://youtu.be/EkSJ9Ug9Zuk
  * DDJ-1000 V6.5 - **jog screens** - https://youtu.be/h9tQZEHr8hk
  
* DDJ-SX2/SZ/SRT playlist: https://www.youtube.com/playlist?list=PLIlvTGzSxI0V3SUnYFYq4hpeu0o_XyP2l
  * DDJ-SX2/SZ/SRT v6.0 - **main video** - http://youtu.be/H_TE2mtuM6Q
  * DDJ-SX2/SZ/SRT v6.1 - **update** - http://youtu.be/sanF35CYeSg

* AKAI AMX playlist: https://www.youtube.com/playlist?list=PLIlvTGzSxI0Vi7aguzxbmOJdVQCW6CohR
  * AMX v1.0 - **main video** - http://youtu.be/TzAgENM55DE
   
  
## Can I test your mappings for FREE?

Yes. All my mappings work fine with the demo versions of both Traktor and BOME. So if you have these controllers you can just try them in no time. 

If you are considering buying equipment then I recommend that you test the mapping yourself in a shop showroom. I do this all the time before I buy anything (just mention this to the shop personnel).

Finally, all my mappings are a free gift to the community, to enable DJs to use their preferred Software with their preferred Hardware.
If you want further appreciation, PayPal donations are welcome (pedro.estrela@gmail.com)
  

## What are the differences between MIDI mode and HID mode?

There I've contributed a list of differences between MIDI mode and HID mode:

The DDJ-1000 can run in two different modes: MIDI or HID. 
The most obvious difference is the only HID has waveforms on teh jog screens.

However there are many other smaller differences, summarized [here](https://www.mixxx.org/wiki/doku.php/ddj-1000#differences_between_midi_mode_and_hid_mode).

Also, the MIDI mode has several bugs/limitations that I've reported to Pioneer support: 

| Ticket number | Controller |  Description |
| --- | -- | -- |
| 147606 | DDJ-1000 | Jog screen sync led gets stuck | 
| 147606 | DDJ-1000 | BeatFX does't respond to messages, and doesn't tell the current state | 
| 147606 | DDJ-1000 | Jog Ring brightness not customizable | 
| 147606 | DDJ-1000 | Impossible to know which deck you are (deck1 vs 3) |
| 203047 | DDJ-1000 | Faders ignore USB-selector | 
| 205732 | DDJ-1000 | Impossible to know beatFX parameter value  |

Very similar case for the DDJ-800 and XDJ-XZ:

| Ticket number | Controller |  Description |
| --- | -- | -- |
| 147606 | DDJ-1000SRT | Jog Screens not mappable because of a bussiness decision of the Serato company |
| 147606 | DDJ-800 | Jog Screens dead, eventough they are described in the MIDI table and are the same as DDJ-1000 |
| 159944 | XDJ-XZ | Shift doesn't send alternative messages |
| 159944 | XDJ-XZ | Jog screens only have needle and cue marker  |
| 159944 | XDJ-XZ | Jog turn/touch same mssage for vinyl=off |

 
[original list](https://www.mixxx.org/wiki/doku.php/ddj-1000#list_of_firmware_bugs_open_tickets)
 
  
## Is the DDJ-1000SRT also mappable to Traktor?

**Yes.** I've updated [my SZ/SX2 mapping](#what-are-the-features-of-your-ddj-sx2--ddj-sz--ddj-srt-traktor-mapping)
to work on the SRT. 
Please see the demo video here: https://www.youtube.com/watch?v=aU3QnOez56A&t=2s

Specific comments:
* **Jogs screens:** Jog Screens are NOT supported in MIDI. This is a business decision of the Serato company. 
  * If this affects you, please voice your opinion on this feature request thread: 
  * https://serato.com/forum/discussion/1736390
* **Pioneer Effects**: Mixer runs in external mode. This means that you have all pioneer effects for Traktor music. 
  * This is very different from the regular DDJ-1000, which runs in internal mode and only has Pionner beatFX in the master channel for Traktor sources.
* **Scratching:** Please put your jog weight to “heavy”.  This will significantly improve scratching and jogFX. Also please avoid VINYL OFF mode. The TSI disables jog touch in this case, but the jog loses resolution compared to VINYL ON mode;

## Is the DDJ-XP2 mappable to Traktor?

The XP2 is now really popular because its the cheapest way 
to unlock [Rekordbox V6 performance](#What-is-NOT-unlocked-in-the-Rekordbox-V6-hardware-options).
 
My [DDJ-1000 mapping](https://maps.djtechtools.com/mappings/9279) is compatible with the XP1/XP2.\
So it will work. But it was not made specific to it, so some features might be missing.

Strong recommendation is to use v6.3.3 of my DDJ-1000 mapping.\
This is because later versions require [BOME](https://www.bome.com/products/miditranslator), 
are more complex [to install](mapping_ddj_1000/Installation%20Help/DDJ%20Mappings%20-%20Installation%20Guide.pdf), 
and focus on non-XP2-relevant features like the jog screens.
  
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

## Read this if your Play button doesnt work

Are you using a custom mapping? Does some functions work but not the Play/Pause button?

This is a typical sign of a double installed mapping. Play works as a "toggle", so if its applied twice it cancels itself.

Solution:
* Delete all mapping pages in the controller manager
* install the desired mapping only once


# DJ Tutorials

This section has links to DJ tutorials and technical information.

* [List of Online DJ Courses](#List-of-Online-DJ-Courses)
* [List of Technical Webinars](#List-of-Technical-Webinars)
* [Midi mapping tutorials](#Midi-mapping-tutorials)
* [List of advanced MIDI mappings](#List-of-advanced-MIDI-mappings)


## List of Online DJ Courses
  
Below a list of DJ courses, all from well-known Tutors.\
This is appropriate and recommended when you want a structured syllabus that covers all bases.\
In particular DJTechtools is offering [interactive-only advanced sessions](https://us02web.zoom.us/webinar/register/WN_XyLog-v7QXm4LoBMxLfdCg).

Other than paid courses, these fine people contributed A LOT of FREE tutorials in youtube, their websites and forums.\
If you are dedicated enough, experimenting and trying these materials for yourself can get you as far as you want.

* **Phil Morse and team:**
  * https://www.digitaldjtips.com/dj-courses/
* **Ean Golden and team:**
  * Advanced Interactive: https://us02web.zoom.us/webinar/register/WN_XyLog-v7QXm4LoBMxLfdCg
  * Videos: https://store.djtechtools.com/collections/sound-packs-tutorials
* **Carlo Atendido:**
  * https://sellfy.com/djcarloatendido/
* **DJ TLM:**
  * https://djcoursesonline.com/dj-programs/
* **DJ Endo / DJ Shiftee:**
  * https://online.berklee.edu/courses/learn-to-dj-with-traktor
  * http://www.dubspot.com/programs/dj-extensive-program/?from=105#courses
* **Jamie Hartley:**
  * https://wearecrossfader.co.uk/online-dj-courses/
* **DJ DAVE:**
  * https://www.adsrsounds.com/product/courses/traktor-pro-3-masterclass/
* **Udemy:**
  * https://www.udemy.com/topic/dj/

## List of Introductory DJ Tutorials / Exercises

For now, see: https://www.mixxx.org/wiki/doku.php/beginner_dj_links
 
## List of beginner tips

https://www.digitaldjtips.com/2012/09/10-hidden-traktor-gems-for-better-djing/

* general [comparison of controllers to CDJs](https://djtechtools.com/2017/07/23/ddj-cdjs-practicing-cdjs-pioneer-dj-controller/)

(more to add)

  
## List of Technical Webinars

* **Jeroen Groenendijk**
  * **Files & Management:** https://www.youtube.com/watch?v=B8n9ma-egX4
  * **Add Files, Tagging & Preferences:** https://www.youtube.com/watch?v=BkpkGZNoNf8
* **Mix Master G:**
  * **Lots of useful technical videos here:** https://www.youtube.com/channel/UCMXHg5Oi8vlfKyEvsgrMRuQ/playlists

TODO: add more high-quality webinars.
  
## Midi mapping tutorials

* **Beginner:**
  * **Traktor very first keyboard map:** https://djtechtools.com/2015/02/26/intro-to-basic-midi-mapping-with-traktor/
  * **Traktor basic modifiers:** https://djtechtools.com/2014/05/11/midi-mapping-101-the-traktor-modifier-re-explained/
  * **Load and Sync**: https://ask.audio/articles/how-to-create-two-advanced-mappings-in-traktor-pro
* **Intermediate:**
  * **Traktor SuperCombos:** https://blog.native-instruments.com/how-to-map-instant-effects-in-traktor/
  * **Traktor Step sequencer:** https://djtechtools.com/2018/01/29/traktors-step-sequencer-map-midi-controller/ 
  * **Traktor Patten recorder:** https://djtechtools.com/2019/01/16/how-to-use-traktors-pattern-recorder-with-any-midi-controller/
* **Advanced**
  * **Traktor Global MIDI controls:** https://djtechtools.com/2015/09/08/traktor-global-midi-control-control-multiple-midi-devices-one-controller/
  * **Rekordbox BOME emulation of jogwheels:** https://djtechtools.com/2017/05/08/hack-rekordbox-use-controllers-jogwheels/
  * **Rekordbox RXM-1000:** https://djtechtools.com/2019/06/24/hacking-rekordbox-fx-and-adding-rmx-1000-control/
  * **Serato modifers and jogs:** https://djtechtools.com/2018/04/11/hacking-serato-djs-midi-mapping-jogwheels-touchstrips-and-modifiers/
 
 
TBD: https://ask.audio/articles/how-to-create-two-advanced-mappings-in-traktor-pro
  
## List of advanced MIDI mappings


Besides [my own mappings](#Free-Mappings), these are other advanced mappings that I've used before and recommend.
Studying these mappings is a great way to learn advanced MIDI mapping.  

* **Stewe:**
  * **Kontrol S4 MK3 Ninja:** https://maps.djtechtools.com/mappings/9325
* **Tekken:**
  * **S4 ultimate mapping:** https://maps.djtechtools.com/mappings/9277
  * **F1 ultimate mapping:** https://maps.djtechtools.com/mappings/652
* **DJ Tech Tools:**
  * **Twisted Gratification:** https://maps.djtechtools.com/mappings/5437
  * **DJTT Kontrol S4 MK2:** https://maps.djtechtools.com/mappings/2211

Another good indicator is the list of most downloaded mappings (click "Downloads" to sort:\
* https://maps.djtechtools.com/mappings?search%5Bsoftware_id%5D=29 )

Other lists of advanced mappings:
* https://blog.native-instruments.com/the-best-s4-hacks-of-all-time/
* https://blog.native-instruments.com/custom-mappings-to-extend-your-traktor-control/

  
  
  
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


| Case | Signature  | TK->RB Correction  |
| ------ | ----- | ---- |
| case A | No headers | 0 ms |
| case B | Only xing  | 26 ms |
| case C | Invalid lame crc | 26ms |
| case D | Valid lame crc| 0 ms |


## 26ms shift issue links
* 26ms research work: https://github.com/digital-dj-tools/dj-data-converter/issues/3
* Examples of corner cases: https://github.com/pestrela/music_scripts/tree/master/traktor/26ms_offsets/examples_tagged
* Analysis code: https://mybinder.org/v2/gh/pestrela/music_scripts/master

![26ms_problem](pics/26ms_problem.png?raw=true)

## 26ms shift algorithm

```
if mp3 does NOT have a Xing/INFO tag:
     case = 'A'
     correction = 0ms
 
 elif mp3 has Xing/INFO, but does NOT have a LAME tag:
     # typical case: has LAVC header instead
     case = 'B'
     correction = 26ms
 
 elif LAME tag has invalid CRC:
     # typical case: CRC= zero
     case = 'C'
     correction = 26ms
     
 elif LAME tag has valid CRC:
     case = 'D'
     correction = 0ms
```     
     

## Which DJ converters avoid the 26ms shift issue?

Historically, there was no way to convert your collection on Windows. The only converters available were for MacOS. This has now changed recently.\
All softwares take different approaches to solve the [26ms shift problem](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares).

This is the current situation as far as I tested it myself:
* **[DJ Data Converter](https://github.com/digital-dj-tools/dj-data-converter)**: This is a command line tool for Windows, WSL, and macOS. This is where the full research of the [26ms shift problem](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares) was done, and where it was first implemented. This is [another python converter](https://github.com/ErikMinekus/traktor-scripts/blob/master/playlist-export.py).
* **[Rekord Cloud](https://rekord.cloud/wiki/convert-library)**: This is a web application, so it supports all OSes. It also has many other useful features other than DJ conversion. The authors have [read the research](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares), implemented it for the 26ms case, and then extended it for virtualDJ with a 50ms value. As it is a web app, it created added an offline optional app just to scan shift mp3s.
* **[DJCU](https://www.facebook.com/DJConversionUtility/posts/568896026977298)**: This is a macOS-only application. Recently it got the hability to convert windows files, but still from macOS only. They have a manual tool to correct the shifts after conversion (REKU). More recently they correct shifts automatically using the encoder strings. This is something that I researched before and replaced with LAME/LAVC/LAVF tags instead.
* **[Rekordbuddy](https://next.audio/)**: This is also a macOS-only application. A Windows version is on the works for many years. This app corrects some shift cases correctly automaticlaly, but it misses others as well (when I tested it on a macOS VM).
* **[MIXXX](https://github.com/mixxxdj/mixxx/pull/2119#issuecomment-533952875)**: A new upcoming feature is reading Rekordbox-prepared USB sticks nativelly. This is of course affected by the 26ms problem. Like rekordcloud, the developers have [read the research](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares) and implemented it for their case (which depends on the several mp3 libraries they use).
* **[Choones](https://support.choones.app/guides)**: To be tested. Choones is an upcoming web application that does cloud-based conversion among many other features. At time of writing this is not publicly available. I've contated the team by email, and they told me they are aware of the 26ms shift issue.


# Free DJ Software Tools

This section groups the DJ software tools written by me, all freely available.
 
* [Traktor tools overview](#what-software-tools-did-you-built-for-Traktor)
* [CMDR TSI editor](#What-features-did-you-add-to-the-CMDR-TSI-editor)
* [CMDR on macOS](#How-can-I-run-CMDR-in-my-macOS)


* [Elastic beatgrids emulation](#How-to-emulate-elastic-beatgrids-in-Traktor)
* [Swapping Traktor settings](#How-to-swap-Traktor-configurations-without-the-slow-preferences-window)
* [Tracklist and CUE tools](#how-i-build-perfect-tracklists-using-cue-files)
* [Youtube, Google an Discogs shortcuts](#What-shortcuts-you-added-for-Youtube-Google-and-Discogs)
* [Github Markdown tools](#Github-Markdown-tools)
* [Programming libraries](#what-programming-libraries-and-technical-scripts-did-you-author)


## What software tools did you built for Traktor?

[This folder](tools_traktor) contains my Traktor tools and CUE tools.
Below is a summary; see [here](tools_traktor/README.md) for more details

See also the CMDR editor [changes](#What-features-did-you-add-to-the-CMDR-TSI-editor).

* **Traktor_clone_cues**
  * Clones cues between physically duplicated files. 
  * Is also able to merge traktor NML files.
* **rekordbox_add_beatmarkers**
  * adds a beatmarker every 4 beats. Part of the [elastic beatgrid emulation](#How-to-emulate-elastic-beatgrids-in-Traktor)
* **CUE_tools**
  * Tools to generate CUE files and timestamped tracklists
  * Tools to search a whole set in youtube tabs and to scrape lyrics
  * My mp3tag actions scripts
  * Adaptor scripts to run DJCU and Rekordbuddy in Windows
* **26ms offsets**
  * Research about the 26ms mp3 cue shifts in DJ conversion apps. [More info](https://github.com/digital-dj-tools/dj-data-converter/issues/3)
* **BOME tools:**
  * Easy wrapper around the [BOME analyser that documents 
  variables](https://www.bome.com/support/kb/cross-reference-list-of-all-variables-in-a-mt-pro-project), and a new script to find unused variables: 
  [download](https://github.com/pestrela/music/blob/master/traktor/tools_traktor/bome_analyse_project.sh)
  * Deck duplicator with [emulated arrays](https://www.bome.com/support/kb/array-emulation-using-4-sequential-variables-and-automatic-generation-of-rules): 
  [download]:(https://github.com/pestrela/music/blob/master/traktor/tools_traktor/bome_duplicate_deck.py) 
 
## What features did you add to the CMDR TSI editor?

The CMDR editor did not get new features for 2.5 years. In Jan 2020 I've revived this project.\
Download: https://github.com/cmdr-editor/cmdr/releases/latest/download/cmdr_tsi_editor_latest.zip
Documentation: https://github.com/cmdr-editor/cmdr#2020-improvements

**Highlights:**
* TP3 and S4-MK3 support
* Grid quick filter
* many new Shortcuts (channel change, modifier rotation
* FX list and encoder mode fixes; same sorting as controller manager

![CMDR ChangeLog](https://raw.githubusercontent.com/cmdr-editor/cmdr/master/docs/pics/cmdr_improvements1.png "eedd" )

## How can I run CMDR in my macOS?


There is three ways to edit your mappings in macOS.

### Simplest: Xtrememapping


The simplest answer is: buy a copy of [XtremmeMapping](https://www.xtrememapping.com/) for macOS.

### More complex: Azure Cloud

The more complex answer is: get a free trial of a windows virtual machine. 

This will run in the "azure" microsoft cloud, and requires giving your credit card to detail to microsoft 
(they say over and over that no automatic billing will ever happen after the trial period without you changing your )

installation:
* link1: https://microsoft.github.io/AzureTipsAndTricks/blog/tip246.html
* link2: https://www.techrepublic.com/article/build-your-own-vm-in-the-cloud-with-microsoft-azure/

Then connect to your cloud machine using RDP for mac:
https://www.techrepublic.com/article/pro-tip-remote-desktop-on-mac-what-you-need-to-know/

Then:
  * Install CMDR as explained here: [CMDR installation instructions](https://github.com/pestrela/cmdr#download-and-installation)
  * Copy your TSI into the virtual machine (simplest is to use eg google drive on the browser)
 
### Most complex: VirtualBox

The most complex answer is: get a personal virtual machine couples with an evaluation copy of any Windows OS.

Step by step instructions are on:
  * https://towardsdatascience.com/how-to-install-a-free-windows-virtual-machine-on-your-mac-bf7cbc05888e
  * Step 1: Download VirtualBox
  * Step 2: Grab Windows 10
  * Step 3: Install VirtualBox and the extension pack
  * Step 4: Get your OS up and running

Then:
  * Install CMDR as explained here: [CMDR installation instructions](https://github.com/pestrela/cmdr#download-and-installation)
  * Copy your TSI into the virtual machine (simplest is to use eg google drive on the browser)

  
[original blog post](https://github.com/cmdr-editor/cmdr/blob/master/docs/running_on_macos.md)
  
  
## How I build perfect tracklists using CUE files

I use a set of tools to generate a CUE file with the timings of my sets.
Once I have this file, I can generate tracklists with timestamps like in this example: https://www.mixcloud.com/dj_estrela/mix-17-cd07-trance-jun-2019/

Steps BEFORE the set (for prepared sets):
* group the files in folders, per style (Vocal Trance, Uplifting trance, etc)
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

* **cue_renumber_files.py:**
  * renumbers mp3 files, in sequence. This is useful to make a sequenced playlist in your operating system folders, outside Traktor.
* **cue_make_tracklist.sh:**
  * from a folder, generates basic tracklist text files
* **cue_convert_timestamps.sh:**
  * convert MMM:SS to HH:MM:SS format. Winamp uses the first format, Adobe audition uses the second 
* **cue_merge_cues.py:**
  * this is the main tool. It merge back and forth any CUE file with any tracklist text file. 
    It can read either case from separate or single files. It also cleans the artist - title fields, and generates timestamped tracklists 
* **cue_rename_cue.sh:**
  *  matches the CUE file contents with the FILE tag. This is useful when you rename the files externally.

  
## What Programming libraries and technical scripts did you author?

Please see my open-source github repos in https://github.com/pestrela?tab=repositories
See also my [windows shortcuts](#What-shortcuts-you-added-for-Youtube-Google-and-Discogs)

Summary:
* **Yapu:** Yet another python libary
  * this is a python3 library for helper wrappers, classes, etc
  * https://github.com/pestrela/yapu
* **Yabu:** Yet another bash library
  * this is a collection of hundreds of bash scripts that wrap common 
  * also includes a full set of bash libraries of functions
  * https://github.com/pestrela/yabu
* **cdd_bash:**
  * aliases to transfer the current directory between terminal windows
  * https://github.com/pestrela/cdd_bash
* **smi_counter:**
  * windows SMI counter. Useful for detect laptop DPC stalls
  * https://github.com/pestrela/smi_counter

  
  
## Open-Source useful information

Below some links useful to build open source projects

* **Choose a license:**
  * This sites compares licenses from more to less requirements.
  * https://choosealicense.com/licenses/  ([table](https://choosealicense.com/appendix/))
* **Semantic version:**
  * Explains how to versions work, namely backwards-compatible changes
  * https://semver.org/
* **Keep Changelog:**
  * Explains what to put on the git log message
  * https://keepachangelog.com/en/1.0.0/
  
  
## Github Markdown tools

* Better Cheatsheet: https://gist.github.com/jonschlinkert/5854601
* Tables Generator: https://www.tablesgenerator.com/markdown_tables

This is a small program to check relative links inside the same MD document: [md_check_relative_links.py](../wsl_tools).

  
## What shortcuts you added for Youtube, Google and Discogs?

[This folder](../downloads) contains Windows tweaks and other generic tools.

My [autohotkey file](../downloads/AutoHotkey.ahk) has all kinds of useful *glabal* shortcuts that *work for any text of any program*
* CTRL+F08: Search in Discogs
* CTRL+F09: Search in Explorer
* CTRL+F10: Current url to clipboard
* CTRL+F11: Search in Youtube (list)
* CTRL+F12: Search in Youtube (first hit)
* Win+backspace: toggle any window to be always on top for
* Win+Arrows: Arrange windows on the corners, 3 possible sizes. Also supports regular half-screen
* Win+Insert: **Append** a copy to the clipboard. Really useful to collect things around and paste once

More scripts in this folder:
* a youtube-dl wrapper
* a tool to search 1001tracklists, ticketswap and DJ TechTools maps.

  
# DJ Software optimization

This section covers DJ software optimization.

* [Optimization Quick fixes](#How-to-optimize-a-laptop-for-DJ-Software---Summary)
* [Optimization Complex case](#How-to-optimize-a-laptop-for-DJ-Software---Complex-case)
* [Audio Performance guides](#List-of-performance-guides-specific-to-audio)
* [DDJ-1000 and turbo boost](#how-to-avoid-crackle--glitches--noise-on-windows-by-disabling-intel-turbo-boost)
* [USB thin cables](#Read-this-if-you-have-erratic-USB-cable-problems)
* [SMI hidden interrupts](#How-to-count-SMI-hidden-interrupts-in-Windows)
* [Dell pre-installed services issues](#dell-laptop-pre-installed-services-latency-issues)
* [Deep trace analysis](#How-to-make-a-deep-trace-of-everything-that-runs-in-your-laptop)
* [Every possible optimization](#list-of-every-possible-performance-audio-optimization)
* [Traktor verbose log](#How-to-enable-Traktor-verbose-log)
* [Buying a laptop for Audio](#Buying-a-laptop-for-Audio)

## How to optimize a laptop for DJ Software - Summary
  
Every year laptops have more and more Power saving tricks.\
These tricks are *VERY* damaging for DJ software.\

For a demo of theses issues please see at 1:20 of https://www.youtube.com/watch?time_continue=85&v=ijFJZf_KSM8

Below some *quick fixes* to try first you have crackle / glitches / noise:

* a) *Continuous* crackle when playing:
  * Raise the driver buffer
* b) Crackle when when *moving the Jogs*:
  * Disable turbo boost ([steps](#how-to-avoid-crackle--glitches--noise-on-windows-by-disabling-intel-turbo-boost))
* c) *Random* crackle:
  * Disable wireless
  * Update the BIOS and all Drivers from your laptop manufacturer
  * Disable all power saving features (Turbo boost, Speedsteep, USB selective sleep, ...)
  
if not enough, then please read below  
  

## How to optimize a laptop for DJ Software - Complex case
  
If the quick fixes above were not enough then there is **no easy solution**. 

The way forward is complex:
* **Measure:** Measure the problems using [LatencyMon], [DPCLatency], [IDLT] and [SMI_reporter] to establish an objective baseline
* **Performance Guides:** Study performance guides that are specific to audio
* **Update log:** Study update logs to understand what changed when. This list can be quite big. 
* **Disable drivers:** disable the drivers one by one measuring in between 
* **Downgrade drivers:** as above, but downgrading components one by one while re-measuring 
* **Low-level Trace:** Generate a trace of the whole system using Windows Performance tools

Again: measurement is crucial to control every change to the system.
  
## How to avoid crackle / glitches / noise on Windows by disabling Intel turbo boost?

If you have an HP laptop and have crackle when move the jogs you have to disable Intel turbo boost.

There are 3 ways to disable turbo boost:
a) Specific program (best way): Use the "Quick CPU" software: https://www.coderbag.com/product/quickcpu
b) Set windows power to 99% CPU: [guide](https://forums.pioneerdj.com/hc/en-us/articles/360015455971-To-those-who-have-crackling-noise-when-using-DDJ-1000-with-rekordbox-dj)
c) BIOS config: https://support.serato.com/hc/en-us/articles/203057850-PC-Optimization-Guide-for-Windows

Macs have turbo boost, but are not affected. Anyway, the way to disable is [here](https://www.redmondpie.com/how-to-enable-or-disable-turbo-boost-on-mac/)

Official recommendation from Pioneer: https://forums.pioneerdj.com/hc/en-us/articles/360015455971-To-those-who-have-crackling-noise-when-using-DDJ-1000-with-rekordbox-dj


## List of every possible performance audio optimization

Things to try while measuring:
- **USB:** gauge USB cables; use usb 2.0 port;  
- **Windows Power options:** performance profile; change "turn X off after"; "turn off device"; wireless adaptor power saving; Fast Startup;
- **Windows Configs:** optimize to background processes; paging file; Spectre patches; Visual Effects; SuperFetch;
- **Battery:** windows best performance; plugged-in vs battery; Intel DPTF (power throttling); ACPI battery control;  
- **Device Manager:** "USB root hub" power management; 
- **Services:** TBD
- **Processes:** process affinity; process lasso; DEP
- **CPU:** Turbo boost; SpeedStep; SpeedShift; Core parking; Frequency scaling; UnderVolting; C states;
- **Sounds:** Realtk HD audio; Wavs Maxxaudio; disable onboard audio; No sounds profile; audio 3d enhancements;  
- **Wireless:** Wifi / Bluetooth; 
 
[maxxaudio-less driver](http://forum.notebookreview.com/threads/kevin-shroffs-modded-realtek-audio-drivers-for-dell-xps-15-9560-and-more.807060/)
 
Another list: [here](https://answers.microsoft.com/en-us/windows/forum/all/high-dpc-latency-from-acpisys-causing-audio-clicks/a7977dd5-6a52-4ee7-91bd-83180c21c1c2)

## List of performance guides specific to audio

* **Native Instruments:**
  * Guide: https://support.native-instruments.com/hc/en-us/articles/209571729-Windows-Tuning-Tips-for-Audio-Processing
  * Specific drivers to disable: https://support.native-instruments.com/hc/en-us/article_attachments/205621745/Driver_List_EN.pdf
* **Serato:**
  * Guide: https://support.serato.com/hc/en-us/articles/203057850-PC-Optimization-Guide-for-Windows
* **Ableton:**
  * https://help.ableton.com/hc/en-us/articles/209071469-Optimizing-Windows-for-Audio
* **Sweetwater:**
  * Guide: https://www.sweetwater.com/sweetcare/articles/pc-optimization-guide-for-windows-10/?fbclid=IwAR2z4UFZVRYLW2XpMGUgge51-UCe1ZhlF6gq2ZcR90HWEp33fI7TkMOJfO0
* **PCDJ:**
  * https://www.pcdj.com/dj-software-windows-10-system-optimization-guide/
* **Dell guide:**
  * https://www.dell.com/support/article/us/en/19/sln317113/xps-9570-resolving-intermittent-crackling-audio-issues?lang=en*   
   
   
Very old guides:
* **djtechtools:** 
  * https://djtechtools.com/2011/08/14/optimizing-windows-for-djing-part-i-power-script/
* **Numark:** 
  * https://www.numark.com/kb/article/1424

DDJ-1000 specific:
* **DDJ-1000:** 
  * https://forums.pioneerdj.com/hc/en-us/articles/360015455971-To-those-who-have-crackling-noise-when-using-DDJ-1000-with-rekordbox-dj
  
  
Finally, Cantabile software produced a 97 page pdf guide on audio optimization:
https://www.cantabilesoftware.com/glitchfree/
  
## Dell laptop pre-installed services latency issues

If you have a Dell laptop, **beware of the services that come preinstalled with the laptop**.

Specifically I've measured that "Dell SupportAssist" causes SECONDS of latency every 30 minutes, due to heavy [SMI interrupts](#How-to-count-SMI-hidden-interrupts-in-Windows)

The solution is simply to disable the Dell services in "services.msc"

**More details:** [smi_counter](https://github.com/pestrela/smi_counter)
 
![dell_support_assist3](https://github.com/pestrela/smi_counter/blob/master/dell_support_assist3.jpg?raw=true)




## How to count SMI (=hidden interrupts) in Windows

If your whole laptop stops once in a while for several seconds - including the mouse - it can be [SMI issues](https://www.resplendence.com/latencymon_cpustalls).

SMIs are "hidden interrupts" that the BIOS can issue at any time and will *lock all cores*.
As these are not visible to the OS, these will confuse latencyMon, but not [IDLT](https://www.resplendence.com/latencymon_idlt).

These interrupts are used, for example, when you change the laptop brightness. 
The CPU has a special counter for these interrupts. 

I've made a small tool to read this special counter in Windows: [count_smi tool](https://github.com/pestrela/smi_counter) 

Below a simple test that shows that changing the brightness in Dell XPS "costs" 4 SMIs:

![dell_smi_light_problems](https://github.com/pestrela/smi_counter/blob/master/pics/dell_smi_counter.jpg?raw=true )
                           

## How to make a deep trace of everything that runs in your laptop
   
TODO: document the windows performance analyser   
   
   
## Read this if you have erratic USB cable problems

USB cables may be too thin and not deliver enough power to your controller.\
Confirm your cable does NOT have these labels:
* 28/2C
* 28AWGX2C
* AWG 28X2C
 
In general you want the "2C" label to have "24" and not "28".\
full info: https://support.native-instruments.com/hc/en-us/articles/210293725-Choosing-the-Correct-USB-Cable-for-Your-NI-Hardware-Device
more info2: https://goughlui.com/2014/10/01/usb-cable-resistance-why-your-phonetablet-might-be-charging-slow/


## How to enable Traktor verbose log

**important:** this will affect performance, so use only for manual tests!

log file: traktor_root\log\traktor.log
    
Windows:
*  TBD

MacOS:
*  close traktor
*  go to User:Library: Preferences:com.native-instruments.de:Traktor.plist
*  add key Log.Verbosity with value 5
*  default value: 2
      
## Buying a laptop for Audio

Are you going to buy a laptop? Be sure you can return it to the shop if you have any problems.

My advice if you are buying a Windows laptop is the following:
* Check latest guides to choose a laptop
  * Ensure that it has USB-A ports. No exceptions.
* Buy such model in a real shop where you can return it in 30 days **without any questions asked**
  * Enquire this question specifically!
* Measure DPC problems continuously - including overnight - for Latencymon, SMI_counter
* If you have any problems return the laptop, or follow my guides to fix the issues.
 


# Windows usage

Windows-specific tips go here.

* [Why I use Windows instead of Mac](#Why-I-use-Windows-instead-of-Mac)
* [Generic Windows tweaks and programs I use](#Generic-Windows-tweaks-and-programs-I-use)
* [How to use QQTabBar with multiple tabs, folder bookmarks and program launchers](#How-to-use-QQTabBar-with-multiple-tabs-folder-bookmarks-and-program-launchers)
* [How to add WSL scripts to QQTabBar](#How-to-add-WSL-scripts-to-QQTabBar)


## Why I use Windows instead of Mac
    
Apple and MacOS is in general a better choice to do audio work (both DJing and Production). 

The operating system is stronger because it was built on Unix. The hardware and software are better 
integrated as they are built by the same company. 
And there is generally less bugs across the board as the hardware are standardized (ie, all macs are the same inside the same model).

Nevertheless its definitely not perfect; while I've seen more issues in Windows, I've also seen issues in Macs. 
In particular, as of Nov 2019 this got a lot worse with MacOS Catalina, namely as it migrated to 64-bit only drivers and the removal of itunes/music App. 

So if I say the mac is still overall a better choice for Music, so why I'm using a Dell XPS 15 windows? 
Main reasons are:
* **a) Folder Tree:** I use File explorer with the [full tree visible all the time](#why-i-manage-music-using-os-folders-only). I've tried Finder several times but did not enjoyed their paradigms. 
Also tried to use a windows file explorer clone for mac, it was completely abandoned by the author.
* **b) No flexibility:** AKA the "one apple way". I've never got used to their GUI, their keyboard shortcuts, 
and the keyboard itself. 
In particular there is the extremely annoying decision of having to use 2 hands for the
 [forward delete key](https://forums.macrumors.com/threads/why-no-delete-key.1360799/). 
Same story for the Maximize feature. Same story for lack of USB-A ports, SD cards and dongles. 
Ditto for no headphone jack in recent iphones.
In all cases the answer is  "get used to it". Well, I didn't.\
See also [my Windows tweaks](#Generic-Windows-tweaks-and-programs-I-use)
* **c) Software library:** Very limited choice on software and freeware, as compared to Windows
* **d) Expensive:** Underpowered machines, when compared to their direct windows counterparts [in the same price range](https://musiccritic.com/equipment/disk-jockey/best-laptops-for-djing/)
* **e) Command Line:** I use the command heavily to automate tasks in bash, git updates, and python programming.

See also these comments on [switching from OSX to Windows](https://www.meldaproduction.com/text-tutorials/switching-from-osx-to-windows)
from a Music company.


## WSL Linux shell on Windows

I use the command heavily to automate tasks in bash, git updates, and python programming.

For years I've used a linux VM inside windows, but now I only use WSL. 

* Installation guide: https://adamtheautomator.com/windows-subsystem-for-linux/
* Integration with python: https://towardsdatascience.com/setting-up-a-data-science-environment-using-windows-subsystem-for-linux-wsl-c4b390803dd
* Integration with visual studio: https://devblogs.microsoft.com/commandline/an-in-depth-tutorial-on-linux-development-on-windows-with-wsl-and-visual-studio-code/

 


## Generic Windows tweaks and programs I use 

I love [customization](https://www.neogaf.com/threads/some-of-my-cant-live-without-progams-what-are-yours.1482889/), so I have installed several tweaker apps. These are all GUIS to edit the refgistry and change / unlock / customize windows features. Below the reviews:
* [Activaid](https://www.ghacks.net/2014/09/24/activaid-is-a-useful-autohotkey-script-collection/)
* [Winareo tweraker](https://winaero.com/comment.php?comment.news.1836)
* [Ultimate windows tweaker](https://www.thewindowsclub.com/ultimate-windows-tweaker-4-windows-10)
* [NirSoft utils](https://www.nirsoft.net/utils/)
* [Win 10 annoyances](https://www.pcmag.com/how-to/how-to-fix-the-most-annoying-things-in-windows-10)

Plus some specific programs:
* [QQTabbar](https://www.techsupportalert.com/content/qttabbar.htm): Adds tabs to File Explorer, folder bookmarks and program shortcuts. Please see below pictures.
* [Link Clump](https://chrome.google.com/webstore/detail/linkclump/lfpjkncokllnfokkgpkobnkbkmelfefj?hl=en): Make a rectangle around hyperlinks; open all in new tabs.
* [WinDirStat](https://windirstat.net/): find missing disk space hogs
* [Resilio sync](https://www.techadvisor.co.uk/download/backup-recovery/resilio-sync-263-3331463/): automatic folder synchronization
* [Allway Sync](https://www.tomsguide.com/us/file-sync-backup,review-1060-4.html): manual folder synchronization

## How to use QQTabBar with multiple tabs, folder bookmarks and program launchers

QQTabbar ([link to a review](https://www.techsupportalert.com/content/qttabbar.htm)) is 
an amazing file explorer add-on. It supports multiple tabs, folder bookmarks and program launchers.\
I use this every day to open WSL linux terminals in the current folder, and to open audio files programs directly.

Usage:
![qqtabbar_usage](pics/qqtabbar_usage.jpg?raw=true)

Configuring Launchers:
![qqtabbar_launchers](pics/qqtabbar_launchers.jpg?raw=true)

## How to add WSL scripts to QQTabBar

Combining QQTabBar and WSL bash scripts is a powerful way to manipulate files in Explorer.

Example programs from [here](../wsl_tools/):
* windows_launch_spek.sh: calls the spek frequency analyzer for several files
* windows_group_files_in_folder.sh: create a sub-folder and move selected files into it 
* simple WSL shell launch on that folder

Most important tricks are:
* launch bash as 'wsl.exe --cd %cd% -- <your_script> %f%'
  * '--cd %cd% --' changes the working folder to that location
  * without further parameters this opens an interactive shell
* process the files with "wslpath $file" to convert to WSL format
  * if you are launching windows programs, use the arguments "as-is"  

![qqtabbar_wsl_scripts](pics/qqtabbar_wsl_scripts_.jpg?raw=true)



# Rekordbox v6 topics

* [Issues of the V6 Rekordbox migration - Major](#issues-of-the-V6-Rekordbox-migration---major)
* [Issues of the V6 Rekordbox migration - Minor](#issues-of-the-V6-Rekordbox-migration---minor)
* [What is NOT unlocked in the Rekordbox V6 hardware options](#What-is-NOT-unlocked-in-the-Rekordbox-V6-hardware-options)
* [How to ignore Rekordbox upgrades](#How-to-ignore-Rekordbox-upgrades-completely)


## Issues of the V6 Rekordbox migration - Major

1) **Vendor Lock-in:**
* V6 encrypts the database and removed the XML export option.
  * Discussion: https://www.reddit.com/r/DJs/comments/g11s3l
  * Workaround: https://www.reddit.com/r/DJs/comments/g2c9l9
* This vendor lock-in doesn't look good on latest European regulations:
  * "To eliminate vendor lock-in practices, the Regulation provides for and encourages 
  the development of codes of conduct for service providers. With these codes of conduct, 
  consumers should be able to switch to other service providers more easily."
  * source: https://www.gtlaw-amsterdamlawblog.com/2018/11/another-privacy-regulation-but-this-time-on-non-personal-data/

2) **Perpetual bought licenses** do not transfer to subscription model:
* I've bought a rekordbox performance (149 USD), rekordbox video (99USD)and RMX pack (9.9USD) to use in my DDJ-1000.\
  * Total cost: 260USD w/o Tax.
  * V5 licenses: https://web.archive.org/web/20200217154645/https://rekordbox.com/en/plan/pluspacks/
* This V5 license doesn't carry over to the new subscription model
  * Note: "check" in this table means that it is suported. It doesn't mean it is free! (https://rekordbox.com/en/support/link )
  
The XML vendor lock is a **deal breaker** for me.\
The dead V5 license is quite annoying (there will be no V5 improvements and I don't expect any support moving forward).
  
## How did the industry commenters reacted to the v6 XML export issue?
(Post to be updated periodically. Please send updates to pedro.estrela@gmail.com)


* Digital DJ Tips: https://www.digitaldjtips.com/2020/04/rekordcloud-mixo-apps-offer-new-dj-library-conversion-tools/
  * "What about this Rekordbox 6 issue? none of the conversion apps out there old or new except Rekordcloud works with Rekordbox 6 exporting, because your data is locked down inside Rekordbox 6 in a way it wasn’t in previous versions."
* DJ Tech Tools: https://djtechtools.com/2020/04/14/rekordbox-6-now-with-cloud-library-syncing/
  * (issue not specifically covered)
* DJ Worx: https://djworx.com/rekordbox-6-puts-your-library-in-the-cloud/
  * (issue not specifically covered)
* DJCU: https://www.reddit.com/r/DJs/comments/g11s3l/xml_implicationslimitations_of_the_new_rekordbox/
  * "Call to arms: I ask all DJs regardless if they use my tools or not, ask Pioneer DJ to bring the export to XML function back, and while at it, ask them to fix the XML import. Don't go mad at Pulse"
* Rekordcloud: https://rekord.cloud/blog/technical-inspection-of-rekordbox-6-and-its-new-internals 
  * "It could be different: In case Pioneer reads this: do the right thing and open up Rekordbox."
* Rekordbuddy: https://forums.next.audio/t/rekord-buddy-and-rekordbox-6-do-not-upgrade-for-now/2257/15
  * "I’ve always done things by the book with Rekord Buddy and so my first reaction is to make we stay within the law here."
* Mixo: https://support.mixo.dj/guide/rekordbox-6?search=9676776fd018f4b4ec565dcf1c1db0f6
  * "We would recommend that users who wish to move their Rekordbox collections to other DJ Software avoid updating to Rekordbox 6"

My own comment is the following:
* Pedro Estrela:  https://djworx.com/traktor-s4-mk3-screen-hack-hits-version-2-0/
  * "MIXXX is fully open. After the RB6 database encryption story last week, and all this years of Traktor workarounds, it looks the best way forward."
  
 

## Issues of the V6 Rekordbox migration - Minor
  
Besides the XML export and the bought licenses problem there is additional smaller issues:\
no search box on the explorer node; no midi mapping with modifiers, multiple actions and CFX selector;\
Cannot physically delete files inside RB. Still hotcues do not move the floating cue.

On the plus side, it now automatically auto-relocate renamed and moved tracks. This is a [major improvement]([a) Automatic finds moved files](#why-is-traktor-my-software-of-choice-a-database-repair-mass-relocate)).\
It also has shared audio and video playlists.\
It also has a Day skin, which is something [all OS already support](#How-to-enable-day-skin-in-any-software)

The other functions I either do not use (streaming, ableton link) or have my own solution ([automatic sync using a NAS](#how-i-synchronize-and-backup-my-whole-traktor-music-and-configuration-across-laptops-and-a-nas)).
 
## What is NOT unlocked in the Rekordbox V6 hardware options

With v6 there are combinations of equipement that unlock *some* functionality.
* Plans: https://rekordbox.com/en/plan/
* Hardware: https://rekordbox.com/en/support/link

Combining both lists, this is what is **NOT unlocked**:
* DVS (except DJM-750Mk2, 450, 250MK2, interface2, DDJ-RZ, XP1, XP2)
* Video (except RXZ)
* Sampler sequence saving
* RMX effects
* Lyrics
* Cloud Sync

All these need either the 10eur/mo or the 15eur/mo subscription (August 2020 new prices)

For example, this is how video looks like with my DDJ-1000 connected:\
"You cannot use this function in your current plan."\
![v6_video_watermark](pics/v6_video_watermark.jpg?raw=true)

Same story for DVS:\
![v6_dvs_with_ddj_1000](pics/v6_dvs_with_ddj_1000.jpg?raw=true)


## How to ignore Rekordbox upgrades completely

The last usable Rekordbox is version v5.6.0.\
Later versions either have a bug on [XML import](https://www.youtube.com/watch?v=JV89dj1hDWM), 
or they [lack XML export](#issues-of-the-V6-Rekordbox-migration---major) at all.

However, you will be nagged with an upgrade window every time you start RB.

to remove this, simply rename this file to something else:

C:\Program Files\Pioneer\rekordbox 5.6.0\Upmgr rekordbox.exe
    
   
## How to enable day skin in any software

If you are playing on the bright outside you will not see a thing.
Some softwares provide a specific skin for this situation.

But this feature is native to the OS: 

Windows 10:
* Press Win + Plus / settings / Invert Colors / Turn on magnifier
* [guide](https://windowsreport.com/inverted-colors-windows-10/)

MacOS:
* “System Preferences” > “Keyboard” > “Shortcuts” > “Accessibility” >  “Invert Colors
* [guide](https://devicebar.com/invert-display-colors-on-apple-mac-os-x/2642/)
    
    
# MIXXX topics

This section covers MIXXX, the open-source professional DJ software.
* [What makes MIXXX unique](#what-makes-mixxx-unique)
* [How complete is MIXXX?](#how-complete-is-mixxx)
* [DDJ support in MIXXX](#ddj-support-in-mixxx)



## What makes MIXXX unique 

[MIXXX](https://mixxx.org/) is a professional-level DJ software that is fully open-source software.

This means that ANYONE has the complete freedom to improve MIXXX by fixing bugs, extending features or adding entirely new functionality.

Such is unique among any solution, and is severely lacking in all other DJ software that have bugs unfixed for years ([example](#Traktor-Slow-preferences-Window)), possibly forever.

Also interesting, MIXXX is provided at no cost to the users. Anyone can just download, and have a go at it.


## How complete is MIXXX?

Out of the box, MIXXX has a very impressive number of advanced DJ features:
* DVS control to any soundcard
* BPM, Key detection and Sync 
* A very complete list of effects
* DJ controller support, both built-in and contributed, and a mapping wizard for new controllers.

It has [dozens more DJ standard features](https://mixxx.org/features) as well like Loops, Sampler, HotCues, Quantize, Censor, EQ, etc.

I've made a review of MIXXX 2.3 from the point of view of a heavy Traktor user:
https://www.mixxx.org/forums/viewtopic.php?f=1&t=13355
    
Another Traktor vs MIXXX comparison: https://www.mixxx.org/forums/viewtopic.php?f=1&t=13267    

    
## DDJ support in MIXXX
    
MIXXX has good support for the simplest DDJ controllers like 400, RB and SB2 ([full list](https://www.mixxx.org/wiki/doku.php/pioneer_ddj_controllers)).
On the 4 Deck controllers it supports the SX, which is compatible to the other S-based controllers like the SX2 and SZ.

For the [DDJ-1000](https://www.mixxx.org/wiki/doku.php/ddj-1000) there is a first mapping with the [jog screens](https://www.mixxx.org/forums/viewtopic.php?f=7&t=13346).

I intend to contribute to MIXXX my own DDJ-1000/SX2/SZ mappings soon, based on my [Traktor mappings experiences](#Free-Mappings).

    
# Music Styles

* [What are Retro, Metal and Reggae remixes](#What-are-Retro-Metal-and-Reggae-remixes)
* [How to learn good transition points by reconstructing sets](#How-to-learn-good-transition-points-by-reconstructing-sets)
* [Examples of Retro, Metal and Reggae remixes](#Examples-of-Retro-Metal-and-Reggae-remixes)



## What are Retro, Metal and Reggae remixes

### Retro Remixes
I'm a big fan of Retro remixes ([wikipedia page](https://en.wikipedia.org/wiki/80%27s_remix)). 
These are remixes of modern tracks with typical 80s sounds, but with the original vocal.\
Good artists  to check are 
[Exile](https://www.youtube.com/user/dima839/videos?view=0&sort=dd&flow=grid),
[Initial Talk]( https://www.youtube.com/channel/UC-zc27zh_-_x0UI7wiqAg7w/videos?view=0&sort=dd&flow=grid),
[Tronicbox](https://www.youtube.com/channel/UCB3W9gT-mFMN1j12pydSNOw/videos?view=0&sort=dd&flow=grid )
and [SX Ade Synthwave](http://youtube.com/channel/UCcG7Yj2yVP_11oy9D7nLbkQ/videos?view=0&sort=dd&flow=grid ).\
[Loki](https://www.youtube.com/user/patryk1997100/videos?view=0&sort=dd&flow=grid)
and [Sagkra]( https://www.youtube.com/user/sakgramixesII/videos?view=0&sort=dd&flow=grid) have 
only a few retro remixes, but there they are **rely really good**.\
Full playlists: 
[Playlist 1](https://www.youtube.com/playlist?list=PLR6iLyPrwbYO0xGzpVUDTJrD4lTs3r7lU ), 
[Playlist 2](https://www.youtube.com/playlist?list=PLccRgYlrdQ0imAehsQXmtKgJ3Zstt26Et ),
[Playlist 3](https://www.youtube.com/playlist?list=PLsqzrF7W4SoxB9uWJdHbVoPR2hU5n1tcO ),

### Metal Remixes


Similar is Metal remixes. In that style, people transform modern tracks in to Hard Rock/Metal style.
There it ranges from playing the guitars/drums on top of the track, all the way to remaking the whole track.\
Good authors to check are [Sindre Myskja](https://www.youtube.com/user/sindremyskja/videos?view=0&sort=dd&flow=grid) (this is the best one by far),
[Danny Killian](https://www.youtube.com/user/danyTWIG/videos)) (note: a lot of videos were deleted), 
[Bliix]( https://www.youtube.com/user/bliix/videos?view=0&sort=dd&flow=grid)
[Jotun studio]( https://www.youtube.com/user/Jotun6662/videos?view=0&sort=dd&flow=grid),
[Nanock](https://www.youtube.com/channel/UCxSoglV-neBcp_6aVTPFSlg/videos).\
Full Playlists: [Playlist 1](https://www.youtube.com/watch?v=XLipQ7AgcsE&list=RDXLipQ7AgcsE )

### Reggae Remixes

Same idea is reggae remixes.
Again, modern tracks are remixed with the typical reggae sounds, but with the original vocal.\
Good authors to check are [Theemotion]( https://www.youtube.com/channel/UCXxbs26yQ9BUwVLIUpOVf3w/videos?view=0&sort=dd&flow=grid ),
[Jr Blender]( https://www.youtube.com/user/thatshitissowild/videos?view=0&sort=dd&flow=grid),
[Chala](  https://www.youtube.com/channel/UCpXSNWccH_2ONpP3zTig2_g/videos?view=0&sort=dd&flow=grid),
[Ganja music](https://www.youtube.com/channel/UCdsLQbyCDWjYluA3N0khGIQ)
 and [BillyBoy](https://soundcloud.com/billyboyfiji679 ) \
Full Playlist: [Playlist 1](https://www.youtube.com/watch?v=A_j7AhQRzKg ), 

  
## Examples of Retro, Metal and Reggae remixes
 
The fundamental aspect in all these styles - Retro remixes, Metal versions and Reggae remixes - is that the original vocal are used.
As such, it typically departs from [regular covers](https://en.wikipedia.org/wiki/Cover_version) sung by other artists.


Below some examples of both styles, compared to the original versions:

Lady Gaga, Bradley Cooper - Shallow 
* shallow original: https://www.youtube.com/watch?v=bo_efYhYU2A
* shallow 80s version: https://www.youtube.com/watch?v=KRJIIubEZ-c
* shallow metal: https://www.youtube.com/watch?v=Ftg06g_d6JY

Lady Gaga - Born This Way:
* born way - original:https://www.youtube.com/watch?v=3Vzrr64ZrVU
* born way - 80s: https://www.youtube.com/watch?v=sGOGRDufIe8
* born way - metal: https://www.youtube.com/watch?v=XLipQ7AgcsE

Alan Walker - Diamond Heart 
* diamond heart - original: https://www.youtube.com/watch?v=sJXZ9Dok7u8
* diamond heart - 80s: https://www.youtube.com/watch?v=mQbj-g_xZzU

The Weeknd - Blinding Lights:
* lights - original: https://www.youtube.com/watch?v=fHI8X4OXluQ
* lights - 80s: https://www.youtube.com/watch?v=tjSr_Itd0VM


Examples Reggae remixes - TBD.


## How to learn good transition points by reconstructing sets

One great way to learn good mixing points is to recreate existing mixes made by others, for learning purposes.

In 1995 I've heard my favorite mixed CD ever: "Kaos Totally Mix 1, mixed live by Dj Vibe at Kremlin, Lisbon, Portugal."
In the last 25 years, I listened to this CD at least 75 times, probably a lot more.

But only by recreating the mix first in Adobe Audition and then in Traktor I found (all?) the technical tricks of the amazing work by Dj Vibe. Amazing work!!

Versions:
* This is the original mix in youtube, uploaded by Kaos Records Portugal
  * https://www.youtube.com/watch?v=uuun-IcRuTw
* This is a pack with all the individual tracks with their traktor cues. 
  * Please match as follows: 1<->5 / 2<->6 / 3<->7 / 4<->8; 
  * some cues are gradual IN/OUT fades, some are already open faders.
  * https://www.dropbox.com/sh/bg4ey3z8uieis0e/AABlZeCqyskOgKWyjlXdsphVa?dl=0

**IMPORTANT:** ALL TRACKS ARE COPYRIGHT 1995 [KAOS RECORDS](http://bit.ly/KaosRecords).\
Tracks were recorded from vinyl for **EDUCATIONAL PURPOSES ONLY.** ([Fair use disclaimer](https://www.termsfeed.com/blog/fair-use-disclaimer/)).


![kaos CD cover](pics/kaos_totally_mix_reconstruction_cd_cover.jpg?raw=true)
![kaos audition](pics/kaos_totally_mix_reconstruction_audition.jpg?raw=true)




# Other topics
* [How to enable day skin in any software](#How-to-enable-day-skin-in-any-software)
* [How I recorded my old radio show recordings and found the IDs](#How-I-recorded-my-old-radio-show-recordings-and-found-the-IDs)
* [How I edited my videos showing the Traktor screen](#How-I-edited-my-videos-showing-the-Traktor-screen)
* [How I synchronize and backup my whole Traktor structure across laptops and a NAS](#how-i-synchronize-and-backup-my-whole-traktor-music-and-configuration-across-laptops-and-a-nas)
* [How to replace the DDJ-1000 filter knobs with Silver knobs](#How-to-replace-the-DDJ-1000-filter-knobs-with-Silver-knobs)
* [DJ Census over time results](#DJ-Census-over-time-results)
* [Some metrics of my free contributions](#Some-metrics-of-my-free-contributions)

* [People that I learned a lot from the Global DJ community](#Some-people-from-which-Ive-learned-a-lot-from-the-Global-DJ-community)

  
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
 
 
see also this forum post on [reducing the hiss of K7](http://www.oldskoolanthemz.com/forum/showthread.php?t=68960).
 
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
  Ideally, grab the microphone stand on **ANOTHER desk**, so that your scratching will not vibrate the smartphone.
  * Record the controller image in 16:9 format
  * Record the laptop screen using [this free tool](https://www.freescreenrecording.com/)
  * If its a spoken video, record the audio from the smartphone. If its pure DJing use from the mixer output, or internal Traktor.

* Editing part 1: merge everything to a single video
  * Download the latest version of [openshot](https://www.openshot.org/download/). 
  Read this [tutorial for basics](https://www.howtoforge.com/tutorial/an-introduction-to-video-editing-in-openshot-2-0/). 
  [this is another tutorial](https://gist.github.com/peanutbutterandcrackers/f0f666243133e0ed25abbc12a4ba23d7)
  * Change profile to a 4:3 format, 30fps (preferences / profile). This is crucial to fit both the controller and the top traktor screen
  * Add the Controller video on Track 1. Zoom out (ctrl+Scroll). Click in the very first frame. 
  Use properties / Rotate to fix any rotation issues.
  Use effects / crop to crop the controller to size. 
  Use right click / transform to center and scale it to the bottom of the screen
  * Move the video to the middle of the timeline. Lock track 1 so that it no longer moves (track 1 / RMB / lock)
  * Add the Screen video to Track 2. Do the same steps as before to crop and scale / center the video on the top part of the screen
  * Sync the two videos by finding something unique (eg press play). Zoom in a lot. Disable snap for precise alignment. Confirm alignment in the end of the video
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
  


## How to fix DDJ-1000 loose jogs

(taken form FB post, to clean up and add pictures)

video: https://www.youtube.com/watch?v=LnvZR3Kiuxs


LOOSE JOG WHEEL DISCOVERY 
READ BELOW....

It seems the part that is responsible for keeping the jog wheel in place is not the rollers at all. 

It’s a bracket that has two stationary barrels attached to it. The one in the back is for right to left movement and the one in the front is for front to back movement. 

If you have a jog wheel that is loose this is the part that has failed or has come defective from manufacturing. 

These barrels sit inside of a channel on the under side of the jog wheel top plate ( where your hand makes contact to scratch )

The way the barrels are held onto the bracket is they are pressed into the bracket and center-punched to mushroom the metal to lock it in place on the bottom. 

* When a jog wheel develops front to back movement the front barrel will be found to be loose and exhibit a wobble on the bracket. 

* When a jog wheel develops side to side movement the rear barrel will be found to be loose and exhibit a wobble on the bracket. 

If you are able to carefully center punch the shaft from the bottom of the bracket it is possible to re-secure the barrel.
Once the barrel is secured properly to the bracket your movement in your jog wheel will be eliminated. 

I’m trying to get a part number(s) in case anyone is tired of sending in their unit and it coming back not fixed. 

Honestly this is something that pioneer should have done a recall on as I’ve seen so many posts about it here and on forums and have spoke to SAM ASH and Guitar Center with both retailers aware and complaining about the issue. 

Pioneers stance is to keep quiet when all they had to do is replace this bracket that probably cost them 5.00 to have made. 

The labor for the repair is most likely why they are keeping quiet. It’s just unacceptable.

  
## How to replace the DDJ-1000 filter knobs with Silver knobs

Both 1000 and 1000SRT have extremely [dull filter knobs](../pic_sets/silver_knobs/DDJ-1000RB.jpg). Which is a pity.\
For now the best fit is [DAA1309](https://www.pacparts.com/part.cfm?part_no=DAA1309&mfg=Pioneer) from the DDJ-SZ or DJM-900. This is an almost perfect fit.

Folder with pictures of the knobs: [here](../pic_sets/silver_knobs)

* [DAA1309](../pic_sets/silver_knobs/DAA1309.png):
  * This has the best fit overall. The knob is slightly higher than desired.
  * [Part list](https://www.pacparts.com/part.cfm?part_no=DAA1309&mfg=Pioneer): \
    DJM-900NX2/2000NX1/750\
    DDJ-SZ/ DDJ-RZ/ DDJ-RZX
  
* [DAA1320/DAA1350](../pic_sets/silver_knobs/DAA1320.jpg):
  * this was confirmed NOT to work
  * [parts list]((https://www.pacparts.com/part.cfm?part_no=DAA1320&mfg=Pioneer)): DJM-S9 / DJM-900SRT / XDJ-RX / XDJ-RX2

* [100-SX3-3009](../pic_sets/silver_knobs/100-SX3-3009.jpg):
  * not tested
  * [part list](https://www.pacparts.com/part.cfm?part_no=100-SX3-3009&mfg=Pioneer): DDJ-RX
  
* [DAA1373](../pic_sets/silver_knobs/DAA1373.jpg):
  * not tested
  * [parts list](https://www.pacparts.com/part.cfm?part_no=DAA1373&mfg=Pioneer): DJM750 MK2 / 250MK2 / 450 / S3
  
* [Rane 2015](../pic_sets/silver_knobs/rane%202015%20filters.jpg):
  * this was confirmed to work [by another user](https://www.facebook.com/photo.php?fbid=3050933838255437&set=gm.672781936578130&type=3&theater&ifg=1)

  
  
  
## DJ Census over time results

Digital DJ Tips and DJ Tech Tools collect yearly data on the most popular software and controllers. 
Every year I update this page with the new data points over time. Source files are [here](../census_graphs)

See also the [most popular DJ softwares census](../census_graphs).\
See also the graph showing the [most popular DJ softwares over time](../census_graphs).

![dj software over time](../census_graphs/dj_software_over_time.jpg?raw=true)
![dj controllers over time](../census_graphs/dj_controllers_over_time.jpg?raw=true)
![dj platforms over time](../census_graphs/dj_platform_over_time.jpg?raw=true)

  
## Some metrics of my free contributions

These are my biggest crontibutions.\
What did you enjoyed the most? please tell me to pedro.estrela@gmail.com

* Knowledge Base: 16K words 
  * https://github.com/pestrela/music/blob/master/traktor/README.md
* DDJ-1000 mapping: 4K downloads  
  * https://maps.djtechtools.com/mappings/9279
* DDJ-SX2/SZ/SRT mapping: 3K downloads 
  * https://maps.djtechtools.com/mappings/9222
* CMDR Changelog: 80 lines
  * https://github.com/pestrela/cmdr#2020-improvements 
  
 
## Some people from which I've learned a lot from the Global DJ community

"AKA my DJ hall of fame".
![Hall Of Fame](pics/hall_of_fame.jpg)

When I started DJing in 2000 I've learned a lot from local DJs in Lisbon that I've meet regularly.\
The ones I worked the most were Rui Remix, Bruno Espadinha, Joao Vaz, Jaylion, Miguel Assumpcao and DJ Ice.

20 years later the Internet changed this locality a lot.\
You can now learn anything from youtube tutorials, reading articles and have insightful conversations with people that you may never meet.

Below some of the people that I've learned the most. Apologies if I forget anyone.\
All of them made significant contributions either in articles, software or video tutorials. 
In the vast majority this is applicable to any DJ software.

Most of them I've either meet them in person, or I had numerous conversations with them over chat.

* **Ean Golden:**
  * Inventor of Controlerism, Founder of DJtechtools, Hundreds of articles, Workshops
  * https://djtechtools.com/author/Admin/
* **Phill Morse:**
  * Founder of DigitalDJTips (biggest online DJ school), Hundreds of articles
  * https://www.digitaldjtips.com/category/news/
* **Stevan Djumic:**
  * Dozens of very high quality Traktor mappings. Reverse engineering his mappings was a major turning point for me.
  * https://my.djtechtools.com/users/3776
* **Jeroen Groenendijk:**
  * Multiple workshops and generic techtalks
  * https://www.facebook.com/pg/DJResource/videos/
* **Peter van Ruiten:**
  * Author of the DJCU converter. Dozens of videos about conversion and DJ collection management
  * https://www.youtube.com/channel/UCMXHg5Oi8vlfKyEvsgrMRuQ/videos
* **Christiaan Maaks:**
  * Author of the rekordcloud online converter. Lots of generic info applicable to all converters  
  * https://rekord.cloud/wiki/
* **Alex Coyle:**
  * Author of the open-source DJ converter. I worked with him over months to research the [26ms shift problem](#what-is-the-26ms-shift-issue-when-converting-cuesloops-between-softwares)
  * https://github.com/digital-dj-tools/dj-data-converter/issues/3
* **DJ TLM:**
  * Dozens of tutorials on Scratching
  * https://www.youtube.com/user/djTLMtv/videos?view=0&sort=dd&flow=grid
* **Teo Tormo:**
  * Dozens of articles on advanced midi mapping and DJ hacking.
  * https://djtechtools.com/author/teotormo/
  
  
**Honorable mentions:**\
These individuals also made contributions that benefit a lot of users.\
Biggest difference to the group above is that I had much less interactions with them.

[Damien Sirkis](https://forums.next.audio/c/rekord-buddy/faq) (RekordBuddy), 
[Florian Bomers](https://www.bome.com/contributor/florian) (BOME), 
[Steven Caldwell](https://www.bome.com/contributor/steve1) (BOME),
[Michael Rahier](https://github.com/TakTraum/cmdr) (CMDR),
[Klaus Mogensen](https://www.youtube.com/channel/UCEphlcllAEbUwiuLqHMux9g/videos?view=0&sort=dd&flow=grid) (VirtualDJ),
[DJ Rachel](https://www.youtube.com/user/Serwrenity123/videos?view=0&sort=dd&flow=grid) (VirtualDJ),
[Carlo Atendido](https://www.youtube.com/user/djcarloatendido/videos?view=0&sort=dd&flow=grid) (Tutorials),
[Pulse](https://www.youtube.com/user/DeejayPulse/videos?view=0&sort=dd&flow=grid) (Rekordbox),
[DJ Keo](https://www.youtube.com/channel/UCtj1Z5UtHJtKX1c7zGWd18A/videos?view=0&sort=dd&flow=grid) (Industry Commentary),
[Mojaxx](https://www.youtube.com/user/MojaxxVDJ/videos) (Serato),
[Gábor Szántó](https://app.slack.com/client/T0ECEN4CW/C0ECETDEK) (DJ Player Pro),
[Friedemann Becker](https://github.com/pestrela/music/blob/master/pic_sets/traktor_interview/Interview%20with%20the%20lead%20Traktor%20programmer.pdf) (Traktor),
[Mike Henderson](https://online.berklee.edu/courses/learn-to-dj-with-traktor) (DJ Endo),
[Stephane Clavel](https://www.digitaldjtips.com/2018/08/interview-stephane-clavel-virtual-dj-founder-talks-innovation-the-future-of-djing/) (VirtualDJ),
[Jamie Hartley](https://wearecrossfader.co.uk/online-dj-courses/) (WeAreCrossfader),
[madZach](https://djtechtools.com/author/madzach/) (Production and DJing),
[DAVE](https://www.youtube.com/channel/UCe2doOsbbp-B2dN3jbJ4Uzg/playlists) (Tutorials),





