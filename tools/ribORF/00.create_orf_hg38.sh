#!/bin/bash
set -eox pipefail
export ribORF_SRC="/home/cmb-panasas2/skchoudh/github_projects/ribocop_tools_source/RibORF/RibORF.1.0/"
export GENOME_FASTA="/home/cmb-panasas2/skchoudh/genomes/hg38/fasta/hg38.fa"
export GTF_TO_GENEPRED="/home/cmb-panasas2/skchoudh/genomes/hg38/annotation/gencode.v25.annotation.gtfTogenePred.genePred"
export OUTPUT_DIR="/home/cmb-panasas2/skchoudh/genomes/hg38/ribORF_annotation"

mkdir -p $OUTPUT_DIR

perl "$ribORF_SRC/ORFannotate.pl" -g "$GENOME_FASTA" -t "$GTF_TO_GENEPRED" -o "$OUTPUT_DIR"

