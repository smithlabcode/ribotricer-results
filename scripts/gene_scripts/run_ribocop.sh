#!/usr/bin/bash
source activate riboraptor
ref=$1
pro=$2
root="/home/cmb-panasas2/wenzhenl/benchmark/gene_level/${ref}/${pro}/ribocop"
mkdir -p $root
if [ "$ref" = "hg38" ]; then
    echo "hg38"
    gtf="/home/cmb-panasas2/wenzhenl/genomes/hg38/annotation/gencode.v25.annotation.gtf"
    fasta="/home/cmb-panasas2/wenzhenl/genomes/hg38/fasta/hg38.fa"
else
    echo "mm10"
    gtf="/home/cmb-panasas2/wenzhenl/genomes/mm10/annotation/gencode.vM11.annotation.gtf"
    fasta="/home/cmb-panasas2/wenzhenl/genomes/mm10/fasta/mm10.fa"
fi

cd $root
echo $ref
echo $pro
pwd
RiboCop detect-orfs --bam ../RIBO_CCDS_lengths.bam --prefix ribo --gtf $gtf --annotation /home/cmb-panasas2/wenzhenl/genomes/${ref}/annotation/ribocop_annotation/cds_orfs.tsv
RiboCop detect-orfs --bam ../RNA_CCDS_lengths.bam --prefix rna --gtf $gtf --annotation /home/cmb-panasas2/wenzhenl/genomes/${ref}/annotation/ribocop_annotation/cds_orfs.tsv
