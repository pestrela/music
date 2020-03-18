#!/usr/bin/env python3

# 

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
import glob
from enum import Enum 


from yapu.imports.internal import *
from yapu.files import DPath

from yapu.multiline import *
from yapu.string import *
from yapu.html import *

from googleapiclient.discovery import build as google_build_query 


State = Enum('State', ['not_found', 'instrumental', 'found'])


#
# todo: add https://www.whosampled.com/

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
#   

watermarks=[
  "Report lyrics",
]


exception_table={

"DAFT PUNK VS MODJO - One More Lady - DJ Stein Mix" : 
"MODJO - Lady",

"PUSSY DUB FOUNDATION - Make The World Go Round" : 
"Antoine Clamaran - Get Up lyrics",

"SUPALA VS MAW - Work Alert - DJ Estrela Edit":
"MASTERS AT WORK - Work",

"LOCAL BOY - Thriller - Medley With Owner Of A Lonely Heart":
"YES - Owner of a lonely heart",

"EUROPE VS MODERN TALKING - Djsakgra Mashup Mix":
"europe - the final countdown",

"CHRISS - With A Boy Like You":
"The Troggs - With A Girl Like You",


}

# Nora Serafino - Get Back Into My Heart (Dub Mix) 1987
# Future Sense - Heartaches
# Andy Rosnay - Rêve Etrange (
# >>> Paradiso - Paradise Mi Amor
# >>>> the voyagers - distant planet

# playlist a ver: https://www.youtube.com/watch?v=SOIcQSz8sPY&list=PLEC53D7269E3E2E68&index=3&t=0s
# outra playlist a ver (sets) https://www.youtube.com/watch?v=8ROsTZuzoXo&list=PL97UX1SiB5bqLTwCts033N_sXMAEF2bu7&index=1
# another list: http://www.circuitandanthems.com/80sItaloDiscoCollection.html
# https://www.youtube.com/playlist?list=FLyghFpzbDaPh7OHd5nO1USw
# https://www.youtube.com/playlist?list=PLkmIVxFc_lLFJkV0jxuNFwhg4okrvTv8C





# List of Italo Disco lyrics: https://www.discogs.com/group/thread/536249

