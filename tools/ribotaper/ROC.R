library(ROCR)
args<-commandArgs(trailingOnly=TRUE)

data <- read.table(args[1],header=TRUE,row.names=1)
mymethod <- prediction(data[["ribotricer"]],data$truth)
ribocode <- prediction(-data[["ribocode"]],data$truth)
ribotaper <- prediction(-data[["ribotaper"]],data$truth)
orfscore <- prediction(data[["ORFscore"]],data$truth)

mymethod1<-performance(mymethod,"tpr","fpr")
ribocode1<-performance(ribocode,"tpr","fpr")
ribotaper1<-performance(ribotaper,"tpr","fpr")
orfscore1<-performance(orfscore,"tpr","fpr")

mymethod2<-performance(mymethod,"prec","rec")
ribocode2<-performance(ribocode,"prec","rec")
ribotaper2<-performance(ribotaper,"prec","rec")
orfscore2<-performance(orfscore,"prec","rec")

pdf(args[2])
par(mfrow=c(2,1))
par(mai=c(1,2,0.1,2))
#
plot(mymethod1@x.values[[1]],mymethod1@y.values[[1]],xlab=mymethod1@x.name,ylab=mymethod1@y.name,col="black",type="l",ylim=c(0,1))
points(ribocode1@x.values[[1]],ribocode1@y.values[[1]],xlab=ribocode1@x.name,ylab=ribocode1@y.name,col="red",type="l")
points(ribotaper1@x.values[[1]],ribotaper1@y.values[[1]],xlab=ribotaper1@x.name,ylab=ribotaper1@y.name,col="blue",type="l")
points(orfscore1@x.values[[1]],orfscore1@y.values[[1]],xlab=orfscore1@x.name,ylab=orfscore1@y.name,col="green",type="l")
legend(x="bottomright", legend=c("Ribotricer", "RiboCode", "RiboTaper", "ORFscore"),bty='n',col=c("black", "red", "blue", "green"),lwd=2.5,cex=1.0)
#
plot(mymethod2@x.values[[1]],mymethod2@y.values[[1]],xlab=mymethod2@x.name,ylab=mymethod2@y.name,col="black",type="l",ylim=c(0,1))
points(ribocode2@x.values[[1]],ribocode2@y.values[[1]],xlab=ribocode2@x.name,ylab=ribocode2@y.name,col="red",type="l")
points(ribotaper2@x.values[[1]],ribotaper2@y.values[[1]],xlab=ribotaper2@x.name,ylab=ribotaper2@y.name,col="blue",type="l")
points(orfscore2@x.values[[1]],orfscore2@y.values[[1]],xlab=orfscore2@x.name,ylab=orfscore2@y.name,col="green",type="l")
legend(x="bottomright", legend=c("Ribotricer", "RiboCode", "RiboTaper", "ORFscore"),bty='n',col=c("black", "red", "blue", "green"),lwd=2.5,cex=1.0)
dev.off()

methods <- c("ribotricer", "ribocode", "ribotaper", "orfscore")

#

mymethod3<-performance(mymethod,"auc")
ribocode3<-performance(ribocode,"auc")
ribotaper3<-performance(ribotaper,"auc")
orfscore3<-performance(orfscore,"auc")

auc <- c(mymethod3@y.values[[1]],ribocode3@y.values[[1]],ribotaper3@y.values[[1]],orfscore3@y.values[[1]])
auc <- cbind(methods, auc)
write.table(auc,args[3],sep="\t",row.names=F,col.names=F)

