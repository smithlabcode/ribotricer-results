#!/usr/bin/bash
ref=$1
pro=$2
ribo=$3
rna=$4
reads=$5
offsets=$6
mkdir -p /home/cmb-panasas2/wenzhenl/benchmark/${ref}/${pro}
cd /home/cmb-panasas2/wenzhenl/benchmark/${ref}/${pro}
printf "ribo: ${ribo}\nrna: ${rna}\n" > samples_used.txt
printf "read lengths: ${reads}\noffsets: ${offsets}\n" >> samples_used.txt
printf "/home/cmb-panasas2/wenzhenl/github/ribotaper/scripts/Ribotaper.sh /staging/as/wenzhenl/re-ribo-analysis/${pro}/mapped/bams/${ribo}.bam /staging/as/wenzhenl/re-ribo-analysis/${pro}/mapped/bams/${rna}.bam /home/cmb-panasas2/wenzhenl/genomes/${ref}/annotation/ribotaper_annotation/ $reads $offsets /home/cmb-panasas2/wenzhenl/github/ribotaper/scripts/ /home/cmb-panasas2/wenzhenl/miniconda3/envs/ribotaper/bin/ 16" >> samples_used.txt
/home/cmb-panasas2/wenzhenl/github/ribotaper/scripts/Ribotaper.sh /staging/as/wenzhenl/re-ribo-analysis/${pro}/mapped/bams/${ribo}.bam /staging/as/wenzhenl/re-ribo-analysis/${pro}/mapped/bams/${rna}.bam /home/cmb-panasas2/wenzhenl/genomes/${ref}/annotation/ribotaper_annotation/ $reads $offsets /home/cmb-panasas2/wenzhenl/github/ribotaper/scripts/ /home/cmb-panasas2/wenzhenl/miniconda3/envs/ribotaper/bin/ 16
