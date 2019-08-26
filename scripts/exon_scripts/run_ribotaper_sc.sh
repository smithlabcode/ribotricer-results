#!/usr/bin/bash
set -eox pipefail
ref=$1
pro=$2
ribo=$3
rna=$4
reads=$5
offsets=$6
data_dir="/home/cmb-panasas2/skchoudh/github_projects/2019_ribotricer_rebuttal/reviewer1/comment_data/${ref}/${pro}"
ribotaper_src="/home/cmb-panasas2/skchoudh/github_projects/ribotricer-results/tools/ribotaper/ribotaper-1.3.1a/scripts/Ribotaper.sh"
ribotaper_source="/home/cmb-panasas2/skchoudh/github_projects/ribotricer-results/tools/ribotaper/ribotaper-1.3.1a/scripts/"
ribotaper_annotation="/home/cmb-panasas2/skchoudh/genomes/${ref}/ribotaper_annotation_v96/"
bedtools_dir="/home/cmb-06/as/skchoudh/software_frozen/anaconda37/envs/ribotaper/bin"
mkdir -p /home/cmb-panasas2/skchoudh/github_projects/2019_ribotricer_rebuttal/reviewer1/comment_analysis/${ref}/${pro}
cd /home/cmb-panasas2/skchoudh/github_projects/2019_ribotricer_rebuttal/reviewer1/comment_analysis/${ref}/${pro}
printf "ribo: ${ribo}\nrna: ${rna}\n" > samples_used.txt
printf "read lengths: ${reads}\noffsets: ${offsets}\n" >> samples_used.txt
printf "$ribotaper_src $data_dir/bams_unique/${ribo}.bam $data_dir/bams_unique/${rna}.bam $ribotaper_annotation $reads $offsets 16" >> samples_used.txt
bash $ribotaper_src $data_dir/bams_unique/${ribo}.bam $data_dir/bams_unique/${rna}.bam $ribotaper_annotation $reads $offsets 16
