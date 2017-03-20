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

#Compiles list of Motor Vehicle sources
motor_codes <- filter(codes, grepl("On-Road", codes$EI.Sector))
motor_codes_list <- list(motor_codes$SCC)

#Filters pm2.5 data fram on Motor Vehicle Source list from previous step, AND only in baltimore city
motor_frame <- filter(frames, frames$fips=="24510" & frames$SCC %in% motor_codes[[1]])

#Group elements by year
motor_frame <- group_by(motor_frame, year)

#Calculate sums by year
sums <- as.data.frame( summarise(motor_frame, sum=sum(Emissions)) )

#Open plot
png("plot5.png")

#Plot sums
plot(x=sums$year, sums$sum, 
     xlab="Year", 
     ylab="Tons", 
     main="Baltimore City Motor Vehicle PM2.5 Emissions",
     pch=8, lwd=3, col="blue")

#Connect with Lines
lines(sums$year, sums$sum, 
      lwd=3, col="blue")

#Save Plot
dev.off()