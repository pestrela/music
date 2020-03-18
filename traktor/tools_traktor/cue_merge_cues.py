#!/usr/bin/env python3

 
# base libraries 
import sys, os, glob, string, marshal
import string
import argparse
import os
import re
from collections import defaultdict
from functools import partial
from pathlib import Path
import glob

## extra libraries
from cueparser import CueSheet
import textwrap

## YAPU
from yapu.imports.internal import *
from yapu.multiline import grep_1, grep_not, grep

 

      
	
def add_leading_zero_TS(i):
  if ":" in i and len(i)==5:
    i = "0:" + i
  return i
    

def mixcloud_to_tracklist(text, n=4, fmt=None):
  """
  text = multi line string input
  n = amount to groupby
  fmt = which fields to print. default is all fields
  """

  text= text.splitlines()
  text = list( filter(None, text))
  if fmt is None:
    fmt = "".join([str(i) for i in list(range(n))])
  else:
    fmt = "".join([str(int(i)-1) for i in list(fmt)])
    
  for i in list_break(text, n):
    if True:
      i = list(map(add_leading_zero_TS, i))
        
      l=list(fmt)
      st = "{"+"} - {".join(l)+"}"
      #print(st, len(i), *i)
      st = st.format(*i).title()
      print(st)

      
      
