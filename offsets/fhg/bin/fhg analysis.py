#!pip install pandas seaborn
# to launch: https://mybinder.org/v2/gh/pestrela/music_scripts/master


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

from IPython.display import display as ipython_display

    
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

def my_raise(x):
    raise x
        

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
        # DISABLED CODE
        
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


    
    extra_title           = dict_remove_key(kwargs, 'extra_title')
    if extra_title:
        title = "%s\n%s" % (title, extra_title)
        


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
          #my_raise("countplot: need to specify either 'x' or 'hue'")
          x = hue

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
    
    hue            = dict_remove_key(kwargs, 'hue')
    kwargs['hue']  = hue
    
    extra_title = df_count_groupby_desc(data, hue)
    
    seaborn_cdfplot(data=data, y=y, extra_title=extra_title, **kwargs)
    #seaborn_countplot(data=data, y=y, **kwargs)
    #df_display_count_groupby(data, hue)

    
#####
##### NEW library fuctions follow here
#####    


def df_count_groupby(df, col=None):
    """
    counts how many entries generated by a groupby. 
    break col may be optional, then it counts all entries
    
    output: 
     - dataframe
     - display dataframe
     - one-liner
    """
    
    if col and (not col in df.columns):
        col = None
        
    if col is None:
        df = pd.DataFrame([len(df) ], columns=["count"])
        df.index = ['all']
    else:
        df = df.groupby(col).count().iloc[:,0:1]
        df.columns = ['count']
        
    return df

    
def df_count_groupby_display(df, col=None):
    """
    as above, but displays the result
    """
    df = df_count_groupby(df, col)
    ipython_display(df)
    return None


def df_count_groupby_desc(df, col=None, multi_line=False):
    """
    as above, but output is a oneliner
    """
    
    #df = df_count_groupby(df, col)

    df = df_count_groupby(df, col)
    st = str(df).strip().replace("\n", ";  ")
    st = " ".join(st.split())

    return "COUNT: %s" % (st)



def df_diff_columns_1e3(*args, multiplier=1000, **kwargs):
    return df_diff_columns(*args, multiplier=multiplier, **kwargs)
    

    
def df_diff_columns(df, col1, col2, new_name=None, *, multiplier=1, frac_digits=0):
    if new_name is None:
        col1_1 = col1.split("_")[0]
        col1_2 = col1.split("_")[1]
        col2_1 = col2.split("_")[0]
        col2_2 = col2.split("_")[1]
        
        if col1_1 == col2_1:
            new_name = "%s_vs_%s_%s" % (col1_2, col)
            # FIXME: finish this

    df[col1] = df[col1].astype(float)
    df[col2] = df[col2].astype(float)
            
                
    df[new_name] = (df[col1] - df[col2])*multiplier
    df[new_name] = df[new_name].round(frac_digits)
    
    if frac_digits == 0:
        df[new_name] = df[new_name].astype(int)
        
    return df


def df_preview_intermediate_df(df, groupby=None, n_head=2, n_tail=None, debug=True):
    if not debug:
        return
    
    if n_tail is None:
        n_tail = n_head
    
    print("*************")
    tmp_df = pd.concat([df.head(n_head), df.tail(n_tail)])
    
    ipython_display(tmp_df)
    
    df_display_count_groupby(df, groupby)


def df_query_contains(df, col, value):
    return df[df[col].str.contains(value)]
    

def df_preview_query_contains(df, col, value):
    try:
        df = df_query_contains(df, col, value)
    except:
        print("Warning: %s %s not found" % (col, value))
        df = df.head(1)
        
    ipython_display(df)
    
    
def df_read_csv_string(st, **kwargs):
    from io import StringIO
    return pd.read_csv(StringIO(st), **kwargs)

#####
##### Main program functions starts here
#####


def read_rb_file(file, source):
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
            tag = "has_shift"
        elif "/good" in location:
            tag = "good_shift"
        else:
            tag = "bad_shift"

        loc = PureWindowsPath(location)
        stem = loc.stem
        stem = stem.replace("%20", " ").replace(".", "_")
            
        #debug =True
        if debug:
            print(name, type(inizio), inizio)
            #return
                  
        ret = [name, stem, inizio, bpm, compression, source, tag]
        #ret = ret + [location]
        rets.append(ret)

        i=i+1
        if limit and (i > limit):
            break
            
    df = pd.DataFrame(rets, columns=['name', 'stem', 'inizio', 'bpm', 'compression', 'source', 'tag'])
    #print(rets[0])
    #df = df.reset_index()
    return df


def type_encoder(x):
    x = x.lower()
    if "lavf" in x:
        return "LAVF"
    if "lavc" in x:
        return "LAVC"
    if "av" in x:
        return "AV"
    elif "lame" in x:
        return "LAME"
    elif "unk" in x:
        return "UNK_ENC"
    else:
        return "OTHER_ENC"

    
