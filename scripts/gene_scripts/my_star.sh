#!/usr/bin/bash
source activate riboraptor
data=$1
ref=$2
prefix=$3
if [ "$ref" = "hg38" ]; then
    echo "hg38"
    gtf="/home/cmb-panasas2/wenzhenl/genomes/hg38/annotation/gencode.v25.annotation.gtf"
    fasta="/home/cmb-panasas2/wenzhenl/genomes/hg38/fasta/hg38.fa"
else
    echo "mm10"
    gtf="/home/cmb-panasas2/wenzhenl/genomes/mm10/annotation/gencode.vM11.annotation.gtf"
    fasta="/home/cmb-panasas2/wenzhenl/genomes/mm10/fasta/mm10.fa"
fi
star_index="/home/cmb-panasas2/wenzhenl/genomes/${ref}/star_annotated"

# STAR --runThreadN 8 --runMode genomeGenerate --genomeFastaFiles hg19_genome.fa --sjdbGTFfile simulated.gtf --genomeDir staridx
STAR --outFilterType BySJout --runThreadN 16 --outFilterMismatchNmax 2 --genomeDir $star_index --readFilesIn $data --outFileNamePrefix $prefix --outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM GeneCounts --outFilterMultimapNmax 1 --outFilterMatchNmin 16 --alignEndsType EndToEnd --outSAMattributes All
