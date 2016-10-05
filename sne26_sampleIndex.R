index <- read.csv("prmr_smpl_index.csv")
#this file is a manual index of corresponding sample number and primer index number from my notebook.
#the file's in the github repository.

index$experiment <- "sne26"
#I hardcoded this in, but if we're integrating with Darach's data it needs to be changed

index$replicate <- substr(index$sample, 1,1)
index$Q <- index$replicate

#indicating whether sample was upshifted based on number in sample name
index$Q <- sub("1", T, index$Q)
index$Q <- sub("2", T, index$Q)
index$Q <- sub("3", T, index$Q)
index$Q <- sub("4", F, index$Q)
index$Q <- sub("5", F, index$Q)
index$Q <- sub("6", F, index$Q)


index$time <- substr(index$sample, 2,2)


#indicating time via sample name
index$time <- sub("A", "preShift", index$time)
index$time <- sub("X", "preShift", index$time)
index$time <- sub("B", "preShock", index$time)
index$time <- sub("Y", "preShock", index$time)
index$time <- sub("C", "postShock", index$time)
index$time <- sub("Z", "postShock", index$time)

write.csv(index,file="sne26index.csv")

