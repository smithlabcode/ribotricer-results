# Results and the scripts for benchmarking RiboCop with other methods

The benchmark method used here is partially established by RiboTaper and RiboCode. 
The benchmark method relies on using profiles of expressed CCDS exons or genes from 
Ribo-seq data as true positives and those from RNA-seq data as true negatives
to assess the performance of each method.

Since RiboTaper was originally designed for detecting actively translating exons and was
assessed its performance at exon level, we followed the convention used in RiboCode to
compare RiboCop with ORFscore, RiboTaper and RiboCode together at exon level. For those
tools which only work at gene or transcript level detection, including ORF-Rater, RibORF,
RiboHMM, and RP-BP, we performed the comparison in a second round. 

We downloaded and installed each tool by following the instruction at the following pages:
