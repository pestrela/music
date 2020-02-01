#!/bin/bash


function display_help()
{
  echo "
  
Displays the count of SMI (System Management Interrupts) in windows.
  
Pre-requisites:
 - WSL
 - Windows Kernel Debugger: 
     https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/
    (install windows SDK, select only 'Debugging Tools for Windows')
  
To install this script:
- disable secure boot in BIOS
- enable debug in windows kernel: 
- reboot
    
    
    
  To measure SMI LATENCY impact:
   IDTL - In Depth Latency Tests, using HIGH_LEVEL IRQL
   https://www.resplendence.com/latencymon_idlt
   
  how to check MSRs in windows:
    rdmsr - 
    https://kevinwlocke.com/bits/2017/03/27/checking-msrs-for-x2apic-in-windows/
      
"

}

function pass()
{
  local dummy=1

}

function global()
{
  # this is a global variable 
  pass
}



function returns()
{
  # this is a global variable that contains the return string from this function
  pass
}

function private()
{ 
  # this is a global variable that is supposed to only be used inside a function
  pass
}


function get_smi_count()
{
  local to_exec
  local output
  returns counter
  
  kernel_debugger_dir="/mnt/c/Program Files (x86)/Windows Kits/10/Debuggers/x64"
  kernel_debugger_file="kd.exe"

  to_exec="${kernel_debugger_dir}/${kernel_debugger_file}"

  output="$( "${to_exec}" -kl -c "RDMSR 0x34;q" )"
  
  counter="$( echo "$output" | grep "msr\[34\]"  | sed 's/`/ /' | awk --non-decimal-data '{ printf("%d", "0x"$NF ); }' )"
  
  get_date
}

function get_date()
{
  returns now
  
  now="$( date +"%s.%N" )"
}

function convert_human_date()
{
  local epoch_date="$1"
  local human_date
  
  human_date="$( date --date "@${epoch_date}"  +%H:%M:%S.%N  )"
  echo "$human_date"
}

function convert_human_date_full()
{
  local epoch_date="$1"
  local human_date
  
  human_date="$( date --date "@${epoch_date}"  --iso-8601=ns  )"
  echo "$human_date"
}
 

function start_program()
{
  global start_time
  
  get_date
  start_time="$now"
  last_refresh="$now"
  
  echo ""
  echo "SMI WSL counter"
  echo "started at: $( convert_human_date $start_time )"
  echo "will append stats to: $stats_file"
  
  echo "config:"
  echo "min_to_report: $min_to_report"
  echo "min_to_stats: $min_to_stats"
  echo "min_passage_time_minutes: $min_passage_time_minutes"

  echo ""
}


function end_program()
{
  global start_time
  
  get_date
  stop_time="$now"
  
  echo "End time: $( convert_human_date $stop_time )"
  echo "stats file: ${stats_file}"

  echo ""
  exit 0
}

function dump_human_smi()
{
  global now  delta
  
  echo "$( convert_human_date $now ): $delta SMI events seen this second "

}


function dump_stats_smi()
{
  global now  delta
  
  echo "$( convert_human_date_full $now ) $now $delta" >> "$stats_file"

}

function hrtime_subtract()
{
  local a
  local b
  local ret
  
  a="$1"
  b="$2"
  
  ret="$( echo "$a" "$b" | awk '{print int($1-$2)}' )"
  echo "$ret"

}


function show_passage_of_time()
{
  local time_elapsed
  private last_refresh
  
  time_elapsed=$( hrtime_subtract "$now" "$last_refresh" )
  #echo "$time_elapsed $now $last_refresh"
  
  if [ "$time_elapsed" -ge "$min_passage_time_seconds" ]; then
    echo "."
  
    last_refresh="$now"
  fi
  
  #sleep "$sleep_time"

}


stats_file="$HOME/windows_home/smi_count.stats"

last_counter=0
counter=0
sleep_time="0.3"
sleep_time="0.1"
min_to_report=1
min_to_stats=50
min_to_stats=1

min_passage_time_minutes=1
#min_passage_time_minutes=60
min_passage_time_seconds="$(( 60 * min_passage_time_minutes ))"

get_smi_count
last_counter="$counter"

start_program

while true ; do
  
  get_smi_count
  delta=$((  ${counter} - ${last_counter} ))
  
  if [ $delta -ge $min_to_report ]; then
    dump_human_smi
  fi

  if [ $delta -ge $min_to_stats ]; then
    dump_stats_smi
  fi

  show_passage_of_time
  
  last_counter="${counter}"
done

end_program



