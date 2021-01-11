#!/bin/bash


set -e
set -u

function echo_stderr ()
{
	echo -e "$@" >&2
}



#
# Generic die function. 
# Shows a message, then exits the program
#
function die()
{
	set +x
  echo_stderr ""
	echo_stderr "********************"
	echo_stderr "ERROR: ${1:-}"
	echo_stderr "********************"
	echo_stderr ""
	
  
	exit 99
}

#
# A.B.C -> A.B
#
function remove_extension()
{
	echo "${1%.*}"
}

argc=0
declare -a argv
function add_argv()
{
	(( argc ++ ))		|| true
	argv[$argc]="$1"
}

function clear_argv()
{
	argc=0
  unset argv
  declare -a argv
}


#
# $1 - number of places to shift
#
function shift_argv()
{
	local n=${1:-1}
	local argc_orig="$argc"
  local i
  local j
  
	argc=$(( $argc - $n ))

	if [ $argc -le 0 ]; then
		argc=0
		unset argv

		return 0
	fi
	
	
	##### shift the new values
	i=1
	j=$(( $n + 1 ))
	while [ $i -le $argc ]; do
		argv[$i]="${argv[$j]}"
		i=$(( $i + 1 ))
		j=$(( $j + 1 ))
	done

	#### unset the shifted values
	while [ $i -le $argc_orig ]; do
		#echo unset "argv[i]"
		unset "argv[i]"
		i=$(( $i + 1 ))
	done
	
}



############



function show_rules_inner()
{
  cat "$file_in" | awk '
/] Translator /{t=$0} 

/Incoming:/{ next; }
/Outgoing:/{ next; }

{
  if(NF==0){
    next;
  }
  print t, "___" $0
}  '  
}


function show_inner()
{
  local what="$1"
  
  
  #echo "$what"

  cat "$file_in" | awk -v what="$what" '
function dump_rule(t,i)
{
    printf("%-60s %s %s\n", t, "______", i)

}  
  
/] Translator /{
  translator=$0;
  next;
} 

/Outgoing:/{
  if((what == "timers") || (what == "outgoing")){
    #print("dede __")
    #dump_rule(translator, $0)
    if( $2!= "(none)"){ 
      dump_rule(translator, $0)
    }
  }
  next;
}  

/Incoming:/{
  if(what=="timers" || what=="incoming"){
    if( $2!= "(none)"){ 
      dump_rule(translator, $0)
    }
  }
  next;
} 

# general rules
{
  if(what != "rules"){
    next;
  }

  if(NF==0){
    next;
  }
  dump_rule(translator, $0)
  #print("__")
  #print("__")
} 

'  
}


########
function show_incoming()
{
  a=9
  output="`show_inner "incoming"`"
  add_colon_to_grep=1
  show_grep_warning=1
}

function show_rules()
{
  extra_params="-A2 -B2"
  
  output="`show_inner "rules" `"
  add_colon_to_grep=1
  show_grep_warning=1
}

function show_outgoing()
{
  output="`show_inner "outgoing" `"
  add_colon_to_grep=1
  show_grep_warning=1

}

function show_timers()
{
  output="`show_inner "timers"`"
  add_colon_to_grep=1
}



function sort_output()
{
  output="`echo "$output" | sort -t: -k 1 -n | uniq `"

}

function show_globals()
{
  output="$( cat "$file_in" | awk -f "$awk_program"  | grep -v "Total Translators" )"

  #echo "$output" | grep i1
  #exit 0
  
  #set -x
  if [ $remove_startup -ge 1 ]; then
    output="$( echo "$output" | grep -v "Set Global Variables" )"
  fi
  
  if [ $keep_header -eq 0 ]; then
    output="`echo "$output" | awk '{print $1, $NF}' `"
  fi 

  sort_output
}

function show_raw_awk()
{
  output="`cat "$file_in" | awk -f "$awk_program" `"
}


function show_raw_file()
{
  output="`cat "$file_in"  `"
}


function add_space_before_translator()
{
  awk '/5.10/{if (A==0){print ""; } A=1; print} !/5.10/{A=0; print} '

}


