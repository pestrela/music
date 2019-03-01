#!pip install bs4 requests

import requests
import bs4
import json
import re


def get_latest_urls(main_url, limit=5):
    # original idea: https://gist.github.com/CharlieTLe/9272de175edb85b07e332c2108288451

    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'}
    r = requests.get(main_url, headers=headers)
    soup = bs4.BeautifulSoup(r.text, 'html.parser')
    urls = []
    for setLink in soup.find_all('div', class_="tlLink"):
        link = 'https://www.1001tracklists.com' + setLink.find('a').get('href')
        urls.append(link)
        print(link)
        if len(urls) >= limit:
            break
            
    return urls


def get_one_set(url):

    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'}

    r = requests.get(url, headers=headers)
    soup = bs4.BeautifulSoup(r.text, 'html.parser')
    
    print("\n\n%s\n" % (url))
    i = 1
    for track in soup.find_all('span', class_="trackFormat"):
        trackName = track.text.strip() #.replace('-', '\n')
        #.replace('&', 'and')
        #trackName = re.sub('[^a-zA-Z0-9_]', '', trackName)
        print("%02d - %s" % (i, trackName))
        i = i+1

        
def get_latest_sets(main_url, limit=5, only_summary=False):
    urls = get_latest_urls(main_url=main_url, limit=limit)

    if only_summary:
        return
        
    for url in urls:
        get_one_set(url)
        
        
main_url="https://www.1001tracklists.com/source/hufm3c/panama-amsterdam/index.html"
limit=2
get_latest_sets(main_url, limit, only_summary=True)
