#!/bin/bash
set -eox pipefail
export riboHMM_SRC="/home/cmb-panasas2/skchoudh/github_projects/riboHMM/"
export GENOME_FASTA="/home/cmb-panasas2/skchoudh/genomes/hg38/fasta/hg38.fa"
export GENOME_GTF="/home/cmb-panasas2/skchoudh/genomes/hg38/annotation/gencode.v25.annotation.gtf"
export OUTPUT_DIR="/staging/as/skchoudh/riboHMM_out/SRP"

python "$riboHMM_SRC/infer_CDS.py" --rnaseq_file $1 --mappability_file $2 test/hg19_model.txt "$GENOME_FASTA" "$GENOME_GTF" "$OUTPUT_DIR"

