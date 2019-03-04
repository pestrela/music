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

def get_one_set(url):

    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'}
    r = requests.get(url, headers=headers)
    soup = bs4.BeautifulSoup(r.text, 'html.parser')
    
    print("\n\n%s\n" % (url))
    i = 1
    
    names = []
    for name in soup.find_all('span', class_="trackFormat"):
        name = name.text.strip() #.replace('-', '\n')
        #.replace('&', 'and')
        #trackName = re.sub('[^a-zA-Z0-9_]', '', trackName)
        names.append(name)
 
    cues = []
    for cue in soup.find_all('div', {"class": "cueValueField"}):
        cue = cue.text.strip()
        cues.append(cue)
    
    for ((i, name), cue) in zip(enumerate(names), cues):  
        if cue == "":
            cue=i
            
        print("%-5s - %s" % (cue, name))
        
        
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
        if len(urls) >= limit:
            break
    
    print("\n\n")
    return urls

        

main_url="https://www.1001tracklists.com/source/hck7y3/transmission-events/index2.html"
limit=2

#get_latest_urls(main_url, limit=limit)
get_latest_sets(main_url, limit=limit, grep=grep)
    
