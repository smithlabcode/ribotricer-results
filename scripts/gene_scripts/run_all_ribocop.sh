#!/usr/bin/bash
source activate riboraptor
file=$1
while read line
do
    read -r -a array <<< $line
    pro=${array[0]}
    ref=${array[1]}
    min=${array[2]}
    max=${array[3]}
    bash run_ribocop.sh $ref $pro
done < $file
