library(ROCR)
pro='learned'
data1 = read.table("hg38/SRP098789_human/ROC_input.txt", header=TRUE, row.names=1)
data2 = read.table("hg38/SRP010679_human/ROC_input.txt", header=TRUE, row.names=1)
data3 = read.table("mm10/SRP003554_mouse/ROC_input.txt", header=TRUE, row.names=1)
data4 = read.table("mm10/SRP115915_mouse/ROC_input.txt", header=TRUE, row.names=1)
data5 = read.table("hg38/SRP029589_human/ROC_input.txt", header=TRUE, row.names=1)
data6 = read.table("hg38/SRP063852_human/ROC_input.txt", header=TRUE, row.names=1)
data7 = read.table("hg38/SRP102021_human/ROC_input.txt", header=TRUE, row.names=1)
data8 = read.table("mm10/SRP062407_mouse/ROC_input.txt", header=TRUE, row.names=1)
data9 = read.table("mm10/SRP078005_mouse/ROC_input.txt", header=TRUE, row.names=1)
data10 = read.table("mm10/SRP091889_mouse/ROC_input.txt", header=TRUE, row.names=1)
data = rbind(data1, data2, data3, data4, data5, data6, data7, data8, data9, data10)
dim(data)
cop = prediction(data[['ribocop']], data$truth)
cop = performance(cop, 'f')
xvalues = cop@x.values[[1]]
yvalues = cop@y.values[[1]]
cutoff = xvalues[which.max(yvalues)]
pdf(paste0(pro, '_cutoff_fscore.pdf'))
plot(cop, xlim=c(0, 1), ylim=c(0, 1))
abline(v=cutoff, col='red', lwd=3, lty=2)
text(cutoff, 0.1, toString(cutoff))
dev.off()