def generate_cue(file_music, input_tl, input_cue):
  #  code run: https://try.jupyter.org/
  global opts
  file_music_base = Path(file_music).stem 

  try:
    cd_name = os.path.splitext(file_music)[0].split("-",1)[1].strip()
    #print(cd_name)
  except:
    cd_name = "untitled"

  # TODO:
  #  separate code from data files
  #  words in full caps are not capitalized (again)

  cue_ok = True
  ignored_header=False
  
  tl = []
  cue = []

  ## collect track positions
  indexes = []
  minutes = []
  for st in input_cue.splitlines():
    st = st.strip()
    

    if(re.search("^INDEX", st)):
        
      a, b, timestamp = st.split()
      
      minute, second, frame = timestamp.split(":")
      minute = int(minute) + opts.cue_offset_minutes
      minute = "%02d" % minute
      
      frame = int(frame)
      if(frame>59):
        #print("warning: adjusting non-standard frame to 59f")
        frame = 59
      
      
      timestamp = "%s:%s:%s" % (minute, second, frame)
      st = "%s %s %s" % (a, b, timestamp)
      if opts.debug:
        print("processing: %s" % st)
      indexes.append(st)
      
      minute_out = "%s min" % minute
      if len(minute) <= 2:
        minute_out = "%s " % (minute_out)
      minutes.append(minute_out)

  if len(indexes) == 0:
    die("Cue empty")

  cue.extend(['', '', 'FILE "%s" %s' % (file_music, opts.output_type)])
  cue.extend(['PERFORMER "DJ ESTRELA"'])
  cue.extend(['TITLE "%s"' % (cd_name)])
  cue.append('')

  if opts.debug:
    print("")
  
  count = 0
  for st in input_tl.splitlines():
    
    st = st.replace("\t","").strip()
    #st = grep(st, ['.mp3','.wav', '.m4a'])
    
    if st is None or st == "":
       continue

    if opts.has_tl_header and not ignored_header:
      ignored_header = True
      print("\nIgnoring TL header:\n %s \n" % st)
      continue

    if opts.debug:
      print(st)
      
    st = grep("-", st)
    
    if st is None or st == "":
      continue
      
    if opts.has_tl_header and not ignored_header:
      ignored_header = True
      print("\nIgnoring TL header:\n %s \n" % st)
      continue

    count += 1

    if opts.debug:
      print("processing: %s" % st)
    st = st.lower()

    st = st.replace(".mp3", "")
    st = st.replace(".wav", "")
    st = st.replace(".m4a", "")

    st = st.replace("(", "-")
    st = st.replace(")", "")
    st = st.replace("-", " - ")
    st = " ".join(st.split())    # remove white space

    st = st.replace("|", "-")

    if opts.debug:
      print(st)
      
    if opts.ignore_tl_num:
      st = " - ".join(st.split(" - ",1)[1:])

    l = st.split("-", 1)
    if(len(l)<= 1):
      print("\nline read: %s" % (st))
      die("Too few fields. Please use -n to disable track numbers")
    
    if opts.debug:
      print(l)
      
    num = "%02d" % (count)
    artist = l[0].strip().upper()
    #title = l[1].strip().title()
    
    title = string.capwords(l[1].strip())
    

    #print(artist)

    try:
      time_entry = indexes[count -1]
      minute_entry = minutes[count - 1]
    except:
      time_entry = ""
      minute_entry = "UNK"
    
    
    #st = " - ".join([minute_entry, artist, title])
    #st = "[%s] %s - %s" % (minute_entry, artist, title)
    st = "%s | %s - %s" % (minute_entry, artist, title)
    
    if opts.debug_short_cue and count >= 3:
      break
      
    
    # New Tracklist
    tl.append(st)
    if((count )%5 == 0):
      tl.append(".")

    # new Cue
    cue.append('TRACK %s AUDIO' % num)
    cue.append('\tPERFORMER "%s"' % artist)
    cue.append('\tTITLE "%s"' % title)
    cue.append('\t%s' % time_entry)
    
  cue.extend(['', '', ''])


  print("MERGE: Read %d CUE indexes" % (len(indexes)))
  print("MERGE: read %d TL tracks" % (count))
  
  if count == 0:
    die("TL empty")

  if len(indexes) != count:
    if not opts.debug_mismatch_sizes:
      die("Cue has different size than Tracklist. Check no newlines in the cue file. Use -z to accept it by force")
    else:
      print("Cue has different size than Tracklist")
    
    
  if not cue_ok:
      print("BAD CUE")
      print()

  #print(opts)
  if opts.gen_tl:
      # detailed tracklist for comments
      tl2 = [ ".", "%s" % (file_music_base), "." ]
      tl2.extend(tl)
      tl2.extend([".", "."])
      write_file(opts.file_tl, tl2)
      
      # simple tracklist for hearthis.at
      tl2_simple=tl.copy()
      tl2_simple = [ a for a in tl2_simple if a != "." ]
      #tl2_simple = [ a.replace("|", "-") for a in tl2_simple ]
      #tl2_simple = [ "-".join(a.split("-")[1:]) for a in tl2_simple ]
      write_file(opts.file_tl_simple, tl2_simple)

      if (not os.path.exists(opts.file_info)) or (opts.regen_nfo):
        # Todo: read from cue sheet these values
        # https://wiki.hydrogenaud.io/index.php?title=Cue_sheet
        
        mixcloud_base = "dj_estrela_80s"
        mixcloud_name = "80s-pop-cd3"
      
        url_hearat="https://hearthis.at/djestrela/%s" % (mixcloud_name)
        url_mixcloud="https://www.mixcloud.com/%s/%s" % (mixcloud_base, mixcloud_name)
        url_tracklist="https://github.com/pestrela/music/blob/master/tracklists/%s" % (opts.file_tl)
        url_lyrics="https://github.com/pestrela/music/blob/master/tracklists/%s" % (opts.file_lyrics)

        url_lyrics="https://github.com/pestrela/music/blob/master/tracklists" 
              
        simple_info=[ "Part XX of my XXXX mix series.",
"Tracklist and Lyrics on the first post comment.", 
".",
".",
"Download: %s" % (url_hearat),
"Streaming: %s" % (url_mixcloud), 
"Lyrics: %s" % ( url_lyrics ),
"Previous Mixes: http://www.djestrela.com",
".",
]


        write_file(opts.file_info, simple_info)
      
      
  if opts.gen_cue:
      cue2 = [ "", "" ]
      cue2.extend(cue)
      cue2.extend(["", ""])
      write_file(opts.file_cue, cue2)
 
  print("\nAll done.")


def remove_last_dot(file_base):
  if file_base[-1] == ".":
    file_base = file_base[:-1]
  return file_base

  
  
def read_file(file, encodings=["UTF-8", "ISO-8859-1"]):

  for encoding in encodings:
    try:
      with open(file, 'r', encoding=encoding) as f:
        ret = f.read()
        return ret
    except Exception as e:
      #print(e)
      pass
      
  die("Cannot read %s. Tried these encodings. Please run the file command" % (file))
    
 
  
def write_file(file, lines):
  global opts

  numSavedVersions = 3
  #if opts.do_write_no_backup:
  #  numSavedVersions = 0
  
  #print(numSavedVersions )
    
  if opts.do_write:
    if opts.do_write_no_backup:
      outf = open(file, "w")
    else:
      outf = VersionedOutputFile(file, numSavedVersions=numSavedVersions)
      
    outf.write("\n".join(lines))
    outf.close()
    print("Generated file: %s" % (file))
    
  else:
    print("\n".join(lines))
    print("No file generated (use -f/-F for that)")
    if opts.debug:
      print("Would write: %s" % (file))

      
def remove_empty_lines(input):
  ret = "\n".join([i for i in  input.split("\n") if i ] )
  return ret      
    
    
