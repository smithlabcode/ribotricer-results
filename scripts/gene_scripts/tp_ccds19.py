# -*- coding:UTF-8 -*-
__author__ = 'Wenzheng Li'
"""
Read CCDS annotation and Ribo- and RNA- profiles to output set of CCDS
genes which are actively translating as True Positives
--------
We need four files for this purpose, and there is coordinate issue to be
taken care of.
The CCDS annotation downloaded from ncbi is 0-based closed cooridinate,
and the stop codon is included in the last exon.
The frames_ccds and Centered_RNA_tracks_ccds and P_sites_all_tracks_ccds are
all 0-based half open.
"""
import sys
from tqdm import *
from collections import defaultdict

ccds_file = sys.argv[1]
ribo_file = sys.argv[2]
rna_file = sys.argv[3]
prefix = sys.argv[4]
cutoff = 5 # number of reads in exon to be considered as translating
min_len = 10 # minimum length of CCDS to be included

rna = {}
ribo = {}
print('reading RNA profiles')
with open(rna_file, 'r') as orf:
    total_lines = len(['' for line in orf])
with open(rna_file, 'r') as orf:
    with tqdm(total=total_lines) as pbar:
        for line in orf:
            pbar.update()
            chrom, start, end, cat, gid, strand, cov = line.strip().split('\t')
            cov = [int(x) for x in cov.strip().split()]
            total = sum(cov)
            start = int(start)
            end = int(end)
            rna[(chrom, start, end, strand)] = [total, gid]

print('reading Ribo profiles')
with open(ribo_file, 'r') as orf:
    total_lines = len(['' for line in orf])
with open(ribo_file, 'r') as orf:
    with tqdm(total=total_lines) as pbar:
        for line in orf:
            pbar.update()
            chrom, start, end, cat, gid, strand, cov = line.strip().split('\t')
            cov = [int(x) for x in cov.strip().split()]
            total = sum(cov)
            start = int(start)
            end = int(end)
            ribo[(chrom, start, end, strand)] = [total, gid]

to_write = ''
keyerror = 0
total_exons = 0
print('reading CCDS annotation')
with open(ccds_file, 'r') as orf:
    total_lines = len(['' for line in orf])
ccds =  defaultdict(list)
with open(ccds_file, 'r') as orf:
    with tqdm(total=total_lines) as pbar:
        for line in orf:
            pbar.update()
            #chrom start end Gene_Trans, ., strand
            chrom, start, end, name, _, strand = line.strip().split('\t')
            start, end = int(start), int(end)
            ccds[(chrom, strand, name)].append((start, end))

de = 0
for (chrom, strand, name), locations in ccds.items():
    de += 1
    if de > 2:
        break
    locations.sort(key=lambda x: x[0])
    valid = True
    rna_reads = 0
    gene_ids = set()
    orf_length = 0
    for i, loc in enumerate(locations):
        total_exons += 1
        # if strand == '+' and i == len(locations)-1:
        #     start = loc[0]
        #     end = loc[1]+1-3
        # elif strand == '-' and i == 0:
        #     start = loc[0]+3
        #     end = loc[1]+1
        # else:
        #     start = loc[0]
        #     end = loc[1] + 1
        start = loc[0]
        end = loc[1]
        orf_length += end - start
        print(chrom, strand, name, start, end)
        try:
            nread, gid = rna[(chrom, start, end, strand)]
            rna_reads += nread
            gene_ids.add(gid)
            nread, gid = ribo[(chrom, start, end, strand)]
            if nread < cutoff:
                valid = False
            gene_ids.add(gid)
        except KeyError:
            valid = False
            keyerror += 1
            continue
    if (valid and rna_reads >= cutoff and len(gene_ids) == 1 and
            orf_length >= min_len):
        to_write += '{}\n'.format(list(gene_ids)[0])
print('Total exons: {}\nKey Errors: {}\n'.format(total_exons, keyerror))
with open('{}_TP_genes.txt'.format(prefix), 'w') as output:
    output.write(to_write)
