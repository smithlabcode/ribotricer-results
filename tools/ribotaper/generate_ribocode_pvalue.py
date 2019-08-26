# Original author: Zhengtao Xiao (GPLv3)
# Modified by: Saket Choudhary (GPLv3)

import click
from collections import namedtuple
import numpy as np
from scipy import stats
from scipy.stats import find_repeats, distributions, ttest_1samp

WilcoxonResult = namedtuple("WilcoxonResult", ("statistic", "pvalue"))


def wilcoxon_greater(x, y, zero_method="wilcox", correction=False):
    """	data if x is larger than y, single-sided.	"""
    if np.allclose(x, y, equal_nan=True):
        return WilcoxonResult(np.nan, np.nan)
    """shamelessly stolen from scipy"""

    if len(x) < 10 and not (np.allclose(x, x[0]) and np.allclose(y, y[0])):
        # sample size too small, using the ttest
        t_statistic, t_pvalue = ttest_1samp(x - y, popmean=0)
        if np.mean(x - y) > 0:
            t_pvalue /= 2.0
        else:
            t_pvalue = 1 - t_pvalue / 2.0
        return WilcoxonResult(t_statistic, t_pvalue)

    if zero_method not in ["wilcox", "pratt", "zsplit"]:
        raise ValueError(
            "Zero method should be either 'wilcox' " "or 'pratt' or 'zsplit'"
        )
    if y is None:
        d = np.asarray(x)
    else:
        x, y = list(map(np.asarray, (x, y)))
        if len(x) != len(y):
            raise ValueError("Unequal N in wilcoxon.  Aborting.")
        d = x - y
        d[(d == 0) & (x + y != 0)] = -1  # penalty for equal value

    if zero_method == "wilcox":
        # Keep all non-zero differences
        d = np.compress(np.not_equal(d, 0), d, axis=-1)

    count = len(d)
    # if count < 10:
    # 	warnings.warn("Warning: sample size too small for normal approximation.")

    r = stats.rankdata(abs(d))
    r_plus = np.sum((d > 0) * r, axis=0)
    r_minus = np.sum((d < 0) * r, axis=0)

    if zero_method == "zsplit":
        r_zero = np.sum((d == 0) * r, axis=0)
        r_plus += r_zero / 2.0
        r_minus += r_zero / 2.0

    T = min(r_plus, r_minus)
    mn = count * (count + 1.0) * 0.25
    se = count * (count + 1.0) * (2.0 * count + 1.0)

    if zero_method == "pratt":
        r = r[d != 0]

    replist, repnum = find_repeats(r)
    if repnum.size != 0:
        # Correction for repeated elements.
        se -= 0.5 * (repnum * (repnum * repnum - 1)).sum()

    se = np.sqrt(se / 24)
    correction = 0.5 * int(bool(correction)) * np.sign(T - mn)
    z = (T - mn - correction) / se
    if r_plus > r_minus:
        prob = distributions.norm.sf(abs(z))
    else:
        prob = 1 - distributions.norm.sf(abs(z))

    return WilcoxonResult(T, prob)


def combine_pvals(pvalues, method="stouffer"):
    """:param pvs
    :return: combined pvalue
    """
    pvs = pvalues[~np.isnan(pvalues)]
    if pvs.size != 2:
        comb_pv = np.nan
    else:
        comb_pv = stats.combine_pvalues(pvalues, method=method)[1]

    return comb_pv


def read_frames(filename):
    """read the annotated read frame
    """
    frame_dict = {}
    with open(filename) as fin:
        for line in fin:
            name, frame, strand, length = line.strip().split("\t")
            frame_dict[name] = int(frame)
    return frame_dict


class P_SITE(object):
    """psite profile"""

    def __init__(self, strand, psites):
        self.strand = strand
        self.psites = psites

    def toArray(self):
        if self.strand == "+":
            return np.array(list(map(int, self.psites.split())))
        else:
            return np.array(list(map(int, self.psites.split()[::-1])))


def read_track(filename):
    retDict = {}
    with open(filename) as fin:
        for line in fin:
            chrom, start, end, type, geneid, strand, psite = line.strip().split("\t")
            k = "_".join([chrom, start, end, type, geneid])
            retDict[k] = P_SITE(strand, psite)
            retDict[k].length = int(end) - int(start)
    return retDict


def cal_coverage(psite_array):
    nozeros = psite_array.nonzero()[0].size
    return float(nozeros) / psite_array.size


def extract_frame(orf_psite_array):
    """extract frame0 , frame1, frame2 vector"""
    if orf_psite_array.size % 3 != 0:
        shiftn = orf_psite_array.size % 3
        f0 = orf_psite_array[:-shiftn][np.arange(0, orf_psite_array.size - shiftn, 3)]
        f1 = orf_psite_array[:-shiftn][np.arange(1, orf_psite_array.size - shiftn, 3)]
        f2 = orf_psite_array[:-shiftn][np.arange(2, orf_psite_array.size - shiftn, 3)]
    else:
        f0 = orf_psite_array[np.arange(0, orf_psite_array.size, 3)]
        f1 = orf_psite_array[np.arange(1, orf_psite_array.size, 3)]
        f2 = orf_psite_array[np.arange(2, orf_psite_array.size, 3)]
    return f0, f1, f2


