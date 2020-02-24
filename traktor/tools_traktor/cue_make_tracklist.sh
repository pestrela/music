#!/bin/bash

#set -x

folder="$( basename "$( pwd )" )"
file1="${folder} - tracklist.txt"
file3="${folder} - set notes.txt"

tracklist="`ls -1 *.flac *.mp* *.MP* *.FLA*  | sed 's/\.[^.]*$//' `"

do_tl=1
<<<<<<< HEAD
do_set=1
=======
do_set=0
>>>>>>> 5b137ccf93381f6de39617a7e9ecf996693224a4
if [ "$1" == "-s" ]; then 
  do_set=1
fi

if [ "$do_tl" -ge 1 ]; then
  # tracklist: simple, with a one-line header
  (
  echo "

$folder

$tracklist

"

  ) > "$file1"
  echo "Generated: $file1"
  
fi


if [ "$do_set" -ge 1 ]; then

  # set notes: 
  #   - just the beginning of the tracks
  #   - one space per track
  (
  echo "

ERROS:
-----  
   TBD


PAREI A OUVIR:
--------------
  TBD


SET NOTES:
----------
  COM MT / SEM MT

"

  echo "$tracklist" | cut -b-25 | awk '{print $0 ":"; print ""}'

  echo ""

  ) > "$file3"
  echo "Generated: $file3"
fi



exit 0