def read_ffprobe(ffprobe_file = "ffprobe.csv"):
    # to generate this csv from Alex's tool:
    #   ln -sf ../../collection\ files/1\ -\ TK\ collection.nml collection.nml
    #   ln -sf ../../collection\ files/4\ -\ rekordbox\ -\ small\ collection.xml rekordbox.xml
    #    #cat ffprobe.edn  | egrep  "/mnt/|:encoder" |  awk '{if(index($1, "mnt")){ print FILE "  " ENC;  FILE=$0; ENC="UNK"} else { ENC=$3 }}' > ffprobe.csv
    
    # new version:
    #   find . -iname "*.mp3" | tr '\n' '\0' | xargs -0 -n1 -- ffprobe 2>&1 | cat - > step1.txt
    #   cat step1.txt | egrep -i "encode|Input.*from" | egrep -B1 -i "encoder.* : Lav" > step2.txt
    #   cat step2.txt | egrep "^Input" -A1 | egrep -v "^--"  | paste - - |  cut -b21- | sed 's/:.*:/,/' > ffprobe.csv
        
    a = pd.read_csv(ffprobe_file, names=['file',"encoder"], quotechar="'")
    a['file'] = a['file'].str.replace('"','').str.strip()
    a['stem'] = a['file'].apply(lambda x: Path(x).stem)

    a['encoder'] = a['encoder'].str.replace('"','').str.replace('}','').str.strip()
    
    a['encoder_simple'] = a['encoder'].apply(type_encoder)
    
    a = a[['stem','encoder', 'encoder_simple']]
    return a


def df_preview_debug(df, in_function_return=False):
    """
    drop this function to preview the intermediate dataframes.
    Can also be used as a decorator to see returned functions
    
    flavors are:
     a) just see the general structure of the dataframes (head+tail)
     b) instead, track a SPECIFC row over and over  (good to check input files)
     
    options are:
     - see nothing
     - see returned functions dfs
     - see intermediate steps as well
    """
    
    track_a_specific_value = True
    
    also_show_intermediate_dfs = True
    #also_show_intermediate_dfs = False

    #master_disable_debug = True
    master_disable_debug = False
    
    
    #####
    show_df = in_function_return or also_show_intermediate_dfs
    
    if master_disable_debug:
        return None

    if not show_df:
        return None
    
    if track_a_specific_value:
        df_preview_query_contains(df, "stem", "ESTIVA")
    else:
        df_preview_intermediate_df(df)

    return None
        
def decorator_df_preview_debug(df):
    #print("dede")
    return df_preview_debug(df, in_function_return=True)
        
    
def display_versions(versions):
    display(df_read_csv_string(versions, sep='\s+').set_index("Program"))
        

def df_convert_to_stem(df, col="file", new_col="stem"):
    df[new_col] = df[col].apply(lambda x: Path(x).stem)
    return df



#@decorator_df_preview_debug
def step1_read_dj_collections(file_rb, file_tk):
    """
    input:
      2x DJ collections files in RB_XML format
      This collection has both MP3 and WAV files; and folders containing the tag "good"/"bad"
    
    output is a dataframe with these fields:
      stem: index to join later
      tag: manually seen shift / no shift
      RB_vs_TK_adj: offset that was automatically measured (with WAV correction)
    """
    
    input_df1 = read_rb_file(file_rb, "RB")
    input_df2 = read_rb_file(file_tk, "TK")
    input_df = pd.concat([input_df1, input_df2], ignore_index=True)

    input_df['inizio'] = input_df['inizio'].astype(float)
    input_df['bpm'] = input_df['bpm'].astype(float)
    print("Total entries: %d" % ( len(input_df)))

    df_preview_debug(input_df)

    pivot_df = pd.pivot_table(input_df, index=['stem','tag'], columns=['source','compression'], values=['inizio'],
                   fill_value=0) #, aggfunc=[np.sum])

    pivot_df.columns=['RB_mp3', 'RB_wav', 'TK_mp3', 'TK_wav']
    pivot_df = pivot_df.reset_index()


    df_preview_debug(pivot_df)

    merge_df = pivot_df.copy()

    merge_df = df_diff_columns_1e3(merge_df, 'RB_mp3', 'TK_mp3', 'RB_vs_TK_mp3')

    #df_preview_intermediate_df(merge_df)


    merge_df = df_diff_columns_1e3(merge_df, 'RB_wav', 'TK_wav', 'RB_vs_TK_wav')
    #merge_df = df_diff_columns_1e3(merge_df, 'RB_mp3', 'RB_wav', 'RB_mp3_vs_wav')
    #merge_df = df_diff_columns_1e3(merge_df, 'TK_mp3', 'TK_wav', 'TK_mp3_vs_wav')

    merge_df['RB_vs_TK_adj'] = merge_df['RB_vs_TK_mp3'] - merge_df['RB_vs_TK_wav']

    # terminology:
    #   RB_vs_TK_mp3 = "X+Y"
    #   RB_vs_TK_wav = "Y"
    #   RB_vs_TK_adj = "X"

    df_preview_debug(merge_df)

    value_cols=['RB_vs_TK_adj'] #, 'RB_vs_TK_mp3']
    #id_cols = ['encoder', 'encoder_simple', 'tag']
    id_cols = [ 'stem', 'tag']
    merge_df= merge_df[id_cols + value_cols]

    df_preview_debug(merge_df, True)   ## todo: make this a decorator
    
    return merge_df
    
    
