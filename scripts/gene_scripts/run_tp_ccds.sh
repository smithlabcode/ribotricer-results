#!/usr/bin/bash
ref=$1
pro=$2
cd /home/cmb-panasas2/wenzhenl/benchmark/gene_level/${ref}/${pro}
python /home/cmb-panasas2/wenzhenl/benchmark/scripts/gene_scripts/tp_ccds.py /home/cmb-panasas2/wenzhenl/genomes/${ref}/annotation/CCDS.20181207.txt /home/cmb-panasas2/wenzhenl/benchmark/exon_level/${ref}/${pro}_from_fastq/data_tracks/P_sites_all_tracks_ccds /home/cmb-panasas2/wenzhenl/benchmark/exon_level/${ref}/${pro}_from_fastq/data_tracks/Centered_RNA_tracks_ccds /home/cmb-panasas2/wenzhenl/genomes/${ref}/annotation/ribocop_annotation/cds_orfs.tsv ${pro}
