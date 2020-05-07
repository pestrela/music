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


function show_incoming_inner()
{
  cat "$file_in" | awk '
/] Translator /{t=$0} 
/Incoming:/{
  if( $2!= "(none)"){ 
    print t, "___" $0
  }
}  '  
}

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

function show_outgoing_inner()
{
  cat "$file_in" | awk '
/] Translator /{t=$0} 
/Outgoing:/{
  if( $2!= "(none)"){ 
    print t, "___" $0
  }
}  '  
}

####
function show_incoming()
{
  output="`show_incoming_inner `"
  add_colon_to_grep=1
}


function show_rules()
{
  extra_params="-A2 -B2"
  
  output="`show_rules_inner `" 
  add_colon_to_grep=1
}


function show_outgoing()
{
  output="`show_outgoing_inner `"
  add_colon_to_grep=1
}


function sort_output()
{
  output="`echo "$output" | sort -t: -k 1 -n | uniq `"

}

function show_globals()
{
  output="$( cat "$file_in" | awk -f "$awk_program"  | grep -v "Total Translators" )"

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
  output="`cat "$file_in" | awk -f "$awk_program" `"
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
  -v: show which translators use which variables
  -a: show assignments
  
  -i: show translator + incomings
  -o: show translator + outgoings
  -r: show translator + rules
  
  -R1: show RAW output of awk program
  -R2: show RAW file itself
  
  
options:  
  -k: keep translator header
  -1: merge greps using OR  (default)
  -2: merge greps using AND
  -0: greps once at a time 
  "
  exit 0
}



do_grep=0
keep_header=0
#oper="show_globals"
oper="none"
remove_startup=1
    
merge_grep="or"    
add_colon_to_grep=0
    
    
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
     
  #####
  -v)
    oper="show_globals"
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
    
  -0)
    merge_grep="one_at_a_time"
    ;;

  -1)
    merge_grep="or"
    ;;
  -2)
    merge_grep="and"
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
do_case_insensitive=""
 
shift_argv 1



 
case "$oper" in
  show_outgoing)
    show_outgoing
    ;; 
    
  show_incoming)
    show_incoming
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




if [ $do_grep -eq 1 ]; then

  if [ $merge_grep == "or" ]; then
    collected="${argv[1]}"

    shift_argv
    
    while [ $argc -ge 1 ]; do
      collected="${collected}|${argv[1]}"
      shift_argv
    done

    add_argv "$collected"
  fi
      
  ## Do one at a time
  while [ $argc -ge 1 ]; do
    to_grep="${argv[1]}"
    shift_argv
    
    output2="`echo "$output" | egrep ${do_case_insensitive} "$to_grep" `"
    
    echo ""
    echo "$output2" 
  done
  
  echo ""
else

  echo "$output" 
fi


#exit 0