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
import collections

from subprocess import Popen, PIPE, STDOUT
import pandas as pd

#### YAPU
from yapu.imports.internal import *
from yapu.string import RString
from yapu.bash import bash



"""
about doing open source library
- remove pandas dependencies
- cleanup print_debug stuff

"""


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

###
### STRING wrapper functions. These functions ALWAYS return copies!
###

# awk string functions: https://www.gnu.org/software/gawk/manual/html_node/String-Functions.html
# python string functions: https://docs.python.org/2/library/string.html



def ml_clean_runs_of_empty_lines(ml):
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

     


dj_set = """

ID - ID - ID

1:07:27 - Giuseppe Ottaviani - Musica  [BLACK HOLE]   

??? 55:29 Menno De Jong - Ananda (Sean Tyas Remix) [ITWT (BLACK HOLE)]    F_r_t (14.1k) 24x0x2x
?? 59:18 UDM - Music For Life [DIGITAL SOCIETY (ENHANCED)]    F_r_t (14.1k) 13x0x1x
>>>>>>>>>>>>>>>>>>>>>>>>>>>> 62:15 Leroy Moreno - Technicolour [PURE TRANCE (BLACK HOLE)]    F_r_t (14.1k) 12x1x1x


++>> 65:57 Madwave & XiJaro & Pitch - Nothing Set In Stone [GROTESQUE]    F_r_t (14.1k) 28x1x1x
>>>>>>> conf 68:39 Simon Patterson - Us [RESET (SPINNIN')]    F_r_t (14.1k) 139x0x1x


"""

"""
1:00:27 - Paul van Dyk ft. Second Sun - Crush (Neptune Project Remix)  [VANDIT]   
1:03:28 - Paul van Dyk ft. Sue McLaren - Lights (Giuseppe Ottaviani Remix)  [ULTRA]   
1:07:27 - Giuseppe Ottaviani - Musica  [BLACK HOLE]   

      - Paul van Dyk ft. Vega 4 - Time Of Our Lives (UK Club Mix)  [ARMADA]   
1:22:18 - Paul van Dyk & Jordan Suckley - The Code  [VANDIT]   
1:26:50 - Paul Van Dyk vs. Alex M.O.R.P.H. & Heatbeat - Nothing But Amistad (Matt Bukovski Mashup)      [VANDIT]   
      - Paul van Dyk ft. Hemstock & Jennings - Nothing But You  [VANDIT]
      - Alex M.O.R.P.H. & Heatbeat - Amistad  [VANDIT]
1:29:43 - Paul van Dyk - For An Angel (Synfonic Remix)  [VANDIT]   
1:30:39 - Paul van Dyk vs. Dash Berlin ft. Vera Ostrova - Touched By Sky Falling Down (Matt Bukovski Mashup)      [AROPA?/?VANDIT]   
      - Dash Berlin ft. Vera Ostrova - Till The Sky Falls Down  [AROPA (ARMADA)]
      - Paul van Dyk - Touched By Heaven  [VANDIT]
1:32:44 - Paul van Dyk ft. Johnny McDaid - Home (Paul van Dyk 2014 Live Edit)  [ULTRA]   
1:36:00 - Paul van Dyk ft. Johnny McDaid - All The Stars (Paul van Dyk Club Mix)    
1:41:12 - Paul van Dyk & Emanuele Braveri ft. Rebecca Louise Burch - Escape Reality Tonight  [VANDIT]   
1:45:41 - Sam Laxton - Outlander  [DIGITAL SOCIETY (ENHANCED)]   
1:48:27 - Rafael Osmo - Renaissance (Giuseppe Ottaviani Remix)  [GO ON AIR (BLACK HOLE)]   
1:52:10 - Paul van Dyk ft. Plumb - I Don't Deserve You (Giuseppe Ottaviani Remix)  [VANDIT]   
1:56:20 - Paul van Dyk & Alex M.O.R.P.H. - Breaking Dawn  [VANDIT]   
1:59:53 - Paul van Dyk pres. Shine - SHINE Ibiza Anthem 2018  [VANDIT]   


"""  


