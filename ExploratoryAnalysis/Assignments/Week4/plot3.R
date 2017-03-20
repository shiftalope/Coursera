#Load appropriate Libaries
library(dplyr)
library(ggplot2)

#Reads in PM2.5 data from working directory if not already in memory.
#Check first so as not to waste time re-reading large files during development
if(!exists("frames")){
  print("Reading in pm25 Data Frames...")
  frames <- readRDS("summarySCC_PM25.rds")
}
#Filter raw data frame to select only data from baltimore city 
balt_data <- filter(frames, fips=="24510")

#Splits data by type, returns list of data frames
balt_split <- split(balt_data, balt_data$type)

#Splits data frame by year
balt_split <- lapply(balt_split, function(x){split(x, x$year)})

#Sums across list of data frames
sums <- lapply(balt_split, function(y){lapply(y, function(x){sum(x$Emissions)})})

#Create the sum data frame to plot
dat <- data.frame(Type=character(),
                  Year=integer(),
                  Sum=numeric())

#Fill the data frame with sums
myTypes <- names(sums)
myYears <- names(sums$`NON-ROAD`)
for(TYPE in myTypes){
  for(YEAR in myYears){
    dat <-rbind(dat, data.frame(Type=TYPE, 
                                Year=as.integer(YEAR), 
                                Sum=as.numeric(sums[[TYPE]][[YEAR]])))
  }
}

#Open png to write plot to
png("plot3.png")

#Plot sums using ggplot, put in informative/readable format
myplot <- ggplot(data=dat, aes(x=Year, y=Sum, group=Type, color=Type)) +
  geom_line() +
  geom_point( size=4, shape=21, fill="white") +
  ggtitle("Yearly Baltimore City PM2.5 Emission By Type") +
  labs(x="Year", y="Tons / Year") +
  scale_fill_discrete(name="Emission Type")

#Print and save plot
print(myplot)
dev.off()