custom_table={



"BABY'S GANG - My Little Japanese Boy":
"""

Japanese ,japanese, japanese boy.

I have a special friend. 
We are walking hand in hand, 
we go round 
oh ho.

 I love his magic eye, 
he's so crazy, 
he's so fine, 
the best in town.
oh ho 

I like to talk with him, 
he's my special little dream,
 i think i prison? because he is mine?
He's come from very far,
 he's the perle ? visual? star.
 And when he  is mine,
 i get so high. 

Ref: You are my friend,
 my little japanese boy,
 My liitle man , 
for you i give up my Toys?  

I  Have a special friend
 ,we are walking hand in hand 
we will go round
goes down town

i.i. i .have .......a special friend....we we we are walking

we and my little friend
we are walking to the old magic man 
oh ho
we go to magic eye
very .....?  special husband 
 he is just fit and fine

you pass it in your hands
there it in your button is

there you can live it in a dream

were you can find the child
following my superboy
the time is right 
we try to see

Ref: You are my friend
my little japanese boy
my little man 
for you i give up my toy

Ref: You are my Friend
my little Japanese boy
we come again 
my special wonderfull guy

hahaha can't find it on internet so treid to listen back and back again ciao Niels from the 

""",

"SWEET CONNECTION - Heart To Heart - Vocal Mix":
"""
boy
the magic in your eyes i know
I cant believe it

its true
i feel my burning heart in crisis

oh yeah I need you
and you will see 
together we strong
we will get it trough
whaever goes wrong

[pre-chorus]
so cant you feel my heartbeat
your body next to mine

[chorus]
were heart to heart
oh boy i do love you
soul to soul
come carry my love

heart to heart
never know what i should do 
baby without you
heart to heart

heart to heart
soul to soul
carry my love

in
i know I'm the only one
i hope forever
you
you kiss me once again I knew
i'll see togetehr

we are like a ball protecting 
cause our love will keep us strong

""",

"SHEILA STEWART - It's You":
"""

Do you know what I want to say?
Do you say what I want to play?
Do you know? I am now so in love with you
without I don't know what to do. 

You're all I want and I am so afraid
That your turn away someday
Here is you that's all I wanted of the heart.

Ref: You are all that I'm living for
I have nothing to ask for.
You are all that I'm living for
I never could ask for more.

Can you see what I want to say?
Can you know what I want to play?
Can you know? I could never to without you
Without you I am feeling blue.

You're all I want and I am so afraid
That you go away someday
Must I go or must I stay?
So we can't play

Ref: You are all that I'm living for
I have nothing to ask for.
You are all that I'm living for
I never could ask for more.

Should I stay or should I go?
I don't know.
Should I stay or should I go?
I don't know.
""",





"DR MARTINI - You Are The One":
"""
How many times I called you?
How many times?
How many times?
Day after day I need you
Every day you break my heart
We need to be together
And I can still be really on my soul command
Under the guy you never
You win my mind, you want to play
You can't replace my love

Every night I need you
Every night
Every night
Every time I want you
Every time I want your love

It makes you stay together
I want to be your other for a night, tonight
You know I'm not like teasin'
I don't make you leave for now,
I'm not a leaver

You are the one I'm dreaming of
You are the one
I'm loving you baby
You are the one I like to see
I want to sing my song for you baby
You are the one I'm dreaming of
You are the one
I'm loving you baby
You are the one I like to see
I want to sing my song for you, ohoo

I wanna say I love you
I wanna say
I wanna say
I wanna feel your heartbeat
I wanna feel your heart tonight
We need to be together
And I can still be really on my soul command
Under the guy you never
You win my mind
You want to play
You can't replace my love

You are the one I'm dreaming of
You are the one
I'm loving you baby
You are the one I like to see
I want to sing my song for you, ohoo

I wanna say I love you
I wanna say
I wanna say
I wanna feel your heartbeat
I wanna feel your heart tonight
""",


"MYSTERIOUS ART - Humunkulus - Men Of Glass":
"""
...
genes 
without knowing 
what it means to give life

... machines
killing the nature and structure of life

trying to break the ice
surrounding the unknown questions of life
obsessing lose mankind 
to created computerized life

(chorus)
Men Of Glass
made to last
all around me
see them pass

Men Of Glass
made to last
machines evolvers
becoming monsters

Men Of Glass

Ignoring the seventh sign
the world will become
to a terrible lounge
obsessing lose mankind 
to created computerized life

(chorus)

I got a feeling inside of me
I feel I'm back into my pace
I hear a voice who is telling me:
"don't do these silly and stupid things"


""",



"NORD EST - Overnight - Extended":
"""

I wanna party all night!
I wanna dance all night!

Tonight is the night oh nightlove!

OH OH OH OVERNIGHT!
""",


"OFRA HAZA - Im Nin' Alu - Played In Full Mix 2":
"""
Im nin'alu daltei n'divim
Daltei marom lo nin'alu

Im nin'alu
Im nin'alu

El Chai
El Chai
Im nin'alu

Im nin'alu daltei n'divim
Daltei marom lo nin'alu

El Chai, maremam al karubim
Kulam b'rucho ya'alu
El Chai

Ki hem elai kis'o kawruvim
Yodu sh'mei weihal'lu
Chayet shehem rotzeh washawvim
Miyom b'ri'aw nichlawlu

Im nin'alu
El Chai

Uv'shesh kanufayim s'vivim
Awfim b'eit yitjaljelu

Im nin'alu daltei n'divim
Daltei marom lo nin'alu
El Chai, mareimawm al kawruvim
Kulawm b'rucho ya'alu
El Chai

Jaljal wa'ofen ru'ashim
Medim sh'mei u'm'gadeshim
Miziv k'veido loveshim
Uv'shesh kanufayim s'vivim  

Awfim b'eit yitjaljelu
Ya'anu b'gel shirim areivim
Yachad b'etet nidjalu
Jaljal wa'ofen ru'ashim
Medim sh'mei u'm'gadeshim
Miziv k'veido loveshim
El Chai
""",

"JAN HAMMER - Crockett's Theme - Ben Liebrand Vice Hammer Dmc Mix":
"""
  [Instrumental (with Miami Vice Samples)]
""",

"WISH KEY - Last Summer - Remix 87" :
"""
I remember all the sweet sensation
That last summer gave my heart
I remember all the good time by
Lying on the beach

I remember last summer
I remember love season
I remember last summer
I remember love season

I remember that you
Were asking there
(I remember that you
Were asking there)
Where the sea washed the shore
I feel in love

You seemed not to notice me when I
Laid by your side
But I knew that something has struck you
As well as me

I remember last summer
I remember love season

I remember all the sweet sensation
That last summer gave my heart
I remember all the good time by
Lying on the beach

I remember goo-goo ladies and me
Looking straight into my eyes
And my heart was beating faster speed
With the love I feel for you

I remember all the sweet sensation
That last summer gave my heart
I remember goo-goo ladies and me
Looking straight into my eyes

And my heart was beating faster speed
With the love I feel for you

I remember last summer
ooh ooh, ah
I remember love season

I remember last summer
ooh ooh, ah
I remember love season
""",


"STEVE EDEN & PAUL JAMES - Memories Emotion" :
"""

We both turn on this way
We don't realize that

In our mind..........
.............................

Days are gone goodbye
Wish you could be the same forever
Take my hand and look into my eyes

When comes the night
I feel I am a better man
Tonight I want to feel the sun
Together we'll see the light

We walk alone this way
Meet up with the sun's light
So it's you remind me
Of when you were a little girl

We walk into the night
Without never end
Make out some of the stars
Look into my eyes

We want the night
We feel we are twice good as one
Tonight we'll stay 'til the sun
Together we'll see the light


We feel a new emotion now 



We want the night
We feel we are twice good as one
Tonight we'll stay 'til the sun
Together we'll see the light


We feel a new emotion now 



We want the night
We feel we are twice good as one
Tonight we'll stay 'til the sun
Together we'll see the light


We feel a new emotion now

""",

"LUZON - The Baguio Track - Chus & Ceballos Iberican Remix" :
"""
Samaj Aya golden Kahan hai
Isne sirf ek galti ki thi Sher uda Diya tha
Is se khartnak message Gaya
Ab ye jitne bhi Sher or tiger ki  khal
Saja ke baithe hainn
Jama karwa do
""",


"LIL MO' YIN YANG - Reach - Little More Mix ":
"""
Oh daddy between ..
[repeat]

Oh daddy ..
We got no love ..
We got no love ..
We ain’t got no love ..

Reach [repeat]
""",


"HELDER - Ladies Night - Live":

"""
Vamos subir agora! 
Vamos agarrar a noite! 
Porque hoje é Ladies Night! 
Eu quero ouvir um grito só de mulheres!

E agora esta 'e prea voces mulheres!
esta musica foi feita sooooo' para as mulheres!

os homens nao se sintam mal!
porque nos estamos aqui por causa delas!

sobe DJ!

quero ouvir o grito!
mais barulho!

ok mulheres, 'e mesmo assim!
vamos agarrar a noite!

hoje 'e ladies night!
ahah!
ok familia!
show!

vamos dar
o grito da noite!
ta' podendo ou nao ta' podendo??

'e por isso!!!
'e por isso!!!
yaa
oh yaa!

eu sabia!
todo o mundo!
facam barulho!!!
 
ok!
ya!
ya ya ya ya ya!!
tra qua qua qua!
eueeeeee!

uou uou uou uou!  

eue!
tra dom bolon
'e opra da dom bolon!
(repeat)

ok pessoal!
e nao vamos esquecer os nossos kotas do seba master!
ai seba masters!
nos estamos com voces!

eua 
da-lhe agora
eueee eueeee
ahhh
eua

(repeat)
  
ai pirigo 
esta do caracas

ja! ok!
allo allo pessoal!
pessoal da noite!
e agora chegou a hora das palmas
todo o mundo maozinhas no ar
pa pa pa pa pa!
pa pa pa pa pa!

e agora todo o mundo
todo o mundo atento
parou as palamos
hoje vamos fazer uma coisa diferente
agora todo o mundo, baixinho:
"da don bolo"
"'e pra' da don..."

nao, nao, baixinho! baixinho! baixinho!
agora, so para ouvir
"da don bolo"

ai' ja' estamos a gritar, ja'??
sobe DJ, sobe para ouvir meus palmas!
vamos dar as palmas!
alloo fokas!

mulheres!
ai mulheres!
vamos
pa pa pa pa pa!
pa pa pa pa pa!

ai puto!
ai puto!
ai puto!
ai puto!

'e por isso!
ahhhhh
mulheres!
mulheres e homens!
homens e mulheres!
ahhhhhhhhhhhhhhhhhhhhhhhh

eueeeeee

da dom bolon
'e pra da dom bolon!
chega-lhe!
  
da dom bolon
'e pra da dom bolon!
chega-lhe!

da dom bolon
'e pra da dom bolon!
chega-lhe!

da dom bolon
'e pra da dom bolon!
chega-lhe!
  
chega-lhe!
chega-lhe!

ai gibala
gibala hoje esta' feito fogo!
aplica!
mete!

chega-lhe!
chega-lhe!

ok pessoal!
hoje isto hoje esta' quente!
hoje isto hoje esta' quente!
ohhh
vamos embora

chega-lhe!
chega-lhe!
chega-lhe!
chega-lhe!

ai puto
ai puto
ai puto
ai puto

isso hoje vai bater!
ahahaha
ahahaha

todo o mundo a gibar
a gibar!
giba-lhe!

eueee
eueee
eueee
eueee
""",


}



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
           
