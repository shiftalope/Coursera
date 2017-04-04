#This script plots timelines of: 
#"Global_active_power", "Voltage", "Sub_metering", and "Global_reactive_power" values from household_power_consumption data
#Each variable is plotted in a separate plot grouped in a 2x2 matrix
#The "Sub_metering" plot has all 3 Sub_metering categories overlayed on top of each other

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
png(filename="plot4.png")

#Partition plotting canvas to hold 4 plots in a 2x2 structure
par(mfrow=c(2,2))

#All Plots are functions of DateTime
#Plot Global_active_power in first position (top-left)
plot(strptime(myData$Date_Time, format="%d/%m/%Y %H:%M:%S"), myData$Global_active_power, ylab ="Global Active Power", xlab=" ",type="l")
#Plot Voltage in second position (top-right)
plot(strptime(myData$Date_Time, format="%d/%m/%Y %H:%M:%S"), myData$Voltage, ylab ="Voltage", xlab="datetime",type="l")

#Plot Sub_metering_1 in third position (bottom-left)
plot(strptime(myData$Date_Time, format="%d/%m/%Y %H:%M:%S"), myData$Sub_metering_1, ylab ="Energy sub metering", xlab=" ",type="l")
#Overlay Sub_metering_2
points(strptime(myData$Date_Time, format="%d/%m/%Y %H:%M:%S"), myData$Sub_metering_2, type="l", col="red")
#Overlay Sub_metering_3
points(strptime(myData$Date_Time, format="%d/%m/%Y %H:%M:%S"), myData$Sub_metering_3, type="l", col="blue")
#Add Legend
legend("topright",legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lty=c(1,1,1), bty="n")

#Plot Global_reactive_power in fourth position (bottom-right)
plot(strptime(myData$Date_Time, format="%d/%m/%Y %H:%M:%S"), myData$Global_reactive_power, type="l",xlab="datetime", ylab="Global_reactive_power")

#Close png file
dev.off()