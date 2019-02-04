#!/bin/bash

FILE1="0_ffprobe.raw"
FILE2="0_ffprobe.txt"

( 
  for i in *.mp3 */*.mp3 ; 
  do 
    ffprobe -v verbose "$i" ; 
  done 
) 2>&1 | egrep -i "input|encod" | tee "$FILE1" 

exit 
#| awk '

{
  if($1=="Input"){ 
    if(A==""){
      A="Unk"
    }; 
    print A; 
    A=""
  } else if($1=="encoder"){
      A="encoder__" $3 "_" $4 "_" $5 "__" 
  } else if($1="encoded_by"){ 
      if(A==""){
        A="encodedby__" $3 "_" $4 "_" $5 "__"
     }
  } 
}

END{ 
   print A
}
' | tee "$FILE2"

