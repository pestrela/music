#!/bin/bash


media_files_extensions="mp3|mp4|avi|m4a|opus|webm|wav|flac|alac|aiff"
tag_comment=0
tag_filename=0
debug=0
output_type=1
wrote_csv_header=0
full_output=0
field_separator="|"
subfield_separator="_"
do_uniq=1
justify=80
skip_wav=0

regenerate_cache=0
populate_cache=0

check_encoder=0

run_tool1=1
run_tool2=1
run_tool3=1

argc=0
declare -a argv
function add_argv()
{
	(( argc ++ ))		|| true
	argv[$argc]="$1"
}


display_help()
{
  echo "

analyse mp3 offsets between traktor and rekordbox

usage: `basename $0` file1 [file2]

 "
  exit 1

}


function die_if_failure()
{
  local ret="$1"
  if [ "$ret" -ge 1 ]; then
    echo "exiting."
    exit "$ret"
  fi
}

# library functions follow

#
# A.B.C -> C
#
function extension()
{
	#echo "${1##*.}"
	echo "$1" | awk -F . '{print $NF}'

}

function extension_lower()
{
	#echo "${1##*.}"
	echo "$1" | awk -F . '{print $NF}' | tr '[:upper:]' '[:lower:]'
}


#
# A.B.C -> A.B
#
function remove_extension()
{
	echo "${1%.*}"
}

#
# A.B.C X -> A.B - X.C
#
function add_posttag()
{
	local FILE="$1"
	local ADD="$2"
	local SEP="${3:- - }"

	local B="`remove_extension "${FILE}"`"
	local E="`extension "${FILE}"`"

	echo "${B}${SEP}${ADD}.${E}"
}

function do_uniq()
{
  if [ $do_uniq -ge 1 ]; then 
    uniq 
  else
    cat -
  fi

}


function massage_output()
{
  if [ $full_output -ge 1 ]; then
    cat -
    return 
  fi

  egrep -i "encoder|librar" | do_uniq | \
  if [ $output_type -eq 0 ]; then
    cat - 
  else
    cat - | awk '{print $NF }' | do_uniq | paste -s -d "$subfield_separator" | awk '{if(NF){A=1}} {print } END{if(A==0){print "UNK"}}'
  fi
}


# sub-tools to check:
# sudo apt-get install ffmpeg lltag eyed3 mp3info id3v2 libimage-exiftool-perl libid3-tools id3tool
# https://askubuntu.com/questions/226773/how-to-read-mp3-tags-in-shell



function array_to_csv () 
{
  # https://stackoverflow.com/questions/11180714/how-to-iterate-over-an-array-using-indirect-reference
  #https://mywiki.wooledge.org/BashFAQ/005  
  #IFS=/; echo "${!arr[*]}"; unset IFS

  local arrayname="$1"
  local tmp="$arrayname[@]"
  local array=( "${!tmp}" )
  local FS="$field_separator"
  local var
  

  local quote=""
  local do_quote=0
  
  # Print each element enclosed in quotes and separated by $FS
  if [ $do_quote -ge 1 ]; then
    printf -v var "\"%s\"$FS"  "${array[@]}"
  else
    printf -v var "%s$FS"  "${array[@]}"
  
  fi
  
  # Chop trailing $FS
  var=${var%$FS}
  
  tee_to_file=1
  
 
  echo "$var" | if [ "$tee_to_file" -ge 1 ]; then
    tee -a "$out_csv1"
  else
    cat -
  fi
}



function get_duration()
{
  local file="$1"
  
  mediainfo --Inform="Audio;%Duration%" "$file"
}
  
  
  

function run_tool()
{
  local file_in="$1"
  local file_out="$2"
  local sep="$3"

  shift 3

  tmp_folder="tmp_wav"
  mkdir -p "$tmp_folder"
  cache_file="${tmp_folder}/${file_out}"

  ###
  if [ $regenerate_cache -ge 1 ]; then
    rm "$cache_file"
  fi
  
  if [ ! -f "$cache_file" ]; then
     #echo " cache not found: $cache_file "
     if [ $populate_cache -ge 1 ]; then
        # https://stackoverflow.com/questions/8110530/check-free-disk-space-for-current-partition-in-bash
        free_bytes="`echo $(($(stat -f --format="%a*%S" .)))`"
        free_mb=$(( free_bytes / 1000000 ))
        min_mb=700
        if [ $free_mb -lt $min_mb ]; then
          echo "0"
          return
        fi
      
        "$@"
        mv "$file_out" "${tmp_folder}"
     fi
  else
    # echo "cache was found"
    nop=1
  fi
  
  if [ ! -f "$cache_file" ]; then
    echo "0"
  else
    get_duration "$cache_file"
  fi
}