def step2_read_csv_files(csv_file1, csv_file2):
    """
    input:
      - CSV file with encoder guess information
      - CSV file with decoded WAV number of samples (for several parameters)
    
    output is a dataframe with these fields:
      stem: index to join later
      
      encoder_*: tags of the several encoder guess programs
      
      fhg_vs_of1: default fhg vs fhg -of1
      fhg_vs_mpg: default fhg vs default mpg
      fhg_vs_mpg_nogapless: default fhg vs mpg --nogapless
    """
    

    csv_df1 = pd.read_csv(csv_file1, sep="|")
    csv_df2 = pd.read_csv(csv_file2, sep="|")

    csv_df = pd.merge(csv_df1, csv_df2, on='file')

    csv_df['stem'] = csv_df['file'].apply(lambda x: Path(x).stem)
    
    csv_df = csv_df.rename(index=str, columns={"ffprobe": "encoder_ffprobe", "mp3guessenc": "encoder_mp3guessenc", "mediainfo":"encoder_mediainfo"})

    encoders_list = ["encoder_ffprobe","encoder_mp3guessenc", "encoder_mediainfo"]

    #csv_df['encoder'] = csv_df['encoder_ffprobe']
    #csv_df['encoder'] = csv_df['encoder_mediainfo']

    csv_df = df_convert_to_stem(csv_df)

    df_preview_debug(csv_df)
        
    csv_df = df_diff_columns(csv_df, 'fhg_default', 'fhg_of1',       'fhg_vs_of1')
    csv_df = df_diff_columns(csv_df, 'fhg_default', 'mpg_default',   'fhg_vs_mpg')
    csv_df = df_diff_columns(csv_df, 'fhg_default', 'mpg_nogapless', 'fhg_vs_mpg_nogapless')

    csv_columns=['stem'] + encoders_list + ['fhg_vs_of1', 'fhg_vs_mpg', 'fhg_vs_mpg_nogapless']
    info_df = csv_df[csv_columns]

    info_df = info_df.query('abs(fhg_vs_mpg) < 1000 ')  # remove impossible shifts
    df_preview_debug(info_df, True)   ## todo: make this a decorator
    return info_df



def do_cdf_plot(df, *, y=None, hue=None, do_abs=False, lim=500, **kwargs):
    sns.set()
    df = df.copy()
    
    do_abs=True
    do_abs=False
    
    if do_abs:
        df[y] = df[y].abs()
        ylim=(0, lim)
        #ylim=(-lim, lim)
    else:
        ylim=(-lim, lim)
    
    #hue="tag"
    #hue = "encoder"

    seaborn_cdfplot_with_count(df, y=y, hue=hue, height=4, aspect=3, ylim=ylim, **kwargs)

    
def do_cdf_plot_breakdown_tag(df, y_list=None, hue_list=None, *, do_agg=False, title=None, **kwargs):
    """
    show CDF plot of:
     - hue=tag (iterated)
     - hue=None (merging everything)
    """
    
    # always add non-breakdown first
    if hue_list is None:
        hue_list = [None]
    else:
        if do_agg:
            hue_list = [None] + hue_list
        else:
            hue_list = hue_list
        
    if y_list is None:
        raise
        
    if title is None:
        raise
        
    ### do it
    for y in y_list:
        for hue in hue_list:
            #if hue is not None:
            #    df_display_count_groupby(df, hue)
                
            y_title = '%s  (y="%s")' % (title, y)
            #print(y, hue)
            do_cdf_plot(df, y=y, hue=hue, title=y_title, **kwargs)    
            





#####
##### Main program statements starts here
#####

versions="""
 Program Version
 TraktorPro 3.1.1_8
 Rekordbox  5.4.1
 FFMPEG_BATCH 1.6.5
 ffmpeg 4.1.1
 ffprobe 4.1.1
 MediaInfoLib v18.12
 mpg123  1.25.10
 Fraunhofer_iis 1.4
"""

