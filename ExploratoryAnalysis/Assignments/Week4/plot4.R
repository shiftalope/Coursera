#Load appropriate Libaries
library(dplyr)

#Reads in PM2.5 data from working directory if not already in memory.
#Check first so as not to waste time re-reading large files during development
if(!exists("frames")){
  print("Reading in pm25 Data Frames...")
  frames <- readRDS("summarySCC_PM25.rds")
}

#Reads in classification codes
codes <- readRDS("Source_Classification_Code.rds")

#Compiles list of Combustion Coal sources
coal_codes <- filter(codes, grepl("[Cc]oal",Short.Name), grepl("[Cc]omb", Short.Name))
coal_codes <- list(coal_codes$SCC)

#Filters pm2.5 data fram on Coal list from previous step
coal_frame <- filter(frames, frames$SCC %in% coal_codes[[1]])

#Groups elemtns by year
coal_frame <- group_by(coal_frame, year)

#Sum across all groups
sums <- as.data.frame( summarise(coal_frame, sum=sum(Emissions)) )

#Open plot
png("plot4.png")

#Plot sums
plot(x=sums$year, sums$sum, 
     xlab="Year", 
     ylab="Tons", 
     main="Combustion Coal PM2.5 Emissions",
     pch=8, lwd=3, col="blue")

#Connect points with lines
lines(sums$year, sums$sum, 
      lwd=3, col="blue")

#Save plot
dev.off()