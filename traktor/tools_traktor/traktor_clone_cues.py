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


class Stats():
  
  def print(stats):
    print("""
n_colisions_prev_longer: %d
n_colisions_new_longer: %d
n_colisions_samelen: %d
n_colisions_samelen_prev_newer: %d
n_colisions_samelen_prev_older: %d
n_colisions_samelen_samedate: %d
""" % (
  stats.n_colisions_prev_longer,
  stats.n_colisions_new_longer,
  stats.n_colisions_samelen,
  stats.n_colisions_samelen_prev_newer,
  stats.n_colisions_samelen_prev_older,
  stats.n_colisions_samelen_samedate)
)
  
  
   
  
  
  
def parse_nml(opts, file, phase, db):

  
  print("")
  print("-------------\nDoing phase '%d' for '%s'\n" % (phase, file) )
  
  max_process=opts.max_process
      
  stats = Stats()    
  stats.n_only_on_target=0
  stats.n_processed=0
  stats.n_colisions=0
  
  stats.n_colisions_prev_longer = 0
  stats.n_colisions_new_longer = 0
  stats.n_colisions_samelen = 0
  stats.n_colisions_samelen_prev_newer = 0
  stats.n_colisions_samelen_prev_older = 0
  stats.n_colisions_samelen_samedate = 0
 
  
  root = ET.parse(file).getroot()
  collection=root.find('COLLECTION')
  for entry in collection:
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

    if opts.match_by_filename:
      audio_id = full_path      # this is an hack
    
    
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
          stats.n_colisions += 1
          
          previous        = db[audio_id]
          previous_name   = previous['name']
          previous_folder = previous['folder']
          previous_cues   = previous['cues']
          previous_date   = previous['date']
          len_previous    = len(previous_cues)
          
          ####
          if len_previous > len_new:
            stats.n_colisions_prev_longer += 1
            use_new = False
            report  = True
            debug_msg = "PREVIOUS had more cues (%d). Keeping previous value (%d)" % (len_previous, len_previous)

          elif len_previous < len_new:
            stats.n_colisions_new_longer += 1
            use_new = True
            report  = True
            debug_msg = "NEW has more cues (%d). Using new value" % (len_new)

          elif len_previous == len_new:
              stats.n_colisions_samelen += 1

              if previous_date > date:
                stats.n_colisions_samelen_prev_newer += 1
                debug_msg = "same number of cues (%d). previous is NEWER = Keeping previous value (%d) " % (len_previous, len_previous)
                report = False
                use_new = False
                
              elif previous_date < date:
                stats.n_colisions_samelen_prev_older += 1
                debug_msg = "same number of cues (%d). previous is OLDER = using new value (%d)" % (len_previous, len_previous)
                report = True
                use_new = True
                  
              elif previous_date == date:
                stats.n_colisions_samelen_samedate += 1
                debug_msg = "same number of cues (%d). Same date" % (len_previous)
                report = False
                use_new = False

          if (not quiet) and (verbose ): #or report):
            print(quiet, verbose, report)
            
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
      
      
  print("\nDone  phase '%d' for '%s'. Processed %d entries. Matched %d entries." % (
    phase, file, stats.n_processed, stats.n_colisions) )
    
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

    if not opts.single_pass_only:
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
                    