function test_1_file()
{
  local full_file="$1"
  local file="`basename "$file"`"
  
  file_fhg_default="$file.fhg.default.wav"
  file_fhg_of1="$file.fhg.of1.wav"
  file_mpg_default="$file.mpg.default.wav"
  file_mpg_nogapless="$file.mpg.nogapless.wav"

  dur1="`run_tool "$file" "$file_fhg_default"    -- mp3sDecoder -if "$full_file" -of "$file_fhg_default" -classic `"
  dur2="`run_tool "$file" "$file_fhg_of1"        -- mp3sDecoder -if "$full_file" -of "$file_fhg_of1"     -classic -of1 `"
  dur3="`run_tool "$file" "$file_mpg_default"    -- mpg123              -w "$file_mpg_default"   "$full_file" `"
  dur4="`run_tool "$file" "$file_mpg_nogapless"  -- mpg123 --no-gapless -w "$file_mpg_nogapless" "$full_file" `"
  
  durs=()
  durs+=("${dur1}")
  
  if [ "${durs[*]}" == "0" ]; then
    return 
  fi
  
  durs+=("${dur2}")
  durs+=("${dur3}")
  durs+=("${dur4}")
 
  durs+=("${full_file}")
  
  #declare -p durs

  #echo "$wrote_csv_header"
  
  if [ $wrote_csv_header -eq 0 ]; then
    csv_header=( "fhg_default" "fhg_of1" "mpg_default" "mpg_nogapless" "file" )
    array_to_csv   csv_header
    wrote_csv_header=1
  fi

  #joined_durs="`echo ${durs} ${file} | join_seperator `"
  array_to_csv durs   
 
}

    
while [ "$#" -ge 1 ]; do
  case "$1" in
  -d|--debug)
    debug=1
    ;;
    
  -dd)
    debug=2
    set -x
    ;;
 
  -C)
    wrote_csv_header=1
    ;;

  -c)
    populate_cache=1
    ;;

  -f)
    populate_cache=1
    regenerate_cache=1
    ;;
    
  -w)
    skip_wav=1
    ;;
    
  -h)
    display_help
    ;;
    
  -e)
    check_encoder=1
    ;;
    
  *)
    add_argv "$1"
    ;;
    
  esac
  
  shift
done

if [ "$argc" -eq 0 ]; then
  display_help
fi

out_csv1="mp3_offset.csv"
out_csv2="mp3_encoder.csv"

rm "$out_csv1"

for file in "${argv[@]}" ; do
  if [ ! -f "$file" ]; then
    continue
  fi
  
  ext="`extension_lower "$file" `"
  
  case "$ext" in
  mp3)
    test_1_file "$file"
    ;;
  *)
    nop="nop"
    #echo "ignoring $file"
    ;;
  esac
  
  #exit 
done

if [ "$check_encoder" -ge 1 ]; then
  check_encoder.sh -c "${argv[@]}" | tee "$out_csv2"
fi

exit 0

]





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
#import matplotlib.pylab  as pylab/
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

    
#####
##### NEW library fuctions follow here
#####    

def df_count_groupby(df, col):
    
    df = df.groupby(col).count().iloc[:,0:1]
    df.columns = ['count']
    return df


    
def df_display_count_groupby(df, col=None):
    from IPython.display import display as ipython_display
    
    if col is None:
        print("number of rows: %d" % (len(df)))
    else:
        ipython_display(df_count_groupby(df, col))


def df_preview_intermediate_df(df, groupby=None, n=2, debug=False):
    from IPython.display import display as ipython_display
    
    if not debug:
        return
    
    print("*************")
    ipython_display(df.head(n))
    
    df_display_count_groupby(df, groupby)



def df_read_csv_string(st, **kwargs):
    from io import StringIO
    return pd.read_csv(StringIO(st), **kwargs)

#####
##### Main program functions starts here
#####



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

#####
##### Main program statements starts here
#####


versions="""
 Program Version
 TP3 3.1.1_8
 RK  5.4.1
 FFMPEG_BATCH 1.6.5
 ffmpeg 4.1.1
 ffprobe 4.1.1
 MediaInfoLib v18.12
"""

debug = False

file1="mp3_encoder.csv"
file2="mp3_offset.csv"

df1=pd.read_csv(file1, sep="|")
df2=pd.read_csv(file2, sep="|")


merge_df = pd.merge(df1, df2, on='file')
merge_df

def good_bad(location):

    if "bad - " in location:
        tag = "seen_shift"
    elif "good -" in location:
        tag = "no_shift"
    else:
        tag = "unk"

    #print(location, tag)
    return tag    
        
merge_df['good'] = merge_df['file'].apply(good_bad)


def diff_columns(df, col1, col2, new_name=None, ms_digits=0):
    if new_name is None:
        col1_1 = col1.split("_")[0]
        col1_2 = col1.split("_")[1]
        col2_1 = col2.split("_")[0]
        col2_2 = col2.split("_")[1]
        
        if col1_1 == col2_1:
            new_name = "%s_vs_%s_%s" % (col1_2, col)
            # ...  todo finish this
            
    df[col1] = df[col1].astype(int)
    df[col2] = df[col2].astype(int)
                
    df[new_name] = df[col1] - df[col2]
    df[new_name] = (df[new_name] * 1).round(ms_digits)
    if ms_digits == 0:
        df[new_name] = df[new_name].astype(int)
    return df

merge_df = diff_columns(merge_df, 'fhg_default', 'mpg_default', 'offset')

columns=["ffprobe", 'offset', 'good']
melt_df = merge_df[columns]




sns.set()
do_abs=False
lim=500

if do_abs:
    melt_df['diff_ms'] = melt_df['diff_ms'].abs()
    ylim=(0, lim)
else:
    ylim=(-lim, lim)

    
#display(df_read_csv_string(versions, sep='\s+'))
hue="good"

seaborn_cdfplot(melt_df, y='offset', hue=hue, height=4, aspect=3, ylim=ylim, )
df_display_count_groupby(melt_df, hue)

merge_df

