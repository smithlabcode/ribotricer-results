"""Utilities for analysis
"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import warnings

from collections import Counter
from collections import defaultdict
import numpy as np
from tqdm import *
import sys

orf_file = sys.argv[1]
print('exporting coverages for all ORFs...')
columns = [
    'ORF_ID', 'ORF_type', 'status', 'phase_score', 'read_count', 'length',
    'valid_codons', 'transcript_id', 'transcript_type', 'gene_id',
    'gene_name', 'gene_type', 'chrom', 'strand', 'start_codon', 'profile\n'
]
to_write = '\t'.join(columns)
formatter = '{}\t' * (len(columns) - 1) + '{}\n'

cnt = 0
with open(orf_file, 'r') as orf, open('filtered_result.txt', 'w') as output:
    header = True
    for line in orf:
        # cnt += 1
        # if cnt > 10:
            # break
        if header:
            header = False
            output.write(to_write)
            continue
        fields = line.strip().split('\t')
        oid = fields[0]
        otype = fields[1]
        status = fields[2]
        phase_score = fields[3]
        read_count = fields[4]
        length = fields[5]
        valid_codons = fields[6]
        tid = fields[7]
        ttype = fields[8]
        gid = fields[9]
        gname = fields[10]
        gtype = fields[11]
        chrom = fields[12]
        strand = fields[13]
        start_codon = fields[14]
        cov = fields[15]
        cov = cov[1:-1]
        cov = [int(x) for x in cov.split(', ')]
        if status == 'nontranslating':
            continue
        if sum([sum(cov[i:i + 3]) > 0 for i in range(0, 30, 3)]) < 5:
            continue
        output.write(line)
