# -*- coding:UTF-8 -*-
__author__ = 'Wenzheng Li'
"""
Extract reads from bam file and write into fastq
"""

import sys
import random
import pysam

fin = sys.argv[1]
fout = sys.argv[2]
reverse = sys.argv[3]
lengths = sys.argv[4]

COMPLETE = {'A': 'T', 'T': 'A', 'C': 'G', 'G': 'C', 'N': 'N'}
def reverse_complement(sequence):
    return ''.join(COMPLETE[x] for x in sequence[::-1])

if lengths:
    read_lengths = [int(x) for x in lengths.split(',')]
bam = pysam.AlignmentFile(fin, 'rb')
with open(fout, 'w') as output:
    for r in bam.fetch(until_eof=True):
        if lengths and r.query_length not in read_lengths:
            continue
        seq = r.seq
        qual = r.qual
        name = r.query_name
        if reverse:
            seq = reverse_complement(seq)
            qual = qual[::-1]

        to_write = '@{}\n{}\n+\n{}\n'.format(name, seq, qual)
        output.write(to_write)
