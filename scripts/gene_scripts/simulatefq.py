# -*- coding:UTF-8 -*-
__author__ = 'Wenzheng Li'
"""
Read the frame_ccds file generated by RiboTaper and convert it to a bed file.
Bed file will be used to intersect with bam file to extract reads for only CCDS.
"""

import sys
import random
import pysam
random.seed(42)

rna = sys.argv[1]
lengths = sys.argv[2]
prefix = sys.argv[3]

COMPLETE = {'A': 'T', 'T': 'A', 'C': 'G', 'G': 'C', 'N': 'N'}
def reverse_complement(sequence):
    return ''.join(COMPLETE[x] for x in sequence[::-1])

to_write = ''
read_lengths = [int(x) for x in lengths.split(',')]
bam = pysam.AlignmentFile(rna, 'rb')
for r in bam.fetch(until_eof=True):
    seq = r.seq
    qual = r.qual
    name = r.query_name
    # if r.is_reverse:
    #     seq = reverse_complement(seq[::-1])
    #     qual = qual[::-1]
    if r.query_length in read_lengths:
        pass
    elif r.query_length < min(read_lengths):
        continue
    else:
        trim = r.query_length - random.sample(read_lengths, 1)[0]
        trim_direction = random.choice([1, -1])
        if trim_direction == 1:
            seq = seq[trim:]
            qual = qual[trim:]
        else:
            seq = seq[:-trim]
            qual = qual[:-trim]
    to_write += '@{}\n{}\n+\n{}\n'.format(name, seq, qual)

with open('{}_lengths.fq'.format(prefix), 'w') as fout:
    fout.write(to_write)
