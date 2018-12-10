#!/bin/bash
set -eox pipefail
source activate riborf
samtools view -h -o $1.sam $1
perl /home/cmb-panasas2/skchoudh/github_projects/ribocop_tools_source/RibORF/RibORF.1.0/offsetCorrect.pl -r $1.sam -p offset.correction.parameters.txt -o $1.ribORF.corrected.mapping.sam

