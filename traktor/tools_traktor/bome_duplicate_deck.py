#!/usr/bin/env python3

# pip install yapu
from yapu.imports.all import *


major_vars=list('ghijklmnyz')
minor_vars=list('15aeiosx')

operators=['=','!=','>','<']

exceptions=['hx', "ga", "hi", "ii",]

quickfixes = [
  [ "lbbel", "label" ],
  [ "lcbel", "label" ],
  [ "ldbel", "label" ],
  
  ["npexecutelabel", "noexecutelabel"],
  ["nqexecutelabel", "noexecutelabel"],
  ["nrexecutelabel", "noexecutelabel"],
 
  ["gpto", "goto"],
  ["gqto", "goto"],
  ["grto", "goto"],
]


def dump_translation(debug, st_in, st_out):
  printd(debug, "%5s -> %5s" % (st_in, st_out))



def do_var_replace(data, v_in, v_out, *, oper, where="front"):
  if where=="front":
    st_in=v_in+oper
    st_out=v_out+oper
  elif where=="back":
    st_in=oper+v_in
    st_out=oper+v_out
  else:
    print("error")
  
  dump_translation(opts.debug, st_in, st_out)

  #print("%s\t%s" % (st_in, st_out))
  data = data.replace(st_in, st_out)
  return data


def change_variables(line, step):
  line = RString(line)
  
  if not line.re_search(r"^Option"):
    return line
  
  for major in major_vars:
    for minor in minor_vars:
      v_in=major+minor
      v_in = v_in.lower()
      
      if v_in in exceptions:
        continue
        
      if opts.fast_debug:
        if v_in == "ko":
          print(v_in)
        else:
          continue
        
      minor2=chr(ord(minor) + step) 
      v_out=major+minor2
      
      dump_translation(opts.debug, v_in, v_out)
      
      for oper in operators:
        line = do_var_replace(line, v_in, v_out, oper=oper, where="front")
        line = do_var_replace(line, v_in, v_out, oper=oper, where="back")

      for quickfix in quickfixes:
        line = line.replace(quickfix[0], quickfix[1])
      
  return line
  

def change_channel(line, step):
  line = RString(line)
  
  ch_in='Channel num="0"'
  ch_out='Channel num="%d"' % (step)
  
  line = line.replace(ch_in, ch_out)
  return line

    
def change_timer(line, step):
  line = RString(line)
  
  if not (line.re_search(r"^Incoming") or line.re_search(r"^Outgoing")):
    return line
  
  if step == 1:
    printd(opts.debug, line)
    
    # https://docs.python.org/3/library/re.html#re.sub
    
    # r"\g<1>2"
    out_expression = r'\g<1>%d' % (step+1)
    line = line.re_sub(r'(_.*?)1', out_expression)

    printd(opts.debug, line)
    #sys.exit(1)

  return line  
  
   
def manipulate_st(st, step):
  if opts.do_variables:
    st = change_variables(st, step)
  
  if opts.do_timers:
    st = change_timer(st, step)
  
  if opts.do_channels:
    st = change_channel(st, step)

  return st
  
  
  
def manipulate_ml(ml, step):
  lines = ml_to_st(ml, clean=False)
  lines = [manipulate_st(line, step) for line in lines ]
  ml = st_to_ml(lines)
  return ml
  
 

      

parser = argparse.ArgumentParser(description='compile clone traktor cues based on number of cues')
parser.add_argument('file_in', #nargs='*',
                    help='file input')
                    
                    
parser.add_argument('-d', '--debug', dest="debug", default=False, action="store_true",
                    help='enable debug mode')
                    
parser.add_argument('-D', '--fast_debug', dest="fast_debug", default=False, action="store_true",
                    help='enable fast debug')
                    
parser.add_argument('-s', '--step', dest="step", default=1,type=int,
                    help='step')
                                  

parser.add_argument('-v', '--variables', dest="only_variables", default=False, action="store_true",
                    help='only do variables')
parser.add_argument('-t', '--timers', dest="only_timers", default=False, action="store_true",
                    help='only do variables')
parser.add_argument('-c', '--channels', dest="only_channels", default=False, action="store_true",
                    help='only do variables')

                                  
opts = parser.parse_args()


opts.do_variables = True
opts.do_timers = True
opts.do_channels = True

if opts.only_variables:
  opts.do_variables = True
  opts.do_timers = False
  opts.do_channels = False
  
if opts.only_timers:
  opts.do_variables = False
  opts.do_timers = True
  opts.do_channels = False
  
if opts.only_channels:
  opts.do_variables = False
  opts.do_timers = False
  opts.do_channels = True



opts.file_out= DPath(opts.file_in).with_suffix(".out.bmtp")


if opts.fast_debug:
  major_vars=major_vars[:1]
  minor_vars=minor_vars[:2]

     
with open(opts.file_in, "r") as fd:
  ml = fd.read()
  
ml = manipulate_ml(ml, opts.step)
  
with open(opts.file_out, "w") as fd:
  fd.write(ml)
  
print("Wrote: %s." % (opts.file_out))


"""

./bome_compiler.py a3.bmtp  ;  diff_python.py a3.bmtp a3.out.bmtp

"""



    
