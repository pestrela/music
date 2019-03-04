#!pip install bs4 requests

import requests
import bs4
import json
import re
import time

# original idea: https://gist.github.com/CharlieTLe/9272de175edb85b07e332c2108288451
# see also: https://github.com/GodLesZ/1001tracklists-scraper/blob/master/lib/scraper.js


def get_latest_sets(main_url, limit=5, grep=None):
    urls = get_latest_urls(main_url=main_url, limit=limit, grep=grep)
    for url in urls:
        get_one_set(url)
        time.sleep(0.3)

def get_latest_urls(main_url, limit=5, grep=None, verbose=True):
    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'}
    r = requests.get(main_url, headers=headers)
    soup = bs4.BeautifulSoup(r.text, 'html.parser')
    urls = []
    #print(soup)
    for setLink in soup.find_all('div', class_="tlLink"):
        link = 'https://www.1001tracklists.com' + setLink.find('a').get('href')
        
        if grep and (grep not in link):
            if verbose:
                print("ignoring: %s", (link))
            continue
            
        #print(link)
        urls.append(link)
        if limit and (len(urls) >= limit):
            break
    
    print("\n\n")
    return urls

def dump_list(l):
    print(*["%s\n" % (i) for i in l ])
        
def get_one_set(url, debug=False):

    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'}
    r = requests.get(url, headers=headers)
    soup = bs4.BeautifulSoup(r.text, 'html.parser')
    
    print("\n\n%s\n" % (url))

    
    i = 1
    for a in soup.find_all('tr'): #, id="tlp_3943296"):
        names=[]
        cues=[]
        print(a)

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
        
         

main_url="https://www.1001tracklists.com/source/rch80m/a-state-of-trance-festival/index.html"
limit=233
grep=None

#get_latest_urls(main_url, limit=limit)
#get_latest_sets(main_url, limit=limit, grep=grep)
 
    
url="https://www.1001tracklists.com/tracklist/1jmmt129/reality-test-psy-stage-a-state-of-trance-festival-900-jaarbeurs-utrecht-netherlands-2019-02-23.html"
#get_one_set(url)
