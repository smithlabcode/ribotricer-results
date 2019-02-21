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

_, T, U = sys.argv
annotated = {}
with open(T, 'r') as fin:
    head = True
    for line in fin:
        if head:
            head = False
            continue
        parts = line.strip().split()
        oid = parts[0]
        fold = float(parts[2])
        tid = oid[:oid.find('_')]
        annotated[tid] = fold

with open(U, 'r') as fin, open('foldchange.txt', 'w') as fout:
    fout.write('{}\t{}\t{}\n'.format('ORF_ID', 'FC_U', 'FC_T'))
    head = True
    for line in fin:
        if head:
            head = False
            continue
        parts = line.strip().split()
        oid = parts[0]
        fold = float(parts[2])
        tid = oid[:oid.find('_')]
        if tid in annotated:
            fout.write('{}\t{}\t{}\n'.format(oid, fold, annotated[tid]))