requests_hdr2 = {
       'User-Agent': 'Mozilla/5.0 (Macintosh; Intel'
       'Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, '
       'like Gecko) Chrome/55.0.2883.95 Safari/537.36'
       }
       
requests_hdr2= { 'User-Agent' : 'Mozilla/5.0' }
 
 

try:
  from urllib.parse import quote_plus
except ImportError:
  from urllib import quote_plus

  
#  https://genius.com/modern-talking-brother-louie-lyrics
#  https://genius.com/modern-talking-brother-louie-98-lyrics
  
class Backend(object):
  def __init__(self):
    pass
      
    
  def download(self, url):
    global requests_hdr1, requests_hdr2, opts

    html = requests_get(url, headers=requests_hdr2, timeout=5)
    if opts.save_html:
      ml_to_file(html, "site.html")

    if "too popular" in html.lower():
      print("warning: triggered SPAM protection in %s" % (self.name))
      print("url: %s" % (url))
      if not opts.continue_on_spam:
        print(html)
        sys.exit(1)
        
    soup = BeautifulSoup(html, "lxml")
    
    
    delete_inner_scripts=True
    if delete_inner_scripts:
      _ = [s.extract() for s in soup('script')]
    
    return soup
    
    
  def scrape(self, url):
    soup = self.download(url)

    raw_list = soup.findAll(self.scrape_what, self.scrape_attrs)
    raw_list = [str(a) for a in raw_list ]
    
    raw_lyrics = "\n".join(raw_list)
    #if opts.very_debug:
    #  print(raw_lyrics)
    
    
    lyrics = raw_lyrics
    #print(lyrics)
    lyrics = re.sub(r"<[^<>]*>", self.replace_span, lyrics)   # Remove HTML tags
    #lyrics = lyrics[1:len(raw_lyrics)-1]   # remove list chars
    
    if sys.version_info < (3, 0):
      lyrics = re.sub(r"\\n", '\n', lyrics)
      
    #print(lyrics)
    lines = ml_clean_runs_of_empty_lines(lyrics)
    #print(lines)
    
    printd(opts, "len lines: %d" % (len(lines)))
    
    return lines
    
    
