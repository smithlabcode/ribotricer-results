#!/usr/bin/bash
ref=$1
pro=$2
lengths=$3
dst="/home/cmb-panasas2/wenzhenl/benchmark/gene_level/${ref}/${pro}"
mkdir -p $dst
cd $dst
ccds="/home/cmb-panasas2/wenzhenl/benchmark/gene_level/${ref}_frame_ccds.bed"
ribobam="/home/cmb-panasas2/wenzhenl/benchmark/exon_level/${ref}/${pro}/RIBO_best.bam"
rnabam="/home/cmb-panasas2/wenzhenl/benchmark/exon_level/${ref}/${pro}/RNA_best.bam"
printf "intersecting Ribo\n"
bedtools intersect -abam $ribobam -b $ccds -s > RIBO_CCDS.bam
printf "intersecting RNA\n"
bedtools intersect -abam $rnabam -b $ccds -s > RNA_CCDS.bam
printf "filtering Ribo for read lengths\n"
python /home/cmb-panasas2/wenzhenl/benchmark/scripts/bam_of_lengths.py RIBO_CCDS.bam RIBO_CCDS_lengths.bam $lengths
