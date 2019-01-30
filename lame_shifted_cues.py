
#
# Program:
#   this program analyses a lame heuristic to detect shifted cues between traktor -> rekordbox
#   simplest way to run this code: https://jupyter.org/try
#
# Data:
#   to collect more data, please use https://mediaarea.net/en/MediaInfo
#   To customize the output: preferences / custom / edit / audio / %Encoded_Library%
#
#
import pandas as pd
from io import StringIO

good_list="""
|LAME3.98r|
|LAME3.93 |
||
|LAME3.98r|
||
|LAME3.98r|
||
||
|LAME3.99r|
|LAME3.98r|
|LAME3.97 |
|LAME3.99r|
||
||
|LAME3.99r|
|LAME3.98r|
|LAME3.97 |
||
|LAME3.98r|
||
|LAME3.92 |
||
||
|LAME3.97 |
|LAME3.97 |
|LAME3.93|
||
|LAME3.98 |
||
|LAME3.97 |
|LAME3.97 |
|LAME3.99r|
||
|LAME3.97 |
||
||
|LAME3.97 |
||
|LAME3.99 |
||
||
|LAME3.98r|
|LAME3.97 |
|LAME3.97 |
|LAME3.98r|
||
||
|LAME3.90|
|LAME3.98 |
|LAME3.97 |
||
|LAME3.97 |
||
|LAME3.93|
|LAME3.97 |
|LAME3.99r|
|LAME3.97 |
||
||
|LAME3.98 |
|LAME3.97 |
|LAME3.97 |
|LAME3.97 |
|LAME3.97 |
||
|LAME3.99r|
|LAME3.97 |
||
|LAME3.98r|
||
|LAME3.97 |
|LAME3.97 |
|LAME3.93 |
|LAME3.98r|
|LAME3.97|
||
|LAME3.99r|
||
|LAME3.98r|
|LAME3.97 |
||
|LAME3.97 |
||
||
|LAME3.97 |
|LAME3.97 |
||
|LAME3.97 |
||
|LAME3.97 |
||
|LAME3.97 |
|LAME3.97 |
||
||
||
||
|LAME3.92 |
||
||
|LAME3.98.2|
|LAME3.99rÍ|
|LAME3.96|
||
||
||
||
|LAME3.97 |
|LAME3.99r|
|LAME3.99.5|
||
|LAME3.97|
|LAME3.98r|
|LAME3.99.5|
|LAME3.97 |
||
||
||
||
|LAME3.97 |
|LAME|
||
||
|LAME3.98r|
|LAME3.98r|
||
||
||
|LAME3.98.4|
|LAME3.98.4|
||
|LAME3.99.5|
|LAME3.97 |
|LAME3.99r|
|LAME3.97 |
||
||
|LAME3.99r|
||
|LAME3.98.4UUUUUUUUU|
|LAME3.97 |
||
|LAME3.99.5|
|LAME3.98 |
||
||
|LAME3.82|
|LAME3.99r|
|LAME3.99r|
|LAME3.98.2|
|LAME3.98 |
||
|LAME3.93 |
|LAME3.98r|
|LAME3.99r|
||
||
|LAME3.99 |
|LAME3.98r|
|LAME3.98r|
|LAME3.99r|
|LAME3.99.5|
||
|LAME3.93|
||
|LAME3.97 |
||
|LAME3.97 |
|LAME3.97 |
||
||
||
|LAME3.98r|
|LAME3.90a|
|LAME3.90a|
|LAME3.97 |
|LAME3.98r|
|LAME3.99r|
||
|LAME3.99.5|
|LAME3.93|
|LAME3.98r|
|LAME3.99.5|
|LAME3.99.5|
|LAME3.97 |
|LAME3.98r|
|LAME3.97 |
|LAME3.99r|
|LAME3.98b|
|LAME3.93|
|LAME3.99r|
||
||
|LAME3.99.5|
|LAME3.98r|
|LAME3.98r|
|LAME3.98r|
||
|LAME3.98r|
|LAME3.98.4|
|LAME3.93|
|LAME3.97 |
||
|LAME3.98|
||
||
||
|LAME3.99rÍ|
||
|LAME3.97 |
|LAME3.97 |
|LAME3.97 |
|LAME3.99.5|
||
|LAME3.98r|
|LAME3.99a|
|LAME3.93|
||
|LAME3.98r|
|LAME3.99¢|
|LAME3.98r|
|LAME3.99r|
|LAME3.98r|
|LAME3.82ªªªªªªªªªªª|
||
|LAME3.97 |
|LAME3.99.5|
|LAME3.97|
||
||
||
||
||
||
||
||
||
|LAME3.99r|
|LAME3.97|
||
||
|LAME3.98r|
|LAME3.99.5|
|LAME3.98r|
|LAME3.98r|
|LAME3.98r|
||
||
|LAME3.97 |
|LAME3.97 |
|LAME3.92UUUUUUUU(|
||
|LAME3.98r|
|LAME3.96.1|
|LAME3.98r|
|LAME3.99r|
|LAME3.99r|
|LAME3.82|
|LAME3.82|
|LAME3.82|
|LAME3.97|
|LAME3.99r|
|LAME3.99.5|


"""