class Genius(Backend):
  def __init__(self):
    self.name="genius"
    self.google_st="genius lyrics"
    self.url_start="genius.com"
    self.replace_span=""

    self.scrape_what="div"
    self.scrape_attrs={'class': 'lyrics'}
      

class SongLyrics(Backend):
  def __init__(self):
    self.name="songlyrics"
    self.google_st="songLyrics"
    self.url_start="www.songlyrics.com"
    self.replace_span=""

    self.scrape_what="p"
    self.scrape_attrs={'id':'songLyricsDiv'}

    
class Lyrics24(Backend):
  def __init__(self):
    self.name="lyrics24"
    self.google_st="lyrics-24"
    self.url_start="www.lyrics-24.com"
    self.replace_span="\n"

    self.scrape_what="div"
    self.scrape_attrs={'class':'row text-row'}

        
    
class Decoda(Backend):
  def __init__(self):
    self.name="decoda"
    self.google_st="decoda lyrics"
    self.url_start="decoda.com"
    self.replace_span="\n"

    self.scrape_what="div"
    self.scrape_attrs={'id': 'lyrics-output'}
     
      
class FlashLyrics(Backend):
  def __init__(self):
    self.name="flashlyrics"
    self.google_st="flashlyrics"
    self.url_start="www.flashlyrics.com"
    self.replace_span=""

    self.scrape_what="div"
    self.scrape_attrs={'class': 'main-panel-content'}
    
    

