#!/usr/bin/bash
ref=$1
pro=$2
cd /home/cmb-panasas2/wenzhenl/benchmark/${ref}/${pro}
echo 'running RiboCode'
source activate roc27
python /home/cmb-panasas2/wenzhenl/benchmark/scripts/generate_ribocode_pvalue.py $ref $pro
echo 'running RiboCop'
source activate riboraptor
RiboCop benchmark --rna data_tracks/Centered_RNA_tracks_ccds --ribo data_tracks/P_sites_all_tracks_ccds --prefix ribocop
echo 'running ROC'
python /home/cmb-panasas2/wenzhenl/benchmark/scripts/generate_ROC_input.py $ref $pro
Rscript /home/cmb-panasas2/wenzhenl/benchmark/scripts/ROC.R
mkdir -p /staging/as/wenzhenl/jupyter/roc/${ref}/${pro}
cp auc.txt /staging/as/wenzhenl/jupyter/roc/${ref}/${pro}
cp ROC.pdf /staging/as/wenzhenl/jupyter/roc/${ref}/${pro}
echo 'running theta'
RiboCop theta-dist --rna data_tracks/Centered_RNA_tracks_ccds --ribo data_tracks/P_sites_all_tracks_ccds --frame /home/cmb-panasas2/wenzhenl/genomes/${ref}/annotation/ribotaper_annotation/frames_ccds --prefix ${pro}
Rscript /home/cmb-panasas2/wenzhenl/benchmark/scripts/theta.R ${pro}
mkdir -p /staging/as/wenzhenl/jupyter/theta/${ref}/${pro}
cp ${pro}_angle_stats.txt /staging/as/wenzhenl/jupyter/theta/${ref}/${pro}
cp ${pro}_theta_dist.pdf /staging/as/wenzhenl/jupyter/theta/${ref}/${pro}