def process_one_set(opts):
     
  if opts.base is None:
    die("Need to specify basename")


  if opts.debug_mismatch_sizes:
    opts.do_write_no_backup = False
    opts.do_write = True
    

  if opts.debug_short_cue:
    pass
    #opts.debug = True

  if opts.do_write_no_backup:
    opts.do_write = True

   
  if (opts.gen_tl == False) and (opts.gen_cue == False):
    opts.gen_tl = True
    opts.gen_cue = True

   
  if opts.redo_all:
    opts.gen_cue = True
    opts.gen_tl = True
    opts.do_write = True
    
  if opts.dry_run:
    opts.gen_cue = False
    opts.gen_tl = False
    opts.do_write = False
   
    
  ###
  #print(file_base)

  file_base = os.path.basename(opts.base)
  file_base = Path(file_base).stem 
  file_base = remove_last_dot(file_base)
  print(file_base)

  file_music = "%s.mp3" % file_base
  opts.output_type="MP3"

  if os.path.isfile(file_music):
    print("MP3 file found")
  else:
    file_music = "%s.wav" % file_base
    opts.output_type="WAV"
    
    if os.path.isfile(file_music):
      print("WAV file found")
    else:
      die("No mp3 or WAV file found. Check for case sensitivity problems.")
   
  #print(file_base) 
    
  opts.file_cue = "%s.cue" % file_base
  opts.file_tl = "%s.txt" % file_base
  opts.file_tl_simple = "%s.tracklist" % file_base
  opts.file_info = "%s.nfo" % file_base
  opts.file_lyrics = "%s.lyrics" % file_base
  
  if opts.cuefile:
    input_cue = read_file(opts.cuefile)
  else:
    input_cue = read_file(opts.file_cue)
    

  input_cue = remove_empty_lines(input_cue)
  
  if opts.debug:
    print("\n\nRead CUE contents:")
    print(input_cue)


  if opts.reload_standard_tracklist:
    opts.tracklist = opts.file_tl
    

    
  if opts.tracklist:
    #opts.ignore_tl_num = True
    #opts.file_tl = opts.tracklist
    input_tl = read_file(opts.tracklist)
    
  else:
    print("Reading tracklist __from CUE file itself__")

    #  TODO: do this by hand
    
    from cueparser import CueSheet

    template_header = "%performer% - %title%\n%file%\n%tracks%"    # (also can be %format%, %rem%, %songwriter%)
    template_header = "%tracks%"
    template_tracks = "%performer% - %title%"     #(also can be %offset%, %index%, %songwriter%)

    cuesheet = CueSheet()
    #cuesheet.setOutputFormat(args.header, args.track)
    cuesheet.setOutputFormat(template_header, template_tracks)

    #cuesheet.setOutputFormat(args.header, args.track)
    #with open(cuefile, "r") as f:
    #    cuesheet.setData(f.read())

    cuesheet.setData(input_cue)
    
    import pdb
    try:
      has_error = False
      cuesheet.parse()
    except Exception:
      has_error = True
      print("ERROR: cue sheet error - check frames > 59\n Check also PREGAP 2 entries\n")
      
    #has_error = True
    if has_error:  
      pdb.set_trace()
      cuesheet.parse()
      sys.exit(1)
      
    input_tl = cuesheet.output()
    opts.ignore_tl_num = False
    opts.has_tl_header = False

  #print(input_tl)

  if opts.debug:
    print("\n\n------")
    print("TL FROM CUE READ:\n %s\n\n" % input_tl)
    #print("CUE READ:\n %s\n\n" % input_cue)

    
  generate_cue(file_music, input_tl, input_cue)

  
