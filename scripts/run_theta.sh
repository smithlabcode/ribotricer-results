#!/usr/bin/bash
ref=$1
pro=$2
source activate riboraptor
cd /home/cmb-panasas2/wenzhenl/benchmark/${ref}/${pro}
RiboCop theta-dist --rna data_tracks/Centered_RNA_tracks_ccds --ribo data_tracks/P_sites_all_tracks_ccds --frame /home/cmb-panasas2/wenzhenl/genomes/${ref}/annotation/ribotaper_annotation/frames_ccds --prefix ${pro}
Rscript /home/cmb-panasas2/wenzhenl/benchmark/scripts/theta.R ${pro}