class MusixMatch(Backend):
  def __init__(self):
    self.name="musixmatch"
    self.google_st="musixmatch"
    self.url_start="www.musixmatch.com"
    self.replace_span=""

    
    #self.scrape_what="span"
    #self.scrape_attrs={'class':'lyrics__content__ok'}
    self.scrape_what="p"
    self.scrape_attrs={'class':'mxm-lyrics__content'}
    

class LyricsWorld(Backend):
  def __init__(self):
    self.name="lyricsworld"
    self.google_st="lyricsworld"
    self.url_start="lyricsworld.ru"

    self.scrape_what="p"
    self.scrape_attrs={'id':'songLyricsDiv', 'class':'songLyricsV14'}
    self.replace_span=""

    
class LyricsFreak(Backend):
  def __init__(self):
    self.name="LyricsFreak"
    self.google_st="LyricsFreak"
    self.url_start="www.lyricsfreak.com"
    self.replace_span=""

    self.scrape_what="div"
    self.scrape_attrs={'class':'lyrictxt js-lyrics js-share-text-content'}

    
class MetroLyrics(Backend):
  def __init__(self):
    self.name="metrolyrics"
    self.google_st="metrolyrics"
    self.url_start="www.metrolyrics.com"

    self.replace_span=""

    self.scrape_what="div"
    self.scrape_attrs={'class':'hwx'}
    
  def scrape2(self, url):
    # note: this needs a dedicated scraper because it has extra text inside the lyrics
    
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
    #print(self.artist)
    
    self.artist = re.sub(r" vs .*", " ", self.artist)
    self.artist = re.sub(r"vs\..*", " ", self.artist)
    self.artist = re.sub(r"ft\..*", " ", self.artist)
    self.artist = re.sub(r"feat\..*", " ", self.artist)
    self.artist = re.sub(r"pres\..*", " ", self.artist)
    self.artist = re.sub(r" the ", " ", self.artist)

    #print(self.artist)
    
    # keep large words only
    self.artist = " ".join([a for a in self.artist.split() if len(a) >= 3])
    
    # keep first 2 words only
    self.artist = " ".join(self.artist.split()[:2])
    #print(self.artist)

    
    ### Title: more strict
    self.title = re.sub(r"\(.*\)|\[.*\]", ' ', self.title) # removes: (feat.) [extended cut]
    self.title = re.sub(r"-.*", ' ', self.title) # removes: - Remastered ...
    self.title = re.sub(r" the ", ' ', self.title)

    # keep large words only
    self.title = " ".join([a for a in self.title.split() if len(a) >= 3])

    
    self.title = " ".join(self.title.split()[:3])  #first 3 words only

    return self
    

   
def printv(opts, *args, **kwargs):
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
    
    if opts.verbose:
        print_nonl("%s" % st)

    if not "debug_buf" in opts:
      opts.debug_buf = StringIO()
    
    opts.debug_buf.write(st)
    
    
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

    if not "debug_buf" in opts:
      opts.debug_buf = StringIO()
    
        
    opts.debug_buf.write(st)

    
def dump_buf_to_file(opts, buf, file):
    """ 
    prints a buffer to a file.
    
    optionally prints it on the screen as well.
    """
    
    with open(file, mode='w') as f:
        print(buf.getvalue(), file=f)

    
def check_link_is_correct(opts, artist, title, link, loose_artists=True):
  if loose_artists:
    link = re.sub(r'-', '', link)

  #print(artist, title, link)


  songinfo = "%s %s" % (artist, title)
  songinfo = songinfo.lower()
  songinfo = re.sub(r"ö", "o", songinfo)
  songinfo = re.sub(r"ä", "a", songinfo)
  songinfo = re.sub(r"ü", "u", songinfo)
  songinfo = re.sub(r"[^a-zA-Z0-9 ]", '', songinfo) # Remove special chars
  songinfo_array = songinfo.split()

  #print(songinfo_array)
  
  for item in songinfo_array:
  
    if link.find(item) == -1:
      printd(opts, "field not found: %s" % (item) )
      printd(opts, "field not found in link: %s" % (item) )
      return False
      
  return True

