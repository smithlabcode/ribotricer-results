#!/usr/bin/bash
source activate test-orfrater4
ref=$1
pro=$2
rna_min=$3
rna_max=$4
ribo_min=$5
ribo_max=$6
root="/home/cmb-panasas2/wenzhenl/benchmark/gene_level/${ref}/${pro}/ORF-RATER"
if [ "$ref" = "hg38" ]; then
    echo "hg38"
    gtf="/home/cmb-panasas2/wenzhenl/genomes/hg38/annotation/gencode.v25.annotation.gtf"
    fasta="/home/cmb-panasas2/wenzhenl/genomes/hg38/fasta/hg38.fa"
else
    echo "mm10"
    gtf="/home/cmb-panasas2/wenzhenl/genomes/mm10/annotation/gencode.vM11.annotation.gtf"
    fasta="/home/cmb-panasas2/wenzhenl/genomes/mm10/fasta/mm10.fa"
fi
scripts="/home/cmb-panasas2/wenzhenl/github/ORF-RATER"
db="/home/cmb-panasas2/wenzhenl/benchmark/gene_level/${ref}/${pro}"
cd $db
samtools index RIBO_CCDS_lengths.bam
samtools index RNA_CCDS.bam
rna="$db/RNA_CCDS.bam"
ribo="$db/RIBO_CCDS_lengths.bam"
mkdir -p $root/rna
mkdir -p $root/ribo
cd $root/rna
printf "processing RNA-seq data\n"
gtfToGenePred -ignoreGroupsWithoutExons $gtf stdout | genePredToBed stdin gencode.annotation.bed
python $scripts/prune_transcripts.py --inbed gencode.annotation.bed --summarytable tid_removal_summary.txt -p 16 -v $fasta $rna > 1prune.log
python $scripts/make_tfams.py -v > 2make_tfams.log
python $scripts/find_orfs_and_types.py $fasta --codons ATG -p 16 -v > 3find_ORF.log
python $scripts/psite_trimmed.py $rna --minrdlen $rna_min --maxrdlen $rna_max --subdir RNA --tallyfile tallies.txt --cdsbed gencode.annotation.bed -p 16 -v > 4psite.log
python $scripts/regress_orfs.py $rna --mincdsreads 10 --subdir RNA -p 16 -v > 5regress.log
python $scripts/rate_regression_output.py RNA -p 16 --CSV rate_regression.csv -v > 6rate.log
python $scripts/make_orf_bed.py --minrating 0 > 7make_orf.log
python $scripts/quantify_orfs.py $rna --subdir RNA -p 16 -v --force --CSV quant.csv --minrating 0
cd $root/ribo
printf "processing Ribo-seq data\n"
gtfToGenePred -ignoreGroupsWithoutExons $gtf stdout | genePredToBed stdin gencode.annotation.bed
python $scripts/prune_transcripts.py --inbed gencode.annotation.bed --summarytable tid_removal_summary.txt -p 16 -v $fasta $ribo > 1prune.log
python $scripts/make_tfams.py -v > 2make_tfams.log
python $scripts/find_orfs_and_types.py $fasta --codons ATG -p 16 -v > 3find_ORF.log
python $scripts/psite_trimmed.py $ribo --minrdlen $ribo_min --maxrdlen $ribo_max --subdir Ribo --tallyfile tallies.txt --cdsbed gencode.annotation.bed -p 16 -v > 4psite.log
python $scripts/regress_orfs.py $ribo --mincdsreads 10 --subdir Ribo -p 16 -v > 5regress.log
python $scripts/rate_regression_output.py Ribo -p 16 --CSV rate_regression.csv -v > 6rate.log
python $scripts/make_orf_bed.py --minrating 0 > 7make_orf.log
python $scripts/quantify_orfs.py $ribo --subdir Ribo -p 16 -v --force --CSV quant.csv --minrating 0
