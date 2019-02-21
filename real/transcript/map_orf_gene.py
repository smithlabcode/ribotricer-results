"""Utilities for analysis
"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import warnings

from collections import Counter
from collections import defaultdict
import sys

columns = [
    'ORF_ID', 'ORF_type', 'status', 'phase_score', 'read_count', 'length',
    'valid_codons', 'transcript_id', 'transcript_type', 'gene_id',
    'gene_name', 'gene_type', 'chrom', 'strand', 'start_codon', 'profile\n'
]
_, orf_f, index_f = sys.argv
annotated = {}
with open(index_f, 'r') as fin:
    header = True
    annotated = defaultdict(int)
    for line in fin:
        if header:
            header = False
            continue
        fields = line.strip().split('\t')
        oid = fields[0]
        otype = fields[1]
        # status = fields[2]
        # phase_score = fields[3]
        # read_count = int(fields[4])
        # length = fields[5]
        # valid_codons = fields[6]
        # tid = fields[7]
        # ttype = fields[8]
        # gid = fields[9]
        # gname = fields[10]
        # gtype = fields[11]
        # chrom = fields[12]
        # strand = fields[13]
        # start_codon = fields[14]
        annotated[oid] = fields[4]
converted = set()
with open(orf_f, 'r') as fin:
    header = True
    for line in fin:
        if header:
            header = False
            continue
        fields = line.strip().split()
        oid = fields[0]
        converted.add(annotated[oid])
with open('uniq_genes', 'w') as fout:
    for g in converted:
        fout.write('{}\n'.format(g))
