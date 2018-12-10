#!/bin/bash
set -eox pipefail
export riboHMM_SRC="/home/cmb-panasas2/skchoudh/github_projects/riboHMM/"
export OUT_DIR="/staging/as/skchoudh/riboHMM_out/hg38_synfootprints"
export GENOME_GTF="/home/cmb-panasas2/skchoudh/genomes/hg38/annotation/gencode.v25.annotation.gtf"
export GENOME_FASTA=" /home/cmb-panasas2/skchoudh/genomes/hg38/fasta/hg38.fa"
python "$riboHMM_SRC/construct_synthetic_footprints.py" --output_fastq_prefix $OUT_DIR $GENOME_GTF $GENOME_FASTA

