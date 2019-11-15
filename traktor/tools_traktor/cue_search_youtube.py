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

def print_verbose(verbose, *args, **kwargs):
    print_debug(verbose, *args, **kwargs)


def print_debug(debug, *args, **kwargs):
    if debug:
        print(*args, ** kwargs)
        

def is_dict(var):
    """
    is this a dict-like?
    """
    # see also  collections.Mapping
    return isinstance(var, dict)

def is_iterable(var):
    """
    is this iterable (INCLUDES str)
    """
    return isinstance(var, collections.Iterable)

def is_set(var):
    """
    is this a set
    """

    return isinstance(var, (set))

def is_list(var, *, debug=False):
    """
    is this a list or tuple? (DOES NOT include str)
    """

    print_debug(debug, "is_list: got type %s" % (type(var)))
    return isinstance(var, (list, tuple, pd.core.frame.DataFrame))    #numpy.ndarray  ???  <<<<< this has a bug!


def is_str(var):
    """
    is this a string?
    """

    # python2:
    # return isinstance(var, basestring)
    return isinstance(var, str)

def is_item(var):
    """
    is this a single item
    """
    return is_str(var) or (not is_iterable(var))

def is_dataframe(var):
    """
    is this a DF?
    """

    return isinstance(var, (pd.core.frame.DataFrame))


def is_number(var):
    """
    is this a Number?
    """

    return isinstance(var, numbers.Number)


def is_int(var):
    """
    is this an integer (ie, not a float)? 
    """

    return isinstance(var, int)




def is_datetime(var):
    """
    is this an DT
    """

    return isinstance(var, (datetime.datetime, datetime.date))



def is_index(var):
    """
    is this a DF index?
    """

    return isinstance(var, (pd.core.indexes.base.Index))




#####

def listify_safe(what, *, debug=False):
    """
    upgrade input to a list (except if it was already a list or a set)
    returns (list, original_type) to enable reversibility later

    output #1 is __ALWAYS__ a list, to enable iteration

    ---------------
    use case #1:  "None" means "no columns"
      cols = listify(cols)
      for col in cols:
          <do stuff>

    use case #2:  "None" means "all columns"
      cols = df_listify(df, cols)
      for col in cols:
          <do stuff>
    
    
    --------------
    TODO: expand this to be a class, with __getitem__
    """

    print_debug(debug, "listify: processing type %s" % (type(what)))
    
    if what is None:
        print_debug(debug, "listify: got None")
        return ([], 'none')
    elif is_set(what):
        print_debug(debug, "listify: got set()")
        return (list(what), 'set')
    elif is_list(what):
        print_debug(debug, "listify: got list()")
        return (list(what), 'list')         # calling list() on a list == NO ACTION
    else:
        print_debug(debug, "listify: got fallback")
        return ([what], 'item')


def listify(what, *, debug=False):
    """
    non-reversible version of listify_safe(). In this case "None" always means "no columns".
    output: list
    """
    l, _ = listify_safe(what, debug=debug)
    return l
    
    
def bash(cmd, prnt=True, wait=True):
    """
    Run a command via bash. Optionally prints results and waits for completion.
    return: stdout
    """
    p = Popen(cmd, stdout=PIPE, stderr=STDOUT, shell=True)
    if wait:
        p.wait()
    while True and prnt:
        line = p.stdout.readline()
        if line:
            print(line)
        else:
            break

    return (p)
    

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

  



class about_string_prefixes(str):
  """
  Custom mutable string class, with built-in regular expressions.
  
  other:
    https://stackoverflow.com/questions/10572624/mutable-strings-in-python
    https://stackoverflow.com/questions/7255655/how-to-subclass-str-in-python

  collections.userstring:
  """
    
  """  
  list of lexical prefixes:
    https://docs.python.org/3.6/reference/lexical_analysis.html#string-and-bytes-literals
  
  https://stackoverflow.com/questions/52360537/i-know-of-f-strings-but-what-are-r-strings-are-there-others
      strings: "\n" is a new line
    f-strings: format strings: "hello {name}"
    r-strings: raw literals:   "\n" is a backslash and the character 'n'
    b-strings: binary literals
    u-strings: unicode literals
  
  """
  


