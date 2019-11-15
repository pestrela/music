#!/usr/bin/env python3

# coding=utf-8
from bs4 import BeautifulSoup
import dbus
import re
import requests
import sys
import argparse
import time
#import StringIO
from io import StringIO
import argparse
import os
import re
from collections import defaultdict
from functools import partial
from pathlib import Path
import glob
from enum import Enum 



#
# genius scraper:
#   https://gitlab.com/kenogo/spotify-lyrics-cli/blob/master/spotify_lyrics_cli/__init__.py
#
# metrolyrics scraper:
#   https://github.com/bhrigu123/Instant-Lyrics/blob/master/src/lyrics.py 
#

#
# sentiment analysis in popular artists:
#   https://kvsingh.github.io/lyrics-sentiment-analysis.html
#  
# rapidAPI:
#   https://rapidapi.com/brianiswu/api/genius?endpoint=apiendpoint_f78daab1-bdc9-47a6-b193-34717bf458e2
#
# beets:
#   https://github.com/beetbox/beets/blob/v1.3.17/beetsplug/lyrics.py

# todo:
#   add trancehub / lyrichub
#   add musicmatch



use_cases="""
everything found:
  screen:
    01-artist-ttile (found)
    02-artist-ttile (found)
    ...
  lyrics file:
   01-artist-ttile (found)
      ..
      ..
    02-artist-ttile (found)
  fail file: deleted
      
some things not found:
  screen:
    01-artist-ttile (not found)
    02-artist-ttile (found)
    ...
  lyrics file:
    01-artist-ttile (found)
      [NA]
      ..
    02-artist-ttile (found)
  fail file: 
   01-artist-ttile 
      url1
      url2
    (no track 02)
          
          
with -D:
  show on screen as well the failures
  
with -d:
  show on screen as well everything

with -v:
  show final lyrics on sceen as well   
      


"""


########
# Pedro Utils

def ml_clean_runs_of_empty_lines(ml):
  ## NEW NEW NEW
  """
  removes runs of empty lines

  input is multi line
  output is a list of lines 

  # function parameters:
  #   ml         = multiline string. THIS IS ONLY USED AS INPUT
  #   line       = single string
  #   lines      = list of strings
  #   what       = either STRING  or LINES   (unlistify-style)     
  """
  ml = ml.strip()
  lines = ml.split("\n")

  ret = []
  include=True
  for line in lines:
   if line != "":
     include = True
     
   if include:
      ret.append(line)
      
   if line == "":
     include = False
      
  return ret
     
     

def pause():
  try:
    input("Press enter to continue")
  except SyntaxError:
      pass
    
    
def die(st, die=True):
    print("\n\nError: %s\n\n" % st)
    if die:
      sys.exit(1)

def warn(st):
    die(st, die=False)




def print_nl(what=None):
    """
    prints lists with one element 
    """
    what = listify(what)
    print(*what, sep="\n")


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
    

########
# Beets Utils 

DIV_RE = re.compile(r'<(/?)div>?', re.I)
COMMENT_RE = re.compile(r'<!--.*-->', re.S)
TAG_RE = re.compile(r'<[^>]*>')
BREAK_RE = re.compile(r'\n?\s*<br([\s|/][^>]*)*>\s*\n?', re.I)
URL_CHARACTERS = {
    u'\u2018': u"'",
    u'\u2019': u"'",
    u'\u201c': u'"',
    u'\u201d': u'"',
    u'\u2010': u'-',
    u'\u2011': u'-',
    u'\u2012': u'-',
    u'\u2013': u'-',
    u'\u2014': u'-',
    u'\u2015': u'-',
    u'\u2016': u'-',
    u'\u2026': u'...',
}


def unescape(text):
    """Resolves &#xxx; HTML entities (and some others)."""
    if isinstance(text, bytes):
        text = text.decode('utf8', 'ignore')
    out = text.replace(u'&nbsp;', u' ')

    def replchar(m):
        num = m.group(1)
        return unichr(int(num))
    out = re.sub(u"&#(\d+);", replchar, out)
    return out


def extract_text_between(html, start_marker, end_marker):
    try:
        _, html = html.split(start_marker, 1)
        html, _ = html.split(end_marker, 1)
    except ValueError:
        return u''
    return html


