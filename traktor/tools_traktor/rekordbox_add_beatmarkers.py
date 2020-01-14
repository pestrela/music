#!/usr/bin/env python3


              
help_text="""

This program takes a Rekorxdbox XML and adds beatmarkers every 8 beats.
This is useful to convert later to traktor, that lacks dynamic beatgrids

    
"""
help_text2=""
  

 

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
# https://docs.python.org/3.4/library/xml.etree.elementtree.html
import lxml.etree as ET
import os, sys
import pandas as pd
import glob, os
import copy



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
  
  
def dprint(debug, *args, **kwargs):
    if debug > 0:
      print(*args, **kwargs)
      
  
  
def bpm_period(bpm):
    return (60.0 / bpm )

def find_min_beat(bpm, cue):
    period = bpm_period(bpm)
    
    beats = int(cue / period)
    ret = cue - beats * period
    return ret

def find_offset(bpm1, cue1, bpm2, cue2):
    return find_min_beat(bpm1, cue1) - find_min_beat(bpm2, cue2)

def beats_period(bpm, beats):
    print(bpm, beats)
    
    period = bpm_period(bpm)
    ret = period * beats
    return ret
    
    
def advance_beat(bpm, inizio, beats=4):
    position = inizio + beats_period(bpm, beats)
    return position


def bpm_to_st(bpm):
    return "%.2f" % (bpm)
    
def inizio_to_st(inizio):
    return "%.3f" % (inizio)



  
def add_regular_beatmarkers(opts, file_in):
  print("")
  
  
  file_in2 = Path(file_in)
  file_out = Path(file_in2).stem + ".enriched.xml"
  
  max_process=opts.max_process
  
  stats = Stats()    
  stats.n_only_on_target=0
  stats.n_processed=0
  stats.n_enriched=0
  
  stats.n_colisions_prev_longer = 0
  stats.n_colisions_new_longer = 0
  stats.n_colisions_samelen = 0
  stats.n_colisions_samelen_prev_newer = 0
  stats.n_colisions_samelen_prev_older = 0
  stats.n_colisions_samelen_samedate = 0
 
  
  root = ET.parse(file_in).getroot()
  #root = ET.fromstring(xml_data.encode('utf-8'))
  #root = copy.deepcopy(root)
  
  collection = root.find('COLLECTION')


  for entry in collection:
    #entry = collection[0]
    #entry = copy.deepcopy(entry)
    
    
    
    track_name = entry.get('Name')
    track_location = entry.get('Location').replace("%20", " ")
    
    # this is for this entry only
    debug = opts.debug
    verbose = opts.verbose
    quiet = opts.quiet
    very_debug=opts.very_debug
    if very_debug:
      debug = True
    if debug:
      verbose = True
    if verbose:
      quiet = False
      
      
 
    stats.n_processed += 1
    if opts.max_process and (stats.n_processed > opts.max_process):
      print("Breaking early because of MAX_PROCESS")
      break
      
    
    if (opts.grep != "") and (track_location is not None):
      #print(opts.grep, name, folder)
      if re.search(opts.grep, track_location, re.IGNORECASE):
        #print("Found grep string: %s: " % (name))
        #very_debug = True  # just for this run
        quiet = False
        debug = True  
        verbose = True
      else:
        if opts.grep_only:
          if debug:
            #print("Skipping non-grep string %s" % (name))
            pass
          continue
    

    ####    
    dprint(debug, "Track:", track_name)
    dprint(debug, "BPM: ", entry.get('AverageBpm'))
    input_avg_bpm = float(entry.get('AverageBpm'))

    set_bpm_to_first_entry = True

    tempos = entry.findall('TEMPO')
    len_cur = len(tempos)
    
    if len_cur < opts.min_number_cues:
      dprint(verbose, 'IGNORING non-dynamic track (%d cues): %s' % (len_cur, track_name))
      continue
    else:
      dprint(debug, "processing dynamic Track (%d cues): %s" % (len_cur, track_name) )
        
    input_inizios = [x.get("Inizio") for x in tempos]
    input_bpms = [x.get("Bpm") for x in tempos]

    
    
    if opts.limit_cues:
      print("Limiting cues for debugging")
      input_inizios = input_inizios[:opts.limit_cues]
      input_bpms = input_bpms[:opts.limit_cues]
    
      print("input_inizios :", input_inizios )
      print("input_bpms :", input_bpms )
      
    len_input = len(input_bpms)

    if set_bpm_to_first_entry:
      output_avg_bpm = float(input_bpms[0])
      dprint(debug, "Original average BPM: %s" % (bpm_to_st(input_avg_bpm)))
      dprint(debug, "Using first BPM instead: %.2f" % (output_avg_bpm))

    else:
      output_avg_bpm = input_avg_bpm
      dprint(debug, "Using original average BPM: %s" % (bpm_to_st(output_avg_bpm)))

        
    output_inizios = []
    output_bpms = []
    for i in range(len_input - 1):
      print("_", i)
      input_pos = float(input_inizios[i])
      input_bpm = float(input_bpms[i])

      pos = input_pos
      dprint(debug, i , len_input)
      next_pos = float(input_inizios[i+1])
      
      pos_margin = 0.005
      next_pos = next_pos - pos_margin
      dprint(debug, "")
      
      
      print(beats_period(input_bpm, opts.beats_window))
      dprint(debug, "Before inner loop: this_BM: %f  period: %f    next_BM: %f     " %(
        pos, beats_period(input_bpm, opts.beats_window), next_pos )
        )
        
      while pos < next_pos:
        output_inizios.append(pos) 
        output_bpms.append(input_bpm) 
        
        pos = advance_beat(input_bpm, pos, opts.beats_window)
        dprint(very_debug, "After iteration inside INNER loop: pos: %f  next_pos: %f " %( pos, next_pos) )

        break
      
      break
      
    stats.n_enriched += 1
        
    len_output = len(output_inizios)
    if not quiet:
      print("Enriched track:  %d -> %d    (%s)" % ( len_input, len_output, track_name))

    # re-write new XML track header
    entry.set("AverageBpm", bpm_to_st(output_avg_bpm))
    entry_xml = tempos[0]
    entry_xml = copy.deepcopy(entry_xml)

    # re-write new XML cues
    for x in entry.findall('TEMPO'):
      entry.remove(x)

    for inizio, bpm in zip(output_bpms, output_inizios):
      new_tempo_xml = copy.deepcopy(entry_xml)
      new_tempo_xml.set("Inizio", inizio_to_st(inizio))
      new_tempo_xml.set("Bpm", bpm_to_st(bpm))

      entry.append(new_tempo_xml) 

  
  #########
  ### exit steps                    
  if not opts.save_output:
    print("==> SKIPPING final save. %s   (use -f to force changes)" % (file_out))
    
  else:  
    file_out2 = VersionedOutputFile(file_out, numSavedVersions=3)
    
    if very_debug:
        ET.dump(root)
     
    file_out2.write(ET.tostring(root, pretty_print=True).decode("utf-8"))
    
    file_out2.close()
    
    print("")
    print("")
    print("SAVED FILE: %s" % (file_out))
      
      
  print("\nDone '%s'. Processed %d entries. Enriched %d entries." % (
    file_in, stats.n_processed, stats.n_enriched) )
    
  if opts.verbose:
    stats.print()
    
  print("------------------")
  print("")
 

 
