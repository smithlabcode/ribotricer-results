# The palette with grey:
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442",
                "#0072B2", "#D55E00", "#CC79A7")
# The palette with black:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442",
                 "#0072B2", "#D55E00", "#CC79A7")

data1 = read.table("mm10/SRP003554_mouse/auc.txt")
data2 = read.table("mm10/SRP062407_mouse/auc.txt")
data3 = read.table("mm10/SRP078005_mouse/auc.txt")
data4 = read.table("mm10/SRP091889_mouse/auc.txt")
data5 = read.table("mm10/SRP115915_mouse/auc.txt")
data = cbind(data1, data2, data3, data4, data5)
colnames(data) = c('SRP003554', 'SRP062407', 'SRP078005',
                   'SRP091889', 'SRP115915')
rownames(data) = c('RiboCop', 'RiboCode', 'RiboTaper', 'ORFscore')
pdf('auc_mm10.pdf', width=16/2.54, height=10/2.54)
# pdf('auc_hg38.pdf')
colors = cbbPalette[c(1,4,6,8)]
barplot(as.matrix(data), ylab='AUC', ylim=c(0, 1), cex.lab=1.5, cex.main=1.4,
        beside=TRUE, col=colors, las=3)
legend('bottomright', c('RiboCop', 'RiboCode', 'RiboTaper', 'ORFscore'), cex=1.3,
       bty='n', fill=colors)
dev.off()
