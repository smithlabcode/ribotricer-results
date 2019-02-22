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
import os

files = sys.argv[1:]

counts = {}
for i, f in enumerate(files):
    with open(f, 'r') as fin:
        header = True
        for line in fin:
            if header:
                header = False
                continue
            gene, cnt = line.strip().split('\t')
            if gene not in counts:
                counts[gene] = [0] * len(files)
            counts[gene][i] = cnt

basenames = [os.path.splitext(f)[0] for f in files]
formater = '{}'+'\t{}'*len(files) + '\n'
with open('cnt.txt', 'w') as fout:
    fout.write(formater.format(*(['gene'] + basenames)))
    for gene, cnts in counts.items():
        fout.write(formater.format(*([gene] + cnts)))
