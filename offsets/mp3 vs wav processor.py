#!pip install pandas seaborn

# https://jupyter.org/try
# https://docs.python.org/3.4/library/xml.etree.elementtree.html
import xml.etree.ElementTree as ET
import os, sys
import pandas as pd
import glob, os
import numpy as np

from pathlib import Path,  PureWindowsPath

import pandas as pd
import seaborn as sns

import numpy             as np
import matplotlib.pyplot as plt
#import matplotlib.pylab  as pylab
#import matplotlib.image  as mpimg
#import seaborn           as sns


#####
##### library functions follow
#####

def dict_remove_key(d, key, default=None):
    """
    removes a key from dict __WITH__ side effects
    Returns the found value if it was there (default=None). It also modifies the original dict.
    """
    return d.pop(key, default)


def swap(a,b):
    return (b,a)


def internal_seaborn_facetgrid_myfunc(y, kind, **kwargs):
    data = kwargs.pop('data')
    #x = dict_remove_key(kwargs, 'x')
    ax = plt.gca()
    serie = data[y]

    if len(serie) == 0:
        print("WARNING: no data for CDF seaborn plot")
        print(y,kind)
      

    if kind == "cdf":
        serie_sorted = np.sort(serie)
        p = 1.0 * np.arange(len(serie)) / (len(serie) - 1)
        plt.plot(serie_sorted, p, **kwargs)
    elif kind == "dist":
        sns.distplot(serie, norm_hist=True, hist=False, kde=True)
    else:
        raise  ValueError('seaborn_FacetGridplot: unknown Kind')


def seaborn_FacetGridplot(data, y, kind="cdf"                 # args required 
                          , replace_NAs=True
                          , title="", figsize=None            # args SETTED to final grid
                          , xlim=None, ylim=None              # args SETTED to all subplots
                          , size=3, aspect=2, col_wrap=2      # args PASSED to aLL subplots
                          , sort_lines=True
                          , **kwargs):
    
    """
    main wrapper to FacetGrid.
    Please see options in https://seaborn.pydata.org/generated/seaborn.FacetGrid.html#seaborn.FacetGrid
    
    """


    #### NA problems:
    
            
    ####
    # adds defaults to kwargs
    #kwargs['col_wrap'] = col_wrap
    kwargs['size']   = size
    kwargs['aspect'] = aspect
    
    
    ### support breakdown lists by making the powerset on the fly
    ### https://seaborn.pydata.org/generated/seaborn.FacetGrid.html
    if False:
        x              = dict_remove_key(kwargs, 'x')
        data, x        = df_melt_breakdown(data, x)
        kwargs['x']    = x

        hue            = dict_remove_key(kwargs, 'hue')
        data, hue      = df_melt_breakdown(data, hue)
        kwargs['hue']  = hue

        col            = dict_remove_key(kwargs, 'col')
        data, col      = df_melt_breakdown(data, col)
        kwargs['col']  = col

        row            = dict_remove_key(kwargs, 'row')
        data, row      = df_melt_breakdown(data, row)
        kwargs['row']  = row


        


    ### force hues to be sorted
    # todo: do cols and rows as well
    x          = dict_remove_key(kwargs, 'x')
    hue        = dict_remove_key(kwargs, 'hue')
    hue_order  = dict_remove_key(kwargs, 'hue_order')

    # all the above are optional. Provide defaults in this case
    if (hue is None):
        hue = x
    if (x is None):
        x = hue
    if (hue is not None) and (hue_order is None):
        #hue_order = np_unique_unsorted(data[hue], format_output="series")
        pass
        
    kwargs['hue']       = hue
    kwargs['hue_order'] = hue_order
    #############
    
    
    if (kind == "count"):
        # https://seaborn.pydata.org/generated/seaborn.catplot.html
        
        assert(y is None)

        y          = dict_remove_key(kwargs, 'y')

        hue        = dict_remove_key(kwargs, 'hue')
        hue_order  = dict_remove_key(kwargs, 'hue_order')
    
        if x is None:
          my_raise("countplot: need to specify either 'x' or 'hue'")

        g = sns.catplot(data=data, y=x, x=None, kind="count", **kwargs)
        
    elif (kind == "line") or (kind == "point"):
        hue_order = dict_remove_key(kwargs, 'hue_order')
        
        assert(x is not None)  # <<<<< IMPROVE THIS
        
        if (kind == "line"):
          sub_plt = plt.plot
          if sort_lines:
            data = data.sort_values(x)
        elif (kind == "point"):
          sub_plt = plt.scatter
        
        #x          = dict_remove_key(kwargs, 'x')
          
        g = sns.FacetGrid(data, **kwargs)
        g.map(sub_plt, x, y).add_legend()
      
    elif (kind == "box") or (kind=="bar"):
        # from https://seaborn.pydata.org/generated/seaborn.boxplot.html
        # "Using factorplot() is safer than using FacetGrid directly, as it ensures synchronization of variable order across facets"
        
        x_order  = dict_remove_key(kwargs, 'hue_order')   ## TODO!
        if x is None:
          x = dict_remove_key(kwargs, 'hue')
        
        g = sns.factorplot(x=x, y=y, data=data, kind=kind, **kwargs)


        
    else:
        # swap xlim - even if they dont exist!
        #kwargs = dict_swap_keys(kwargs, 'xlim', 'ylim')
        
        xlim, ylim = swap(xlim, ylim)
        
        g = sns.FacetGrid(data=data, **kwargs)
        g = g.map_dataframe(internal_seaborn_facetgrid_myfunc, y, kind)

    #sns.factorplot(data=df, x="extra", y='sepal_length', col="extra", sharey=True, kind='point', size=6, aspect=1.5).set_xticklabels(rotation=90).fig.suptitle("dede", y=1.02)  
    
    g.add_legend()
    set_kwargs = dict(xlim=xlim, ylim=ylim) #, figsize=figsize)
    g.set(**set_kwargs).fig.suptitle(title, y=1.05)
        
    return g
  


