#!/usr/bin env python3



from yapu.imports.internal import *
from yapu.string import RString
#import string
 

used_vars_st = """
g1
g2
g5
g6
ga
gb
ge
gf
gi
gj
go
gp
gs
gt
h1
h2
h5
h6
ha
hb
he
hf
ho
hp
hs
ht
hw
hy
hz
i1
i2
i5
i6
ia
ib
j1
j2
j5
j6
ja
jb
jo
jp
k1
k2
k5
k6
ka
kb
kf
kj
ko
kp
ks
kt
l1
l2
m1
m2
m5
m6
ma
mb
n1
n2
n5
n6
na
nb
no
np
y5
y6
ya
yb
yo
yp
ys
yt
z1
z2
z5
z6
za
zb
zo
zp
zs
zt
"""


def generate_zero_init():
  globals="ghijklmnyz"

  todo = list(range(10)) + [ch for ch in string.ascii_lowercase]

  for letter in globals:
      for n in todo:
          var="%s%s" % (letter, n)
          assignment = "%s = 0" % (var)
          print(assignment)
        

def list_one_every_n(lst, n=2, end=None, start=None):
  if start and end:
    lst = lst[start:end]
  if start and not end:
    lst = lst[start:end]
  if not start and end:
    lst = lst[:end]
    
  lst = lst[::n] 
  return lst

def ch_next(ch, i=0):
    ret =  chr(ord(ch) + i)
    return ret

def 
  local_prefix = "opqrstuvwx"
  global_prefix = "ghijklmnyz"
  global_suffix = string.ascii_lowercase + string.digits
  reduced_suffix = '15aeiosx'


  possible_vars = set()
  possible_locals = set()
  possible_globals = set()
  reduced_globals = set()

  used_vars = set()

  ####
  for var in used_vars_st.split("\n"):
      if not var:
          continue
      used_vars.add(var)    
      
  for var in local_prefix:
      var = "%s%s" % (var, var)
      possible_locals.add(var)

  for i in global_prefix:
      for j in global_suffix:
          var = "%s%s" % (i,j)
          possible_globals.add(var)
          
  for i in global_prefix:
      for j in reduced_suffix:
          #for m in range(4):
              m = 0
              var = "%s%s" % (i, ch_next(j, m))
              #print(var)
              reduced_globals.add(var)
          
  ######
  used_vars = used_vars & reduced_globals
  unused_vars = reduced_globals - used_vars
  return 
  
def show_vars(var_list, used_vars, what="unused", show_breaks=True):

    last_prefix = ""
    for var in sorted(reduced_globals):
        this_prefix = var[0]
        if this_prefix != last_prefix:
            if show_breaks:
                print("\n*****")
        last_prefix = this_prefix    

        ####
        is_present = var in used_vars
        if is_present:
            present_ch = "*" 
        else:
            present_ch = " " 
            
        ###
        do_print = False
        if what == "unused":
            do_print = not is_present
        elif what == "used":
            do_print = is_present
        elif what == "all":
            do_print = True
        else:
            raise SyntaxError()

        #print(var, is_present, do_print)    

        if do_print:
            print('"%s" %s' % (var, present_ch))

            
show_vars(reduced_prefix, used_vars, "unused")            
