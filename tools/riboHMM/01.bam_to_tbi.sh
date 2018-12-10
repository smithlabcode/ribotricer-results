#!/bin/bash
set -eox pipefail
source activate ribohmm
samtools index $1
python /home/cmb-panasas2/skchoudh/github_projects/riboHMM/bam_to_tbi.py --dtype riboseq $1


