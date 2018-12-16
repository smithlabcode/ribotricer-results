library(ROCR)
pro='learned'
data1 = read.table("hg38/SRP098789_human/ROC_input.txt", header=TRUE, row.names=1)
data2 = read.table("hg38/SRP010679_human/ROC_input.txt", header=TRUE, row.names=1)
data3 = read.table("mm10/SRP003554_mouse/ROC_input.txt", header=TRUE, row.names=1)
data4 = read.table("mm10/SRP115915_mouse/ROC_input.txt", header=TRUE, row.names=1)
data = rbind(data1, data2, data3, data4)
dim(data)
cop = prediction(data[['ribocop']], data$truth)
cop = performance(cop, 'f')
xvalues = cop@x.values[[1]]
yvalues = cop@y.values[[1]]
length(xvalues)
cutoff = xvalues[which.max(yvalues)]
xvalues = xvalues[seq(1, length(xvalues), 100)]
yvalues = yvalues[seq(1, length(yvalues), 100)]
pdf(paste0(pro, '_cutoff_fscore_without_max.pdf'))
plot(xvalues, yvalues, type='l', lty=1, xlim=c(0, 1), ylim=c(0, 1))
abline(v=cutoff, col='red', lwd=3, lty=2)
text(cutoff, 0.1, toString(cutoff))
dev.off()
