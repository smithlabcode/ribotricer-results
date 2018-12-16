#!/usr/bin/bash
source activate riboraptor
file=$1
while read line
do
    read -r -a array <<< $line
    pro=${array[0]}
    ref=${array[1]}
    bash run_star.sh $ref $pro
done < $file
