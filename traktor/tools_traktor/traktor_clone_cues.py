#!/usr/bin/env python3


"""
todo in this software:
 - confirm all collection files are case-sensitive. fix them if not.
 - confirm all collection files start with c:\root\sync_traktor (instead of desktop)
 
 - check consistency: confirm all files are from root folder were imported 
 - deleted files: confirm all files exist. Delete the deleted one.

 
Example steps: 
--------------
 - import \folder1\a.mp3 
 - add 3 cues (lock?)
 - copy to \folder2. Import receives 3 cues
 - add 4th cue to \folder2
 - move \folder1 to \folder3
 - check consistency:   \folder1 not found -> mass relocate on root -> finds \folder2
 
 
NEW METHOD:
-----------
- SMALL MOVES:  (like rekordbox)
  - Traktor:
    - import all tracks "as-is"
    - analyse new tracks  
  - Python:
    - run clone cues  (uses old tracks)
    - delete missing tracks 
 
- BIG MOVES:
   - Traktor:
     - check consistency
     - mass relocate 
  - Python:
    - run clone cues  (uses old tracks)
    - delete missing tracks 


CONFIRMED:
 - adding tracks is incremental
 - tracks already in collection show as "[]" in the icons.
 
"""
  

import sys, os, glob, string, marshal
import string, re


# base libraries 
import argparse
import os
import re
from collections import defaultdict
from functools import partial
from pathlib import Path
import glob


def print_nonl(*args, **kwargs):
    """
    print(value, ..., sep=' ', end='\n', file=sys.stdout, flush=False)

    Prints the values to a stream, or to sys.stdout by default.
    Optional keyword arguments:
      file:  a file-like object (stream); defaults to the current sys.stdout.
      sep:   string inserted between values, default a space.
      end:   string appended after the last value, default a newline.
      flush: whether to forcibly flush the stream.
    """
    print(*args, end="", ** kwargs)
    

    


class VersionedOutputFile:
    """ 
    Like a file object opened for output, but with versioned backups
    of anything it might otherwise overwrite 
    
    #https://www.oreilly.com/library/view/python-cookbook/0596001673/ch04s27.html
    """

    def __init__(self, pathname, numSavedVersions=3):
        """ Create a new output file. pathname is the name of the file to 
        [over]write. numSavedVersions tells how many of the most recent
        versions of pathname to save. """
        self._pathname = pathname
        self._tmpPathname = "%s.~new~" % self._pathname
        self._numSavedVersions = numSavedVersions
        self._outf = open(self._tmpPathname, "w")   # use "wb" and str.encode() for better compatibility.

    def __del__(self):
        self.close(  )

    def close(self):
        if self._outf:
            self._outf.close(  )
            self._replaceCurrentFile(  )
            self._outf = None

    def asFile(self):
        """ Return self's shadowed file object, since marshal is
        pretty insistent on working with real file objects. """
        return self._outf

    def __getattr__(self, attr):
        """ Delegate most operations to self's open file object. """
        return getattr(self._outf, attr)

    def _replaceCurrentFile(self):
        """ Replace the current contents of self's named file. """
        self._backupCurrentFile(  )
        os.rename(self._tmpPathname, self._pathname)

    def _backupCurrentFile(self):
        """ Save a numbered backup of self's named file. """
        # If the file doesn't already exist, there's nothing to do
        if os.path.isfile(self._pathname):
            newName = self._versionedName(self._currentRevision(  ) + 1)
            os.rename(self._pathname, newName)

            # Maybe get rid of old versions
            if ((self._numSavedVersions is not None) and
                (self._numSavedVersions > 0)):
                self._deleteOldRevisions(  )

    def _versionedName(self, revision):
        """ Get self's pathname with a revision number appended. """
        return "%s.~%s~" % (self._pathname, revision)

    def _currentRevision(self):
        """ Get the revision number of self's largest existing backup. """
        revisions = [0] + self._revisions(  )
        return max(revisions)

    def _revisions(self):
        """ Get the revision numbers of all of self's backups. """
        revisions = []
        backupNames = glob.glob("%s.~[0-9]*~" % (self._pathname))
        for name in backupNames:
            try:
                revision = int(str.split(name, "~")[-2])
                revisions.append(revision)
            except ValueError:
                # Some ~[0-9]*~ extensions may not be wholly numeric
                pass
        revisions.sort(  )
        return revisions

    def _deleteOldRevisions(self):
        """ Delete old versions of self's file, so that at most
        self._numSavedVersions versions are retained. """
        revisions = self._revisions(  )
        revisionsToDelete = revisions[:-self._numSavedVersions]
        for revision in revisionsToDelete:
            pathname = self._versionedName(revision)
            if os.path.isfile(pathname):
                os.remove(pathname)
                
                
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
  traktor_clone_cues -s -c collection_file  [any number of old collection files]
	