from configparser import ConfigParser

  
class google_cse():
  def __init__(self):
    """
    Python wrapper:   https://github.com/psolin/csepy
    
    To use, create this file:
      $HOME/.google_cse/google_cse.ini
        [cse]
        cse_key=012302401370948303102:jbp3hqb2hjb
        api_key=<your own PRIVATE api key>


    Info:
      https://towardsdatascience.com/current-google-search-packages-using-python-3-7-a-simple-tutorial-3606e459e0d4
      https://stackoverflow.com/questions/37083058/programmatically-searching-google-in-python-using-custom-search
  
    """
  
  
    """
    CSE:
      current: https://cse.google.com/cse?cx=012302401370948303102:jbp3hqb2hjb 
      create new: https://cse.google.com/cse/create/new
      help: https://developers.google.com/custom-search/v1/site_restricted_api
      user url: https://cse.google.com/cse?cx=012302401370948303102:jbp3hqb2hjb
      management: https://console.developers.google.com/apis/api/customsearch/overview?project=22254433430 
    
    Lyrics project:
      https://console.developers.google.com/apis/credentials?showWizardSurvey=true&project=lyrics-searcher
      
    """

    
    self.config_file = "/home/pestrela/.google_cse/google_cse.ini"
    self.config = ConfigParser()
    self.config.read(self.config_file)
    self.cse_key = self.config['cse']['cse_key']
    self.api_key = self.config['cse']['api_key']
    
    self.service = google_build_query(
      "customsearch", "v1", developerKey=self.api_key)
    
  def query(self, st, num=10, **kwargs):
    global opts
    
    
    query_results = self.service.cse().list(
      q=st,             # Query
      cx=self.cse_key,  # CSE ID
      **kwargs    
      ).execute()
    items = query_results['items']
    
    items = [result['link'] for result in items]
    #print(items)
    
    return items
    
    
    
    
  
