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





############

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

function show_outgoing()
{
  output="`show_outgoing_innner `"
}

function sort_output()
{
  output="`echo "$output" | sort -t: -k 1 -n | uniq `"

}

function show_globals()
{
  output="$( cat "$file_in" | awk -f "$awk_program"  | grep -v "Set Global Variables" | grep -v "Total Translators" )"

  if [ $keep_header -eq 0 ]; then
    output="`echo "$output" | awk '{print $1, $NF}' `"
  fi 

  sort_output
}

function show_raw()
{
  output="`cat "$file_in" | awk -f "$awk_program" `"
}

function add_space_before_translator()
{
  awk '/5.10/{if (A==0){print ""; } A=1; print} !/5.10/{A=0; print} '

}

function show_rules()
{
  extra_params="-A2 -B2"
  
  output="`cat "$file_in" `" 
}

function display_help()
{
  echo "
  $0 <file> [optional grep]
  
  Wrapper around the BOME AWK analyser. 
  All operations supports an grep string for trimming down the output 
  
  -v: show used variables + rules
  -o: show outgoing + translator
  -r: show rules
  
  -k: keep translator header
  "
  exit 0
}



do_grep=0
keep_header=0
#oper="show_globals"
oper="none"
    
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

  -o)
    oper="show_outgoing"
    ;;
    
  -i)
    oper="show_incoming"
    ;;
    
  -R)
    oper="show_raw"
    ;;
    
  -r)
    oper="show_rules"
    ;;
    
  -k)
    keep_header=1
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
 
#echo  "${argv[@]}"

if [ $argc -ge 2 ]; then
  do_grep=1
  to_grep="${argv[2]}"
fi

 
case "$oper" in
  show_outgoing)
    show_outgoing
    ;;
  show_globals)
    show_globals
    ;;
    
  show_raw)
    show_raw
    ;;
    
  show_rules)
    show_rules
    ;;
    
  *)
    display_help
    ;;
    
esac    


if [ $do_grep -ge 1 ]; then
  output="`echo "$output" | grep -i "$to_grep" `"
fi
  
echo "$output" 

