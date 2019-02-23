


#!/usr/bin/env python
# coding: utf-8a

#!pip install seaborn xlrd 


import pandas as pd
import seaborn as sns

import numpy             as np
import matplotlib.pyplot as plt
#import matplotlib.pylab  as pylab
#import matplotlib.image  as mpimg
#import seaborn           as sns


file="offset-encoder.xlsx"
tab="offset-encoder-flat"


xls = pd.ExcelFile(file)
df = pd.read_excel(xls, tab)

#df = df.head(10)

df = df[['offset', 'encoder']]

df['encoder'] = df['encoder'].fillna('unk')

def av_heuristic(st, keep_ver=True):
    bad_lame = False
    st = st.lower()
    if st.find("av") >= 0:
        ret="AV"
    elif st.find("lame") >= 0:
        ret="LAME"
    elif st.find("itunes") >= 0:
        ret="ITUNES"
    elif st == "unk":
        ret = "unk"
    else:    
        ret = "OTHER"
    return ret


def lame_heuristic(st, keep_ver=True):
    bad_lame = False
    if ((st == "LAME3.99.5") or
       (st == "LAME3.99") or 
       (st == "LAME3.98")
       #or (st == "LAME3.99.5ªªÁ")
       ):
        bad_lame = True

    if keep_ver:
        if bad_lame:
            ret = st
        else:
            ret = "LAME_OTHERS"
    else:
        if bad_lame:
            ret = "LAME_BAD"    
        else:
            ret = "LAME_GOOD"
        
    return ret


df['encoder2'] = df['encoder'].apply(av_heuristic)
df['encoder3'] = df['encoder'].apply(lame_heuristic)

df['offset_ms'] = (df['offset'] * 1000).round(1)
df['offset_ms_abs'] = df['offset_ms'].abs()

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
    

#seaborn_cdfplot(df, 'offset_ms', hue="encoder2",
#                 xlim=None, ylim=[-200,200], size=5, aspect=2)

sns.set()
lim_ms=50

use_abs=True
#use_abs=False

do_detailed = True
#do_detailed = False

if use_abs:
    offset="offset_ms_abs"
    ylim=[0, lim_ms]
    
else:
    offset="offset_ms"
    ylim=[-lim_ms, lim_ms]
    #ylim=[0, lim_ms]

    
#xlim=(0.8,1.0)    
xlim=(0.0,1.0)    
    
def do_plot(*args, do_count=False, **kwargs):
    if do_count:
        tool=seaborn_cdfplot_with_count
    else:
        tool=seaborn_cdfplot
    
    return tool(*args, **kwargs, size=4, aspect=3)



do_plot(df, y=offset, hue="encoder2", ylim=ylim)

if do_detailed:
    for (name, df2) in df.groupby('encoder2'):
        do_plot(df2, y=offset, hue="encoder", row="encoder2", ylim=ylim, xlim=xlim)

        