def get_lyrics2(opts, _artist, _title, debug=False, backends=None):
  global requests_hdr1, requests_hdr2
  
  if backends is None:
    # todo: make this an option as well
    
    backends = [Genius, MusixMatch,  LyricsWorld, FlashLyrics, LyricsFreak, Decoda, SongLyrics, Lyrics24]
    removed = MetroLyrics

    #backends = [LyricsWorld]
    #backends = [FlashLyrics]
    
  opts.custom_backends = opts.custom_backends.lower()
  if opts.custom_backends == "ge":
    backends = [Genius]
  elif opts.custom_backends == "mm":
    backends = [MusixMatch]
  elif opts.custom_backends == "ml":
    backends = [MetroLyrics]
  elif opts.custom_backends == "lw":
    backends = [LyricsWorld]
  elif opts.custom_backends == "fl":
    backends = [FlashLyrics]
  elif opts.custom_backends == "lf":
    backends = [LyricsFreak]
  elif opts.custom_backends == "de":
    backends = [Decoda]
  elif opts.custom_backends == "sl":
    backends = [SongLyrics]
  elif opts.custom_backends == "24":
    backends = [Lyrics24]
    
    
  cse = google_cse() 
  #debug = True

  opts.debug_buf = StringIO()
  
  printd(opts, "")
  printd(opts, "")
  printd(opts, "")
  printd(opts, "")
  printd(opts, "Doing %s - %s" % (_artist, _title))

  track = Track()
  track = track.set_track(_artist, _title)

  printd(opts, "Reduced search: %s - %s" % (track.artist, track.title))
  
  
  
  ######### search engine
  # https://moz.com/blog/the-ultimate-guide-to-the-google-search-parameters
  # https://fossbytes.com/google-alternative-best-search-engine/
  if False:
    if opts.search_engine == "bing":
      url = 'http://www.bing.com/search?count=50&q='
      url = 'http://www.bing.com/search?q='
      #url = "http://duckduckgo.com/?ia=web&q="
      #url = "http://search.yahoo.com/search?p="
      
    elif opts.search_engine == "startpage":
      url="https://www.startpage.com/do/search?q="
      
    elif opts.search_engine == "google":
      url = 'http://www.google.com/search?num=50&q='
      url = 'https://cse.google.com/cse?cx=012302401370948303102:jbp3hqb2hjb&num=50&q='
      
    
    else:
      die("Unknown search provider: %s" % (opts.search_engine))

      
    to_search = '%s %s ' % (track.artist, track.title)

    printd(opts, "To search in %s: %s" % (opts.search_engine, to_search))
  
    
    to_search = quote_plus(to_search)
    
    url = url + to_search
    printd(opts, "Search engine URL: %s " % (url))

    opts.debug_cache_google = True
    #opts.debug_cache_google = False
    if opts.debug_cache_google:
      printd(opts, "Loading google results from cache")
      result = file_to_ml("google.html") #, debug=True)
    else:
      result = requests_get(url, headers=requests_hdr2, timeout=5)
      
      
  
    if "systems have detected unusual traffic" in result.lower():
      print("warning: triggered SPAM protection in GOOGLE")
      print("url: %s" % (url))
      ml_to_file(result, "google.html")
      sys.exit(1)

    if opts.save_html:
      ml_to_file(result, "google.html")
  else:
    to_search = '%s %s ' % (track.artist, track.title)

    result_list = cse.query(to_search)
    result = " ".join(result_list)
    result = result + " "
  
  printd(opts, "returned from search engine: %s" % (result))
  result = RString(result)
  
  track.found = State.not_found
  for back in backends:
  
    backend = back()
    printd(opts, "")
    printd(opts, "Doing Backend: %s" % backend.name)

    regexp=r"http[s]*://"+backend.url_start+'/.*? '
    links=[]
    for link in result.re_findall(regexp):
      link = link.lower()[:-1]           # Remove final "
      link = re.sub(r"&.*", '', link)    # Remove PHP stuff
      links.append(link)
      
    links = set(links)    # remove duplicates
    
    for link in links:
      printd(opts, "Considering this link: %s" % (link))

      link_correct = check_link_is_correct(opts, track.artist, track.title, link)

      if not link_correct :
         printd(opts, "Link exists, but its for the wrong track: %s" % (link) )
         continue

      ##### Scrape it   
      
      if opts.dry_run:
        print("Exiting because of dry_run")
        break

      printd(opts, "Link accepted, going to scrape: %s" % (link) )
        
      track.lyrics = backend.scrape(link)

      printd(opts, "Backend %s found %s lines" % (back, len(track.lyrics)))
      
      #sys.exit(1)  
    
      if len(track.lyrics) <= 2:
        track.found = State.instrumental 
        # continue searching in this case!
        continue                               
        
      else:
        track.found = State.found 
        break
      
    if track.found == State.not_found:
      printd(opts, "link not found: %s" % (regexp))
      
    if track.found == State.found:
      break

    
  ###########  
  printd(opts, "")

  write_debug = False
  if track.found == State.found:
    printv(opts, "       [FOUND in %s]" % (backend.name) )
  
  elif track.found == State.instrumental:
    print("      [INSTRUMENTAL]" )
    track.lyrics = ["[INSTRUMENTAL]"]
    
    if opts.debug_instrumentals:
      write_debug = True
      
  elif track.found == State.not_found:
    print("     [NOT FOUND]")
    track.lyrics = ["[NA]"]
    write_debug = True
    
    #print(result)
    
  else:
    die("Unknown state")
    
  if write_debug or opts.debug:
    opts.error_channel.write(opts.debug_buf.getvalue())
    opts.any_failure = True
        
  # Clean-up common watermarks in lyrics
  for watermark in watermarks:
    track.lyrics = [a for a in track.lyrics if a != watermark ] 
      
  time.sleep(opts.sleep)
      
  return track
  


def get_lyrics_oneline(opts, raw_line, **kwargs):


  line = RString(raw_line)
  if "|" in line: 
    line = line.split("|")[1].strip()
  
  if line in exception_table.keys():
    line = exception_table[line]
    print("   Warning: found translation. Now considering: '%s'" % (line))
    
  else:
    printd(opts, "Track not found on the exception table: '%s'" % (line))

    
  artist = line.split("-")[0]
  title = line.split("-")[1]
  
  if line in custom_table.keys():
    print("   Warning: found track in local lyrics database: '%s'" % (raw_line))
  
    track = Track()
    track = track.set_track(artist, title)
    track.found = State.found 
    track.lyrics = custom_table[line].split('\n')
    return track
  
  return get_lyrics2(opts, artist, title)

  
  
    
###############    
    

parser = argparse.ArgumentParser(description='find lyrics from tracklists')
parser.add_argument('file_in', type=str, nargs="?",
                    help='Specify basename for all files')
