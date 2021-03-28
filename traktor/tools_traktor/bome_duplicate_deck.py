#!/usr/bin/env python3

# pip install yapu
from yapu.imports.all import *

import logging
from logging import DEBUG, INFO, WARNING


"""
DEBUG
INFO
  WARNING
  
ERROR
CRITICAL

https://docs.python.org/3/library/logging.html#logging-levels
https://verboselogs.readthedocs.io/en/latest/readme.html
https://docs.python.org/3/library/logging.html#logging.Logger.log
https://stackoverflow.com/questions/14097061/easier-way-to-enable-verbose-logging/20663028
"""


_logger = logging.getLogger('root')
FORMAT = "[%(filename)s:%(lineno)s - %(funcName)15s() ] %(message)s"
logging.basicConfig(format=FORMAT)
_logger.setLevel(logging.DEBUG)


class LogWrapper(logging.getLoggerClass()):

    def __init__(self, logger):
        self.logger = logger

        
    def basicConfig(self, **kwargs):
        self.logger.basicConfig(**kwargs)
        
    def setLevel(self, level):
        self.logger.setLevel(level)
    
    def info(self, *args, sep=' '):
        self.logger.info(sep.join("{}".format(a) for a in args))

    def debug(self, *args, sep=' '):
        self.logger.debug(sep.join("{}".format(a) for a in args))

    def warning(self, *args, sep=' '):
        self.logger.warning(sep.join("{}".format(a) for a in args))

    def error(self, *args, sep=' '):
        self.logger.error(sep.join("{}".format(a) for a in args))

    def critical(self, *args, sep=' '):
        self.logger.critical(sep.join("{}".format(a) for a in args))

    def exception(self, *args, sep=' '):
        self.logger.exception(sep.join("{}".format(a) for a in args))

    def log(self, level, *args, sep=' '):
        self.logger.log(level, sep.join("{}".format(a) for a in args))

logger = LogWrapper(_logger)


def list_get_indexes(list_, indexes):
    """
    Access multiple elements of list knowing their index

    https://stackoverflow.com/questions/18272160/access-multiple-elements-of-list-knowing-their-index
    
    """
    
    from operator import itemgetter 

    ret = itemgetter(*indexes)(list_)
    return ret
    
def test_list_get_indexes():
    a = [-2, 1, 5, 3, 8, 5, 6]
    b = [1, 2, 5]
    expected = (1, 5, 5)
    
    #print(expected, list_get_indexes(a, b) )
    assert(expected == list_get_indexes(a, b) )
    
    
#####
#####
#####


results="""
 ('single', 265),
 ('single', 267),
 ('long', 312),
 ('long', 341),
 
 (300 miliseconds)
"""

def ddj_1000_find_longpress(lines):
    lines = data.split('\n')
    #lines = lines[:12]

    double_clicks=[]
    single_clicks=[]

    first_line=True

    ret = []

    for line in lines:
        if not "1000" in line:
            continue

        l = line.split()
        l = list_get_indexes(l, [0,6,7])
        ts, note, vel = l

        ts = int(ts)
        if note == "71":
            if vel == "7F":
                if first_line:
                    first_line=False
                else:    
                    #print(this_click, duration)
                    elem = (this_click, duration)
                    ret.append(elem)

                start=ts
            if vel == "00":
                duration = ts - start
                this_click="long"
        if note == "5F":
            this_click="single"

    ret.sort(key=lambda x:x[1])
    print(ret)
    
#####
#####
#####
    

major_vars=list('ghijklmnyz')
minor_vars=list('15aeiosx')

operators=['=','!=','>','<', '*', '/', '+', '-', ]

exceptions=['hx', "ga", "gx", "hi", "ii", "ie"]


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

  
  
  # normal decks
  ch_in='Channel num="0"'
  ch_out='Channel num="%d"' % (step)
  line = line.replace(ch_in, ch_out)

  
  # pad decks
  ch_in='Channel num="7"'
  ch_out='Channel num="%d"' % (7+step*2)
  line = line.replace(ch_in, ch_out)
  
  ch_in='Channel num="8"'
  ch_out='Channel num="%d"' % (1+7+step*2)
  line = line.replace(ch_in, ch_out)
  
  
  # descriptions
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
  
  logger.log(DEBUG, line)
  
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

  logger.log(DEBUG, line)
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
  
  lines = [RString(line) for line in lines]
  
  conv = {}
  out = []
  for line in lines:
    logger.debug("step1: line:", line)
    
    to_match=r"^\[Preset.\d+\]"
    if line.re_match(to_match):
      preset = line.re_findfirst(to_match)
      logger.warning("step1: found preset:", preset)

    # find decks to change
    to_match=r"Name=.*"
    if line.re_match(to_match):
      logger.info("step1: line:", line)
     
       
        
      to_match2=r"(Name=.* CH)1 \((\d)\)"
      if line.re_match(to_match2):
       
        name, step = line.re_findfirst(to_match2)
    
        step = int(step)
        deck = step+1
    
        new_line = "%s%s" % (name, deck)
      
        #logger.warning("now doing deck: %d", deck, line, new_line, sep="\n")
        line.set(new_line)
      
        conv[preset]=deck
        logger.warning("step1: line:", line)
        logger.warning("step1: added conv", preset, deck)
    
    out.append(line)
     
  lines=out    
 
  print("conversion table:", conv)
  if opts.step1_only:
    sys.exit(0)
  
  ########
  
  out = []
  new_deck = None
  for line in lines:
    to_match=r"^\[Preset.\d+\]"
    if line.re_match(to_match):
      preset = line.re_findfirst(to_match)
      
      if preset in conv:
        new_deck=conv[preset]
      else:
        new_deck=None

      logger.warning("Changed preset: %s -> %s" %(preset, new_deck) ) 
        

    if new_deck:
      line2 = manipulate_st(line, new_deck)
      logger.info(line) 
      logger.info(line2) 
      logger.info("")
      
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
                    
parser.add_argument("-v", "--verbose", dest="verbose", help="increase output verbosity",
                    action="store_true")
                    
parser.add_argument("-q", "--quiet", dest="quiet", help="decrease output verbosity",
                    action="store_true")
                 
                 
parser.add_argument('--step1_only', dest="step1_only", default=False, action="store_true",
                    help='enable fast debug')
                   
parser.add_argument('-D', '--fast_debug', dest="fast_debug", default=False, action="store_true",
                    help='enable fast debug')
                    
parser.add_argument('--deck', dest="deck_selected", default=0, type=int,
                    help='Target deck. Use 2 for channel 2; 3 for channel 3; etc')

#parser.add_argument('-a', '--all', dest="do_all_decks", default=False, action="store_true",
#                    help='Duplicate all 4 decks')
                    

parser.add_argument('-V', '--variables', dest="only_variables", default=False, action="store_true",
                    help='only do variables')
parser.add_argument('-T', '--timers', dest="only_timers", default=False, action="store_true",
                    help='only do variables')
parser.add_argument('-C', '--channels', dest="only_channels", default=False, action="store_true",
                    help='only do variables')


parser.add_argument('--diff', dest="do_diff", default=False, action="store_true",
                    help='do diff of already generated files')
                    
opts = parser.parse_args()


logger.setLevel(logging.WARNING)
if opts.verbose:
  logger.setLevel(logging.INFO)
if opts.debug:
  logger.setLevel(logging.DEBUG)
  print("Doing debug")
if opts.quiet:
  logger.setLevel(logging.ERROR)
  print("Doing debug ERROR")

#logging.basicConfig(level=logging.WARNING)
    
    
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


