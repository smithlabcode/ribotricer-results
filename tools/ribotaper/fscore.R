# options(echo <- TRUE)
args <- commandArgs(trailingOnly = TRUE)
# defualt 0.05
# ribotaper_cutoff <- args[1]
ribotaper_cutoff <- 0.05
# default 6.044
# ORFscore_cutoff <- args[2]
ORFscore_cutoff <- 6.044
# default 0.05
# ribocode_cutoff <- args[3]
ribocode_cutoff <- 0.05
#default 0.428571428571
# ribotricer_cutoff <- as.double(args[1])
ribotricer_cutoff <- 0.428571428571

# ground truth
data <- read.table(args[1],header=TRUE,row.names=1)
positives <- rownames(data[data$truth == 1, ])
negatives <- rownames(data[data$truth == 0, ])
# ribotaper results
ribotaper_positives <- rownames(data[data$ribotaper < ribotaper_cutoff, ])
ribotaper_negatives <- rownames(data[data$ribotaper >= ribotaper_cutoff, ])
true_positives <- intersect(positives, ribotaper_positives)
true_negatives <- intersect(negatives, ribotaper_negatives)
sensitivity <- length(true_positives) / length(positives)
specificity <- length(true_negatives) / length(negatives)
precision <- length(true_positives) / length(ribotaper_positives)
recall <- length(true_positives) / length(positives)
fscore <- 2 * recall * precision / (recall + precision)
res.ribotaper <- data.frame(ribotaper=c(sensitivity, specificity, fscore,
                                       precision, recall))
# ORFscore results
ORFscore_positives <- rownames(data[data$ORFscore > ORFscore_cutoff, ])
ORFscore_negatives <- rownames(data[data$ORFscore <= ORFscore_cutoff, ])
true_positives <- intersect(positives, ORFscore_positives)
true_negatives <- intersect(negatives, ORFscore_negatives)
sensitivity <- length(true_positives) / length(positives)
specificity <- length(true_negatives) / length(negatives)
precision <- length(true_positives) / length(ORFscore_positives)
recall <- length(true_positives) / length(positives)
fscore <- 2 * recall * precision / (recall + precision)
res.ORFscore <- data.frame(ORFscore=c(sensitivity, specificity, fscore,
                                       precision, recall))
# ribocode results
ribocode_positives <- rownames(data[data$ribocode < ribocode_cutoff, ])
ribocode_negatives <- rownames(data[data$ribocode >= ribocode_cutoff, ])
true_positives <- intersect(positives, ribocode_positives)
true_negatives <- intersect(negatives, ribocode_negatives)
sensitivity <- length(true_positives) / length(positives)
specificity <- length(true_negatives) / length(negatives)
precision <- length(true_positives) / length(ribocode_positives)
recall <- length(true_positives) / length(positives)
fscore <- 2 * recall * precision / (recall + precision)
res.ribocode <- data.frame(ribocode=c(sensitivity, specificity, fscore,
                                       precision, recall))
# ribotricer results
ribotricer_positives <- rownames(data[data$ribotricer > ribotricer_cutoff, ])
ribotricer_negatives <- rownames(data[data$ribotricer <= ribotricer_cutoff, ])
true_positives <- intersect(positives, ribotricer_positives)
true_negatives <- intersect(negatives, ribotricer_negatives)
sensitivity <- length(true_positives) / length(positives)
specificity <- length(true_negatives) / length(negatives)
precision <- length(true_positives) / length(ribotricer_positives)
recall <- length(true_positives) / length(positives)
fscore <- 2 * recall * precision / (recall + precision)
res.ribotricer <- data.frame(ribotricer=c(sensitivity, specificity, fscore,
                                       precision, recall))
res <- cbind(res.ribotaper, res.ORFscore, res.ribocode, res.ribotricer)
rownames(res) <- c('sensitivity', 'specificity', 'fscore', 'precision', 'recall')
write.table(res, args[2], sep="\t", row.names=T, col.names=T, quote=F)