parser.add_argument('-d', dest="debug", default=False, action='store_true',
                    help='Shows all debug messages to screen and error channel')
                    
parser.add_argument('-v', dest="verbose", default=False, action='store_true',
                    help='Shows verbose messages to the screen and error channel')
                    
parser.add_argument('-D', dest="debug_if_notavailable", default=False, action='store_true',
                    help='Shows URLs when not found in screen as well (its always printed to "failed" file')
                    
parser.add_argument('-P', dest="do_pause_all", default=False, action='store_true',
                    help='pause between EVERY track')

parser.add_argument('-p', dest="do_pause_failed", default=False, action='store_true',
                    help='pause between FAILED tracks')

                    
parser.add_argument('-I', dest="debug_instrumentals", default=True, action='store_false',
                    help='skip debugging instrumentals')
                    
                    
parser.add_argument('-s', '--sleep', dest="sleep", default=1.0, type=float,
                    help='delay between every track')

parser.add_argument('--one', dest="do_one_track", default=None, type=str,
                    help='do a single track')

parser.add_argument('--dry_run', '--dry-run', '--dry', dest="dry_run", default=False, action='store_true',
                    help='dry run - do not call google')

parser.add_argument('--no_dot', dest="add_dots_empty_lines", default=True, action='store_false',
                    help='do not add a dot to represent empty lines')
                    

parser.add_argument('-b', '--back', '--backend', dest="custom_backends", type=str, default="",
                    help='custom_backends: MM, GE, ML, LW, FL ')

                    
parser.add_argument('-n', '--max', dest="max_tracks", default=0, type=int,
                    help='maximum number of tracks to process')

                    
parser.add_argument('--continue_on_spam', '--spam', dest="continue_on_spam", default=False, action="store_true",
                    help='exit on spam detection')

parser.add_argument('--debug_cache_google', dest="debug_cache_google", default=False, action="store_true",
                    help='read google results from a file')
                    
parser.add_argument('--save_html', dest="save_html", default=False, action="store_true",
                    help='save intermediate html to files')


                    
opts = parser.parse_args()

opts.search_engine = "google"
#opts.search_engine = "bing"
#opts.search_engine = "startpage"

n = 0


  

if opts.file_in == None:
  die("Please input positional argument")

if opts.do_one_track:
  opts.debug = True
  
if opts.debug:
  opts.debug_if_notavailable = True
  opts.save_html = True
  
  
if opts.do_one_track:
  opts.debug = True
  opts.error_channel = StringIO()
  
  track = get_lyrics_oneline(opts, opts.do_one_track)

  for line in track.lyrics:
    print("\t%s" % (line))
  sys.exit(0)
  
  
opts.file_in = DPath(opts.file_in).with_suffix(".txt")
opts.file_out_l = DPath(opts.file_in).with_suffix(".lyrics")
opts.file_out_e = DPath(opts.file_in).with_suffix(".lyrics_error")
opts.any_failure = False
#opts.error_channel = StringIO()



    

with open(opts.file_in) as file_in, open(opts.file_out_l, 'w') as out_channel, open(opts.file_out_e, 'w') as error_channel:
  opts.error_channel = error_channel
  
  for line_raw in file_in.readlines():
    #printd(opts, "read line_raw: %s" % (line_raw))
    
    
    line_raw = line_raw.strip()
    line_raw = RString(line_raw)

    if not line_raw.re_search("min +[|] "):
      continue
    
  
    n = n + 1
    if opts.max_tracks and (n > opts.max_tracks):
      break

    print("%s" % (line_raw))

    
    track = get_lyrics_oneline(opts, line_raw)

    # dump final output to file
    print("\n%s\n\t.\n" % (line_raw), file=out_channel)
    for line in track.lyrics:
      if opts.add_dots_empty_lines:
        if line == "":
          line = "."
    
      # add final tab per line
      print("\t%s" % (line), file=out_channel)

    print("\t.\n", file=out_channel)
    
    #print(opts.do_pause_all )
    if opts.do_pause_all or (opts.do_pause_failed and track.found == State.not_found):
      pause()
    
    time.sleep(opts.sleep)
    
    
# remove final error file if no errors
if not opts.any_failure:
    DPath(opts.file_out_e).unlink()

    
print("\n\nAll Done")
  
