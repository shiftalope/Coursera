#This script plots timelines of "Sub_metering_1", "Sub_metering_2", and Sub_metering_3" values from household_power_consumption data
#They are plotted separately but overlayed on top of each other

#Get Column Names from text file, save to vector
colNames <- read.table("household_power_consumption.txt", sep=";",skip=0, nrows=1,stringsAsFactors=FALSE)
colNames <- as.character(colNames[1,])

#Read in only the needed lines of the text file to maximize speed 
#(skip and nrows values pre-determined by looking up the rows for the specific days requested)
myData <- read.table("household_power_consumption.txt", sep=";",skip=66636, nrows=2880, header=TRUE)

#Add correct column names to dataframe
colnames(myData) <- colNames

#Paste Date and Time strings from the first two columns of the DataFrame together
#Store in vector for later use
DateTimeVec <- character()
for(i in 1:nrow(myData)){
  toAdd <- paste(myData[i,1], myData[i,2])
  DateTimeVec <- c(DateTimeVec, toAdd)
}

#Add new DateTime column to DataFrame
myData$Date_Time <- DateTimeVec

#Preapre png file to save plot to
png(filename="plot3.png")

#Plot Sub_metering_1 as a function of DateTime
plot(strptime(myData$Date_Time, format="%d/%m/%Y %H:%M:%S"), myData$Sub_metering_1, ylab ="Energy sub metering", xlab=" ",type="l")
#Overlay plot of Sub_metering_2 as a function of DateTime
points(strptime(myData$Date_Time, format="%d/%m/%Y %H:%M:%S"), myData$Sub_metering_2, type="l", col="red")
#Overlay plot of Sub_metering_2 as a function of DateTime
points(strptime(myData$Date_Time, format="%d/%m/%Y %H:%M:%S"), myData$Sub_metering_3, type="l", col="blue")
#Add a Legend
legend("topright",legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lty=c(1,1,1))

#Close png file
dev.off()