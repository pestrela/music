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

        i = i  + 1
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
            
        
def do_work(main_url, limit=5, start=None, grep=None, token=None, what=None):
    global token_global
    
    if token == token_global:
        print("bad token")
        return
    token_global = token

    ###
    if what == "list":
        get_latest_urls(main_url, limit=limit, start=start)
    elif what == "sets":
        get_latest_sets(main_url, limit=limit, start=start, grep=grep)
 


main_url="https://www.1001tracklists.com/source/ummzhc/luminosity/index4.html"
start=15
limit=None
grep=None

what="list"
what="sets"
token=2


do_work(main_url, limit=limit, start=start, grep=grep, token=token, what=what)


print('\n\nALL DONE \n\n')
