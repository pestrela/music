#!/bin/bash

# https://www.howtogeek.com/354220/how-to-enable-case-sensitive-folders-on-windows-10/

function die()
{
  echo "Error: $@"
  #read
  exit 1
}

function display_help()
{
  echo "
  $0 <folder> [folders]
  
  Manipulates the case-sensitivity setting of NTFS in windows 10
  
operations:  
  -q: show case sensitivity status
  -s: set case-sensitive    (=linux mode, macOS mode)
  -i: set case-INsensitive  (=windows mode)
  
options:  
  -r: recursive
  -f: force actual changes
  
help:  
  -h: display help
  -d: debug trace
  "
  exit 0
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


function tag_file_to_delete()
{
  local file_in="$1"
  
  local dirname_in="$( dirname "$file_in" )"
  local basename_in="$( basename "$file_in" )"
  
  
  local file_out="${dirname_in}/__delete_me__${basename_in}"

  mv "$file_in" "$file_out"
}

function recycle()
{
  local file="$1"
  local recycle_folder="/mnt/c/Root/0_linux_home/recycle_bin"
  
  mv -b "$file" "$recycle_folder"
}

#set -x

set -e
set -u


do_recursive=0
oper="query"
do_final_read=0
force=0
needs_force=1
debug=0

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
     
  -r)
    do_recursive=1
    ;;

  -f)
    force=1
    ;;

    
  -s|--sensitive)
    oper="set_sensitive"
    ;;
    
  -i|--insensitive)
    oper="set_insensitive"
    ;;
    
  -q)
    oper="query"
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
  if [ $do_recursive -ge 1 ]; then
    die "Cannot do recursive without specifying folders"
  fi
  add_argv "."

fi

needs_force=1
case "$oper" in
query)
  needs_force=0
  ;;
*)
  needs_force=1
  ;;
esac

if [ $needs_force -ge 1 ]; then
  if [ $force -eq 0 ]; then
    die "Changes require option -f as well"
  fi
fi

if [ $debug -ge 1 ]; then
  set -x
fi


while [ "$argc" -ge 1 ]; do
  folder="${argv[1]}"
  shift_argv

  #file_in_linux="$( wslpath "$file_in_win" )"
  case "$oper" in
  set_sensitive)
    fsutil.exe file setCaseSensitiveInfo "$folder" enable
    ;;
  set_insensitive)
    fsutil.exe file setCaseSensitiveInfo "$folder" disable
    ;;
     
  query)
    fsutil.exe file queryCaseSensitiveInfo "$folder"
    ;;
  esac
    
done


if [ $do_final_read -ge 1 ]; then
  echo ""
  echo "All done"
  read
fi




