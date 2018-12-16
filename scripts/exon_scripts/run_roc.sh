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