dj_set ="""
 
B1	– Ride Committee* Feat. Roxy	Accident (Original Mix)	7:10

"""


parser = argparse.ArgumentParser(description='find lyrics from tracklists')
parser.add_argument('file_in', type=str, nargs='?',
                    help='Specify basename for all files')
parser.add_argument('-d', dest="debug", default=False, action='store_true',
                    help='Shows all debug messages to screen and error channel')
parser.add_argument('-D', dest="debug_if_notavailable", default=False, action='store_true',
                    help='Shows URLs when not found in screen as well (its always printed to "failed" file')
parser.add_argument('--dry_run', '--dry-run', dest="dry_run", default=False, action='store_true',
                    help='dry run - do not call google')

parser.add_argument('-f', dest="open_chrome", default=False, action='store_true',
                    help='Actually open chrome')
parser.add_argument('-s', dest="internal_set", default=False, action='store_true',
                    help='use internal test set')
parser.add_argument('-q', dest="quiet", default=False, action='store_true',
                    help='quiet')
                    
                    
opts = parser.parse_args()

#opts.debug = True
opts.debug_buf = StringIO()
  
  
chrome_exe="/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" 

if not opts.internal_set:
  print("Input tracklist:\n")
  dj_set = sys.stdin.read()
  opts.open_chrome = True
  
  
ret=[]
for line in dj_set.split('\n'):
  line = RString(line).strip().lower()

  printd(opts, "Input string: %s" % (line))

  line.unicode_clean()
  
  
  # ignore non-tracks
  if not "-" in line:
    printd(opts, "Ignoring: %s" % (line))
    continue
    
  # ignore tracks already known
  if line.re_match(r"^\+"):
    continue
  
  # ignore tracks to download
  if line.re_match(r"^\>"):
    continue

 
  # remove K7 tags
  line.re_sub("^[ab][1-9]\s", ' ')
  
  
  # remove tags (ID, conf, etc)
  line.re_remove_words(["id", 'conf'])
  
  #remove everything until first character
  line.re_sub(r"^[^a-zA-Z]+")
  
  #same for end of string
  line.re_sub(r"[^a-zA-Z]+$")
  
  #remove dashes and [release]
  line.re_sub(r"\-").re_sub(r"\*").re_sub(r'\[.*$').strip()
    
  
  if line.empty():
    print("line ended up being empty after replacements")
    continue
    
  printd(opts, "Clean string: %s" % (line))
  
  line = "youtube %s" % (line)
  
  printd(opts, "To search in Google: %s" % (line))
  line = quote_plus(line)
  
  url = 'http://www.google.com/search?q=' + line
  printd(opts, "Google URL: %s " % (url))

  result = requests.get(url, headers=requests_hdr1).text
  link_start = result.find("https://www.youtube.com/watch")
  
  if(link_start == -1):
    printd(opts, "track not found on google"  )
    continue
    
  link_end = result.find('"', link_start + 1)
  
  
  link = result[link_start:link_end] #.lower()
  
  if "&" in link:
    print("warning: link has '&' - %s " % (link) )
  
  
  link = re.sub(r"&.*", '', link)    # Remove PHP nonesense

  print("Considering this link: %s" % (link))

  ret.append(link)
  
  
if not len(ret):
  print("NOTHING TODO")
  sys.exit(0)
    
  
#### open chrome
# chrome command line switches:  https://peter.sh/experiments/chromium-command-line-switches/
urls = ["'%s'" % (i) for i in ret] 

cmd = "'%s' %s " % (chrome_exe, " ".join(urls) )
  
print("")  
print("TODO: %s" % (cmd))

if opts.open_chrome:
  bash(cmd, wait=False)
  
  
  
  
  