function show_assignments()
{
  extra_params="-A2 -B2"
  
  #  output="`cat "$file_in" | awk '/Translator/{tl=$0; next;} {print tl, $0;}' | egrep -v -- "==|<=|>=|!="   | grep "=" `"
  output="`cat "$file_in" | awk '/Translator/{tl=$0; next;} {print tl, $0;}'  | grep "=" `"

}

function display_help()
{
  echo "
  $0 <file> [optional grep]
  
  Wrapper around the BOME AWK analyser. 
  All operations supports an grep string for trimming down the output 

operations:  
  -v: show which translators use which variables  (warning: some bugs)
  -a: show assignments
  
  -i: show translator + incomings
  -o: show translator + outgoings
  -t: show translator + incomings + outgoings (useful for timers)
  -r: show translator + rules
  
  -R1: show RAW output of awk program
  -R2: show RAW file itself
  
  
options:  
  -I: do case sensitive grep
  -k: keep translator header
  -1: merge greps using OR  (default)
  -2: merge greps using AND
  
greps:
  -1: grep one at a time
  -A: grep AND
  -O: grep OR

  -I: do case INsensitive
  -S: do case sensitive
  
debug:
  --head: limit output to 10 lines
  
  "
  exit 0
}



do_grep=0
keep_header=0
oper="none"
remove_startup=1
    
merge_grep="or"    
add_colon_to_grep=0
show_grep_warning=0
do_high_channels=0
do_bad_gotos=0
do_bad_blinks=0

#do_case_insensitive="-i"
do_case_insensitive=""
do_head=0

    
while [ "$#" -ge 1 ]; do
  case "$1" in
  -d|--debug)
    debug=1
    ;;
    
  -dd)
    debug=2
    set -x
    ;;
 
  -h)
    display_help
    ;;
    
  --head)
    do_head=10
    ;;
  
     
  #####
  -v)
    oper="show_globals"
    ;;

    
  -t)
    oper="show_timers"
    ;;
    
  -i)
    oper="show_incoming"
    ;;

  -r)
    oper="show_rules"
    ;;

  -o)
    oper="show_outgoing"
    ;;
    
  -R1)
    oper="show_raw_awk"
    ;;
    
  -R2)
    oper="show_raw_file"
    ;;
    
  -a)
    oper="show_assignments"
    ;;
    
  -s)
    remove_startup=0
    ;;
    
  -k)
    keep_header=1
    ;;
    
  --high_channels|-hc)
    oper="show_timers"
    do_high_channels=1
    ;;
    
  --bad_gotos|-bg)
    oper="show_rules"
    do_bad_gotos=1
    ;;

  --blinks)
    oper="show_rules"
    do_bad_blinks=1
    ;;
    
  
  -1)
    merge_grep="one_at_a_time"
    ;;

  -2|--or|-O)
    merge_grep="or"
    ;;
  -3|--and|-A)
    merge_grep="and"
    ;;

  -I)
    do_case_insensitive="-i" 
    ;;

  -S)
    do_case_insensitive="" 
    ;;
    
    
  -:)
    add_colon_to_grep=1
    ;;

    
  -*)
    die "unknown option: $1"
    ;;
    
  *)
    add_argv "$1"
    ;;
    
  esac
  
  shift
done


if [ $argc -eq 0 ]; then
  die "need file exported from bome"

fi


awk_program="$HOME/bin/bome_show_globals.2020-01-29.awk"
file_in="${argv[1]}" 
file_out="`remove_extension "$file_in"`.vars"
 
shift_argv 1

file_tmp="/tmp/bome_analysis.txt"

if [ ! -r "$file_in" ]; then
  die "File unreadable: $file_in"
fi

if [ $do_high_channels -ge 1 ]; then
  grep_onoff.sh "$file_in"   "START COMPILATION" "END COMPILATION" > "$file_tmp"
  file_in="$file_tmp"
fi


 
case "$oper" in
  show_outgoing)
    show_outgoing
    ;; 
    
    
  show_incoming)
    show_incoming
    ;;
    
  show_timers)
    show_timers
    ;;
    
  show_globals)
    show_globals
    ;;
    
  show_raw_awk)
    show_raw_awk
    ;;
    
  show_raw_file)
    show_raw_file
    ;;
    
  show_assignments)
    show_assignments
    ;;
    
  show_rules)
    show_rules
    ;;
    
  *)
    display_help
    ;;
    
