# Results and the scripts for benchmarking RiboCop with other methods

### Introduction
The benchmark method used here is partially established by RiboTaper and RiboCode. 
The benchmark method relies on using profiles of expressed CCDS exons or genes from 
Ribo-seq data as true positives and those from RNA-seq data as true negatives
to assess the performance of each method. Beside testing their ability to distinguish
between true positives and true negatives, we also use those tools in real application
and compare the translating ORFs detected with the proteomic evidence. Lastly,
we applied each tool to the replicates of a dataset, to further see if the ORFs detected
are similar across replicates. To get a comprehensive understanding of the performance
of each method, and also to account for the high heterogeneity of Ribo-seq data,
we seleted ten datasets, including five human datasets and five mouse datasets for the
benchmarking.

Since RiboTaper was originally designed for detecting actively translating exons and was
assessed its performance at exon level, we followed the convention used in RiboCode to
compare the tools supporting exon level detection in the first group. 
RiboCop along with ORFscore, RiboTaper and RiboCode are compared at exon level ORF detection.
For those tools which only work at gene or transcript level detection, including ORF-Rater, RibORF,
RiboHMM, and RP-BP, we performed the comparison in a second group. 

### Installation
We downloaded and installed each tool by following the instruction at the following pages:
* [ORF-RATER](https://github.com/alexfields/ORF-RATER)
* [RibORF](https://github.com/zhejilab/RibORF) (version 1.0)
* [RiboTaper](https://ohlerlab.mdc-berlin.de/software/RiboTaper_126/) (version 1.3)
* [RiboHMM](https://github.com/rajanil/riboHMM)
* [RP-BP](https://github.com/dieterich-lab/rp-bp) (version 1.1.12)
* [RiboCode](https://github.com/xryanglab/RiboCode) (version 1.2.10)
