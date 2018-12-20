#!/usr/bin/bash
source activate riboraptor
ref=$1
pro=$2
lengths=$3
if [ "$ref" = "hg38" ]; then
    echo "hg38"
    gtf="/home/cmb-panasas2/wenzhenl/genomes/hg38/annotation/gencode.v25.annotation.gtf"
    fasta="/home/cmb-panasas2/wenzhenl/genomes/hg38/fasta/hg38.fa"
else
    echo "mm10"
    gtf="/home/cmb-panasas2/wenzhenl/genomes/mm10/annotation/gencode.vM11.annotation.gtf"
    fasta="/home/cmb-panasas2/wenzhenl/genomes/mm10/fasta/mm10.fa"
fi
scripts="/home/cmb-panasas2/wenzhenl/benchmark/scripts/gene_scripts"
star_index="/home/cmb-panasas2/wenzhenl/genomes/${ref}/star_annotated"

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
python $scripts/bam_of_lengths.py RIBO_CCDS.bam RIBO_CCDS_lengths.bam $lengths
printf "simulating RNA for read lengths\n"
python $scripts/simulatefq.py RNA_CCDS.bam 28,29,30 RNA_CCDS
STAR --outFilterType BySJout --runThreadN 8 --outFilterMismatchNmax 2 --genomeDir $star_index --readFilesIn RNA_CCDS_lengths.fq --outFileNamePrefix simulated --outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM GeneCounts --outFilterMultimapNmax 1 --outFilterMatchNmin 16 --alignEndsType EndToEnd --outSAMattributes All
mv simulatedAligned.sortedByCoord.out.bam RNA_CCDS_lengths.bam
