#!/bin/bash

cat - | sponge  | egrep -- "-|:" | awk '{if(NF==1){ A=$1 } else {print A "  " $0 ; A ="" } } '
