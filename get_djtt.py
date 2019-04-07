#!pip install --upgrade pip
#!pip install pandas wget bs4 requests lxml 



import pandas as pd
import requests
import bs4
import json
import re
import time
import bs4
#from bs4 import BeautifulSoup



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
        print("\n\n%s\n" % (url))
    return soup 


def df_split_serie(df, col, n=0, *, count=None, new_col=None, to_int=True):
    """
    splits a string column into a new column
    """
    
    def helper(x):
        nonlocal to_int, n
        
        #print(n)
        if count is None:
            ret = x[n]
        else:
            print(x[n:count], n, count)
            ret = " ".join(x[n:count])
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
    #df['pedro'] = df['author'].str.contains('Pedro')
    df['pedro'] = df['author'].where(df['author'].str.contains('pedro'), other="").str.replace("by pedro", "X")
        
        
    df = df_split_serie(df, 'downloads', 0)
    #df = df_split_serie(df, 'author', 1, to_int=False)
    df = df_split_serie(df, 'likes2', 0, new_col="likes")
    df = df_split_serie(df, 'likes2', 0, new_col="dislikes")
    #df = df_split_serie(df, 'name', -3,count=3, new_col="age")
    df = df[['author','downloads', 'pedro']]
    df = df.sort_values('downloads', ascending=False)
    return df
    
    
controller_ids = [("ddj-1000", 450), ("ddj-sx2", 272), ("ddj-sz", 234), ("AKAI amx", 277)]
for (cntl_name, cntl_id) in controller_ids:
    print("\n\nDoing: %s" % (cntl_name))
    
    df = get_table(cntl_id)
    df = massage_table(df)
    display(df)
    #break
    
    
