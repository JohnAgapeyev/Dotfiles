#!/bin/bash

awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' $1 | sort | uniq -c | sed "s/^[ \t]*//" | grep -v ^1 | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' > umatrix_temp
cat $1 | grep "^[^\*]" > umatrix_otherTemp
grep -v -f umatrix_temp umatrix_otherTemp > umatrix_output.txt
rm umatrix_temp
rm umatrix_otherTemp
cat $1 | grep "^\*" >> umatrix_output.txt
cat umatrix_output.txt | sort -u > umatrix_temp
mv umatrix_temp umatrix_output.txt

