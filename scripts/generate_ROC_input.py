#!/usr/bin/env python
# -*- coding:UTF-8 -*-
__author__ = 'Zhengtao Xiao'

import pandas as pd
import numpy as np
import sys

cmd, ref, pro = sys.argv

# read result
def read_resultccds(filename):
	df = pd.read_table(filename,index_col=0,na_values='NA')
	return df
def read_ribocode(filename):
	df = pd.read_table(filename,index_col=0,na_values='NAN')
	return df
def read_ribocop(filename):
	df = pd.read_table(filename,index_col=0,na_values='NAN')
	return df

def roc_output(df,outname="ROC_input.txt"):
	with open(outname,"w") as fout:
		fout.write("\t".join(["name","ribotaper","chisq","ORFscore","ribocode","ribocop","truth"]) + "\n")
		for j in df.index:
			if np.nan not in df.ix[j][["pval_multit_3nt_ribo","chisq_ribo","ORF_score_ribo","code_ribo","ribo_coh"]]:
				fout.write(j + "_ribo" + "\t" + "\t".join(map(str,df.ix[j][["pval_multit_3nt_ribo","chisq_ribo","ORF_score_ribo","code_ribo","ribo_coh"]])) + "\t1\t\n")
			if np.nan not in df.ix[j][["pval_multit_3nt_rna","chisq_rna","ORF_score_rna","code_rna","rna_coh"]]:
				fout.write(j + "_rna" + "\t" + "\t".join(map(str,df.ix[j][["pval_multit_3nt_rna","chisq_rna",
				                                                                  "ORF_score_rna","code_rna","rna_coh"]])) + "\t0\t\n")


#main
#1. read result
# ribotaper_df = read_resultccds("results_ccds")
ribotaper_result = '/home/cmb-panasas2/wenzhenl/benchmark/{}/{}/results_ccds'.format(ref, pro)
ribotaper_df = read_resultccds(ribotaper_result)
# ribocode = read_ribocode("ribocode_result.txt")
ribocode_result = '/home/cmb-panasas2/wenzhenl/benchmark/{}/{}/ribocode_result.txt'.format(ref, pro)
ribocode = read_ribocode(ribocode_result)
# ribocop = read_ribocop("ribocop_result.txt")
ribocop_result = '/home/cmb-panasas2/wenzhenl/benchmark/{}/{}/ribocop_results.txt'.format(ref, pro)
ribocop = read_ribocop(ribocop_result)

##Drop NA values
##Not sure if this is fair at all
ribotaper_df_na = ribotaper_df[(ribotaper_df["pval_multit_3nt_ribo"] != np.nan) | (ribotaper_df["pval_multit_3nt_rna"] != np.nan)]
ribocode_df_na = ribocode[(ribocode["code_ribo"] != np.nan) | (ribocode['code_rna'] != np.nan)]
ribocop_df_na = ribocop[(ribocop["ribo_coh"] != np.nan) | (ribocop['rna_coh'] != np.nan)]

#2. merger
merger_df = ribotaper_df_na.merge(ribocode_df_na,how="inner",left_index=True,right_index=True)
merger_df = merger_df.merge(ribocop_df_na,how="inner",left_index=True,right_index=True)

#3. filter the psites_sum < 5:
merger_df_filter = merger_df[merger_df.P_sites_sum > 5]

#4. ROC results
roc_output(merger_df_filter)
