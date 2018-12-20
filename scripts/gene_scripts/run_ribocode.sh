#!/usr/bin/bash
source activate test-ribocode
ref=$1
pro=$2
lengths=$3
offsets=$4
# smp=$5
root="/home/cmb-panasas2/wenzhenl/benchmark/gene_level/${ref}/${pro}"
# ribotx="/staging/as/wenzhenl/re-ribo-analysis/${pro}/mapped/srr_tx_bams/${smp}.bam"
cd $root
pwd
printf "get rna tx bam\n"
# python /home/cmb-panasas2/wenzhenl/benchmark/scripts/gene_scripts/bam_of_lengths.py $ribotx RIBO_tx.bam $lengths
mkdir -p $root/ribocode
cd $root/ribocode
pwd
anno='/home/cmb-panasas2/wenzhenl/genomes/hg38/annotation/ribocode_annotation'
echo '#SampleName	AlignmentFile	Stranded(yes/reverse) EffectiveReadLength P-siteReadLength P-siteOffsets' > rna_config.txt
echo "rna $root/simulatedAligned.toTranscriptome.out.bam yes 28,29,30 12,12,12" >> rna_config.txt
echo '#SampleName	AlignmentFile	Stranded(yes/reverse) EffectiveReadLength P-siteReadLength P-siteOffsets' > ribo_config.txt
echo "ribo $root/RIBO_tx.bam yes ${lengths} ${offsets}" >> ribo_config.txt
echo 'finished'

RiboCode -a $anno -c ribo_config.txt -p 10  -o ribo
RiboCode -a $anno -c rna_config.txt  -p 10 -o rna
