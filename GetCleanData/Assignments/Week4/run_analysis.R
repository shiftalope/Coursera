library(dplyr)
setwd("/Users/alex/Work/Coursera/GetCleanData/Assignments/Week4")

ActivityString <- c("WALKING",
                    "WALKING UPSTAIRS",
                    "WALKING DOWNSTAIRS",
                    "SITTING",
                    "STANDING",
                    "LAYING"
                    )

AddMeanSTD <- function(appendFrame, fileName, type){
  
  newColName <- gsub("_","",fileName)
  ROOT <- paste0("../data/UCI_HAR_Dataset/",type,"/Inertial\ Signals/")
  fullPath <- paste0(ROOT, fileName, "_", type, ".txt")
  print(paste("Opening: ", fullPath))
  tmpData <- read.table(fullPath)
  
  tmpDF <- mutate(appendFrame, tmp1=rowMeans(tmpData))
  tmpDF <- mutate(tmpDF, tmp2=apply(tmpData, 1, sd))
  names(tmpDF)[names(tmpDF) == "tmp1"] <- paste0(newColName, "mean")
  names(tmpDF)[names(tmpDF) == "tmp2"] <- paste0(newColName, "std")
  tmpDF
}

redo = FALSE
if(redo){
test_activity <- read.table("../data/UCI_HAR_Dataset/test/y_test.txt")
test_subjects <- read.table("../data/UCI_HAR_Dataset/test/subject_test.txt") %>%
  rename(id=V1) %>%
  mutate(type="TEST", 
         activity=ActivityString[test_activity$V1])

train_activity <- read.table("../data/UCI_HAR_Dataset/train/y_train.txt")
train_subjects <- read.table("../data/UCI_HAR_Dataset/train/subject_train.txt") %>%
  rename(id=V1) %>%
  mutate(type="TRAIN", 
         activity=ActivityString[train_activity$V1])

rm(test_activity, train_activity)

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

for(file in files){
    test_subjects <- AddMeanSTD(test_subjects, file, "test")
    train_subjects <- AddMeanSTD(train_subjects, file, "train")
}

mergedData <- rbind(test_subjects, train_subjects)
}

mergedData <- arrange(mergedData, id)

tiny <- mergedData[1,]
theFirst <- TRUE
for(ID in 1:30){
  for(ACTIVITY in ActivityString){
    tmpData <- filter(mergedData, id==ID, activity==ACTIVITY)
    tmpRow <- c(id=ID, type=tmpData[1,"type"], activity=ACTIVITY, as.numeric(colMeans(tmpData[4:21])))
    if(theFirst) {tiny[1,] < tmpRow; theFirst <- FALSE}
    else tiny <- rbind(tiny, tmpRow)
  }
}