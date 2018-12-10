#!/usr/bin/bash
source activate riboraptor
ref=$1
pro=$2
root="/home/cmb-panasas2/wenzhenl/benchmark/gene_level/${ref}/${pro}"
if [ "$ref" = "hg38" ]; then
    echo "hg38"
    gtf="/home/cmb-panasas2/wenzhenl/genomes/hg38/annotation/gencode.v25.annotation.gtf"
    fasta="/home/cmb-panasas2/wenzhenl/genomes/hg38/fasta/hg38.fa"
else
    echo "mm10"
    gtf="/home/cmb-panasas2/wenzhenl/genomes/mm10/annotation/gencode.vM11.annotation.gtf"
    fasta="/home/cmb-panasas2/wenzhenl/genomes/mm10/fasta/mm10.fa"
fi
scripts="/home/cmb-panasas2/wenzhenl/benchmark/scripts"
star_index="/home/cmb-panasas2/wenzhenl/genomes/${ref}/star_annotated"

cd $root
echo $ref
echo $pro
pwd
python $scripts/simulatefq.py RNA_CCDS.bam 28,29,30 RNA_CCDS
# STAR --runThreadN 8 --runMode genomeGenerate --genomeFastaFiles hg19_genome.fa --sjdbGTFfile simulated.gtf --genomeDir staridx
STAR --outFilterType BySJout --runThreadN 8 --outFilterMismatchNmax 2 --genomeDir $star_index --readFilesIn RNA_CCDS_lengths.fq --outFileNamePrefix simulated --outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM GeneCounts --outFilterMultimapNmax 1 --outFilterMatchNmin 16 --alignEndsType EndToEnd --outSAMattributes All
mv simulatedAligned.sortedByCoord.out.bam RNA_CCDS_lengths.bam
