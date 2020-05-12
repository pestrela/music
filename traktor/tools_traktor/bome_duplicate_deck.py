#!/usr/bin/env python3


from yapu.imports.all import *

data_in="""
Options53=Actv00Stop00OutO00
Name54=CALCULATIONS
Incoming54=Tim0TimT0007calc1_c
Outgoing54=Tim0TimS0007calc1_d1:0:1
Options54=Actv01Stop00OutO00StMa0000006Clabel002E__cmt>// use this to skip calcs (debug faster)label002C__cmt>// exit rules, execute Outgoing Actionlabel0006__cmt>label0006__cmt>label0021__cmt>/// LINK LOOP & MOVE VALUESif(n5==1)n1=l1label0006__cmt>label0018__cmt>/// CALC TEMPO ADJlabel0032__cmt>// todo: move to local variables j1, j5, etcj1=g1*i1j5=g5*1label0006__cmt>ss=j5/10oo=j1/ssk1=oolabel0006__cmt>label0016__cmt>/// CALC NEW BPMm1=j1m5=j5*100label0006__cmt>m1=m1+m5m5=m5label0006__cmt>m1=m1*h1m5=m5*h5label0006__cmt>ss=m5/10oo=m1/ssk5=oolabel0006__cmt>label0006__cmt>label002C__cmt>///// SOFT TAKEOVER TEMPO CALCULATIONSlabel0027__cmt>//////// are we in soft takeover?label0006__cmt>label001C__cmt>// "la"  "sync" ON/OFFlabel001E__cmt>// "li"  "master" on/offlabel0006__cmt>if(la==0)goto0008sync_offif(la>0)goto0007sync_onlabel0006__cmt>label0008sync_offgoto0012check_tempo_valueslabel0006__cmt>label0007sync_onif(li==0)goto000Amaster_offif(li>0)goto0009master_onlabel0006__cmt>label000Amaster_offgoto0029____________________________TEMPO_IS_DIFFlabel0006__cmt>label0009master_ongoto0012check_tempo_valueslabel0006__cmt>label0006__cmt>label0006__cmt>label0006__cmt>label0006__cmt>label0012check_tempo_valueslabel0006__cmt>label0020__cmt>// ji = wanted tempo valuelabel0027__cmt>// js = soft takeover in progresslabel0021__cmt>// ls = sync blinking timerlabel0008__cmt>//label002E__cmt>// note: here we do NOT change the timerlabel0006__cmt>label001C__cmt>// examples: -6% = -60label0006__cmt>pp=jilabel0006__cmt>label0017__cmt>// dynamic marginlabel0026__cmt>//   "il" = tempo range, unitarylabel0029__cmt>//   "ww" = magin, already times 10label0008__cmt>//label0034__cmt>// example: 10 = 1 percent (for minimum range)label0006__cmt>label001C__cmt>// To tune this value:label003E__cmt>//   raise if sync still blinks when moving fader slowlylabel0006__cmt>ww=5if(i5==6)ww=5if(i5==10)ww=5if(i5==16)ww=10if(i5==25)ww=10if(i5==100)ww=80label0006__cmt>label0006__cmt>label0006__cmt>label0006__cmt>label0006__cmt>xx=k1-wwuu=k1+wwlabel0006__cmt>if(pp<=xx)goto0029____________________________TEMPO_IS_DIFFif(pp>=uu)goto0029____________________________TEMPO_IS_DIFFgoto0029____________________________TEMPO_IS_SAMElabel0006__cmt>label0029____________________________TEMPO_IS_SAMEjs=0goto0003endlabel0006__cmt>label0006__cmt>label0029____________________________TEMPO_IS_DIFFjs=1goto0003endlabel0006__cmt>label0006__cmt>label0003endlabel0006__cmt>
Name55=---
Incoming55=None
Outgoing55=None
Options55=Actv00Stop00OutO00
Name56=SEND BPM
Incoming56=Tim0TimT0007calc1_d
Outgoing56=MID3<Outgoing Action="MIDI"><Simple Type="ControlChange14"><Channel num="0"/><Value1 num="0x15"/><Value2 var="pp"/></Simple></Outgoing>
Options56=Actv01Stop00OutO00StMa00000010if(kx==1)goto000Fsend_native_bpmif(ga==1)goto000Fsend_native_bpmgoto000Bsend_actuallabel0006__cmt>label0006__cmt>label000Bsend_actualpp=k5goto0003endlabel0006__cmt>label000Fsend_native_bpmpp=h1pp=pp*10pp=pp/h5goto0003endlabel0006__cmt>label0003end
Name57=SEND PERCENTAGE
Incoming57=Tim0TimT0008t_blink1
Outgoing57=MID3<Outgoing Action="MIDI"><Simple Type="ControlChange14"><Channel num="0"/><Value1 num="0x16"/><Value2 var="pp"/></Simple></Outgoing>
Options57=Actv01Stop00OutO00StMa0000002Cif(ga==1)goto000Epressing_shiftif(kx==1)goto0016previewing_loop_valuesif(ls>=1)goto0013blink_timer_runninggoto000Bshow_actuallabel0006__cmt>label0006__cmt>label000Epressing_shiftlabel0016previewing_loop_valuesgoto0010show_tempo_rangelabel0006__cmt>label0006__cmt>label0010show_tempo_rangepp=i5pp=pp*10goto0003endlabel0006__cmt>label000Bshow_actualpp=k1goto0003endlabel0006__cmt>label0006__cmt>label0013blink_timer_runninglabel0028__cmt>//if js==0 then Goto "show_wanted"if(js==0)goto000Bshow_actualgoto000Ddo_blink_fastlabel0006__cmt>label0006__cmt>label000Ddo_blink_fastif(zw==0)goto000Bshow_wantedgoto000Cshow_nothinglabel0006__cmt>label0006__cmt>label000Cshow_nothingpp=2001goto0003endlabel0006__cmt>label000Bshow_wantedpp=jigoto0003endlabel0006__cmt>label0006__cmt>label0003endpp=pp+1000label0006__cmt>
Name58=---
Incoming58=None
"""