Reference:
  [1] AUDIO_ID: https://www.mail-archive.com/mixxx-devel@lists.sourceforge.net/msg05061.html

More info on my workflow based on folders:
  https://github.com/pestrela/music_scripts/blob/master/traktor/README.md#how-to-manage-your-collection-using-operating-systems-folders-and-without-dj-playlists-ie-using-only-finder-windows-explorer-etc
  
  
"""


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


def percentage(a,b):
  ret =  (a * 100) / b
  ret = int(ret)
  return ret
  
  
  
class Stats():
  
  def print(stats):
    print("""
n_matches_prev_longer: %d
n_matches_new_longer: %d
n_matches_samelen: %d
n_matches_samelen_prev_newer: %d
n_matches_samelen_prev_older: %d
n_matches_samelen_samedate: %d
""" % (
  stats.n_matches_prev_longer,
  stats.n_matches_new_longer,
  stats.n_matches_samelen,
  stats.n_matches_samelen_prev_newer,
  stats.n_matches_samelen_prev_older,
  stats.n_matches_samelen_samedate)
)
  
  
   
  
  
  
def parse_nml(opts, file, phase, db):

  
  print("")
  print("-------------\nDoing phase '%d' for '%s'\n" % (phase, file) )
  
  max_process=opts.max_process
      
  stats = Stats()    
  stats.n_only_on_target = 0
  stats.n_processed = 0
  stats.n_entries = 0
  stats.n_matches = 0
  
  stats.n_matches_prev_longer = 0
  stats.n_matches_new_longer = 0
  stats.n_matches_samelen = 0
  stats.n_matches_samelen_prev_newer = 0
  stats.n_matches_samelen_prev_older = 0
  stats.n_matches_samelen_samedate = 0
  stats.no_audio_id = 0
  
  root = ET.parse(file).getroot()
  collection=root.find('COLLECTION')
  for entry in collection:
    stats.n_entries += 1
  
    debug = opts.debug
    verbose = opts.verbose
    quiet = opts.quiet
    very_debug=False
    if debug:
        verbose = True

  
    audio_id = entry.get('AUDIO_ID')
    location = entry.find('LOCATION')
   
    name = location.get('FILE')
    folder = location.get('DIR')
    full_path = "c:%s%s" % ( folder.replace("/:", "/"), name)
    date = pd.to_datetime(entry.get('MODIFIED_DATE'))

    
    ###
    
    if opts.match_by_filename:
      audio_id = full_path      # this is an hack
    
    if audio_id is None:
      stats.no_audio_id += 1
      continue
    
    if date is None:
      print("skipping missing date: ", name)
      continue
   
    if opts.deep_analysis:
      import pathlib
      pathlib.Path(file)

    if (opts.grep != "") and (name is not None):
      #print(opts.grep, name, folder)
      if re.search(opts.grep, name, re.IGNORECASE):
        #print("Found grep string: %s: " % (name))
        #very_debug = True  # just for this run
        debug = True  
        quiet = False
        verbose = True
        
      else:
        
        if opts.grep_only:
          if debug:
            #print("Skipping non-grep string %s" % (name))
            pass
          continue

    #print("ok")
    
    cues = entry.findall('CUE_V2')
    len_new = len(cues)
    
    if phase == 1:
      if not audio_id in db:
        if debug:
          print("NEW ENTRY (%d cues):  -- %s" % (len_new, name))
          
          if very_debug:
            print("Audio_ID: %s" % (audio_id))

          if opts.report_folders:
            print("  FOLDER (NEW): %s" % ( folder ))

      else:
          stats.n_matches += 1
          
          previous        = db[audio_id]
          previous_name   = previous['name']
          previous_folder = previous['folder']
          previous_cues   = previous['cues']
          previous_date   = previous['date']
          len_previous    = len(previous_cues)
          
          ####
          if len_previous > len_new:
            stats.n_matches_prev_longer += 1
            use_new = False
            report  = True
            debug_msg = "PREVIOUS had more cues (%d). Keeping previous value (%d)" % (len_previous, len_previous)

          elif len_previous < len_new:
            stats.n_matches_new_longer += 1
            use_new = True
            report  = True
            debug_msg = "NEW has more cues (%d). Using new value" % (len_new)

          elif len_previous == len_new:
              stats.n_matches_samelen += 1

              if previous_date > date:
                stats.n_matches_samelen_prev_newer += 1
                debug_msg = "same number of cues (%d). previous is NEWER = Keeping previous value (%d) " % (len_previous, len_previous)
                report = False
                use_new = False
                
              elif previous_date < date:
                stats.n_matches_samelen_prev_older += 1
                debug_msg = "same number of cues (%d). previous is OLDER = using new value (%d)" % (len_previous, len_previous)
                report = True
                use_new = True
                  
              elif previous_date == date:
                stats.n_matches_samelen_samedate += 1
                debug_msg = "same number of cues (%d). Same date" % (len_previous)
                report = False
                use_new = False

          if (not quiet) and (verbose ): #or report):
            #print(quiet, verbose, report)
            
            print("\nDUPLICATE (prev: %d/ new: %d) -- " % 
                (len_previous, len_new, ), end="")

            
            if opts.report_folders:
              if previous_folder != folder:
                print("%s" % ( name))
                #print("  FOLDER_OLD: %s" %
                #    ( previous_folder ))
                print("  FOLDER_NEW: %s" %
                    ( folder ))
              else:
                print("%s" % ( folder))
                print("  NAME_OLD: %s" %
                    ( previous_name ))
                print("  NAME_NEW: %s" %
                    ( name ))
                
            print("  %s" % (debug_msg))   # final outcome

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
            
    stats.n_processed += 1
    if max_process and (stats.n_processed > max_process):
        print("Breaking early after processing %d entries" % (stats.n_processed) )
        break

  #########
  ### exit steps                    
  if phase == 2:
    file_out = file #+ ".merged"
    #print("new entries only on target: %d" % (n_only_on_target))
    
    if not opts.save_output:
      print("==> SKIPPING final save. %s   (use -f to force changes)" % (file_out))
      
    else:  
      file_out2  = VersionedOutputFile(file_out, numSavedVersions=3)
      
      if very_debug:
          ET.dump(root)
       
      file_out2.write(ET.tostring(root).decode("utf-8"))
      
      file_out2.close()
      
      print("")
      print("")
      print("SAVED FILE: %s" % (file_out))
      
      
  print("")
  
  if not opts.match_by_filename:
    print(stats.no_audio_id, stats.n_entries)
    if percentage(stats.no_audio_id, stats.n_entries) > 30:
      print("Warning: %s non-analysed files. Did you forgot -M ?" % (stats.no_audio_id))
    
  print("Done  phase '%d' for '%s'. Processed %d entries. Matched %d entries." % (
    phase, file, stats.n_processed, stats.n_matches) )
    
  if opts.verbose:
    stats.print()
    
  print("------------------")
  print("")
  return db

#####
def analyse_collection_files(opts, current_collection, previous_collection_list=[]):

    if current_collection is None:
        display_help()

    # phase 1
    db = {}

    #for file in glob.glob("*.nml"):
    #    print("adding:", file)
    #    previous_collection_list.append(file)
    
    previous_collection_list.append(current_collection)
    
    for file in previous_collection_list:
        db = parse_nml(opts, file, phase=1, db=db)

    if not opts.single_pass:
      # phase 2
      db = parse_nml(opts, current_collection, phase=2, db=db)

    print("All done")


 
#########
parser = argparse.ArgumentParser(description='clone traktor cues based on number of cues')
parser.add_argument('other_collection', nargs='*',
                    help='other collection files. they will be processed in alphabetical order')
                    
parser.add_argument('-c', dest="final_file", required=True,
                    help='Main collection file. It will be replaced with a new version (old files are saved)')

parser.add_argument('-n', dest="max_process", default=None, type=int,
                    help='Max tracks to process')

parser.add_argument('-d', dest="debug", default=False, action="store_true",
                    help='Debug flag')

parser.add_argument('-q', dest="quiet", default=False, action="store_true",
                    help='Quiet flag')

parser.add_argument('-v', dest="verbose", default=False, action="store_true",
                    help='Verbose flag')
                    
parser.add_argument('--single', "--single_pass_only", dest="single_pass", default=False, action="store_true",
                    help='single pass only')

                    
parser.add_argument('-g', dest="grep", type=str, default="", 
                    help='optional string to grep. Shows verbosity for that entry. Still processes that entry')

parser.add_argument('-G', dest="grep_only", type=str, default="", 
                    help='same, but skips processing of other entries')

parser.add_argument('--report_folders', dest="report_folders", default=False, action="store_true",
                    help='optional string to grep. Shows verbosity for that entry')
                    
parser.add_argument('--deep', dest="deep_analysis", default=False, action="store_true",
                    help='Checks actual file is they are missing and case sensitivity problems')
                    
parser.add_argument('-M', '--match_by_filename', dest="match_by_filename", default=False, action="store_true",
                    help='Match by filename instead of AUDIO_ID')
              
                    
parser.add_argument('-f', dest="save_output", action="store_true", default=False, 
                    help='Actualy do save the final file')
                    

parser.add_argument('-f', dest="save_output", action="store_true", default=False, 
                    help='Actualy do save the final file')

                    
#                    <MODIFICATION_INFO AUTHOR_TYPE="user"></MODIFICATION_INFO>
                
                    
                    
opts = parser.parse_args()

###########
           
if(opts.grep_only):
  opts.grep = True
  opts.single_pass = True
           
if(opts.grep):
  opts.report_folders = True

  
analyse_collection_files(opts, opts.final_file, opts.other_collection)


 






    
    