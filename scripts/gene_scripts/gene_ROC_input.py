# -*- coding:UTF-8 -*-
__author__ = 'Wenzheng Li'
"""
Generate ROC input for gene level benchmark
"""

import sys
ref = sys.argv[1]
pro = sys.argv[2]

# ground truth
truth = '/home/cmb-panasas2/wenzhenl/benchmark/gene_level/{}/{}/{}_TP_genes.txt'.format(ref, pro, pro)

# ORF-RATER
orfrater_rna = '/home/cmb-panasas2/wenzhenl/benchmark/gene_level/{}/{}/ORF-RATER/rna/quant.csv'.format(ref, pro)
orfrater_ribo = '/home/cmb-panasas2/wenzhenl/benchmark/gene_level/{}/{}/ORF-RATER/ribo/quant.csv'.format(ref, pro)

# ribORF
riborf_rna = '/home/cmb-panasas2/skchoudh/benchmark/gene_level/{}/{}/ribORF_results/orfs/RNA/pred.pvalue.parameters.txt'.format(ref, pro)
riborf_ribo = '/home/cmb-panasas2/skchoudh/benchmark/gene_level/{}/{}/ribORF_results/orfs/RIBO/pred.pvalue.parameters.txt'.format(ref, pro)
