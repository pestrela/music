#!/bin/bash


set -u
set -e
 
function display_help()
{
  echo "
  
Displays the count of SMI (System Management Interrupts) / SMM (System Management Mode) in Windows.
It also saves a log file to show average events per hour.
  
  
Pre-requisites:
  - WSL
  - Windows Kernel Debugger:
    - install windows SDK, select ONLY 'Debugging Tools for Windows'
    - https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/
  
To install this script:
  - Disable secure boot in BIOS
  - Enable debug in windows kernel  (bcdedit.exe -debug on)
    - https://alfredmyers.com/2017/11/26/the-system-does-not-support-local-kernel-debugging/
  - Reboot
     
To measure SMI LATENCY impact:
  - Run IDTL (In Depth Latency Tests) with HIGH_LEVEL IRQL
  - https://www.resplendence.com/latencymon_idlt
  - https://www.resplendence.com/latencymon_cpustalls
   
Intel register:
  - https://stackoverflow.com/questions/50790715/is-there-a-way-to-determine-that-smm-interrupt-has-occured/
  - See chapter 34 of https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-vol-3c-part-3-manual.pdf
 
Tools to read MSR in windows:
  - rdmsr: https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/rdmsr--read-msr-
  - Old info about PI: https://kevinwlocke.com/bits/2017/03/27/checking-msrs-for-x2apic-in-windows/
 
How to find the BIOS update history in Dell:
  - Dell update logs: C:\ProgramData\Dell\UpdateService\Log  
  - Activity.log:
    - log format: https://www.dell.com/support/manuals/ie/en/iebsdt1/dell-command-update-v2.3/dcu_ug_2.3/activity-log?guid=guid-31fdd315-57c4-48d5-9847-a3f9f1dd86d7&lang=en-us
    - iconv -f UTF-16LE -t UTF-8 ../Activity.log  -o - | tr [:upper:] [:lower:] | awk '/timestamp/{a=$0} /installing/{ print a, $0; }' |  sed -e 's/<[^>]*>/ /g;s/t/ /;s/\./ /' | dos2unix > activity.txt
    - cat activity.txt | grep -i installing 
  - service.log:
    - cat service.6.log | grep -i installing
  

    
 
"

}

# todo: add usb device dump, versions, etc


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
  echo "min_to_report_screen: $min_to_report_screen"
  echo "min_to_stats: $min_to_stats"
  echo "min_passage_time_minutes: $min_passage_time_minutes"

  echo ""
  echo "Use 'q' to quit"
  echo ""
  
  dump_stats_start 
}


function end_program()
{
  global start_time
  
  get_date
  stop_time="$now"
  
  time_elapsed_s=$( hrtime_subtract "$now" "$start_time" )
  time_elapsed_h=$( hrdelta_divide "$time_elapsed_s" 3600 ) 
  
  dump_stats_stop
  
  echo "End time: $( convert_human_date $stop_time )"
  echo "stats file: ${stats_file}"
  echo "Analysis duration: ${time_elapsed_s} seconds"
  echo "Analysis duration: ${time_elapsed_h} hours"

  echo ""
  exit 0
}

function dump_human_smi()
{
  global now  delta
  
  echo "$( convert_human_date $now ): $delta SMI events seen this second "

}

function dump_stats_stop()
{
  dump_stats_string "STOP"

}


function dump_stats_start()
{

  dump_stats_string "START"

}

function dump_stats_string()
{
  global now  delta
  local command="$1"
  local test_desc="$test_description"
  
  echo ""
  echo "$( convert_human_date_full $now ) $now $command '$test_desc'" >> "$stats_file"
  echo ""
 
}


function dump_stats_smi()
{
  global now  delta
  
  echo "$( convert_human_date_full $now ) $now SMI $delta" >> "$stats_file"

}

function hrdelta_divide()
{
  local a="$1"
  local b="$2"
  local precision=1

  ret="$( echo "$a" "$b" | awk '{ret=($1/$2); printf("%.1f", ret)}'; )"
  echo "$ret"

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
    echo -n "."
  
    last_refresh="$now"
  fi
  
  #sleep "$sleep_time"

}


stats_file="$HOME/windows_home/smi_count.stats"

last_counter=0
counter=0
sleep_time="0.3"
sleep_time="0.1"
min_to_report_screen=10
min_to_stats=50
#min_to_stats=1

min_passage_time_minutes=5
min_passage_time_minutes2=60
#min_passage_time_minutes=60
min_passage_time_seconds="$(( 60 * min_passage_time_minutes ))"

get_smi_count
last_counter="$counter"

if [ $# -ge 1 ]; then
  test_description="$1"
  
else

  read -p "Please input your test description:  " test_description
  
fi

start_program

while true ; do
  
  #sleep 1
  get_smi_count
  delta=$((  ${counter} - ${last_counter} ))
  
  if [ $delta -ge $min_to_report_screen ]; then
    dump_human_smi
  fi

  if [ $delta -ge $min_to_stats ]; then
    dump_stats_smi
  fi

  show_passage_of_time
  
  last_counter="${counter}"
  
  RET=0
  read -t 0.1 -n 1 answer    || RET=$?
  
  if [[ $RET -eq 0 && "$answer" == "q" ]]; then
    break
  fi
  
done

end_program
 