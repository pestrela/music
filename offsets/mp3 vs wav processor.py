#!pip install pandas

# https://jupyter.org/try
# https://docs.python.org/3.4/library/xml.etree.elementtree.html
import xml.etree.ElementTree as ET
import os, sys
import pandas as pd
import glob, os
import numpy as np

from pathlib import Path,  PureWindowsPath


def read_file(file, source):
    root = ET.parse(file).getroot()
    collection=root.find('COLLECTION')

    limit=None
    #limit=20
    i=0
    debug=False

    rets = []
    for entry in collection:
        location = entry.get('Location')
        name= entry.get('Name')

        tempo = entry.find('TEMPO')
        inizio = tempo.get("Inizio")
        bpm = tempo.get("Bpm")

        if "/mp3/" in location:
            compression = "mp3"
        elif "/wav/" in location:
            compression = "wav"
        else:
            compression = "unk"

        if "/bad" in location:
            tag = "bad"
        elif "/good" in location:
            tag = "good"
        else:
            tag = "unk"

        loc = PureWindowsPath(location)
        stem = loc.stem

        stem = stem.replace("%20", " ").replace(".", "_")
            
        if debug:
            print(name, inizio)

        ret = [name, stem, inizio, bpm, compression, source, tag]
        #ret = ret + [location]
        rets.append(ret)

        i=i+1
        if limit and (i > limit):
            break
            
    df=pd.DataFrame(rets, columns=['name', 'stem', 'inizio', 'bpm', 'compression', 'source', 'tag'])
    #print(rets[0])
    #df = df.reset_index()
    return df


file1="1 - RB - import of small tagged dataset.xml"
file2="2 - TK - import of small tagged dataset.xml"


df1 = read_file(file1, "RB")
df2 = read_file(file2, "TK")
df = pd.concat([df1, df2], ignore_index=True)
print("Total entries: %d" % ( len(df)))




merged = pd.pivot_table(df, index=['stem'], columns=['source','compression'], values=['inizio'],
               fill_value=0, aggfunc=[np.sum])
merged.columns=['RB_mp3', 'RB_wav', 'TK_mp3', 'TK_wav']
merged.head()