def extract_text_in(html, starttag):
    """Extract the text from a <DIV> tag in the HTML starting with
    ``starttag``. Returns None if parsing fails.
    """

    # Strip off the leading text before opening tag.
    try:
        _, html = html.split(starttag, 1)
    except ValueError:
        return

    # Walk through balanced DIV tags.
    level = 0
    parts = []
    pos = 0
    for match in DIV_RE.finditer(html):
        if match.group(1):  # Closing tag.
            level -= 1
            if level == 0:
                pos = match.end()
        else:  # Opening tag.
            if level == 0:
                parts.append(html[pos:match.start()])
            level += 1

        if level == -1:
            parts.append(html[pos:match.start()])
            break
    else:
        print('no closing tag found!')
        return
    return u''.join(parts)


def search_pairs(item):
    """Yield a pairs of artists and titles to search for.

    The first item in the pair is the name of the artist, the second
    item is a list of song names.

    In addition to the artist and title obtained from the `item` the
    method tries to strip extra information like paranthesized suffixes
    and featured artists from the strings and add them as candidates.
    The method also tries to split multiple titles separated with `/`.
    """

    title, artist = item.title, item.artist
    titles = [title]
    artists = [artist]

    # Remove any featuring artists from the artists name
    pattern = r"(.*?) {0}".format(plugins.feat_tokens())
    match = re.search(pattern, artist, re.IGNORECASE)
    if match:
        artists.append(match.group(1))

    # Remove a parenthesized suffix from a title string. Common
    # examples include (live), (remix), and (acoustic).
    pattern = r"(.+?)\s+[(].*[)]$"
    match = re.search(pattern, title, re.IGNORECASE)
    if match:
        titles.append(match.group(1))

    # Remove any featuring artists from the title
    pattern = r"(.*?) {0}".format(plugins.feat_tokens(for_artist=False))
    for title in titles[:]:
        match = re.search(pattern, title, re.IGNORECASE)
        if match:
            titles.append(match.group(1))

    # Check for a dual song (e.g. Pink Floyd - Speak to Me / Breathe)
    # and each of them.
    multi_titles = []
    for title in titles:
        multi_titles.append([title])
        if '/' in title:
            multi_titles.append([x.strip() for x in title.split('/')])

    return itertools.product(artists, multi_titles)


######
# Instant-Lyrics 
    
requests_hdr1 = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11'
           '(KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
           'Accept-Language': 'en-US,en;q=0.8',
           'Connection': 'keep-alive'}
           
           

try:
  from urllib.parse import quote_plus
except ImportError:
  from urllib import quote_plus

    
class Backend(object):
  def __init__(self):
    pass
      
    
  def download(self, url):
    requests_hdr2 = {
           'User-Agent': 'Mozilla/5.0 (Macintosh; Intel'
           'Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, '
           'like Gecko) Chrome/55.0.2883.95 Safari/537.36'
           }
           
    html = requests.get(url, headers=requests_hdr2).text
    soup = BeautifulSoup(html, "lxml")
    
    
    delete_inner_scripts=True
    if delete_inner_scripts:
      _ = [s.extract() for s in soup('script')]
    
    return soup
    
    
  def scrape(self, url):
    soup = self.download(url)

    raw_lyrics = str(soup.findAll(self.scrape_what, self.scrape_attrs))
    lyrics = raw_lyrics[1:len(raw_lyrics)-1]   # remove list chars
    lyrics = re.sub(r"<[^<>]*>", '', lyrics)   # Remove HTML tags
    
    if sys.version_info < (3, 0):
      lyrics = re.sub(r"\\n", '\n', lyrics)

      
    lines = ml_clean_runs_of_empty_lines(lyrics)
    return lines
    

       
   
    
 # see also www.songlyrics.com 
 
class Genius(Backend):
  def __init__(self):
    self.name="genius"
    self.google_st="genius lyrics"
    self.url_start="https://genius.com"
    self.scrape_what="div"
    self.scrape_attrs={'class': 'lyrics'}
      
      
class FlashLyrics(Backend):
  def __init__(self):
    self.name="flashlyrics"
    self.google_st="flashlyrics"
    self.url_start="https://www.flashlyrics.com"
    self.scrape_what="div"
    self.scrape_attrs={'class': 'main-panel-content'}
    
    

