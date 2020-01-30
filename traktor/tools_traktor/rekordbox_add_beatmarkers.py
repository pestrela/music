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
import copy, math


from urllib.parse import urlparse


from yapu.imports.internal import *



 

def display_help():
  global help_text, help_text2

  print(help_text)
  print(help_text2)

  sys.exit(1)
		
    
    
def die(msg):
  print("Error: %s" % (msg))
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
    #print(bpm, beats)
    
    period = bpm_period(bpm)
    ret = period * beats
    return ret
    
    
def advance_beat(bpm, inizio, beats):
    position = inizio + beats_period(bpm, beats)
    return position


def bpm_to_st(bpm):
    return "%.2f" % (bpm)
    
def inizio_to_st(inizio):
    return "%.3f" % (inizio)

    
import re

def lreplace(pattern, sub, string):
    """
    Replaces 'pattern' in 'string' with 'sub' if 'pattern' starts 'string'.
    """
    return re.sub('^%s' % pattern, sub, string)

def rreplace(pattern, sub, string):
    """
    Replaces 'pattern' in 'string' with 'sub' if 'pattern' ends 'string'.
    """
    return re.sub('%s$' % pattern, sub, string)

def location_to_wsl(location):
  p = urlparse(location)
  st = os.path.abspath(os.path.join(p.netloc, p.path))
  st = lreplace("/C:/", "/mnt/c/", st)

  return Path(st)
  
    
def far_away_bpm(bpm1, bpm2):
  return not math.isclose(bpm1, bpm2, rel_tol=0.10)

  
