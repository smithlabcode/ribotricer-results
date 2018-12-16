# The palette with grey:
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442",
                "#0072B2", "#D55E00", "#CC79A7")
# The palette with black:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442",
                 "#0072B2", "#D55E00", "#CC79A7")

data1 = read.table("hg38/SRP010679_human/fixed_cutff.txt", header=T, row.names=1)
data1 = as.numeric(as.vector(data1[3,]))
data2 = read.table("hg38/SRP029589_human/fixed_cutff.txt", header=T, row.names=1)
data2 = as.numeric(as.vector(data2[3,]))
data3 = read.table("hg38/SRP063852_human/fixed_cutff.txt", header=T, row.names=1)
data3 = as.numeric(as.vector(data3[3,]))
data4 = read.table("hg38/SRP098789_human/fixed_cutff.txt", header=T, row.names=1)
data4 = as.numeric(as.vector(data4[3,]))
data5 = read.table("hg38/SRP102021_human/fixed_cutff.txt", header=T, row.names=1)
data5 = as.numeric(as.vector(data5[3,]))
data = data.frame(x1=data1, x2=data2, x3=data3, x4=data4, x5=data5)
colnames(data) = c('SRP010679', 'SRP029589', 'SRP063852', 'SRP098789',
                   'SRP102021')
data = data[c(4,3,1,2),]
rownames(data) = c('RiboCop', 'RiboCode', 'RiboTaper', 'ORFscore')
pdf('fscore_hg38.pdf', width=16/2.54, height=10/2.54)
colors = cbbPalette[c(1,4,6,8)]
barplot(as.matrix(data), ylab='F score', ylim=c(0, 1), cex.lab=1.0, cex.main=1.4,
        beside=TRUE, col=colors, las=3)
legend('bottomright', c('RiboCop', 'RiboCode', 'RiboTaper', 'ORFscore'), cex=1.3,
       bty='n', fill=colors)
dev.off()
