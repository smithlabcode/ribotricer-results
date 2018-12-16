# -*- coding:UTF-8 -*-
__author__ = 'Wenzheng Li'
"""
Filter only those specific read lengths from bam
"""

import sys
import pysam
inbam = str(sys.argv[1])
outbam = str(sys.argv[2])
lengths = str(sys.argv[3])
lengths = [int(x) for x in lengths.split(',')]
allreadsbam = pysam.AlignmentFile(inbam, 'rb')
filteredbam = pysam.AlignmentFile(outbam, 'wb', template=allreadsbam)
for read in allreadsbam.fetch(until_eof=True):
    ref_positions = read.get_reference_positions()
    if len(ref_positions) in lengths:
        filteredbam.write(read)
allreadsbam.close()
filteredbam.close()
