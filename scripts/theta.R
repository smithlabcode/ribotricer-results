options(echo = TRUE)
args = commandArgs(trailingOnly = TRUE)
prefix = args[1]
rna = read.table(paste(prefix, 'rna_angles.txt', sep='_'))
ribo = read.table(paste(prefix, 'ribo_angles.txt', sep='_'))
poisson = read.table(paste(prefix, 'poisson_angles.txt', sep='_'))
rna = rna[,1]
ribo = ribo[,1]
poisson = poisson[,1]
pdf(paste(prefix, 'theta_dist.pdf', sep='_'), width=16/2.54, height=10/2.54,
    pointsize=10)
par(mfrow=c(1,3), pty='s')
hist(ribo, prob=TRUE, xlab='theta', main='Ribo-seq', breaks=100)
lines(density(ribo), lwd=2, col='red')
hist(rna, prob=TRUE, xlab='theta', main='RNA-seq', breaks=100)
lines(density(rna), lwd=2, col='red')
hist(poisson, prob=TRUE, xlab='theta', main='Poisson', breaks=100)
lines(density(poisson), lwd=2, col='red')
dev.off()
