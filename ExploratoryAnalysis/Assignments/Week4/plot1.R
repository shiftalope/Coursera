#Script to calculate and plot the total emissions of PM2.5 per year
#for the years 1999, 2002, 2005, and 2008.
#Requires the file "summarySCC_PM25.rds" to be in working directory
#Saves "plot1.png" to working directory
#-------------------------------------------------------------------

#Reads in PM2.5 data from working directory if not already in memory.
#Check first so as not to waste time re-reading large files during development
if(!exists("frames")){
  print("Reading in pm25 Data Frames...")
  frames <- readRDS("summarySCC_PM25.rds")
}

#Splits data by year, returns list of data frames
#Check if already exists in memory so as not to waste time re-spliting during development
if(!exists("split_data")) split_data <- split(frames, frames$year)

#Calculates the sum of Emissions across all data frames in split data (i.e. sums for every year)
#Converts to millions of tons for better readability on plot
sums <- lapply(split_data, function(x) { return(sum(x$Emissions/1E6))})

#Open png to write plot to
png("plot1.png")

#Plot the sums clearly with informative labels
plot(c(1999,2002,2005,2008), sums, 
     xlab="Year", 
     ylab="Millions of Tons", 
     main="Yearly PM2.5 Emission", 
     pch=8, lwd=3, col="blue")

#Connect points with lines to better visualize the trend
lines(c(1999,2002,2005,2008), sums, 
      lwd=3, col="blue")

#Save plot
dev.off()
