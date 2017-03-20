#Code for compiling Samsung accelerometer and gyroscope data
#to create a tiny dataset that lists the average values of the means
#and standard deviations of various measurements across 30 subjects and
#6 activities
#requires the UCI_HAR_Dataset folder to be in the working directory
#Outputs a text file with the tiny dataset
#=======================================================================
#Load appropriate libaries
library(dplyr)

#Store names of activities for later use
ActivityString <- c("WALKING",
                    "WALKING UPSTAIRS",
                    "WALKING DOWNSTAIRS",
                    "SITTING",
                    "STANDING",
                    "LAYING"
                    )

#Function to add the means and standard deviations of data to a data frame
#Applied to all the various files needed for the body acceleration, gyroscopic, and total accel in a generic way
#-------------------------
#Inputs
#-------------------------
#appendFrame = Frame to add columns to
#fileName = file name (without path) to extract raw data from
#type = Test or Train?
#-------------------------
#Outputs new data frame with added column
AddMeanSTD <- function(appendFrame, fileName, type){
  
  #format new column name from fileName
  newColName <- gsub("_","",fileName)
  
  #get full path to file to be opened
  ROOT <- paste0("UCI_HAR_Dataset/",type,"/Inertial\ Signals/")
  fullPath <- paste0(ROOT, fileName, "_", type, ".txt")
  print(paste("Opening: ", fullPath))
  
  #read in data from appropriate file
  tmpData <- read.table(fullPath)
  
  #calculate row means and add as a new column on the appendFrame
  #save to temprorary data frame
  tmpDF <- mutate(appendFrame, tmp1=rowMeans(tmpData))
  #calculate row standard deviations and add as a new column on the appendFrame
  #add to temprary data frame
  tmpDF <- mutate(tmpDF, tmp2=apply(tmpData, 1, sd))
  
  #change names of the new columns in the temporary data frame co
  names(tmpDF)[names(tmpDF) == "tmp1"] <- paste0(newColName, "mean")
  names(tmpDF)[names(tmpDF) == "tmp2"] <- paste0(newColName, "std")
  
  #return data frame with 2 additional columns
  tmpDF
}

#Used to save time during development, keep TRUE
redo = TRUE
if(redo){
  #reads in files for the test subjects, both the activity and accelration data
  test_activity <- read.table("UCI_HAR_Dataset/test/y_test.txt")
  #rename column and add new column for activity string
  test_subjects <- read.table("UCI_HAR_Dataset/test/subject_test.txt") %>%
    rename(id=V1) %>%
    mutate(type="TEST", 
           activity=ActivityString[test_activity$V1])
  
  #repeat last step for training data
  train_activity <- read.table("UCI_HAR_Dataset/train/y_train.txt")
  train_subjects <- read.table("UCI_HAR_Dataset/train/subject_train.txt") %>%
    rename(id=V1) %>%
    mutate(type="TRAIN", 
           activity=ActivityString[train_activity$V1])
  
  #clear up some space in memory
  rm(test_activity, train_activity)
  
  #construct list of files to be read
  files <- c("body_acc_x", 
             "body_acc_y",
             "body_acc_z",
             "body_gyro_x",
             "body_gyro_y",
             "body_gyro_z",
             "total_acc_x",
             "total_acc_y",
             "total_acc_z"
  )
  
  #Open all files, in both testing a training, extract means and stds for each row using the AddMeanSTD function
  for(file in files){
    test_subjects <- AddMeanSTD(test_subjects, file, "test")
    train_subjects <- AddMeanSTD(train_subjects, file, "train")
  }
  
  #combine both testing and training datasets
  mergedData <- rbind(test_subjects, train_subjects)
}

#sort by subject id
mergedData <- arrange(mergedData, id)

#begin constuction of tiny dataset with junk row to be overwritten
tiny <- mergedData[1,]

#flag to overwrite first row
theFirst <- TRUE
#loops over all subjects and all activities
for(ID in 1:30){
  for(ACTIVITY in ActivityString){
    #Isolate entries specific to subject and activity
    tmpData <- filter(mergedData, id==ID, activity==ACTIVITY)
    
    #construct a new row with means of each column in the isolated dataframe
    tmpRow <- c(id=ID, type=tmpData[1,"type"], activity=ACTIVITY, as.numeric(colMeans(tmpData[4:21])))
    
    #if this is the first row to be added, replace the first row in tiny
    if(theFirst) {tiny[1,] < tmpRow; theFirst <- FALSE}
    #otherwise, add row to bottom
    else tiny <- rbind(tiny, tmpRow)
  }
}

#write tiny dataset to text file
write.table(tiny, "tinyDataset.txt", row.name=FALSE)