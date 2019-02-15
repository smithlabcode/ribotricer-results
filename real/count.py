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

print('exporting coverages for all ORFs...')
columns = [
    'ORF_ID', 'ORF_type', 'status', 'phase_score', 'read_count', 'length',
    'valid_codons', 'transcript_id', 'transcript_type', 'gene_id',
    'gene_name', 'gene_type', 'chrom', 'strand', 'start_codon', 'profile\n'
]
uorf_count = defaultdict(list)
cds_count = defaultdict(list)
for i, f in enumerate(sys.argv[1:]):
    with open(f, 'r') as fin:
        header = True
        annotated = defaultdict(int)
        for line in fin:
            if header:
                header = False
                continue
            fields = line.strip().split('\t')
            oid = fields[0]
            otype = fields[1]
            status = fields[2]
            phase_score = fields[3]
            read_count = int(fields[4])
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
            if otype == 'annotated':
                if status == 'translating':
                    annotated[tid] = read_count
                else:
                    annotated[tid] = 0
            elif otype in ['uORF', 'overlap_uORF']:
                if status == 'translating':
                    uorf_count[oid].append(read_count)
                else:
                    uorf_count[oid].append(0)
                cds_count[oid].append(annotated[tid])

with open('uorf_cnt.txt', 'w') as fout:
    fout.write('ORF_ID\tSRX118286\tSRX118292\tSRX118290\tSRX118296\n')
    for k in sorted(uorf_count):
        fout.write('{}\t{}\t{}\t{}\t{}\n'.format(k, uorf_count[k][0], uorf_count[k][1],
            uorf_count[k][2], uorf_count[k][3]))

with open('cds_cnt.txt', 'w') as fout:
    fout.write('ORF_ID\tSRX118286\tSRX118292\tSRX118290\tSRX118296\n')
    for k in sorted(cds_count):
        fout.write('{}\t{}\t{}\t{}\t{}\n'.format(k, cds_count[k][0], cds_count[k][1],
            cds_count[k][2], cds_count[k][3]))