class MusixMatch(Backend):
  def __init__(self):
    self.name="musixmatch"
    self.google_st="musixmatch"
    self.url_start="https://www.musixmatch.com"

    self.scrape_what="span"
    self.scrape_attrs={'class':'lyrics__content__warning'}

class LyricsWorld(Backend):
  def __init__(self):
    self.name="lyricsworld"
    self.google_st="lyricsworld"
    self.url_start="https://lyricsworld.ru/"

    self.scrape_what="p"
    self.scrape_attrs={'id':'songLyricsDiv', 'class':'songLyricsV14'}

    
class MetroLyrics(Backend):
  def __init__(self):
    self.name="metrolyrics"
    self.google_st="metrolyrics"
    self.url_start="http://www.metrolyrics.com"

  def scrape(self, url):
    soup = self.download(url)
  
    raw_lyrics = (soup.findAll('p', attrs={'class': 'verse'}))
    paras = []
    try:
      final_lyrics = unicode.join(u'\n', map(unicode, raw_lyrics))
    except NameError:
      final_lyrics = str.join(u'\n', map(str, raw_lyrics))

    final_lyrics = (final_lyrics.replace('<p class="verse">', '\n'))
    final_lyrics = (final_lyrics.replace('<br/>', ' '))
    final_lyrics = final_lyrics.replace('</p>', ' ')
    return (final_lyrics)
        
    

###############    

        
      
class Track(object):
  def __init__(self):
    self.artist= ""
    self.title= ""
    self.found=False
    self.lyrics=""
        
        
  def set_track(self, artist, title):
    self.title = title.lower()
    self.artist = artist.lower()

    ### Artist: loose
    # remove synergies, singers, etc
    self.artist = re.sub(r"vs\..*", "", self.artist)
    self.artist = re.sub(r"ft\..*", "", self.artist)
    self.artist = re.sub(r"feat\..*", "", self.artist)
    self.artist = re.sub(r"pres\..*", "", self.artist)

    #print(self.artist)
    
    # keep first 2 words only
    self.artist = " ".join(self.artist.split()[:2])
    #print(self.artist)

    
    ### Title: more strict
    self.title = re.sub(r"\(.*\)|\[.*\]", '', self.title) # removes: (feat.) [extended cut]
    self.title = re.sub(r"-.*", '', self.title) # removes: - Remastered ...

    
    return self
    
     
    
def printd(opts, *args, **kwargs):
    """ 
    prints a debug message to the debug buffer
    
    optionally prints it immediate on the screen as well.
    """

    # sprintf style string building
    buf = StringIO()
    buf.write("debug: ")
    buf.write(*args, **kwargs)
    buf.write("\n")
    st = buf.getvalue()
    
    if opts.debug:
        print_nonl("%s" % st)

    opts.debug_buf.write(st)

    
def dump_buf_to_file(opts, buf, file):
    """ 
    prints a buffer to a file.
    
    optionally prints it on the screen as well.
    """
    
    with open(file, mode='w') as f:
        print(buf.getvalue(), file=f)

    
    
