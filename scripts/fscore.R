options(echo = TRUE)
args = commandArgs(trailingOnly = TRUE)
# defualt 0.05
# ribotaper_cutoff = args[1]
ribotaper_cutoff = 0.05
# default 6.044
# ORFscore_cutoff = args[2]
ORFscore_cutoff = 6.044
# default 0.05
# ribocode_cutoff = args[3]
ribocode_cutoff = 0.05
#default 0.4
ribocop_cutoff = as.double(args[1])
# ribocop_cutoff = 0.40528

# ground truth
data <- read.table("ROC_input.txt",header=TRUE,row.names=1)
positives = rownames(data[data$truth == 1, ])
negatives = rownames(data[data$truth == 0, ])
# ribotaper results
ribotaper_positives = rownames(data[data$ribotaper < ribotaper_cutoff, ])
ribotaper_negatives = rownames(data[data$ribotaper >= ribotaper_cutoff, ])
true_positives = intersect(positives, ribotaper_positives)
true_negatives = intersect(negatives, ribotaper_negatives)
sensitivity = length(true_positives) / length(positives)
specificity = length(true_negatives) / length(negatives)
precision = length(true_positives) / length(ribotaper_positives)
recall = length(true_positives) / length(positives)
fscore = 2 * sensitivity * precision / (sensitivity + precision)
res.ribotaper = data.frame(ribotaper=c(sensitivity, specificity, fscore,
                                       precision, recall))
# ORFscore results
ORFscore_positives = rownames(data[data$ORFscore > ORFscore_cutoff, ])
ORFscore_negatives = rownames(data[data$ORFscore <= ORFscore_cutoff, ])
true_positives = intersect(positives, ORFscore_positives)
true_negatives = intersect(negatives, ORFscore_negatives)
sensitivity = length(true_positives) / length(positives)
specificity = length(true_negatives) / length(negatives)
precision = length(true_positives) / length(ORFscore_positives)
recall = length(true_positives) / length(positives)
fscore = 2 * sensitivity * precision / (sensitivity + precision)
res.ORFscore = data.frame(ORFscore=c(sensitivity, specificity, fscore,
                                       precision, recall))
# ribocode results
ribocode_positives = rownames(data[data$ribocode < ribocode_cutoff, ])
ribocode_negatives = rownames(data[data$ribocode >= ribocode_cutoff, ])
true_positives = intersect(positives, ribocode_positives)
true_negatives = intersect(negatives, ribocode_negatives)
sensitivity = length(true_positives) / length(positives)
specificity = length(true_negatives) / length(negatives)
precision = length(true_positives) / length(ribocode_positives)
recall = length(true_positives) / length(positives)
fscore = 2 * sensitivity * precision / (sensitivity + precision)
res.ribocode = data.frame(ribocode=c(sensitivity, specificity, fscore,
                                       precision, recall))
# ribocop results
ribocop_positives = rownames(data[data$ribocop > ribocop_cutoff, ])
ribocop_negatives = rownames(data[data$ribocop <= ribocop_cutoff, ])
true_positives = intersect(positives, ribocop_positives)
true_negatives = intersect(negatives, ribocop_negatives)
sensitivity = length(true_positives) / length(positives)
specificity = length(true_negatives) / length(negatives)
precision = length(true_positives) / length(ribocop_positives)
recall = length(true_positives) / length(positives)
fscore = 2 * sensitivity * precision / (sensitivity + precision)
res.ribocop = data.frame(ribocop=c(sensitivity, specificity, fscore,
                                       precision, recall))
res = cbind(res.ribotaper, res.ORFscore, res.ribocode, res.ribocop)
rownames(res) = c('sensitivity', 'specificity', 'fscore', 'precision', 'recall')
write.table(res,"fixed_cutff.txt", sep="\t", row.names=T, col.names=T, quote=F)