data = data_in

major_vars=list('ghijklmnyz')
minor_vars=list('15aeiosx')

fast_debug = False
debug = True
debug = False

if fast_debug:
  major_vars=major_vars[:1]
  minor_vars=minor_vars[:2]

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
  
  dump_translation(debug, st_in, st_out)

  #print("%s\t%s" % (st_in, st_out))
  data = data.replace(st_in, st_out)
  return data


def do_variables_inner(line, step):
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
      
      dump_translation(debug, v_in, v_out)
      
      for oper in operators:
        line = do_var_replace(line, v_in, v_out, oper=oper, where="front")
        line = do_var_replace(line, v_in, v_out, oper=oper, where="back")

      for quickfix in quickfixes:
        line = line.replace(quickfix[0], quickfix[1])
      
  return line
  
  
def do_variables(ml, step):
  lines = ml_to_st(ml, clean=False)
  lines = [do_variables_inner(line, step) for line in lines ]
  ml = st_to_ml(lines)
  return ml
  
 
  
  
    
def do_timers(data):
  """
  https://regex101.com/
   in: (_.*)1
   out: \12
   flags: gmU
  
  """
  for line in data.splitlines():
    if "Incoming" in line:
      print(line)

      
step=1
file_in="a2.bmtp"
file_out="a3.bmtp"


parser = argparse.ArgumentParser(description='compile clone traktor cues based on number of cues')
parser.add_argument('file_in', #nargs='*',
                    help='file input')
                    
                    
parser.add_argument('-d', '--debug', dest="debug", default=False, action="store_true",
                    help='enable debug mode')
                    
parser.add_argument('-D', '--fast_debug', dest="fast_debug", default=False, action="store_true",
                    help='enable fast debug')
                    
parser.add_argument('-s', '--step', dest="step", default=1,type=int,
                    help='step')
                                  
                                  
opts = parser.parse_args()


opts.file_out= DPath(opts.file_in).with_suffix(".out.bmtp")


     
with open(opts.file_in, "r") as fd:
  data = fd.read()
  
data = do_variables(data, opts.step)
  
with open(opts.file_out, "w") as fd:
  fd.write(data)
  
print("Wrote: %s." % (opts.file_out))


"""

./bome_compiler.py a3.bmtp  ;  diff_python.py a3.bmtp a3.out.bmtp

"""



    
