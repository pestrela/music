#!/usr/bin/env python3

import sys
import re

import argparse
parser = argparse.ArgumentParser()

parser.add_argument("file", help="mp3 file")
parser.add_argument("-s", "--seek", dest="seek", default=0, type=int, help="what to seek first")
parser.add_argument("-n", "--amount", dest="amount", default=10000, type=int, help="hpw much to read")
parser.add_argument("-w", "--what", dest="what", default="LAME", type=str, help="what to search")

                    
args = parser.parse_args()

args.what = args.what.encode()

## do it
f = open(args.file, 'rb')
f.seek(args.seek)
st = f.read(args.amount)


def str_index_all(st, what):
  ret = [m.start() for m in re.finditer(what, st)]
  return ret
  
def bytes_index_all(array, what):
    '''Yields all the positions of     the pattern p in the string s.'''
    ret = []
    abs_pos=0
    while True:
      try:
        i = array.index(what)
      except:
        #print("done")
        if len(ret)== 0:
          ret=['none']
        return ret
      
      abs_pos = abs_pos + i
      new_pos = i + len(what)
      #print("found %d" % abs_pos)
      ret.append(str(abs_pos))
      
      array = array[new_pos:]
    
#print(st)
print("Finding: %s in %d:%d of file %s" % (args.what, args.seek, args.amount, args.file) )

#print("manual: %s" % st.index(b'LAME'))
ret = bytes_index_all(st, args.what)
ret = "_".join(ret)

print("lame positions: %s" % ret)
  
