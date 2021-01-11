#!/usr/bin/env python3

# pip install yapu
from yapu.imports.all import *


major_vars=list('ghijklmnyz')
minor_vars=list('15aeiosx')

operators=['=','!=','>','<', '*', '/', '+', '-', ]

exceptions=['hx', "ga", "hi", "ii", "ie"]


# quickfixes: instead of avoiding the 
quickfixes = [
  [ "lbbel", "label" ],
  [ "lcbel", "label" ],
  [ "ldbel", "label" ],
  
  ["npexecutelabel", "noexecutelabel"],
  ["nqexecutelabel", "noexecutelabel"],
  ["nrexecutelabel", "noexecutelabel"],

  ["npexecute", "noexecute"],
  ["nqexecute", "noexecute"],
  ["nrexecute", "noexecute"],
  
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

  
def get_next_ch(ch, step):
  if ch == "x":
    if step == 3:
      step = -1
  pass
  ch2=chr(ord(ch) + step) 
  #print(ch, ch2)
  return ch2
  
  

def change_variables(line, deck):
  #line = RString(line)
  step = deck -1

  if not line.re_search(r"^Option"):
    return line
  
  for major in major_vars:
    for minor in minor_vars:
      v_in=major+minor
      v_in = v_in.lower()
      
      if v_in in exceptions:
        continue
        
      if opts.fast_debug:
        if v_in == "zx":
          print(v_in)
          pass
          opts.debug=True
        else:
          continue
        
      minor2=get_next_ch(minor, step)
      v_out=major+minor2
      
      dump_translation(opts.debug, v_in, v_out)
      
      for oper in operators:
        line = do_var_replace(line, v_in, v_out, oper=oper, where="front")
        line = do_var_replace(line, v_in, v_out, oper=oper, where="back")

      for quickfix in quickfixes:
        line = line.replace(quickfix[0], quickfix[1])
      
  return line
  

def change_channel(line, deck):
  #line = RString(line)
  step = deck -1
  
  ch_in='Channel num="0"'
  ch_out='Channel num="%d"' % (step)
  line = line.replace(ch_in, ch_out)
  
  ch_in='ch1'
  ch_out='ch%d' % (deck)
  line = line.replace(ch_in, ch_out)

  ch_in='CH1'
  ch_out='CH%d' % (deck)
  line = line.replace(ch_in, ch_out)
  
  return line

    
def change_timer(line, deck):
  #line = RString(line)
  step = deck -1
  
  
  #if (line.re_search(r"^Incoming") ):
  #  print("__", line)
  
  
  if not (line.re_search(r"^Incoming") or line.re_search(r"^Outgoing")):
    return line
  
  debug=opts.debug
  debug=False
  printd(debug, line)
  
  # https://docs.python.org/3/library/re.html#re.sub
  
  # r"\g<1>2" = group 
  
  # objective:  
  #  - Outgoing4=Tim0TimS000Bdo_preview11:2000:1
  #  ?                                 ^
  #  + Outgoing4=Tim0TimS000Bdo_preview21:2000:1
  
  # regex groups:
  #  input:  r'(...)'  = group #1
  #  output: r'\g<1>'  = group #1
  #  ? = non-greedy
  
  out_expression = r'\g<1>%d' % (deck)  
  
  line = line.re_sub(r'(_.*?)1', out_expression)

  printd(debug, line)
  #sys.exit(1)

  return line  
  
   
def manipulate_st(st, deck):
  if opts.do_variables:
    st = change_variables(st, deck)
  
  if opts.do_timers:
    st = change_timer(st, deck)
  
  if opts.do_channels:
    st = change_channel(st, deck)

  return st
  
  
def pairwise(iterable):
  #https://stackoverflow.com/questions/17373118/read-previous-line-in-a-file-python

  prev = next(fin)
  for line in fin:
      yield prev,line
      prev = line

def regex_pairwise(iterable):

  a,b = pairwise(iterable)
  a = RString(a)
  b = RString(b)
  yield a,b
      
  
def manipulate_ml(ml):

  lines = ml_to_st(ml, clean=False)
  
  inside_deck=False
  
  out = []
  for line in lines:
    line = RString(line)  # debug=True)


    # reset everytime we see a preset
    to_match1=r"^Name=.*"
    if line.re_match(to_match1):
      deck=1
      inside_deck = False

      
      # find decks to change
      to_match2=r"(Name=.* CH)1 \((\d)\)"
      if line.re_match(to_match2):
        inside_deck = True
        
        name, step = line.re_findfirst(to_match2)
    
        step = int(step)
        deck = step+1
        new_line = "%s%s" % (name, deck)
        
        debug1=True
        printd(debug1, "now doing deck: ", deck, line, new_line, sep="\n")
        line.set(new_line)
        
        
    
    if inside_deck:
      line2 = manipulate_st(line, deck)
      #print(line, "\n --> ", line2 )
      
      line = line2
    else:
      pass
      
    out.append(line)
    
  ml = st_to_ml(out)
  return ml
  
 
  
 

# To use this program, create tmp.bmtp with just the entries to compile; remove eveything else
#
# then copy-paste presets to final project
# sadly empty presets are deleted (formatting)      

parser = argparse.ArgumentParser(description='compile clone traktor cues based on number of cues')
parser.add_argument('file_in', #nargs='*',
                    help='file input')
                    
                    
parser.add_argument('-d', '--debug', dest="debug", default=False, action="store_true",
                    help='enable debug mode')
                    
parser.add_argument('-D', '--fast_debug', dest="fast_debug", default=False, action="store_true",
                    help='enable fast debug')
                    
parser.add_argument('--deck', dest="deck_selected", default=0, type=int,
                    help='Target deck. Use 2 for channel 2; 3 for channel 3; etc')

#parser.add_argument('-a', '--all', dest="do_all_decks", default=False, action="store_true",
#                    help='Duplicate all 4 decks')
                    

parser.add_argument('-v', '--variables', dest="only_variables", default=False, action="store_true",
                    help='only do variables')
parser.add_argument('-t', '--timers', dest="only_timers", default=False, action="store_true",
                    help='only do variables')
parser.add_argument('-c', '--channels', dest="only_channels", default=False, action="store_true",
                    help='only do variables')


parser.add_argument('--diff', dest="do_diff", default=False, action="store_true",
                    help='do diff of already generated files')
                    
opts = parser.parse_args()


opts.do_variables = True
opts.do_timers = True
opts.do_channels = True

#opts.only_timers = True


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


#if opts.do_all_decks:
#  opts.decks_todo=[2,3,4]
  
#else:
if opts.deck_selected == 0:
  opts.decks_todo = [2,3,4]
else:
  opts.decks_todo=[opts.deck_selected]

  
opts.file_out= DPath(opts.file_in).with_suffix(".compiled.bmtp")


if opts.do_diff:
  bash("diff_python.py %s %s" % (opts.file_in, opts.file_out))
  sys.exit(0)
    
if opts.fast_debug:
  #major_vars=major_vars[:1]
  #minor_vars=minor_vars[:2]
  pass
    
       
with open(opts.file_in, "r") as fd:
  ml = fd.read()
  
ml = manipulate_ml(ml)
  
with open(opts.file_out, "w") as fd:
  fd.write(ml)
  
print("Wrote: %s." % (opts.file_out))



"""

./bome_compiler.py a3.bmtp  ;  diff_python.py a3.bmtp a3.out.bmtp

"""


