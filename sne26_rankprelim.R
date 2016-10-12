basic_counts <- read.delim(
  "Google\ Drive/Intel/dme203counts0MM160920_18_17_23.txt", header=T)
sne26index <- read.csv("sne26index.csv")

library(reshape2)

meltyDatar <- melt(basic_counts)

rownames(basic_counts) <- basic_counts[,1]
basic_counts <- basic_counts[,-1]

# i'm removing the first column because it just has strain names, 
# which I made the row names
# this makes the functions we apply later work

library(ggplot2)
library(BiocGenerics)

#g <- ggplot(meltyDatar) + geom_point() + aes(x=variable, y=value)

#g+theme(axis.text.x=element_text(angle=90))

meltyDatar$sampleNumber <- sub("Sample(\\d+)_.*","\\1",meltyDatar$variable)
meltyDatar$tag <- sub("Sample\\d+_(.*)","\\1",meltyDatar$variable)
# I like to put experimental factors as their own columns, makes
#   plotting by them easier later

g1 <- ggplot(meltyDatar)+facet_wrap(~tag)+
  aes(x=sampleNumber,weight=value)+scale_y_log10()+
  stat_count(geom="point")+theme(axis.text.x=element_text(angle=90))
# this involves faceting, log10ing the y scale, and using stat_count,
#   which counts the the observations (weighed by "value") for each x
#   and then I've chosen to use a geom of point instead of a barplot
g1
# note my samples are the red ones in the middle of the uptags series
g1+aes(col=sampleNumber%in%sne26index$indexNumber)

# but wait! we already did QC. That file's in:
datar <- read.csv("countedDataForAnalysissne26.csv",header=T)
head(datar)
g2 <- ggplot(datar)+facet_grid(Tag~replicate)+
  aes(x=factor(SampleNum),weight=Counts)+scale_y_log10()+
  stat_count(geom="point")+theme(axis.text.x=element_text(angle=90))
g2

#let's just dump those low ones, probs very noisy
aggregate(Counts~SampleNum+Tag,datar,sum)
datar <- subset(datar,!(Tag=="UP"&SampleNum%in%c(95,97,98))&
                      !(Tag=="DOWN"&SampleNum%in%c(98)))
g3 <- ggplot(datar)+facet_grid(Tag+Q~time)+
  aes(x=factor(SampleNum),weight=Counts,col=factor(replicate))+
  scale_y_log10()+
  stat_count(geom="point")+theme(axis.text.x=element_text(angle=90))
g3

# so from the qc'd data:
countz <- dcast(datar,Strain~SampleNum+Tag+Q+time+replicate+whichRun,
#                value.var="RelativeCounts")
                value.var="Counts")

freq_df <- apply( countz[,-1], 2, function(x) { return (x/sum(x))})

#write.csv(freq_df, "Frequency_Table.csv")

ordered_freqs <- apply( freq_df, 2, order, decreasing=T)

# actually you probs want to use rank, because of ties

#### ALTERNATIVELY here's the one I made in the QC file
datar$replicate <- factor(factor(datar$replicate,
  labels=list("1"="A","2"="B","3"="C","4"="A","5"="B","6"="C")))
rankz <- dcast(datar,Strain+replicate+whichRun+Tag~time+Q,
                value.var="Rank")
g5 <- ggplot(rankz)+facet_wrap(~whichRun)
g5+aes(x=preShift_FALSE,y=preShift_TRUE)+geom_point(size=0.5,alpha=0.5)
g5+aes(x=preShock_FALSE,y=preShock_TRUE)+geom_point(size=0.5,alpha=0.5)
g5+aes(x=postShock_FALSE,y=postShock_TRUE)+geom_point(size=0.5,alpha=0.5)



