#!/usr/bin/env python
# -*- coding:UTF-8 -*-
__author__ = 'Zhengtao Xiao'
"""
read the p_site_all_tracks_ccds file and do 3-periodicity test using RiboCode
usage: python generate_ribocode_pvalue.py 
"""

import sys
import numpy as np
from test_func import wilcoxon_greater,combine_pvals
from collections import namedtuple

## Note: change the path and file name 
#files from RiboTaper
cmd, ref, pro = sys.argv
psite_file = "/home/cmb-panasas2/wenzhenl/benchmark/exon_level/{}/{}/data_tracks/P_sites_all_tracks_ccds".format(ref, pro)
center_file = "/home/cmb-panasas2/wenzhenl/benchmark/exon_level/{}/{}/data_tracks/Centered_RNA_tracks_ccds".format(ref, pro)
frame_file = "/home/cmb-panasas2/wenzhenl/genomes/{}/annotation/ribotaper_annotation/frames_ccds".format(ref)

def read_frames(filename):
	"""
	read the annotated read frame
	"""
	frame_dict = {}
	with open(filename) as fin:
		for line in fin:
			name,frame,strand,length = line.strip().split("\t")
			frame_dict[name] = int(frame)
	return frame_dict

class P_SITE(object):
	"""psite profile"""
	def __init__(self,strand,psites):
		self.strand = strand
		self.psites = psites

	def toArray(self):
		if self.strand == "+":
			return np.array(map(int,self.psites.split()))
		else:
			return np.array(map(int,self.psites.split()[::-1]))

def read_track(filename):
	retDict = {}
	with open(filename) as fin:
		for line in fin:
			chrom,start,end,type,geneid,strand,psite = line.strip().split("\t")
			k = "_".join([chrom,start,end,type,geneid])
			retDict[k] = P_SITE(strand,psite)
			retDict[k].length = int(end) - int(start)
	return  retDict
def cal_coverage(psite_array):
	nozeros = psite_array.nonzero()[0].size
	return float(nozeros) / psite_array.size

def extract_frame(orf_psite_array):
	"""
	extract frame0 , frame1, frame2 vector
	"""
	if orf_psite_array.size % 3 != 0:
		shiftn = orf_psite_array.size % 3
		f0 = orf_psite_array[:-shiftn][np.arange(0,orf_psite_array.size - shiftn,3)]
		f1 = orf_psite_array[:-shiftn][np.arange(1,orf_psite_array.size - shiftn,3)]
		f2 = orf_psite_array[:-shiftn][np.arange(2,orf_psite_array.size - shiftn,3)]
	else:
		f0 = orf_psite_array[np.arange(0,orf_psite_array.size,3)]
		f1 = orf_psite_array[np.arange(1,orf_psite_array.size,3)]
		f2 = orf_psite_array[np.arange(2,orf_psite_array.size,3)]
	return f0,f1,f2

RESULT = namedtuple("result",("frame"))


#read psite
psite_dict = read_track(psite_file)
center_dict = read_track(center_file)
frame_dict = read_frames(frame_file)
result_dict = {}

fout = open("ribocode_result.txt","w")
fout.write("ID\tannotated_frame\tpredict_frame\tcode_ribo\tcode_rna\tribo_cov\tmRNA_cov\n")
for name,psites in psite_dict.iteritems():
	psites_array = psites.toArray()
	annot_frame = frame_dict[name]

	#for RNA
	center_array = center_dict[name].toArray()


	if psites_array.sum() < 5 or center_array.sum() < 5:
		continue

	if psites_array.size < 10:
		continue

	##RPF
	# f0
	f0,f1,f2 = extract_frame(psites_array)
	if f0.size <1:continue
	f0_pvalue1 = wilcoxon_greater(f0,f1,zero_method="wilcox")
	f0_pvalue2 = wilcoxon_greater(f0,f2,zero_method="wilcox")
	f0_pv = combine_pvals(np.array([f0_pvalue1.pvalue,f0_pvalue2.pvalue]))
	f0_coverage = cal_coverage(f0)
	#f1
	f0,f1,f2 = extract_frame(psites_array[1:])
	if f0.size <1:continue
	f1_pvalue1 = wilcoxon_greater(f0,f1,zero_method="wilcox")
	f1_pvalue2 = wilcoxon_greater(f0,f2,zero_method="wilcox")
	f1_pv = combine_pvals(np.array([f1_pvalue1.pvalue,f1_pvalue2.pvalue]))
	f1_coverage = cal_coverage(f0)
	#f2
	f0,f1,f2 = extract_frame(psites_array[2:])
	if f0.size <1:continue
	f2_pvalue1 = wilcoxon_greater(f0,f1,zero_method="wilcox")
	f2_pvalue2 = wilcoxon_greater(f0,f2,zero_method="wilcox")
	f2_pv = combine_pvals(np.array([f2_pvalue1.pvalue,f2_pvalue2.pvalue]))
	f2_coverage = cal_coverage(f0)

	if np.isnan([f0_pv,f1_pv,f2_pv]).any():
		continue
	predict_frame = np.nanargmin([f0_pv,f1_pv,f2_pv])
	ribo_pvalue = [f0_pv,f1_pv,f2_pv][predict_frame]
	ribo_coverage = [f0_coverage,f1_coverage,f2_coverage][predict_frame]

	#mRNA
	#f0
	ff0,ff1,ff2 = extract_frame(center_array)
	pv1 = wilcoxon_greater(ff0,ff1,zero_method="wilcox")
	pv2 = wilcoxon_greater(ff0,ff2,zero_method="wilcox")
	mRNA_coverage_f0 = cal_coverage(ff0)
	mRNA_pv_f0 = combine_pvals(np.array([pv1.pvalue,pv2.pvalue]))
	#f1
	ff0,ff1,ff2 = extract_frame(center_array[1:])
	pv1 = wilcoxon_greater(ff0,ff1,zero_method="wilcox")
	pv2 = wilcoxon_greater(ff0,ff2,zero_method="wilcox")
	mRNA_coverage_f1 = cal_coverage(ff0)
	mRNA_pv_f1 = combine_pvals(np.array([pv1.pvalue,pv2.pvalue]))
	#f2
	ff0,ff1,ff2 = extract_frame(center_array[2:])
	pv1 = wilcoxon_greater(ff0,ff1,zero_method="wilcox")
	pv2 = wilcoxon_greater(ff0,ff2,zero_method="wilcox")
	mRNA_coverage_f2 = cal_coverage(ff0)
	mRNA_pv_f2 = combine_pvals(np.array([pv1.pvalue,pv2.pvalue]))

	if np.isnan([mRNA_pv_f0,mRNA_pv_f1,mRNA_pv_f2]).any():
		continue
	predict_frame_rna = np.nanargmin([mRNA_pv_f0,mRNA_pv_f1,mRNA_pv_f2])
	rna_pvalue = [mRNA_pv_f0,mRNA_pv_f1,mRNA_pv_f2][predict_frame_rna]
	rna_coverage = [mRNA_pv_f0,mRNA_pv_f1,mRNA_pv_f2][predict_frame_rna]

	outlist = [name,annot_frame,predict_frame,ribo_pvalue,rna_pvalue,ribo_coverage,rna_coverage]
	fout.write("\t".join(map(str,outlist)) + "\n")
fout.close()

