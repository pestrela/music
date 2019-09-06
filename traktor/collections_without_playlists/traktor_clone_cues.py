


help_text="""

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
  traktor_clone_cues -c collection_file  [any number of old collection files]
	
Reference:
  [1] AUDIO_ID: https://www.mail-archive.com/mixxx-devel@lists.sourceforge.net/msg05061.html

"""

help_text2="""

Pipeline Workflow:
------------------
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
	
"""

# https://jupyter.org/try
# https://docs.python.org/3.4/library/xml.etree.elementtree.html
import xml.etree.ElementTree as ET
import os, sys
import pandas as pd
import glob, os


def display_help():
    global help_text, help_text2
		
    print(help_text)
    print(help_text2)
		
    sys.exit(1)
		


def file_append_suffix(filename, suffix):
    name, ext = os.path.splitext(filename)
    # generate_id()
    return "{name}_{uid}{ext}".format(name=name, uid=suffix, ext=ext)


def parse_nml(file, phase, db, verbose=False, debug=False, quiet=False, max_process = None):

    print("")
    print("Doing phase %d for %s" % (phase, file) )
    
    if debug:
        verbose = True
    n_only_on_target=0
    n_processed=0
    root = ET.parse(file).getroot()
    collection=root.find('COLLECTION')
    for entry in collection:
        audio_id = entry.get('AUDIO_ID')
        location = entry.find('LOCATION')

        name = location.get('FILE')
        folder = location.get('DIR')
        date = pd.to_datetime(entry.get('MODIFIED_DATE'))
        
        if date is None:
            print("skipping missing date: ", name)
            continue
        
        cues = entry.findall('CUE_V2')
        len_new = len(cues)
        
        if phase == 1:
            if audio_id in db:
                previous        = db[audio_id]
                previous_name   = previous['name']
                previous_folder = previous['folder']
                previous_cues   = previous['cues']
                previous_date   = previous['date']
                len_previous    = len(previous_cues)
                
                ####
                if len_previous > len_new:
                    use_new = False
                    report  = True
                    debug_msg = "PREVIOUS had more cues. Keeping previous value"

                elif len_previous < len_new:
                    use_new = True
                    report  = True
                    debug_msg = "NEW has more cues. Using new value"

                elif len_previous == len_new:
                    if previous_date > date:
                        debug_msg = "same number of cues. previous is newer = Keeping previous value"
                        report = False
                        use_new = False
                    elif previous_date < date:
                        debug_msg = "same number of cues. previous is OLDER = using new value"
                        report = True
                        use_new = True
                        
                    elif previous_date == date:
                        debug_msg = "same number of cues. Same date"
                        report = False
                        use_new = False

                if (not quiet) and (verbose or report):
                    print("DUP (%d/%d) -- " % 
                        (len_previous, len_new, ), end="")

                    if previous_folder != folder:
                        print("%s" % ( name))
                        print("  FOLDER1: %s" %
                            ( previous_folder ))
                        print("  FOLDER2: %s" %
                            ( folder ))
                    else:
                        print("%s" % ( folder))
                        print("  NAME1: %s" %
                            ( previous_name ))
                        print("  NAME2: %s" %
                            ( name ))
                        
                    print("  %s" % (debug_msg))

                if not use_new:
                    cues = previous_cues
                        
            # phase 1: update db with biggest cues
            db[audio_id] = { "name":name, "folder":folder, "cues":cues, 'date':date }
            
        elif phase== 2:
            ## keep the locations unchanged. potentially raise the number of cues
            
            for cue in cues:
                entry.remove(cue)

            previous        = db[audio_id]
            previous_cues   = previous['cues']
            len_previous = len(previous_cues)

            for cue in previous_cues:
                entry.insert(-1, cue)

        else:
            raise ValueError("Unknown phase")
                
        n_processed += 1
        if max_process and (n_processed > max_process):
            print("Breaking early")
            break
                
    #########
    ### exit steps                    
    if phase == 2:
        #file_out = file_append_suffix(file, 'merged')
        file_out = file + ".merged"
        
        if debug:
            ET.dump(root)
            
        tree = ET.ElementTree(root)
        tree.write(file_out)
        print("")
        print("")
        print("Generated: %s" % (file_out))
        print("new only on target: %d" % (n_only_on_target))
        
    print("")
    print("")
    print("")
    return db

#####
def analyse_collection_files(current_collection):

    if current_collection is None:
        display_help()

    # phase 1
    db = {}
    previous_collection_list=[]
    
    for file in glob.glob("*.nml"):
        print("adding:", file)
        previous_collection_list.append(file)
        
    for file in previous_collection_list:
        db = parse_nml(file, phase=1, db=db, debug=False, quiet=True)

    # phase 2
    db = parse_nml(current_collection, phase=2, db=db)

    print("")
    print("All done")

final_file="collection.nml"
final_file=None

analyse_collection_files(final_file)