esac

if [ "$output" == "" ]; then
  echo ""
  echo "error: empty output. Check for bugs."
  exit 1
fi




add_colon_to_grep=0

if [ $argc -ge 1 ]; then
  do_grep=1
  #to_grep="${argv[2]}"
  
  i=1
  while [ $i -le $argc ]; do
    if [ $add_colon_to_grep -ge 1 ]; then
      argv[$i]=":${argv[i]}"
    fi
  
    i=$(( i + 1 ))
  done
  
fi


if [ $do_high_channels -ge 1 ]; then


  echo "$output" | grep "ch\. " | grep "\[x\]" | egrep -v "ch. [1-4]"

  exit 0
fi


# remove comments
output="` echo "$output"  | grep -v "//" `"


if [ $do_bad_gotos -ge 1 ]; then
  echo "$output"  | egrep "Goto|Label" | sed 's/______[ ]*Goto/Goto/;s/______[ ]*Label/Label/;' | 
    sed ':a;s/^\(\([^"]*"[^"]*"[^"]*\)*[^"]*"[^"]*\) /\1_/;ta' | 
    columnx.sh 3 -2 -1 | 
    awk '/Goto/{k=$1"_"$3; if(a[k]<2){ a[k]=1}} /Label/{k=$1"_"$3;  a[k]=2} END{for(k in a){  if(a[k]<=1){print k}} }' |
    egrep -v -i "End|error" | sort -n
  exit 0
fi

if [ $do_bad_blinks -ge 1 ]; then
  echo "$output"  | egrep 'Goto "do_blink' | grep  " 7"
  exit 0
fi



if [ $do_grep -eq 1 ]; then

  if [ $merge_grep == "or" ]; then
    collected="${argv[1]}"

    shift_argv
    
    while [ $argc -ge 1 ]; do
      collected="${collected}|${argv[1]}"
      shift_argv
    done

    add_argv "$collected"
    
    merge_grep="and"
  fi


  
  ## Do one at a time
  while [ $argc -ge 1 ]; do
    to_grep="${argv[1]}"
    shift_argv
    
    #output="`echo "$output" | head `"
    
    
    output2="`echo "$output" | egrep ${do_case_insensitive} "$to_grep" `"

    if [ $do_head -ge 1 ]; then
      output2="`echo "$output2"  | head -n $do_head `"
      #set -x
    
    fi
    

    if [ $merge_grep == "one_at_a_time" ]; then
      echo ""
      echo "Showing: $to_grep"
      echo "$output2"
      
    else
      # iterate on the same 
      output="$output2"
    fi
    
    
  done
  
  
fi
  
# dump final output after optional greps
if [ $merge_grep != "one_at_a_time" ]; then
  echo ""
  echo "$output" 
fi


if [ $show_grep_warning -ge 1 ]; then
    echo ""
    echo "Warning: this was only a basic  grep"
fi


exit 0




top = None
l = []
for line in txt.splitlines():
    if not "-" in line:
        continue
        
    if not "DDJ-1000" in line:
        continue
        
        
    ts, rest = line.split('-', 1)
   
    #print(ts)
    ts = int(ts)/1e3
    if not top:
        top = ts
        
    ts = ts - top
    l.append(ts)
    #break
    

import pandas as pd
import numpy as np

def np_utc_to_timestamp(utc_series, unit="ns", origin="unix", tz='Europe/Amsterdam'):
    """
    converts a series to datetime
    output: series
    """
    
    #if len(utc_series):
    #    first = utc_series.iloc[0]
    #    assert_unixtime(first, unit=unit)

    return pd.Index(pd.to_datetime(utc_series, unit=unit, origin=origin)).tz_localize('utc').tz_convert(tz)

# resample: https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#resampling

a = np.array(l)
a2 = np_utc_to_timestamp(a, unit="s")
df = pd.DataFrame(index=a2)
df['count'] = 1



df.resample("250ms").sum().plot()
df.resample("500ms").sum().plot()
#df.resample("1000ms").sum().plot()



