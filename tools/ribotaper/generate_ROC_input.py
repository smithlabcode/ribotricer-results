#!/usr/bin/env python
# -*- coding:UTF-8 -*-
# Original author: Zhengtao Xiao
# Modified by: Saket Choudhary
import sys

import click
import numpy as np
import pandas as pd


# read result
def read_resultccds(filename):
    df = pd.read_table(filename, index_col=0, na_values="NA")
    return df


def read_ribocode(filename):
    df = pd.read_table(filename, index_col=0, na_values="NAN")
    return df


def read_ribotricer(filename):
    df = pd.read_table(filename, index_col=0, na_values="NAN")
    return df


def roc_output(df, outname):
    with open(outname, "w") as fout:
        fout.write(
            "\t".join(
                [
                    "name",
                    "ribotaper",
                    "chisq",
                    "ORFscore",
                    "ribocode",
                    "ribotricer",
                    "truth",
                ]
            )
            + "\n"
        )
        for j in df.index:
            if (
                np.nan
                not in df.ix[j][
                    [
                        "pval_multit_3nt_ribo",
                        "chisq_ribo",
                        "ORF_score_ribo",
                        "code_ribo",
                        "ribo_coh",
                    ]
                ]
            ):
                fout.write(
                    j
                    + "_ribo"
                    + "\t"
                    + "\t".join(
                        map(
                            str,
                            df.ix[j][
                                [
                                    "pval_multit_3nt_ribo",
                                    "chisq_ribo",
                                    "ORF_score_ribo",
                                    "code_ribo",
                                    "ribo_coh",
                                ]
                            ],
                        )
                    )
                    + "\t1\t\n"
                )
            if (
                np.nan
                not in df.ix[j][
                    [
                        "pval_multit_3nt_rna",
                        "chisq_rna",
                        "ORF_score_rna",
                        "code_rna",
                        "rna_coh",
                    ]
                ]
            ):
                fout.write(
                    j
                    + "_rna"
                    + "\t"
                    + "\t".join(
                        map(
                            str,
                            df.ix[j][
                                [
                                    "pval_multit_3nt_rna",
                                    "chisq_rna",
                                    "ORF_score_rna",
                                    "code_rna",
                                    "rna_coh",
                                ]
                            ],
                        )
                    )
                    + "\t0\t\n"
                )


@click.command()
@click.option(
    "--ribotaper_result", help="Path to ribotaper result file", required=True
)
@click.option("--ribocode_result", help="Path to ribocode result file", required=True)
@click.option(
    "--ribotricer_result", help="Path to ribotricer result file", required=True
)
@click.option("--out", help="Path to write output", required=True)
def write_ROC_input(ribotaper_result, ribocode_result, ribotricer_result, out):

    ribotaper_df = read_resultccds(ribotaper_result)
    # ribocode = read_ribocode("ribocode_result.txt")
    ribocode = read_ribocode(ribocode_result)
    # ribotricer = read_ribotricer("ribotricer_result.txt")
    ribotricer = read_ribotricer(ribotricer_result)

    ##Drop NA values
    ##Not sure if this is fair at all
    ribotaper_df_na = ribotaper_df[
        (ribotaper_df["pval_multit_3nt_ribo"] != np.nan)
        | (ribotaper_df["pval_multit_3nt_rna"] != np.nan)
    ]
    ribocode_df_na = ribocode[
        (ribocode["code_ribo"] != np.nan) | (ribocode["code_rna"] != np.nan)
    ]
    ribotricer_df_na = ribotricer[
        (ribotricer["ribo_coh"] != np.nan) | (ribotricer["rna_coh"] != np.nan)
    ]

    # 2. merger
    merger_df = ribotaper_df_na.merge(
        ribocode_df_na, how="inner", left_index=True, right_index=True
    )
    merger_df = merger_df.merge(
        ribotricer_df_na, how="inner", left_index=True, right_index=True
    )

    # 3. filter the psites_sum < 5:
    merger_df_filter = merger_df[merger_df.P_sites_sum > 5]

    # 4. ROC results
    roc_output(merger_df_filter, out)


if __name__ == "__main__":
    write_ROC_input()
