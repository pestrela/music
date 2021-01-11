#!/usr/bin/env python3 

# https://jupyter.org/try

inside_jupyter = False
inside_jupyter = True


import matplotlib as mpl
import matplotlib.pyplot as plt
from subprocess import Popen, PIPE, STDOUT

if not inside_jupyter:
    mpl.use('Agg') 

import pandas as pd
import numpy as np
import argparse
import os
import re
import sys
import time
from pathlib import Path
import datetime


def get_extension_method(o, method):
    # https://stackoverflow.com/questions/3521715/call-a-python-method-by-name/3521742
    # https://programmingideaswithjake.wordpress.com/2015/05/23/python-decorator-for-simplifying-delegate-pattern/
    # https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/extension-methods

    # https://stackoverflow.com/questions/7139111/python-extension-methods
    
    method = getattr(o, method)
    if method is None:
        raise Exception
    return method
    
    
def call_extension_method(o, method, *args, **kwargs):
    # https://stackoverflow.com/questions/3521715/call-a-python-method-by-name/3521742
    # https://programmingideaswithjake.wordpress.com/2015/05/23/python-decorator-for-simplifying-delegate-pattern/
    # https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/extension-methods

    # https://stackoverflow.com/questions/7139111/python-extension-methods
    
    
    method = get_extension_method(o, method)
        
    ret = method(*args, **kwargs)
    return ret
 

 
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

    

def np_utc_to_timestamp(utc_series, unit="ns", origin="unix", tz='UTC'):
    """
    converts a series to datetime
    output: series
    """
    
    #if len(utc_series):
    #    first = utc_series.iloc[0]
    #    assert_unixtime(first, unit=unit)

    return pd.Index(pd.to_datetime(utc_series, unit=unit, origin=origin)).tz_localize('utc').tz_convert(tz)

    
def png_save_fig(filename, fig=None):
  if fig is None:
     fig = plt.figure()
  fig.savefig(filename)

  
    


def read_file(file_in ):
    l = []
    top = None
    last = None
    
    with open(file_in) as txt:
      for line in txt.readlines():
          if not "-" in line:
              continue

          if not opts.device in line:
              continue


          ts, rest = line.split('-', 1)

          ts = int(ts)/1e3
          if not top:
              top = ts

          ts = ts - top
          l.append(ts)
          #break
        
    a = np.array(l)
    a2 = np_utc_to_timestamp(a, unit="s")
    df = pd.DataFrame(index=a2)
    df['count'] = 1
    return df


parser = argparse.ArgumentParser(description='find lyrics from tracklists')
parser.add_argument('files_in', type=str, nargs='*', default=["v6.8.1.txt", "v7.2.1.txt"],
                    help='Text file with MIDI OUT copy-paste')

parser.add_argument('--device', type=str, default="DDJ-1000",
                    help='device to filter on')

if inside_jupyter:      
  opts = argparse.Namespace()
  opts.files_in = ["v6.8.1.txt", "v7.2.1.txt"]
  opts.files_in = ["6.8.1.txt", "7.2.1.txt"]
  opts.files_in = ["7.3.0.txt", "7.2.1.txt"]
  opts.device = "DDJ-1000"
  
else:
  opts = parser.parse_args()

print(opts)
    
opts.unit1="10ms"
opts.unit2="50ms"
opts.unit2="100ms"
#opts.unit2="10ms"

# sum, mean, std, sem,max, min, median, first, last, ohlc

opts.agg1="sum"
opts.agg2="max"
#opts.agg2="mean"

ax=None
for file_in in opts.files_in:
    version = Path(file_in).stem
    df = read_file(file_in ) 

    duration = df.index[-1] - df.index[0]
    duration = duration / datetime.timedelta(seconds=1)
    print("")
    print("Doing: %s ; duration %.2f seconds" % (file_in, duration))
    
    #print(len(df))
    #df = df.head(len(df)/2)
    #df = df.head(3000)
    
    file_out = file_in + ".png"

    # pandas resample: https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#resampling
    # https://sergilehkyi.com/tips-on-working-with-datetime-index-in-pandas/
    #ax = df.resample(opts.unit1).sum().resample(opts.unit2).max().plot()

    a1 = df.resample(opts.unit1)
    a2 = call_extension_method(a1, opts.agg1)
    a3 = a2.resample(opts.unit2)
    a4 = call_extension_method(a3, opts.agg2)
    
    ax = a4.plot(ax=ax)
    
    #ax = DataFrame2(df).resample(opts.unit1).call_method(opts.agg1).resample(opts.unit2).call_method(opts.agg2).plot()
    
    ax.set_ylim(bottom=0, top=80)
    version="7.2.1 vs 7.3.0"
    title = """
DDJ-1000 mapping version: %s
Aggregation: Sum@%s / Max@%s
""" % (version, opts.unit1, opts.unit2)
    title = title.strip()

    ax.set_title(title)
    ax.set_ylabel('Back to Back Messages [n]')
    
#ax.figure.savefig(file_out)
ax.figure.savefig(file_out)
ax.set_xlim(0,10000)

ax.figure.set_size_inches(9, 6)
ax.figure
    