def add_regular_beatmarkers(opts):
  print("")
    
  file_in = opts.file_in  
  file_in2 = Path(file_in)
  file_out = Path(file_in2).stem + ".enriched.xml"
  
  if not (opts.file_out is None):
    file_out = opts.file_out
    
  if not file_in2.exists():
    die("Unreadsable file: %s " % (file_in))
  
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
  stats.n_swings_bpm = 0
  
  root = ET.parse(file_in).getroot()
  #root = ET.fromstring(xml_data.encode('utf-8'))
  #root = copy.deepcopy(root)
  
  collection = root.find('COLLECTION')


  for entry in collection:
    #entry = collection[0]
    #entry = copy.deepcopy(entry)
    
    if opts.max_process and (stats.n_processed >= opts.max_process):
      print("Breaking early because of MAX_PROCESS")
      break

    
    track_name = entry.get('Name')
    track_location = entry.get('Location').replace("%20", " ")
    track_wsl = location_to_wsl(track_location)
    
    if opts.remove_unreadable_files:
      if not track_wsl.exists():
        dprint(verbose, "Ignoring unreadable track: %s" % (track_wsl))
        # HACK: this still needs to remove the entry in the XML :(
        
        continue
      else:
        print( "readable track: %s" % (track_wsl))
    
    # this is for this entry only
    debug = opts.debug
    verbose = opts.verbose
    quiet = opts.quiet
    very_debug = opts.very_debug
    regular = opts.regular
    
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
    dprint(very_debug, "Track:", track_name)
    dprint(very_debug, "BPM: ", entry.get('AverageBpm'))
    input_avg_bpm = float(entry.get('AverageBpm'))
    input_total_time = float(entry.get('TotalTime'))
    
    tempos = entry.findall('TEMPO')
    len_cur = len(tempos)
    
    dprint(very_debug, tempos[0].items())
    
    if len_cur < opts.min_number_cues:
      dprint(verbose, 'IGNORING non-dynamic track (%d cues): %s' % (len_cur, track_name))
      continue
    else:
      dprint(debug, "processing dynamic Track (%d cues): %s" % (len_cur, track_name) )
        
    stats.n_processed += 1

        
    input_inizios = [ float(x.get("Inizio")) for x in tempos ]
    input_bpms = [ float(x.get("Bpm")) for x in tempos ]


    
    # add fake "last" entry
    input_inizios.append(input_total_time)
    input_bpms.append(input_avg_bpm)
    
    #print(type(input_inizios[0]))
    #print(input_inizios)
    #return
    
    
    dprint(very_debug, "input_inizios :", input_inizios )
      
    if opts.limit_cues:
      print("Limiting cues for debugging")
      input_inizios = input_inizios[:opts.limit_cues]
      input_bpms = input_bpms[:opts.limit_cues]
    
      #print("input_inizios :", input_inizios )
      #print("input_bpms :", input_bpms )

    len_input = len(input_bpms)

    if opts.set_bpm_to_first_entry:
      output_avg_bpm = float(input_bpms[0])
      dprint(debug, "Original average BPM: %s" % (bpm_to_st(input_avg_bpm)))
      dprint(debug, "Using first BPM instead: %.2f" % (output_avg_bpm))

    else:
      output_avg_bpm = input_avg_bpm
      dprint(debug, "Using original average BPM: %s" % (bpm_to_st(output_avg_bpm)))

        
    output_inizios = []
    output_bpms = []
    for i in range(len_input - 1):
      input_pos = float(input_inizios[i])
      input_bpm = float(input_bpms[i])

      if far_away_bpm(input_bpm, input_avg_bpm):
        dprint(debug, "found swing BPM: %s" % (bpm_to_st(input_bpm)) )
        if opts.keep_bpm_swings:
          dprint(regular, "Warning: KEEPING swing BPM unchanged: %s" % (bpm_to_st(input_bpm)))
        else:
          dprint(regular, "Warning: IGNORING swing BPM %s;  using AVG instead: %s" % (
            bpm_to_st(input_bpm), bpm_to_st(input_avg_bpm)))
          input_bpm = input_avg_bpm

      pos = input_pos
      #dprint(debug, i , len_input)
      next_pos = float(input_inizios[i+1])
      
      pos_margin = 0.005
      next_pos = next_pos - pos_margin
      
      dprint(debug, "")
      dprint(debug, "")
      
      #dprint(debug, beats_period(input_bpm, opts.beats_window))
      dprint(debug, "Before entering while: this_BM: %f  period: %f    next_BM: %f     " %(
        pos, beats_period(input_bpm, opts.beats_window), next_pos )
        )
        
     # print(pos, next_pos)  
      while pos < next_pos:
        output_inizios.append(pos) 
        output_bpms.append(input_bpm) 
        
        pos = advance_beat(input_bpm, pos, opts.beats_window)
        dprint(debug, "  before reloop: pos: %f  next_pos: %f " %( pos, next_pos) )
      
      #break
      
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

    for bpm, inizio in zip(output_bpms, output_inizios):
      new_tempo_xml = copy.deepcopy(entry_xml)
      new_tempo_xml.set("Inizio", inizio_to_st(inizio))
      new_tempo_xml.set("Bpm", bpm_to_st(bpm))

      entry.append(new_tempo_xml) 

  
  #########
  ### exit steps                    
  if not opts.save_output:
    print("==> SKIPPING final save. '%s' (use -f to force changes)" % (file_out))
    
  else:  
    file_out2 = VersionedOutputFile(file_out, numSavedVersions=3)
    
    #sys.exit(0)
    if very_debug:
        ET.dump(root)
     
    file_out2.write(ET.tostring(root, pretty_print=True).decode("utf-8"))
    
    file_out2.close()
    
    print("")
    print("")
    print("SAVED FILE: %s" % (file_out))
      
      
  print("\nDone '%s'. Processed %d entries. Enriched %d entries. %d BPM swings" % (
    file_in, stats.n_processed, stats.n_enriched, stats.n_swings_bpm  ) )
    
  if opts.verbose:
    stats.print()
    
  print("------------------")
  print("")
 

 
#class DebuggedArgumentParser(ArgumentParser):
 # def __init__
 
 
 
                    
