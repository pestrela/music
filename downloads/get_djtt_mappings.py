#!pip install --upgrade pip
#!pip install pandas  bs4 requests lxml html5lib  pandas  lxml  html5lib  BeautifulSoup4

import pandas as pd
import requests
import bs4
import json
import re
import time
import bs4
import xml.etree.ElementTree as ET


import re

def bash_regex_to_python_regex(r):
    "*.mp3 ->  ^.*\.mp3$"
    
    r = r.replace(".", "\.")
    r = r.replace("*", ".*")
    return r

def st_case_regex(st, r):
    r = bash_regex_to_python_regex(r)
    
    r = re.compile(r)
    ret = r.search(st)
    return ret


class re_str(str):
    # adapted from:
    #   https://github.com/ActiveState/code/blob/master/recipes/Python/302498_RE_match_replace_through_operator/recipe-302498.py
    #   https://docs.python.org/3/reference/datamodel.html#emulating-numeric-types
    
    cache = {}

    def __mod__(self, regex):
        #print(regex)
        return st_case_regex(self, regex)
    
    
    def __truediv__(self, regex):
        try:
            reg = REstr.cache[regex]
        except KeyError:
            reg = re.compile(regex)
            REstr.cache[regex] = reg
            
        self.sre = reg.search(self)
        return REstr(self.sre.group())
        
    def __floordiv__(self, tpl):
        try:
            regex, repl, count = tpl
        except ValueError:
            regex, repl = tpl
            count = 0
        try:
            reg = REstr.cache[regex]
        except KeyError:
            REstr.cache[regex] = reg = re.compile(regex)
        return REstr(reg.sub(repl, self, count))

    #def __add__(self, tpl):
    #    print(self)
    #    print(tpl)
    
    #def __mul__(self, tpl):
    #    print(self)
    #    print(tpl)
    
    def __call__(self, g):
        return self.sre.group(g)




def restr_unittests():
    a = re_str('abcdebfghbij')
    print("a :", a)

    print( "Match a / 'b(..)(..)' :",)
    print( a / 'b(..)(..)'      )         # find match

    print("a[0], a[1], a[2] :",)
    print( a[0], a[1], a[2]    )          # print letters from string

    print("a(0), a(1), a(2) :",)
    print (a(0), a(1), a(2)  )            # print matches

    print ("a :", a)

    #a /= 'b.', 'X', 1                   # find and replace once
    #print ("a :", a)

    #a /= 'b.', 'X'                      # find and replace all
    #print ("a :", a)
    
    if re_str("file1.mp3") % "*.mp3":
        print("ok")

    if re_str("file2.avi") % "*.mp3":
        print("ok")


def get_all_controllers():
    url = get_djtt_url(0)
    soup = get_html(url)

    a = soup.findAll('select', id="search_midi_controller_id")
    d = dict()
    for i in list(a[0])[:]:
        try:
            i = ET.fromstring(str(i))
        except:
            continue
        if i.tag == "option":
            key = i.text
            value = i.attrib['value'].strip()
            if value == "":
                value = 0
                
            d[key] = int(value)
        
    return d


def get_ids(controllers, djtt_table):
    #djtt_table = get_all_controllers()

    ret = {}
    for c in controllers:
        for k,v in djtt_table.items():
            if c.lower() in k.lower():
                #print(v)
                ret[k] = v
    return ret

def date_to_months(st):
    i, unit = st.split()[:2]
    i = int(i)
    if "month" in unit:
        return i
    elif "year" in unit:
        return i * 12
    else:
        raise

def get_djtt_url(controller_id):
    #url="https://maps.djtechtools.com/mappings?search%5Bmidi_controller_id%5D=450
    #url="https://maps.djtechtools.com/mappings?search[midi_controller_id]="
    #https://www.urldecoder.org/
    url="https://maps.djtechtools.com/mappings?search[midi_controller_id]=%d" % (controller_id)
    return url

def get_html(url, verbose=True):
    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'}
    r = requests.get(url, headers=headers)
    soup = bs4.BeautifulSoup(r.text, 'html.parser')

    if verbose:
        #print("\n\n%s\n" % (url))
        print("%s" % (url))
    return soup 

def sign(x):
    if x < 0:
        return -1
    else:
        return 1

def slice_count(start, count=1, step=1):
    """
    returns a slice operator with count semantics (to use inside "[]")

    Use None to process until the end of the iterator (either direction)
    """
    if count is None:
        stop = None
    else:
        stop = start + count * sign(step)
                                    
    return slice(start, stop, step)


def df_split_serie(df, col, n=0, *, count=1, step=1, new_col=None, to_int=True, sep=" "):
    """
    splits a string column into a new column
    """
    
    def helper(x):
        # https://www.programiz.com/python-programming/methods/built-in/slice
        # slice(stop) -> slice(None, stop, None)
        # slice(start, stop, step)
        nonlocal to_int, n
        
                   
        if count == 1:
            ret = x[n]
        else:
            x = x[slice_count(n, count, step)]
            ret = sep.join(x)
            to_int = False
            
        if to_int:
            ret = int(ret)
        return ret
    
    if new_col is None:
        new_col = col    
        
    df[new_col] = df[col].str.split().apply(helper)
    return df


def get_table(cntl_id):
    url = get_djtt_url(cntl_id)
    soup = get_html(url)
    table = soup.find('table')

    table=soup.find('table')
    input_df = pd.read_html(str(table), header=None)[0] 
    input_df.columns= ['icon','name','author','likes2','downloads']
    return input_df
    
    
def massage_table(df):
    
    final_cols = ['author', 'age', 'downloads', 'X']
    
    df['X'] = df['author'].where(df['author'].str.contains('pedro'), other="").str.replace("by pedro", "X")
        
        
    df = df_split_serie(df, 'author', 1, count=None)
    df = df_split_serie(df, 'downloads', 0)
    
    df = df_split_serie(df, 'likes2', 0, new_col="likes")
    df = df_split_serie(df, 'likes2', 2, new_col="dislikes")
    
    df = df_split_serie(df, 'name', -3, count=2, new_col="age")
    df['age'] = df['age'].apply(date_to_months)
    
    df = df[final_cols]
    df = df.sort_values('downloads', ascending=False)
    return df
    
    
#djtt_table = get_all_controllers()    

djtt_table = get_all_controllers()
   
pedro_controllers = [ "DDJ-1000", "ddj-sx2", "ddj-sz", "AKAI amx"]
other_controllers = ["DDJ-400", "DDJ-800", "ddj-sx", "ddj-sr", "DDJ-Rz", "DDJ-Rx", "DDJ-Rr", 'CDJ-2000' , "DDJ-RZX", 'Numark Party Mix' ]
other_controllers = []

controllers = pedro_controllers + other_controllers
controllers = set(controllers)

c_dict = get_ids(controllers, djtt_table)

for (cntl_name, cntl_id) in c_dict.items():
    print("\nDoing: %s" % (cntl_name))

    try:
        df = get_table(cntl_id)
        df = massage_table(df)
        display(df)
    except:
        pass
    
    #break

    