#########
parser = argparse.ArgumentParser(description='clone traktor cues based on number of cues')
parser.add_argument('-c', dest="final_file", required=True,
                    help='Main collection file. It will be replaced with a new version (old files are saved)')

                      
  
parser.add_argument('-b', dest="beats_window", default=8, type=int,
                    help='Maximum sequential beats WITHOUT a beatmarket')

parser.add_argument('-m', dest="min_number_cues", default=15, type=int,
                    help='minimum numbe of cues to consider track as dynamic')

                    
parser.add_argument('-d', dest="debug", default=False, action="store_true",
                    help='Debug flag')

parser.add_argument('-q', dest="quiet", default=False, action="store_true",
                    help='Quiet flag')

parser.add_argument('-v', dest="verbose", default=False, action="store_true",
                    help='Verbose flag')

parser.add_argument('-V', dest="very_debug", default=False, action="store_true",
                    help='Verbose flag')

                    
parser.add_argument('-g', dest="grep", type=str, default="", 
                    help='optional string to grep. Shows verbosity for that entry. Still processes that entry')

parser.add_argument('-G', dest="grep_only", type=str, default="", 
                    help='same, but skips processing of other entries')

                    
parser.add_argument('-f', dest="save_output", action="store_true", default=False, 
                    help='Actualy do save the final file')

parser.add_argument('-n', dest="max_process", default=None, type=int,
                    help='Max tracks to process')
                    
parser.add_argument('-N', dest="limit_cues", default=None, type=int,
                    help='Max cues to  process')
                    
      

###########
opts = parser.parse_args()
           
if(opts.grep_only):
  opts.grep = True
  opts.single_pass = True
           
if(opts.grep):
  opts.report_folders = True

  
add_regular_beatmarkers(opts, opts.final_file )






 







    
    