parser.add_argument('--single', dest="single_pass_only", default=False, action="store_true",
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
                    
                
                    
                    
opts = parser.parse_args()

###########
           
if(opts.grep_only):
  opts.grep = True
  opts.single_pass = True
           
if(opts.grep):
  opts.report_folders = True

  
analyse_collection_files(opts, opts.final_file, opts.other_collection)


 






xml_data="""<?xml version="1.0" encoding="UTF-8"?>

<DJ_PLAYLISTS Version="1.0.0">
  <PRODUCT Name="rekordbox" Version="5.6.0" Company="Pioneer DJ"/>
  <COLLECTION Entries="10547">
 
    
    <TRACK TrackID="10495" Name="Self Control - Sakgra Pw Elle Mix" Artist="LAURA BRANIGAN"
           Composer="" Album="" Grouping="" Genre="" Kind="MP3 File" Size="7959445"
           TotalTime="233" DiscNumber="0" TrackNumber="1" Year="2019" AverageBpm="112.60"
           DateAdded="2020-01-14" BitRate="32" SampleRate="48000" Comments="Https://www.mediafire.com/file/gx9dihejravb2q3/laura branigan - self control %28sakgra pw elle mix%29.mp3/file"
           PlayCount="0" Rating="0" Location="file://localhost/C:/Root/Sync_Traktor/Traktor%20Music/8%20Pedro%20Archived/1%20Pop_Rock/80s%20Pop/80s%20Italo%20Hits/z_CD%20italo%20disco/cd3/01%20-%20LAURA%20BRANIGAN%20-%20Self%20Control%20-%20Sakgra%20Pw%20Elle%20Mix.mp3"
           Remixer="" Tonality="11A" Label="" Mix="">
      <TEMPO Inizio="0.060" Bpm="112.44" Metro="4/4" Battito="1"/>
      <TEMPO Inizio="13.400" Bpm="112.45" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="15.534" Bpm="112.47" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="17.668" Bpm="112.48" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="19.802" Bpm="112.50" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="21.936" Bpm="112.51" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="24.069" Bpm="112.52" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="26.202" Bpm="112.53" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="28.334" Bpm="112.54" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="30.467" Bpm="112.53" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="32.600" Bpm="112.54" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="41.130" Bpm="112.56" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="49.659" Bpm="112.57" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="51.791" Bpm="112.56" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="56.055" Bpm="112.47" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="58.189" Bpm="112.56" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="62.453" Bpm="112.55" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="66.718" Bpm="112.56" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="81.643" Bpm="112.55" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="88.040" Bpm="112.54" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="90.173" Bpm="112.53" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="94.438" Bpm="112.51" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="94.972" Bpm="112.51" Metro="4/4" Battito="3"/>
      <TEMPO Inizio="96.572" Bpm="112.53" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="100.837" Bpm="112.54" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="107.235" Bpm="112.55" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="111.500" Bpm="112.52" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="113.632" Bpm="112.27" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="115.770" Bpm="112.59" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="117.902" Bpm="112.50" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="120.035" Bpm="112.52" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="122.168" Bpm="112.55" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="124.300" Bpm="112.59" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="126.432" Bpm="112.58" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="128.564" Bpm="112.59" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="137.090" Bpm="112.58" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="141.354" Bpm="112.57" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="145.618" Bpm="112.56" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="147.750" Bpm="112.57" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="154.146" Bpm="112.56" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="162.675" Bpm="112.55" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="177.601" Bpm="112.57" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="179.733" Bpm="112.42" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="181.868" Bpm="112.41" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="184.003" Bpm="112.48" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="184.537" Bpm="112.48" Metro="4/4" Battito="3"/>
      <TEMPO Inizio="186.137" Bpm="112.53" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="188.270" Bpm="112.54" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="190.402" Bpm="112.56" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="192.534" Bpm="112.58" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="194.666" Bpm="112.59" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="203.193" Bpm="112.58" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="207.456" Bpm="112.57" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="211.720" Bpm="112.53" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="215.986" Bpm="112.35" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="220.258" Bpm="112.36" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="222.394" Bpm="112.37" Metro="4/4" Battito="2"/>
      <TEMPO Inizio="224.530" Bpm="112.38" Metro="4/4" Battito="2"/>
    </TRACK>
   
 
  </COLLECTION>
  <PLAYLISTS>
    <NODE Type="0" Name="ROOT" Count="1">
      <NODE Name="Italo Disco CDs" Type="0" Count="4">
        <NODE Name="cd1" Type="1" KeyType="0" Entries="23">
          <TRACK Key="10450"/>
          <TRACK Key="10451"/>
          <TRACK Key="10452"/>
          <TRACK Key="10453"/>
          <TRACK Key="10454"/>
          <TRACK Key="10455"/>
          <TRACK Key="10456"/>
          <TRACK Key="10457"/>
          <TRACK Key="10458"/>
          <TRACK Key="10459"/>
          <TRACK Key="10460"/>
          <TRACK Key="10461"/>
          <TRACK Key="10462"/>
          <TRACK Key="10463"/>
          <TRACK Key="10464"/>
          <TRACK Key="10465"/>
          <TRACK Key="10466"/>
          <TRACK Key="10467"/>
          <TRACK Key="10468"/>
          <TRACK Key="10469"/>
          <TRACK Key="10470"/>
          <TRACK Key="10471"/>
          <TRACK Key="10472"/>
        </NODE>
       
      </NODE>
    </NODE>
  </PLAYLISTS>
</DJ_PLAYLISTS>

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
#import xml.etree.ElementTree as ET
import lxml.etree as ET
import os, sys
import pandas as pd
import glob, os
import copy




def bpm_period(bpm):
    return (60.0 / bpm )

def find_min_beat(bpm, cue):
    period = bpm_period(bpm)
    
    beats = int(cue / period)
    ret = cue - beats * period
    return ret

def find_offset(bpm1, cue1, bpm2, cue2):
    return find_min_beat(bpm1, cue1) - find_min_beat(bpm2, cue2)

def next_beat(bpm, inizio, beats=4):
    
    period = bpm_period(bpm)
    position = inizio + period * beats
    return position


def bpm_to_st(bpm):
    return "%.2f" % (bpm)
    
def inizio_to_st(inizio):
    return "%.3f" % (inizio)


#file = xml_data
#root = ET.parse(file).getroot()
root = ET.fromstring(xml_data.encode('utf-8'))
collection=root.find('COLLECTION')


beats_window = 8

#for entry in collection:


entry = collection[0]
entry = copy.deepcopy(entry)

print(entry.get('AverageBpm'))
input_avg_bpm = float(entry.get('AverageBpm'))

set_bpm_to_first_entry = True

tempos = entry.findall('TEMPO')
len_cur = len(tempos)

if len_cur < 15:
    print('ignoring non-dynamic track')
    #continue
    
inizios = [x.get("Inizio") for x in tempos]
bpms = [x.get("Bpm") for x in tempos]
 
input_inizios = inizios[:4]
input_bpms = bpms[:4]
len_input = len(input_bpms)

if set_bpm_to_first_entry:
    output_bpm = float(bpms[0])
    print("Using first BPM instead: %.2f" % (output_avg_bpm))
    
else:
    output_bpm = input_avg_bpm
    print("Using average BPM: %s" % (bpm_to_st(output_avg_bpm)))
    
output_inizios = []
output_bpms = []
for i in range(len_input - 1):
    input_pos = float(input_inizios[i])
    input_bpm = float(input_bpms[i])
    
    pos = input_pos
    print(i , len_input)
    next_pos = float(input_inizios[i+1])
    
    print("")
    while pos < next_pos:
        output_inizios.append(pos) 
        output_bpms.append(input_bpm) 
        print(pos)
        
        pos = next_beat(input_bpm, pos, beats_window)

# re-write new XML entries
entry.set("AverageBpm", "")
entry_xml = tempos[0]
entry_xml = copy.deepcopy(entry_xml)

tempos.clear()
for inizio, bpm in zip(output_bpms, output_inizios):
    new_tempo_xml = copy.deepcopy(entry_xml)
    new_tempo_xml.set("Inizio", inizio_to_st(inizio))
    new_tempo_xml.set("Bpm", bpm_to_st(bpm))
        
    tempos.append(new_tempo_xml) 
        
        
for x in entry.find('')
entry.removeall()
        



    
    