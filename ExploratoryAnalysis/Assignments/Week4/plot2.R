#Script to calculate and plot the Baltimore City emissions of PM2.5 per year
#for the years 1999, 2002, 2005, and 2008.
#Requires the file "summarySCC_PM25.rds" to be in working directory
#Saves "plot2.png" to working directory
#-------------------------------------------------------------------
#Used to filter raw data frame
library(dplyr)

#Reads in PM2.5 data from working directory if not already in memory.
#Check first so as not to waste time re-reading large files during development
if(!exists("frames")){
  print("Reading in pm25 Data Frames...")
  frames <- readRDS("summarySCC_PM25.rds")
}
#Filter raw data frame to select only data from baltimore city 
balt_data <- filter(frames, fips=="24510")

#Splits data by year, returns list of data frames
balt_split <- split(balt_data, balt_data$year)

#Calculates the sum of Emissions across all data frames in baltimore split data (i.e. sums for every year)
sums <- lapply(balt_split, function(x) { return(sum(x$Emissions))})

#Open png to write plot to
png("plot2.png")

#Plot the sums clearly with informative labels
plot(c(1999,2002,2005,2008), sums, 
     xlab="Year", 
     ylab="Tons", 
     main="Baltimore City Yearly PM2.5 Emissions", 
     pch=8, lwd=3, col="blue")

#Connect points with lines to better visualize the trend
lines(c(1999,2002,2005,2008), sums, 
      lwd=3, col="blue")

#Save plot
dev.off()
