# -*- coding:UTF-8 -*-
__author__ = 'Wenzheng Li'
"""
Generate ROC input for gene level benchmark
"""

import sys
import gzip
import numpy as np
from collections import defaultdict

ref = sys.argv[1]
pro = sys.argv[2]
# lengths = sys.argv[3]
# offsets = sys.argv[4]

root = '/home/cmb-panasas2/wenzhenl/benchmark/gene_level/{}/{}'.format(ref, pro)

selected = {}
# ground truth
truth = '{}/{}_TP_CCDS_genes.txt'.format(root, pro)
with open(truth, 'r') as fin:
    for r in fin:
        orfid, gid, tid, chrom, strand, coor = r.strip().split('\t')
        selected[tid] = (gid, chrom, strand, coor)

# ORF-RATER
orfrater_ribo = '{}/ORF-RATER/ribo/quant.csv'.format(root)
orfrater_rna = '{}/ORF-RATER/rna/quant.csv'.format(root)

# ribORF
# riborf_rna = '/home/cmb-panasas2/skchoudh/benchmark/gene_level/{}/{}/ribORF_results/orfs/RNA/pred.pvalue.parameters.txt'.format(ref, pro)
# riborf_ribo = '/home/cmb-panasas2/skchoudh/benchmark/gene_level/{}/{}/ribORF_results/orfs/RIBO/pred.pvalue.parameters.txt'.format(ref, pro)
#rpbp
# rpbp_result_true = "RpBp_results/results_true/hek293.alignments-only-unique.length-26-27-28-29.offset-12-12-12-12.frac-0.2.rw-0.bayes-factors.bed.gz"
# rpbp_result_simulation = "RpBp_results/results_simulation/hek293.alignments-only-unique.length-26-27-28-29.offset-12-12-12-12.frac-0.2.rw-0.bayes-factors.bed.gz"
#
# rpbp_ribo = '{}/RIBO_CCDS_lengths.alignments-only-unique.length-{}.offset-{}.frac-0.2.rw-0.bayes-factors.bed.gz'.format(root, lengths, offsets)
# rpbp_rna = '{}/RNA_CCDS_lengths.alignments-only-unique.length-{}.offset-{}.frac-0.2.rw-0.bayes-factors.bed.gz'.format(root, lengths, offsets)

#ribocode
print('processing RiboCode results')
ribocode_ribo_genes = defaultdict(float)
ribocode_rna_genes = defaultdict(float)
ribocode_ribo = '{}/ribocode/ribo.txt'.format(root)
ribocode_rna = '{}/ribocode/rna.txt'.format(root)
with open(ribocode_ribo, 'r') as fin:
    for r in fin:
        ORF_ID,ORF_type,transcript_id,transcript_type,gene_id,gene_name,gene_type,chrom,strand,ORF_length,ORF_tstart,ORF_tstop,ORF_gstart,ORF_gstop,annotated_tstart,annotated_tstop,annotated_gstart,annotated_gstop,Psites_sum_frame0,Psites_sum_frame1,Psites_sum_frame2,Psites_coverage_frame0,Psites_coverage_frame1,Psites_coverage_frame2,Psites_frame0_RPKM,pval_frame0_vs_frame1,pval_frame0_vs_frame2,pval_combined,AAseq = r.split('\t')
        if ORF_type == 'annotated' and transcript_id in selected:
            ribocode_ribo_genes[transcript_id] = np.float(pval_combined)
with open(ribocode_rna, 'r') as fin:
    for r in fin:
        ORF_ID,ORF_type,transcript_id,transcript_type,gene_id,gene_name,gene_type,chrom,strand,ORF_length,ORF_tstart,ORF_tstop,ORF_gstart,ORF_gstop,annotated_tstart,annotated_tstop,annotated_gstart,annotated_gstop,Psites_sum_frame0,Psites_sum_frame1,Psites_sum_frame2,Psites_coverage_frame0,Psites_coverage_frame1,Psites_coverage_frame2,Psites_frame0_RPKM,pval_frame0_vs_frame1,pval_frame0_vs_frame2,pval_combined,AAseq = r.split('\t')
        if ORF_type == 'annotated' and transcript_id in selected:
            ribocode_rna_genes[transcript_id] = np.float(pval_combined)
print('ribo:', len(ribocode_ribo_genes))
print('rna:', len(ribocode_rna_genes))


#ribocop
print('processing ribocop results')
ribocop_ribo_genes = defaultdict(float)
ribocop_rna_genes = defaultdict(float)
ribocop_ribo = '{}/ribocop/ribo_translating_ORFs.tsv'.format(root)
ribocop_rna = '{}/ribocop/rna_translating_ORFs.tsv'.format(root)
with open(ribocop_ribo, 'r') as fin:
    for r in fin:
        ORF_ID,coverage,count,length,nonzero,periodicity,pval = r.split('\t')
        tid = ORF_ID.split('_')[0]
        if tid in selected:
            ribocop_ribo_genes[tid] = np.float(periodicity)
with open(ribocop_rna, 'r') as fin:
    for r in fin:
        ORF_ID,coverage,count,length,nonzero,periodicity,pval = r.split('\t')
        tid = ORF_ID.split('_')[0]
        if tid in selected:
            ribocop_rna_genes[tid] = np.float(periodicity)

print('ribo:', len(ribocop_ribo_genes))
print('rna:', len(ribocop_rna_genes))

to_write = 'tid\ttruth\tribocop\tribocode\n'
for tid in selected:
    if tid not in ribocop_ribo_genes:
        ribocop_ribo_genes[tid] = 0.0
    if tid not in ribocop_rna_genes:
        ribocop_rna_genes[tid] == 0.0
    if tid not in ribocode_ribo_genes:
        ribocode_ribo_genes[tid] = 1.0
    if tid not in ribocode_rna_genes:
        ribocode_rna_genes[tid] = 1.0
    to_write += '{}_ribo\t{}\t{}\t{}\n'.format(tid, 1, ribocop_ribo_genes[tid], ribocode_ribo_genes[tid])
    to_write += '{}_rna\t{}\t{}\t{}\n'.format(tid, 0, ribocop_rna_genes[tid], ribocode_rna_genes[tid])

with open('ROC_input.txt', 'w') as fout:
    fout.write(to_write)
