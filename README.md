# Results and the scripts for benchmarking ribotricer with other methods

### Introduction
The benchmark method used here is partially established by RiboTaper and RiboCode. 
The benchmark method relies on using profiles of expressed CCDS exons or genes from 
Ribo-seq data as true positives and those from RNA-seq data as true negatives
to assess the performance of each method. To get a comprehensive understanding of the performance
of each method, and also to account for the high heterogeneity of Ribo-seq data,
we seleted ten datasets, including five human datasets and five mouse datasets for the
benchmarking.

Since RiboTaper was originally designed for detecting actively translating exons and was
assessed its performance at exon level, we followed the convention used in RiboCode to
compare the tools supporting exon level detection in the first group. 
Ribotricer along with ORFscore, RiboTaper and RiboCode are compared at exon level ORF detection.
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

### Exon level benchmarking
We compared ribotricer with existing methods including ORFscore, ORF-RATER,
RibORF, RiboTaper, RP-BP and RiboCode.
For each dataset, we selected on Ribo-seq sample and one RNA-seq sample
to run all the tools. Some tools need both RNA-seq and Ribo-seq for input,
such as RiboTaper, RP-BP. Tools like ribotricer and RiboCode only needs Ribo-seq
as input, but here we will use RNA-seq as negatives for the comparison. 
For all the Ribo-seq samples selected, the read lengths are chosen by inspecting
the metagene plots for each read length and the P-site offset are determined
along side.

RiboTaper is designed for exon level ORF detection, so we benchmarked
ribotricer, RiboTaper along with other tools also supporting exon level
detection together. We generated CCDS RPF profiles for both Ribo-seq
and RNA-seq samples using RiboTaper (v 1.3), the file
data\_tracks/P\_sites\_all\_tracks\_ccds is for Ribo-seq sample
and the file data\_tracks/Centered\_RNA\_tracks\_ccds is for RNA-seq sample.
The file results\_ccds contains the results from RiboTaper and also the
results from ORFscore. 


### Transcript level benchmarking
For the transcript level comparison, we again use the profiles of expressed CCDS genes from Ribo-seq
dta as true positives and those from RNA-seq data as true negatives. In order to have a fair
comparison, the bam files mapped with ```STAT``` are intersected with the CCDS bed file so that
only the reads originating from CCDS regions are used. This step is done with ```bedtools intersect```
command. After the intersection, the Ribo-seq reads are further filtered to only include reads with
read length shown to be periodic at metagene plots. The read lengths used here for each Ribo-seq data
are the same as those used for exon level benchmarking. For the RNA-seq data, after the intersection,
we randomly trimmed each reads from either end to make the read lengths to be between 28 and 30 which is
the typical read length range for Ribo-seq data. This process is achieved by extracting the reads
from RNA-seq bam file, randomly trimming read length, and writing back as FASTQ file. The resulting
FASTQ file is then remapped using ```STAR```.
The processed bam files of Ribo-seq and RNA-seq data are provided as inputs for each tool.
