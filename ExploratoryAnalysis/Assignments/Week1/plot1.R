#This script plots a histogram of "Global Active Power" values from household_power_consumption data

#Get Column Names from text file, save to vector
colNames <- read.table("household_power_consumption.txt", sep=";",skip=0, nrows=1,stringsAsFactors=FALSE)
colNames <- as.character(colNames[1,])

#Read in only the needed lines of the text file to maximize speed 
#(skip and nrows values pre-determined by looking up the rows for the specific days requested)
myData <- read.table("household_power_consumption.txt", sep=";",skip=66636, nrows=2880, header=TRUE)

#Add correct column names to dataframe
colnames(myData) <- colNames

#Preapre png file to save plot to
png(filename="plot1.png")

#Create histogram of Global_active_power values
hist(myData$Global_active_power, main="Global Active Power", col="red", xlab="Global Active Power (kilowatts)")

#Close png file
dev.off()