def seaborn_cdfplot(data, y, **kwargs):
    """
    Wrapper to CDF calculated by hand.
    Please see seaborn_FacetGridplot() for parameter list
    """
    return seaborn_FacetGridplot(data, y, kind="cdf", **kwargs)


def seaborn_countplot(data, *, y=None, count_ylim=None, **kwargs):
    """
    Wrapper to catplot(kind="count")
    Note that "y" is always ignored, to keep compatibility with the CDFPLOT. Use "hue" or "x" instead!
    Please see seaborn_FacetGridplot() for parameter list
    """
    
    if not (y is None):
      print("Warning: specified 'y' parameter '%s'. CountPlot() always ignores this " % (y))

    return seaborn_FacetGridplot(data, y=None, kind="count", **kwargs)
    #ret = sns.catplot(data=data, y=None, x=x, hue=None, kind="count", ylim=count_ylim, **kwargs)


def seaborn_cdfplot_with_count(data, *, y=None, **kwargs):
    """
    shows two plots simultaneously (CDF + count)
    Please see seaborn_FacetGridplot() for parameter list
    """
    
    seaborn_cdfplot(data=data, y=y, **kwargs)
    seaborn_countplot(data=data, y=y, **kwargs)
    
    
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

        
        tempo_entry = entry.find('TEMPO')
        
        inizio = float(tempo_entry.get("Inizio"))
        bpm = float(tempo_entry.get("Bpm"))

        
        if "/mp3/" in location:
            compression = "mp3"
        elif "/wav/" in location:
            compression = "wav"
        else:
            compression = "unk"

        if "/bad" in location:
            tag = "seen_shift"
        elif "/good" in location:
            tag = "no_shift"
        else:
            tag = "unk"

        loc = PureWindowsPath(location)
        stem = loc.stem

        stem = stem.replace("%20", " ").replace(".", "_")
            
        #debug =True
        if debug:
            print(name, type(inizio), inizio)
            return
                  
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


input_df1 = read_file(file1, "RB")
input_df2 = read_file(file2, "TK")
input_df = pd.concat([input_df1, input_df2], ignore_index=True)

input_df['inizio'] = input_df['inizio'].astype(float)
input_df['bpm'] = input_df['bpm'].astype(float)
print("Total entries: %d" % ( len(input_df)))


df = pd.pivot_table(input_df, index=['stem','tag'], columns=['source','compression'], values=['inizio'],
               fill_value=0) #, aggfunc=[np.sum])
df.columns=['RB_mp3', 'RB_wav', 'TK_mp3', 'TK_wav']
df.head(2)

def diff_columns(df, col1, col2, new_name=None, ms_digits=0):
    if new_name is None:
        col1_1 = col1.split("_")[0]
        col1_2 = col1.split("_")[1]
        col2_1 = col2.split("_")[0]
        col2_2 = col2.split("_")[1]
        
        if col1_1 == col2_1:
            new_name = "%s_vs_%s_%s" % (col1_2, col)
            # ...  todo finish this

    df[new_name] = df[col1] - df[col2]
    df[new_name] = (df[new_name] * 1000).round(ms_digits)
    if ms_digits == 0:
        df[new_name] = df[new_name].astype(int)
    return df
    

df = diff_columns(df, 'RB_mp3', 'TK_mp3', 'RB_vs_TK_mp3')
df = diff_columns(df, 'RB_wav', 'TK_wav', 'RB_vs_TK_wav')
df = diff_columns(df, 'RB_mp3', 'RB_wav', 'RB_mp3_vs_wav')
df = diff_columns(df, 'TK_mp3', 'TK_wav', 'TK_mp3_vs_wav')

df['RB_vs_TK_mp3_adjusted'] = df['RB_vs_TK_mp3'] - df['RB_vs_TK_wav']

final_cols=['RB_vs_TK_mp3_adjusted', 'RB_vs_TK_mp3']
df= df[final_cols]
#df.head(2)


# tutorial on melt: https://hackernoon.com/reshaping-data-in-python-fa27dda2ff77

melt_df=df.reset_index().melt(value_vars=cols, id_vars='tag',
                                        var_name ="what", value_name='diff_ms')
melt_df.head(2)

sns.set()

do_abs=True

lim=1000

if do_abs:
    melt_df['diff_ms'] = melt_df['diff_ms'].abs()
    ylim=(0, lim)
else:
    ylim=(-lim, lim)

seaborn_cdfplot(melt_df, 'diff_ms', hue='what',row='tag', size=4, aspect=3, ylim=ylim, )

