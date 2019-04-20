#!pip install bs4 requests

import requests
import bs4
import json
import re
import time

# original idea: https://gist.github.com/CharlieTLe/9272de175edb85b07e332c2108288451
# see also: https://github.com/GodLesZ/1001tracklists-scraper/blob/master/lib/scraper.js
#
# to launch: https://mybinder.org/v2/gh/pestrela/music_scripts/master


def get_latest_sets(main_url, limit=5, start=None, grep=None):
    urls = get_latest_urls(main_url=main_url, limit=limit, start=start, grep=grep)
    
    delay = 1
    if limit and (limit > 20):
        delay = 3
        
    for url in urls:
        get_one_set(url)
        time.sleep(delay)

        
def get_html(url, verbose=True):
    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'}
    r = requests.get(url, headers=headers)
    soup = bs4.BeautifulSoup(r.text, 'html.parser')

    if verbose:
        print("\n\n%s\n" % (url))
    return soup        
        
    
def get_latest_urls(main_url, limit=5, start=None, grep=None, verbose=True):
    soup = get_html(main_url)

    urls = []
    
    for i, setLink in enumerate(soup.find_all('div', class_="tlLink")):
        link = 'https://www.1001tracklists.com' + setLink.find('a').get('href')
        print(i, link)
        
        if grep and (grep not in link):
            if verbose:
                print("ignoring: %s", (link))
            continue
            
        #print(link)
        if start and (i<start):
            continue
        
        urls.append(link)
        if limit and (i > limit):
            break
    
    print("\n\n")
    
    print(urls)
    
    print('\n\n')
    return urls

def dump_list(l):
    print(*["%s\n" % (i) for i in l ])
        
        
def get_one_set(url, debug=False, detect_problem=True):

    soup = get_html(url)
    
    i = 1
    for a in soup.find_all('tr'): #, id="tlp_3943296"):
        names=[]
        cues=[]
        #print(a)

        for name in a.find_all('div', {"class": "tlToogleData"}):
            name = name.text.strip()
            #print(name)
            if "\n" in name:
                name = name.splitlines()[0]

            if "correct label is" in name:
                continue

            names.append(name)

        for cue in a.find_all('div', {"class": "cueValueField"}):
            cue = cue.text.strip()
            cues.append(cue)

        if names == []:
            continue

        i = i + 1
        #print(names)
        #print(cues)

        name = " ".join(names)
        if cues == []:
            cue = ""
        else:
            cue = " ".join(cues)

        line = "%-5s - %s" % (cue, name)
        print(line)
        
    if detect_problem and i <= 4:
        raise Exception
            
        
def do_work(data, limit=5, start=None, grep=None, token=None, oper=None):
    """
    what:
        index_sets:       single URL with a list -> get individual set urls
        recursive_sets:   single URL with a list -> all sets details
        isolated_sets:    input is a LIST of urls -> get set details
    
    """
    if token != 1:
        print("ERROR: Bad token")
        return

    ###
    for line in data.splitlines():
        line = line.strip()
        if not line:
            continue
            
        if oper == "index_sets":
            get_latest_urls(line, limit=limit, start=start)

        elif oper == "recursive_sets":
            get_latest_sets(line, limit=limit, start=start, grep=grep)

        elif oper == "isolated_sets":
            get_one_set(line)

        else:
            raise ValueError("Unknown value", what)


data="https://www.1001tracklists.com/source/ummzhc/luminosity/index4.html"

data="""
https://www.1001tracklists.com/tracklist/bf7hbc1/andromedha-progressions-radio-041-luminosity-beach-festival-netherlands-2018-09-18.html
https://www.1001tracklists.com/tracklist/f6bhqvt/andromedha-electronic-family-contest-mix-2018-06-20.html
"""


data="""

https://www.1001tracklists.com/dj/andromedha/index.html

"""
    

start=None
limit=None
grep=None

#oper="index_sets"
#oper="recursive_sets"
#oper="isolated_sets"
oper=None

token=2

do_work(data, limit=limit, start=start, grep=grep, token=token, oper=oper)

print('\n\nALL DONE \n\n')