def get_lyrics(opts, _artist, _title, debug=False, backends=None):
  global requests_hdr1, requests_hdr2
  
  if backends is None:
    #backends = [LyricsWorld]
    backends = [Genius, MusixMatch, MetroLyrics, LyricsWorld, FlashLyrics]
    
  #debug = True

  State = Enum('State', ['not_found', 'instrumental', 'found'])
  
  opts.debug_buf = StringIO()
  
  printd(opts, "")
  printd(opts, "")
  printd(opts, "")
  printd(opts, "")
  printd(opts, "Doing %s - %s" % (_artist, _title))

  track = Track()
  track = track.set_track(_artist, _title)

  printd(opts, "Reduced search: %s - %s" % (track.artist, track.title))

  
  track.found = State.not_found
  for back in backends:
    time.sleep(0.1)
  
    backend = back()
    printd(opts, "")
    printd(opts, "Doing Backend: %s" % backend.name)
    
    # Google for Lyrics
    search_name = "%s %s %s" % (track.artist, track.title, backend.google_st)

    printd(opts, "To search in Google: %s" % (search_name))
    name = quote_plus(search_name)
  
    url = 'http://www.google.com/search?q=' + name
    printd(opts, "Google URL: %s " % (url))

    result = requests.get(url, headers=requests_hdr1).text
    link_start = result.find(backend.url_start)
  
    if(link_start == -1):
      printd(opts, "track not found on %s" % (backend.name) )
      continue

        
    link_end = result.find('"', link_start + 1)
    link = result[link_start:link_end].lower()
    link = re.sub(r"&.*", '', link)    # Remove PHP nonesense

    printd(opts, "Considering this link: %s" % (link))

    link_correct = check_link_is_correct(track.artist, track.title, link)
    if not link_correct :
       printd(opts, "Link exists, but its for the wrong track: %s" % (link) )
       continue

    ##### Scrape it   
    
    if opts.dry_run:
      print("Exiting because of dry_run")
      break
    
    track.lyrics = backend.scrape(link)
    
  
    if len(track.lyrics) <= 2:
      track.found = State.instrumental 
      continue                               # continue searching in this case
      
    else:
      track.found = State.found 
      break

    
  ###########  
  printd(opts, "")

  write_debug = False
  if track.found == State.found:
    print("       [FOUND in %s]" % (backend.name) )
  
  elif track.found == State.instrumental:
    print("      [INSTRUMENTAL]" )
    track.lyrics = ["[INSTRUMENTAL]"]
    
    if opts.debug_instrumentals:
      write_debug = True
      
  elif track.found == State.not_found:
    print("     [NOT FOUND]")
    track.lyrics = ["[NA]"]
    write_debug = True
    
  else:
    die("Unknonw state")
    
  if write_debug or opts.debug:
    opts.error_channel.write(opts.debug_buf.getvalue())
    opts.any_failure = True
        
    
  return track


def get_lyrics_oneline(opts, line, **kwargs):

  artist = line.split("-")[0]
  title = line.split("-")[1]
    
  return get_lyrics(opts, artist, title)

  
  
    
###############    
    

parser = argparse.ArgumentParser(description='find lyrics from tracklists')
parser.add_argument('file_in', type=str, nargs='?',
                    help='Specify basename for all files')
parser.add_argument('-d', dest="debug", default=False, action='store_true',
                    help='Shows all debug messages to screen and error channel')
parser.add_argument('-D', dest="debug_if_notavailable", default=False, action='store_true',
                    help='Shows URLs when not found in screen as well (its always printed to "failed" file')
                    
parser.add_argument('-p', dest="pause", default=False, action='store_true',
                    help='pause between every track')

parser.add_argument('-I', dest="debug_instrumentals", default=True, action='store_false',
                    help='skip debugging instrumentals')
                    
                    
parser.add_argument('-s', '--sleep', dest="sleep", default=1.0, type=float,
                    help='delay between every track')

parser.add_argument('--one', dest="do_one_track", default=None, type=str,
                    help='do a single track')

parser.add_argument('--dry_run', '--dry-run', dest="dry_run", default=False, action='store_true',
                    help='dry run - do not call google')

opts = parser.parse_args()

n = 0
max = 332

if opts.debug:
  opts.debug_if_notavailable = True

opts.file_out_l = Path(opts.file_in).with_suffix(".lyrics")
opts.file_out_e = Path(opts.file_in).with_suffix(".lyrics_error")
opts.any_failure = False
#opts.error_channel = StringIO()


if opts.do_one_track:
  opts.debug = True
  opts.error_channel = StringIO()
  
  track = get_lyrics_oneline(opts, opts.do_one_track)

  for line in track.lyrics:
    print("\t%s" % (line))
  sys.exit(0)
  

  
  
  

with open(opts.file_in) as file_in, open(opts.file_out_l, 'w') as out_channel, open(opts.file_out_e, 'w') as error_channel:
  opts.error_channel = error_channel
  
  for line_raw in file_in.readlines():
    line_raw = line_raw.strip()
    #if not " min  | " in line_raw:
    #  continue

    n = n + 1
    if n > max:
      break

    print_nonl("%s" % (line_raw))

    line = line_raw.split("|")[1]
    
    track = get_lyrics_oneline(opts, line)

    # dump final output to file
    print("\n%s\n" % (line_raw), file=out_channel)
    for line in track.lyrics:
       print("\t%s" % (line), file=out_channel)

    print("\n", file=out_channel)
    
    if opts.pause:
      pause()
    
    time.sleep(opts.sleep)
    
    
# remove final error file if no errors
if not opts.any_failure:
    Path(opts.file_out_e).unlink()

    
print("\n\nAll Done")
  