def add_debug_arguments(parser):
  parser.add_argument('-q', "--quiet", dest="quiet", default=False, action="store_true",
                      help='Quiet flag')
                      
  parser.add_argument('-R', "--regular", dest="regular", default=True, action="store_false",
                      help='Verbose flag')

  parser.add_argument('-v', "--verbose", dest="verbose", default=False, action="store_true",
                      help='Verbose flag')

  parser.add_argument('-d', "--debug", dest="debug", default=False, action="store_true",
                      help='Debug flag')
                      
  parser.add_argument('-D', "--very_debug", dest="very_debug", default=False, action="store_true",
                      help='Verbose flag')
  
  return parser
  
 
def parse_debug_arguments(opts):
  if opts.very_debug:
    opts.debug = True
    
  if opts.debug:
    opts.verbose = True
    
  if opts.verbose:
    opts.regular = True
    
 
  if opts.quiet:
    opts.regular = False
    opts.verbose = False
    opts.debug = False
    opts.very_debug = False
 
  return opts
  
 
#########
parser = argparse.ArgumentParser(description='clone traktor cues based on number of cues')
parser.add_argument('-i', "--file_in", dest="file_in", required=True, type=str,
                    help='Input file')
parser.add_argument('-o', "--file_out", dest="file_out", required=False, type=str, 
                    help='Output file. If not given, adds "enriched" to the input file')

                      
  
parser.add_argument('-b', "--beats_window",dest="beats_window", default=4, type=int,
                    help='Maximum sequential beats WITHOUT a beatmarker')

parser.add_argument('-m', "--min_number_cues", dest="min_number_cues", default=15, type=int,
                    help='minimum numbe of cues to consider track as dynamic')


                    
parser.add_argument('-g', "--grep", dest="grep", type=str, default="", 
                    help='optional string to grep. Shows verbosity for that entry. Still processes that entry')

parser.add_argument('-G', "--grep_only", dest="grep_only", type=str, default="", 
                    help='same, but skips processing of other entries')

                    
parser.add_argument('-f', "--force", dest="save_output", action="store_true", default=False, 
                    help='Actualy do save the final file')

parser.add_argument('-n', "--max_process", dest="max_process", default=None, type=int,
                    help='Max tracks to process')
                    
parser.add_argument('-N', "--max_cues", dest="limit_cues", default=None, type=int,
                    help='Max cues to  process')

parser.add_argument('-r', "--remove_unreadable_files", dest="remove_unreadable_files", default=False, action="store_true",
                    help='Remove files that cannot be read (WSL style)')
                                        
parser.add_argument('-F', "--set_bpm_to_first_entry", dest="set_bpm_to_first_entry", default=False, action="store_true",
                    help='Sets BPM to first entry (instead of the default AVG)')
                    
parser.add_argument('-B', "--keep_bpm_swings", dest="keep_bpm_swings", default=False, action="store_true",
                    help='Keeps BPM swings "as-is" in the output. By default, these are filtered out and the average BPM value is used')
                    
                    
      
parser=add_debug_arguments(parser)

###########
opts = parser.parse_args()
           
opts = parse_debug_arguments(opts)
           
if(opts.grep_only):
  opts.grep = True
  opts.single_pass = True
           
if(opts.grep):
  opts.report_folders = True

  
add_regular_beatmarkers(opts )




### Steps:
"""


rekordbox_add_beatmarkers.py -f -i s2\ -\ from_Rekordbox\ -\ small.xml -o s3\ -\ from_Rekordbox\ -\ enriched.xml                                          
dj-data-converter-linux -w  s3\ -\ from_Rekordbox\ -\ enriched.xml
mv collection.nml s4\ -\ converted\ collection.nml                                             
xml_pretty_print.sh s4\ -\ converted\ collection.nml  

traktor_clone_cues.py s4\ -\ converted\ collection.nml -c ../collection.nml -M -f



todo: 
- final part
- add detailed phase to jogs
- disable sync when pitch bend (add option to it)

- prepare transtions



"""







    
    