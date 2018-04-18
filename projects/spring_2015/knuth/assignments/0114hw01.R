## read in data file
dat <- read.csv(file = "./tgpp.csv", header=T)
## list column names
colnames(dat)
## list dimensions of dataset to get count for rows and columns
dim(dat)
## list objects and kind of object
lapply(dat,class)
## list values for rows 1,5,8 and columns 3,7,10
dat[c(1, 5, 8), c(3, 7, 10)]
## create pdf of scale vs richness
pdf('./scale_vs_richness.pdf')
par(mfrow = c(2,1))
plot(dat[,5],dat[,6], xlab='scale', ylab='richness',col='darkblue')
dev.off()
## replot scale vs richness using log transformation.
plot(dat[,5],dat[,6], xlab='scale', ylab='richness',col='darkblue',log='xy')
## data was collected at five different scales "100.00" " 10.00" "  1.00" "  0.10" "  0.01"
format(unique(dat[,5]), scientific = F) 
## thus displaying the data along the x axis following ln base 10 intervals parses
## the data into equal intervals, which makes the distribution more easily visible.
## along the y axis the spread seems to decrease with an increase in scale, rather than
## increase, as is seen in the untransformed plot. See comparison below. Zeros are omitted
## from the logarythmic plot.
pdf('./comparison.pdf')
par(mfrow = c(2,1))
plot(dat[,5],dat[,6], xlab='scale', ylab='richness',col='darkblue')
plot(dat[,5],dat[,6], xlab='scale', ylab='richness',col='darkblue',log='xy')
dev.off()