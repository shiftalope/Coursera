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

#Filters pm2.5 data fram on Motor Vehicle Source list from previous step, AND only in (baltimore city or los angeles)
motor_frame <- filter(frames, (frames$fips=="24510" |  frames$fips=="06037") & frames$SCC %in% motor_codes[[1]])

#group my year and city
motor_frame <- group_by(motor_frame, year, fips)

#calculate sums
sums <- as.data.frame( summarise(motor_frame, sum=sum(Emissions)) )

#split into separate data frames for each city
sums <- split(sums, sums$fips)

#Add column to each data frame with %change from starting year
sums <- lapply(sums, function(x){cbind(x, change=100*(x$sum/x$sum[1]-1))})

#recombine data frames
sums <- cbind(sums[[1]], sums[[2]])

#assign unique names
names(sums) <- c("yearLA", "fipsLA", "sumLA", "changeLA", "yearBA", "fipsBA", "sumBA", "changeBA")

#open plot
png("plot6.png")

#Set plot grid to have 2 rows and 1 column
par(mfrow = c(2, 1))

#First plot: independently plot sums from baltimore and sums from los angeles
matplot(x=sums$yearLA, y=sums[, c("sumLA", "sumBA")], type = c("b"),pch=1,col = 1:2, ylab = "Tons", xlab="Year", ylim=c(0,7000) )

#Adds informative legend
legend(x = "top",inset = 0,
       legend = c("Los Angeles", "Baltimore City"), 
       col=1:2, lwd=5, cex=.5, horiz = TRUE)

#First plot: independently plot %change from baltimore and %change from los angeles
matplot(x=sums$yearLA, y=sums[, c("changeLA", "changeBA")], type = c("b"),pch=1,col = 1:2, ylab="% Change From 1999", xlab="Year", ylim=c(-80, 50))

#Adds informative legend
legend(x = "top",inset = 0,
       legend = c("Los Angeles", "Baltimore City"), 
       col=1:2, lwd=5, cex=.5, horiz = TRUE)

#Saves plots
dev.off()