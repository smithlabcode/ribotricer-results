options(echo = TRUE)
# ground truth
data = read.table("ROC_input.txt",header=TRUE,row.names=1)
rna = data[data$truth == 0, ]
ribo = data[data$truth == 1, ]
numFP = round(nrow(rna) * 0.1)
numFP

# ribotaper results
ribotaper_rna = rna[order(rna$ribotaper), ]
ribotaper_cutoff = ribotaper_rna$ribotaper[numFP]
ribotaper_positive = nrow(ribo[ribo$ribotaper <= ribotaper_cutoff, ])
ribotaper_positive

# ORFscore results
ORFscore_rna = rna[order(-rna$ORFscore), ]
ORFscore_cutoff = ORFscore_rna$ORFscore[numFP]
ORFscore_positive = nrow(ribo[ribo$ORFscore >= ORFscore_cutoff, ])
ORFscore_positive

# ribocode results
ribocode_rna = rna[order(rna$ribocode), ]
ribocode_cutoff = ribocode_rna$ribocode[numFP]
ribocode_positive = nrow(ribo[ribo$ribocode <= ribocode_cutoff, ])
ribocode_positive

# ribocop results
ribocop_rna = rna[order(-rna$ribocop), ]
ribocop_cutoff = ribocop_rna$ribocop[numFP]
ribocop_positive = nrow(ribo[ribo$ribocop >= ribocop_cutoff, ])
ribocop_positive

numTP = c(ribocop_positive, ribocode_positive, ribotaper_positive, ORFscore_positive)
write.table(numTP,"true_positive_same_false.txt", sep="\t", row.names=F, col.names=F)