def mm_to_hhmm(st):
  a = int(st)
  ret = "%dh%02d" % (a//60, a%60)
  return ret
  
  
def convert_time1():

  print("Converting times from MMM to HH:MM format.\nUse 'q' to exit")
  
  while True:
    a = sys.stdin.readline().strip()
    if a == "q":
      sys.exit(1)  
    try:
      a = mm_to_hhmm(a)
      print(a)
    except:
      pass  
  
  
  
def convert_time2(base):
  out_file="%s.time.txt" % base
  
  with open(base, 'r') as reader:
    # Note: readlines doesn't trim the line endings
    lines = reader.readlines()

  with open(out_file, 'w') as writer:
    for line in lines:
      fields = re.split(r'(\s+)', line)
      ret = []
      for f1 in fields:
        #print("__", f1)
        if re.search("[0-9]+[:_]", f1):
          #print("__", f1)
          f1 = f1.replace("_", ":")
          p1, p2 = f1.split(":")
          p1 = mm_to_hhmm(p1)
          f1 = "m".join([p1, p2]) 
          #print("__", f1)
        
        ret.append(f1)        
      line = "".join(ret)
        
      #print(line, end="")
      writer.write(line)
      
  sys.exit(0)
   

        
  


parser = argparse.ArgumentParser(description="merge cues and tracklists",
  formatter_class=argparse.RawDescriptionHelpFormatter,
  epilog="""

example:
--------
 regenerate all tracklists (this folder): 
    cue_merge_cues.py . --folder -t  # -f

 regenerate all tracklists (recursive folders): 
    cue_merge_cues.py . --recursive -t  # -f

    
 create new set: 
    cue_merge_cues.py "DJ Estrela - MIX 11 CD01 - Vocal Trance - Mar 2005." -c -t -a  
     
"""
)


parser.add_argument('base', type=str, nargs='?',
                    help='Specify basename for all files')

parser.add_argument('tracklist',type=str, nargs='?',
                    help='Specify another file as the tracklist. If not present, TL is read from cue itself')

parser.add_argument('cuefile',type=str, nargs='?',
                    help='Specify another file as the cue file. If not present, CUE file derived from the basename')

                    
parser.add_argument('-T', dest="reload_standard_tracklist", default=False, action='store_true',
                    help='Read tracklist from standard basename (to avoid specifying it by hand)')

             
parser.add_argument('-F', dest="do_write",  default=False, action='store_true',
                    help='write files out')
parser.add_argument('-f', dest="do_write_no_backup",  default=False, action='store_true',
                    help='write files out - NO BACKUP')

                    
parser.add_argument('-H', dest="has_tl_header", default=True, action='store_false',
                    help='Keep first row as an header')
                    
parser.add_argument('-n', dest="ignore_tl_num", default=True, action='store_false',
                    help='Ignore track numbers from names')

parser.add_argument('-t', dest="gen_tl", default=False, action='store_true',
                    help='Redo Tracklist')

parser.add_argument('-N', dest="regen_nfo", default=False, action='store_true',
                    help='Regenerate nfo file')

                    
parser.add_argument('-c', dest="gen_cue", default=False, action='store_true', 
                    help='Redo Cue file')

####
parser.add_argument('-a', dest="redo_all", default=False, action='store_true', 
                    help='Redo CUE and TXT files')

parser.add_argument('-A', '--dry_run', dest="dry_run", default=False, action='store_true', 
                    help='Do not generate output, but do operations')
                 
parser.add_argument('-d', dest="debug", default=False, action='store_true',
                    help='debug')
parser.add_argument('-D', dest="debug_short_cue", default=False, action='store_true',
                    help='debug_short_cue')

parser.add_argument('-z', dest="debug_mismatch_sizes", default=False, action='store_true',
                    help='Accept different sizes of CUE and TL')

                    
parser.add_argument('--time_conversions', dest="do_time_calcs", default=False, action='store_true',
                    help='Do time calculations MMMM->HH:MM')
                    
                    
parser.add_argument('-O', '--offset', dest="cue_offset_minutes", default=0, type=int,
                    help='Apply an offset in minutes to the cue')
                    
                    


parser.add_argument('-g', '--glob_folder', '--folder', dest="glob_folder", default=False, action='store_true',
                    help='fix all mp3 files in the current folder')

                    
parser.add_argument('-G', '--recursive', dest="glob_recursive", default=False, action='store_true',
                    help='Recursivelly fix all files in the current folder (sub-folders)')

                    
opts = parser.parse_args()

###########

if opts.do_time_calcs:
  convert_time2(opts.base)
      

def process_glob(opts, recursive_folders=False):
  import copy
  
  #args_copy = copy.deepcopy(args)
  
  #saved_opts = opts.copy()
  #print("dede")
  
  
  if opts.glob_recursive:
    iter = Path('.').rglob('*.mp3')
  else:
    iter = Path('.').glob('*.mp3')
  
  
  for file in iter:
    print("Considering glob mp3: %s " % (file))
    
    opts.base = file
    process_one_set(opts)
   
   
if opts.glob_recursive:
  opts.glob_folder = True
   

if opts.glob_folder:
  process_glob(opts)
else:
  process_one_set(opts)
  
  
  
  
####
"""
  cleanup mixcloud:
     \1 - trance    SIM   (trackliss nos comentarios, cues regeneradas)
    
    tudo o resto nao:
  
  audition markers:
    https://community.adobe.com/t5/Audition/Export-via-markers-not-possible/td-p/4027389
    
"""

 