class RString(collections.UserString):
  """
  Implements mutable strings with regex methods. Suitable for chaining regexs.
  Also has built in debug.
  
  ----
  Mutable strings in python:
    question:  https://stackoverflow.com/questions/10572624/mutable-strings-in-python
    answer:    https://stackoverflow.com/questions/50875028/python-how-to-pass-an-instance-variable-to-method-as-implicit-argument-general/50878149#50878149
    code:      https://github.com/python/cpython/blob/e2e7ff0d0378ba44f10a1aae10e4bee957fb44d2/Lib/collections/__init__.py#L1098
    other:     https://stackoverflow.com/questions/7255655/how-to-subclass-str-in-python
    
  Regular Expressions:
    functions:    https://docs.python.org/2/library/re.html#re.sub
    simulator1:   https://regex101.com/
    simulator2:   https://pythex.org/

  Flags:
    re.DEBUG
    re.VERBOSE          Allows comments and whitespace 

    re.IGNORECASE       (ASCCII only)
    re.MULTILINE        '^' matches beginning of string + each neline; same for '$'
    re.DOTALL           '.' matches '\n'
    
    re.LOCALE
    re.UNICODE          \w, \W, \b, \B, \d, \D, \s, \S depends on locale/unicaode
  """
  
  def __init__(self, string, debug=False):
      super().__init__(string)
      self.debug = debug
        
        
  def re_sub_front(*args, **kwargs):
    self.re_sub(*args, front=False, **kwargs)

  
  def re_sub(self, pattern, repl="", count=0, flags=0, front=False):
    """
    wrapper to regex substitution
    #https://docs.python.org/2/library/re.html#re.sub
    """
    
    extra_help="""
    Return the string obtained by replacing the leftmost non-overlapping occurrences of pattern in string by the 
    replacement repl. If the pattern isn’t found, string is returned unchanged. 
    repl can be a string or a function; if it is a string, any backslash escapes in it are processed. 
    That is, \n is converted to a single newline character, \r is converted to a carriage return, and so forth. 
    Unknown escapes such as \j are left alone. Backreferences, such as \6, are replaced with the 
    substring matched by group 6 in the pattern.

    If repl is a function, it is called for every non-overlapping occurrence of pattern. 
    The function takes a single match object argument, and returns the replacement string. 

    The pattern may be a string or an RE object.

    The optional argument count is the maximum number of pattern occurrences to be replaced; 
    count must be a non-negative integer. If omitted or zero, all occurrences will be replaced. 
    Empty matches for the pattern are replaced only when not adjacent to a previous match, 
    so sub('x*', '-', 'abc') returns '-a-b-c-'.

    In string-type repl arguments, in addition to the character escapes and backreferences described above, 
    \g<name> will use the substring matched by the group named name, as defined by the (?P<name>...) syntax. 
    \g<number> uses the corresponding group number; \g<2> is therefore equivalent to \2, but isn’t ambiguous 
    in a replacement such as \g<2>0. \20 would be interpreted as a reference to group 20, not a reference to 
    group 2 followed by the literal character '0'. The backreference \g<0> substitutes in the entire substring 
    matched by the RE.
    """
    
    if self.debug:
      print("re_sub before: %s" % (self.data))
    
    pat_list = listify(pattern)
    
    for pat in pat_list:
      if front:
        pt = "^%s" % (pat)
    
      self.data = re.sub(pat, repl, self.data, count, flags)
      
    
    if self.debug:
      print("re_sub after: %s" % (self.data))
    
    return self
    
    
  def re_subn(self, pattern, repl, count=0, flags=0):
    """
    Perform the same operation as sub(), but return a tuple (new_string, number_of_subs_made).
    """
    
    self.data, number_of_subs = re.subn(pattern, repl, self.data, count, flags)
    
    return (self.data, number_of_subs)
    

  def re_debug_match(self, function, pattern, ret):
    if self.debug:
      print("%s result: %s %s" % ( function, pattern,  "[found]" if ret else "[not found]" ))
    
    
  def re_search(self, pattern, flags=0):
    """
    Scan through string looking for the first location where the regular expression pattern produces a match,
    and return a corresponding MatchObject instance. 
    Return None if no position in the string matches the pattern
    """
    
    ret = re.search(pattern, self.data, flags)
    
    self.re_debug_match("re_search", pattern, ret)
    
    return ret

    
  def re_match(self, pattern, flags=0):
    """   
    If zero or more characters at the beginning of string match the regular expression pattern, 
    return a corresponding MatchObject instance. Return None if the string does not match the pattern; 
    """

    ret = re.match(pattern, self.data, flags)
    
    self.re_debug_match("re_match", pattern, ret)
    
    return ret

    
  def re_split(self, pattern, maxsplit=0, flags=0):
    """
    Split string by the occurrences of pattern. 
    
    If capturing parentheses are used in pattern, then the text of all groups in the pattern are also 
    returned as part of the resulting list. 
    If maxsplit is nonzero, at most maxsplit splits occur, and the remainder of the string is 
    returned as the final element of the list. 
    """
    
    ret = re.split(pattern, self.data, maxsplit, flags)
    
    if debug:
      print("re_split return: %d slices" % (len(ret)))
      
    return ret    
    
    
  def re_findall(self, pattern, flags=0):
    """
    Return all non-overlapping matches of pattern in string, as a list of strings. 
    The string is scanned left-to-right, and matches are returned in the order found. 
    If one or more groups are present in the pattern, return a list of groups; 
    this will be a list of tuples if the pattern has more than one group. 
    Empty matches are included in the result.
    """
    
    ret = re.findall(pattern, self.data, flags)
    
    if debug:
      print("re_findall: return %d slices" % (len(ret)))
      
    return ret  
    
    
  def re_finditer(self, pattern, flags=0):
    """
    Return an iterator yielding MatchObject instances over all non-overlapping matches for the RE pattern in string. 
    The string is scanned left-to-right, and matches are returned in the order found. 
    Empty matches are included in the result. See also the note about findall().
    """
    
    ret = re.finditer(pattern, self.data, flags)
    
    if debug:
      pass
      #print("re_split: return %d slices" % (len(ret)))
      
    return ret  
    

  def re_escape(self):
    """
    Escape all the characters in pattern except ASCII letters and numbers. 
    This is useful if you want to match an arbitrary literal string that may have regular expression 
    metacharacters in it. 
    """
  
    self.data = re.escape(self.data)

    if debug:
      print("re_esacle return: %s" % (self.data))
    
    return self
    
    
  def re_remove_words(self, words):
    words = listify(words)
    
    for word in words:
      tokens = [i for i in self.data.split() if i != word ]
      self.data = " ".join(tokens) 
      
    return self
    
    
  def len(self):
    """
    A string length method. This enables writing left-to-right expressions.
    """
    
    return len(self.data)
  
  
  def strip3(self):
    """
    A string length method. This enables writing left-to-right expressions.
    """
    
    self.data = self.data.strip()
    return self

  
  def empty(self, strip=True):
    """
    checks if string is empty. Strips by default
    """
    
    if strip:
      self.strip()
      
    return self.len() == 0  
  
  
  def unicode_clean(self):
    """
    see also https://ftfy.readthedocs.io/en/latest/
    """
    #self.data = 
    self.data = self.data.replace('\u2013', "-")
    return self
    
    
class RStringD(RString):
  def __init__(self, string, debug=True):
      super().__init__(string, debug)

    
    
def unittest_String():
  #print( RString('dede dededd').re_sub('\s'))
  #print( RString('dede dededd').re_sub('\s').len())
  assert( RString('dede dededd').re_sub('\s').len() == 10 )
    
    
unittest_String()



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
                    help='Actually open chrome')
parser.add_argument('-q', dest="quiet", default=False, action='store_true',
                    help='Actually open chrome')
                    
                    
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
  
  
  
  
  