options(echo = TRUE)
args = commandArgs(trailingOnly = TRUE)
pro = args[1]
library(ROCR)
data = read.table("ROC_input.txt", header=TRUE, row.names=1)
cop = prediction(data[['ribocop']], data$truth)
cop = performance(cop, 'f')
xvalues = cop@x.values[[1]]
yvalues = cop@y.values[[1]]
cutoff = xvalues[which.max(yvalues)]
pdf(paste0(pro, '_cutoff_fscore.pdf'))
plot(cop, xlim=c(0, 1), ylim=c(0, 1), main=pro)
abline(v=cutoff, col='red', lwd=3, lty=2)
text(cutoff, 0.1, toString(cutoff))
dev.off()
