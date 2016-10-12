basic_counts <- read.delim("Google\ Drive/Intel/dme203counts0MM160920_18_17_23.txt", header = T)

library(reshape2)

meltyDatar <- melt(basic_counts)

rownames(basic_counts) <- basic_counts[,1]

#i'm removing the first column because it just has strain names, which I made the row names
#this makes the functions we apply later work

basic_counts$Strain <- NULL


library(ggplot2)
library(BiocGenerics)


#g <- ggplot(meltyDatar) + geom_point() + aes(x=variable, y=value)

#g+theme(axis.text.x=element_text(angle=90))


 

freq_df <- apply( basic_counts, 2, function(x) { return (x/sum(x))})

#write.csv(freq_df, "Frequency_Table.csv")


ordered_freqs <- apply( freq_df, 2, order)
