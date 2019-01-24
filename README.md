# music_scripts

h1. traktor_clone_cues

Main feature: clone CUEs
  This script is able to clone CUEs of the Duplicate files in your Collection.
	
  This is useful when you organise your music using OS folders (instead of traktor playlists).
  In that case, you physically copy files to have them in different "playlists".
  Ignoring the wasted space, the biggest issue is that the CUEs do not propagate to the other duplicates.
  This script fixes this by matching the files by AUDIO_ID [1], and copy the one that has the biggest number of CUEs into their duplicates.
	INPUT: latest "collection.nml" file (with duplicate files)
Secondary feature: merge collections
	Using the same method as above, this script can merge CUEs from multiple collections.
	This is useful when you had an old collection that had CUEs, and somehow they have been lost.
	Simply load both the old and the current collection, and the script will carry missing CUEs forward into the latest collection.
  Note that as above the merging criteria is again the file with the biggest number of CUEs - not the time of last update!!
	
	INPUT: "collection.nml", plus "*.nml" for the old collections
How to run:
  Simplest way to use this program is to use https://jupyter.org/try , then upload both the python code and the NML files. Run the program and download "collection.nml.merged"
	
Reference:
  [1] AUDIO_ID: https://www.mail-archive.com/mixxx-devel@lists.sourceforge.net/msg05061.html
"""

h1. Pipeline Workflow:
  original link: https://www.native-instruments.com/forum/threads/poll-ish-are-people-still-using-itunes-xmls-for-library-management.328895/page-2#post-1675993
	
	My multi-genre, large collection is organized on OS folders (Operating System folders), instead of Playlists. 
  This is to be independent of any possible DJ software and itunes. I find a lot easier to have many Windows Explorer windows open, plus grouping and sub-grouping files on folders. 
  As such I use the “explorer” node of the DJ programs instead of playlists.
	My workflow is fully automated:
	 b) I change filenames continuously to correct artist/title. I use MP3tag_scripts to a) capitalize the names (format is “ARTIST1 ft. ARTIST2 - Capitalized Title - Remix” and b) rename the internal tags  [1].
	 c) Traktor mass-relocate finds files everywhere by AUDIO-ID (ie, content). This is much superior than rekordbox and others [2].
	 d) I made a custom python script that duplicates cues of the duplicated files inside the Traktor collection.nml [1]. This is comparable to [3].
	 e) I use DJCU+RECU/Rekordbuddy2 to generate the rekordbox.xml file. This is done inside a MacOS VM [4] [5]. There were some manual steps, so I made a script to convert the filenames [1]. A Windows-only alternative is [6]
   f) I only need playlists for CDJs. To make playlists, I mass-convert all folders to itunes playlists, recursivelly. Mac version is [7]; Windows version is [8]. Then I do the ususal rekordbox step to prepare USBs pens.
	Any question / comment just ask....
	
	[1] My scripts: https://github.com/pestrela/music_scripts 
	[2] AUDIO_ID: https://www.mail-archive.com/mixxx-devel@lists.sourceforge.net/msg05061.html
	[3] Duplicate tool: http://www.flowrl.com/librarian/
	[4] MacOS VM: https://saintlad.com/install-macos-sierra-in-virtualbox-on-windows-10/
	[5] rekordbuddy VM: https://www.reddit.com/r/Beatmatch/comments/52dvst/how_to_transfer_your_windowsbased_dj_library_from/
	[6] Windows conversion:	https://github.com/ErikMinekus/traktor-scripts/blob/master/playlist-export.py
	[7] MAC folders to itunes playlist: https://dougscripts.com/itunes/scripts/ss.php?sp=droptoaddnmake
	[8] Windows folders to itunes playlists: http://samsoft.org.uk/iTunes/scripts.asp
