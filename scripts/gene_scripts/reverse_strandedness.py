# -*- coding:UTF-8 -*-
__author__ = 'Wenzheng Li'
"""
Since RiboTaper only supports forward stranded reads, 
we need to convert reverse stranded fastq to forward one.
"""
import sys
from tqdm import *
import gzip
from Bio.SeqIO.QualityIO import FastqGeneralIterator

fastq_in = sys.argv[1]
fastq_out = sys.argv[2]

COMPLEMENT = {'A': 'T', 'C': 'G', 'T': 'A', 'G': 'C', 'N': 'N'}
def reverse_complement(seq):
    seq = seq.upper()
    return ''.join(COMPLEMENT[x] for x in seq)

if '.gz' in fastq_in:
    fin = gzip.open(fastq_in, 'rt')
else:
    fin = open(fastq_in, 'r')
with open(fastq_out, 'w') as fout:
    for title, seq, qual in FastqGeneralIterator(fin):
        fout.write('@{}\n{}\n+\n{}\n'.format(title, reverse_complement(seq),
            qual[::-1]))