@click.command()
@click.option("--psite", help="Path to P_sites_all_tracks_ccds file", required=True)
@click.option(
    "--centered_rna", help="Path to Centered_RNA_tracks_ccds file", required=True
)
@click.option("--frame", help="Path to frames_ccds", required=True)
@click.option("--out", help="Path to output file", required=True)
def write_ribocode_result(psite, centered_rna, frame, out):
    psite_dict = read_track(psite)
    center_dict = read_track(centered_rna)
    frame_dict = read_frames(frame)
    result_dict = {}

    fout = open(out, "w")
    fout.write(
        "ID\tannotated_frame\tpredict_frame\tcode_ribo\tcode_rna\tribo_cov\tmRNA_cov\n"
    )
    for name, psites in list(psite_dict.items()):
        psites_array = psites.toArray()
        annot_frame = frame_dict[name]

        # for RNA
        center_array = center_dict[name].toArray()

        if psites_array.sum() < 5 or center_array.sum() < 5:
            continue

        if psites_array.size < 10:
            continue

        ##RPF
        # f0
        f0, f1, f2 = extract_frame(psites_array)
        if f0.size < 1:
            continue
        f0_pvalue1 = wilcoxon_greater(f0, f1, zero_method="wilcox")
        f0_pvalue2 = wilcoxon_greater(f0, f2, zero_method="wilcox")
        f0_pv = combine_pvals(np.array([f0_pvalue1.pvalue, f0_pvalue2.pvalue]))
        f0_coverage = cal_coverage(f0)
        # f1
        f0, f1, f2 = extract_frame(psites_array[1:])
        if f0.size < 1:
            continue
        f1_pvalue1 = wilcoxon_greater(f0, f1, zero_method="wilcox")
        f1_pvalue2 = wilcoxon_greater(f0, f2, zero_method="wilcox")
        f1_pv = combine_pvals(np.array([f1_pvalue1.pvalue, f1_pvalue2.pvalue]))
        f1_coverage = cal_coverage(f0)
        # f2
        f0, f1, f2 = extract_frame(psites_array[2:])
        if f0.size < 1:
            continue
        f2_pvalue1 = wilcoxon_greater(f0, f1, zero_method="wilcox")
        f2_pvalue2 = wilcoxon_greater(f0, f2, zero_method="wilcox")
        f2_pv = combine_pvals(np.array([f2_pvalue1.pvalue, f2_pvalue2.pvalue]))
        f2_coverage = cal_coverage(f0)

        if np.isnan([f0_pv, f1_pv, f2_pv]).any():
            continue
        predict_frame = np.nanargmin([f0_pv, f1_pv, f2_pv])
        ribo_pvalue = [f0_pv, f1_pv, f2_pv][predict_frame]
        ribo_coverage = [f0_coverage, f1_coverage, f2_coverage][predict_frame]

        # mRNA
        # f0
        ff0, ff1, ff2 = extract_frame(center_array)
        pv1 = wilcoxon_greater(ff0, ff1, zero_method="wilcox")
        pv2 = wilcoxon_greater(ff0, ff2, zero_method="wilcox")
        mRNA_coverage_f0 = cal_coverage(ff0)
        mRNA_pv_f0 = combine_pvals(np.array([pv1.pvalue, pv2.pvalue]))
        # f1
        ff0, ff1, ff2 = extract_frame(center_array[1:])
        pv1 = wilcoxon_greater(ff0, ff1, zero_method="wilcox")
        pv2 = wilcoxon_greater(ff0, ff2, zero_method="wilcox")
        mRNA_coverage_f1 = cal_coverage(ff0)
        mRNA_pv_f1 = combine_pvals(np.array([pv1.pvalue, pv2.pvalue]))
        # f2
        ff0, ff1, ff2 = extract_frame(center_array[2:])
        pv1 = wilcoxon_greater(ff0, ff1, zero_method="wilcox")
        pv2 = wilcoxon_greater(ff0, ff2, zero_method="wilcox")
        mRNA_coverage_f2 = cal_coverage(ff0)
        mRNA_pv_f2 = combine_pvals(np.array([pv1.pvalue, pv2.pvalue]))

        if np.isnan([mRNA_pv_f0, mRNA_pv_f1, mRNA_pv_f2]).any():
            continue
        predict_frame_rna = np.nanargmin([mRNA_pv_f0, mRNA_pv_f1, mRNA_pv_f2])
        rna_pvalue = [mRNA_pv_f0, mRNA_pv_f1, mRNA_pv_f2][predict_frame_rna]
        rna_coverage = [mRNA_pv_f0, mRNA_pv_f1, mRNA_pv_f2][predict_frame_rna]

        outlist = [
            name,
            annot_frame,
            predict_frame,
            ribo_pvalue,
            rna_pvalue,
            ribo_coverage,
            rna_coverage,
        ]
        fout.write("\t".join(map(str, outlist)) + "\n")
    fout.close()

if __name__ == '__main__':
  write_ribocode_result()

