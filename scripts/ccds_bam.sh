#!/usr/bin/bash
ccds=$1
inbam=$2
outbam=$3
bedtools intersect -abam inbam -b ccds -s > outbam