dump_versions = True 
dump_versions = False

if dump_versions:  display_versions(versions)

# to generate TK XML file:   ./dj-data-converter-win\ 0.2.1.exe 1\ -\ TK\ collection.nml

file_rb='2 - RB - only small tagged dataset.xml'
file_tk='7 - TK - only small tagged dataset.xml'
    
print("Step1")
collection_df = step1_read_dj_collections(file_rb, file_tk)
do_cdf_plot_breakdown_tag(collection_df, ['RB_vs_TK_adj'], ["tag"],  title='Traktor vs RekordBox "INIZIOS" (wav corrected)')
    

print("Step2")
mp3_encoder_file="mp3_encoder.csv"
mp3_offset_file="mp3_offset.csv"
info_df = step2_read_csv_files(mp3_encoder_file, mp3_offset_file)
do_cdf_plot_breakdown_tag(info_df, ['fhg_vs_of1', 'fhg_vs_mpg', 'fhg_vs_mpg_nogapless'], None, title='Decoded mp3 differences')

print("Step3")

merge_df = pd.merge(collection_df, info_df, on='stem')
df_preview_debug(merge_df)
do_cdf_plot_breakdown_tag(merge_df, [ 'fhg_vs_mpg_nogapless'], ['tag'], title='Decoded mp3 differences (tagged)')

print("Step4")

merge_df['RB+TK__vs__FHG+MPG'] = merge_df['RB_vs_TK_adj'] + merge_df['fhg_vs_mpg']
merge_df['RB+TK__vs__FHG+MPGNGL'] = merge_df['RB_vs_TK_adj'] + merge_df['fhg_vs_mpg_nogapless']
df_preview_debug(merge_df)


simple_df = merge_df[['stem', 'tag', 'encoder_ffprobe', 'encoder_mp3guessenc', 'encoder_mediainfo', "RB+TK__vs__FHG+MPG", "RB+TK__vs__FHG+MPGNGL" ]]
df_preview_debug(simple_df)
do_cdf_plot_breakdown_tag(simple_df, ["RB+TK__vs__FHG+MPGNGL"], ["tag"],  title='FINAL RESULTS')



""" Overview of steps and graphs:

step 1:
  - objective: compare XML inizios for MP3s+WAV that were manually tagged
  - input: 
    - a) rekordbox.XML auto analysed 
    - b) traktor.NML auto analysed converted to XML
  - number of files:
    >300
  - comments: 
    - 60% of the offsets match the manual tagging; 
    - the other 40% are all over the place
  
step 2:
  - objective: compare decoded WAV with FHG and MPG decoders, for various parameters
  - input: 
     - a) mp3_encoder.CSV  (processed, but not used) 
     - b) mp3_offsets.csv with the sizes of 4x WAV files (fhg, fhg -of1, mpg123 default, mpg123 --nogapless)
  - number of files:
      went from 300 to 53 (disk space got full!)
   - comments: 
    - fhg "-of1" parameter had no influence, so it will be ignored
    - "mpg123 --nogapless" resulted in a constant offset of 80% of the files.
    - mpg123 without "nogapless" resulted in the same offset as above, plus an aditional offset for the same 80% files

step 3:
  - objective: add manual tag information to step2 (that comes from step1)
  - input: step1 (manual tag) + step2  (everything)
  - number of files:
      went from 53 to 32 (disk space bad luck on the mathcing)
  - comments:
    - has_shift:  (orange line)
      - everything is corrected perfectly, except for 1x FN (was not correctd but it should)
    - no_shift: (blue line)
      - for 50% of these, we do the right thing: nothing. (because there was no shift in the first place)
      - for the other 50% of these, we do the WRONG thing - we make an ofset that was not real (False positive)
      
step 4:
  - objective: comapre all results from step1 to step2
  - input: step1 (everytyhing) + step2 (everything)
  - number of files:
      same 32
  - comments:
    - has_shift:  (orange line)
      - eveything good. final shift = zero. Profit!
    - no_shift: (blue line)
      - same story as above; we have 50% of this class as False positives


"""


_ = """
print("Difference of MP3 decoders")

for hue in ["tag"]:
    do_cdf_plot(final_df, y="diff_nogapless", hue=hue, title="'Fraunhofer' vs 'mp123 --nogap' Decoders")
    do_cdf_plot(final_df, y="RB_vs_TK_adj", hue=hue, title="Traktor vs Rekordbox MP3 auto-beatgrid difference (adjusted for WAV)")
    do_cdf_plot(final_df, y="predicted_offset", hue=hue, title="Predicted Offsets with Fraunhofer correction")
    
"""    
