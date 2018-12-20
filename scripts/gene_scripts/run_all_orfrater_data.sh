#!/usr/bin/bash
source activate riboraptor
file=$1
while read line
do
    read -r -a array <<< $line
    pro=${array[0]}
    map=${array[1]}
    smp=${array[2]}
    min=${array[3]}
    max=${array[4]}
    root=/staging/as/wenzhenl/realapp/${pro}/${smp}
    scripts=/home/cmb-panasas2/wenzhenl/benchmark/scripts/gene_scripts
    mkdir -p $root
    cd $root
    bash $scripts/run_orfrater_data.sh /staging/as/wenzhenl/re-ribo-analysis/${pro}/${map}/bams/${smp}.bam $min $max
done < $file