bad_list="""
|LAME3.99|
|LAME3.99|
|LAME3.99.5|
|LAME3.99|
|LAME3.99.5|
|LAME3.99|
|LAME3.99|
|LAME3.99|
|LAME3.99.5|
|LAME3.98|
|LAME3.99.5|
|LAME3.99|
|LAME3.99|
|LAME3.99.5|
|LAME3.99|
|LAME3.99|
|LAME3.99|
|LAME3.99|
|LAME3.99|
|LAME3.99|
|LAME3.99|
|LAME3.99|
|LAME3.99.5ªªÁ|
|LAME3.99.5|
|LAME3.99|
|LAME3.99.5|
|LAME3.99.5|
|LAME3.99.5|
|LAME3.99.|
|LAME3.98|
|LAME3.98|
|LAME3.98|
|LAME3.98|
|LAME3.98.4|
||

"""



def lame_heuristic(st, keep_ver=True):
    bad_lame = False
    if ((st == "LAME3.99.5") or
       (st == "LAME3.99") or 
       (st == "LAME3.98")):
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

def read_list(st, tag):
    df = pd.read_csv(StringIO(st), sep="|", names=['dummy1','version','dummy2'])
    s = df['version'].str.replace(" ","_").fillna('unk')
    
    df = pd.DataFrame(s, columns=["version"])
    df['shift']=tag
    
    df['heuristic'] = df['version'].apply(lame_heuristic)
    return df

def do_stats(df1, index, columns, normalize=False):
    df2 = pd.crosstab(index=df1[index], columns=df1[columns], normalize=normalize)
    df2 = df2.sort_values([df2.columns[0],df2.columns[1]], ascending=False)
    if normalize:
        df2 = df2.round(3)*100.0
    return df2

def add_fp_col(a):
    fp_list=[]
    for i in range(len(a)):
        row = a.iloc[i]
        bad = row[0]
        good = row[1]
        if i == len(a) - 1:
            num = bad
        else:
            num = good
        fp = num * 100.0 / (bad+good)
        #print(fp*100.0) #.round(3)
        fp_list.append(fp)

    a['False Positive %']=fp_list
    a['False Positive %']=a['False Positive %'].round(1)
    return a


df_good = read_list(good_list, 'good_shift')
df_bad  = read_list(bad_list, 'bad_shift')

df_both = pd.concat([df_good, df_bad], ignore_index=True)

print("\n\nNumber of mp3 samples: %d  (%d good / %d bad)     Percentage Bad shifts: %.1f%%\n" % (len(df_both), len(df_good), len(df_bad), len(df_bad)*100.0/len(df_both)))

stats = do_stats(df_both, index='heuristic', columns='shift')
stats = add_fp_col(stats)
stats
