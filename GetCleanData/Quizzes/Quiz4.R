setwd("/Users/alex/Work/Coursera/DataScience/GetCleanData")

Q1 <- function(){
  if(!file.exists("data/USCommunities.csv")){
    print("Downloading File...")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "data/USCommunities.csv")
  }
  file1 <- read.csv("data/USCommunities.csv")
  splitNames <- strsplit(names(file1), "wgtp")
  print(splitNames[[123]])
}

Q23 <- function(){
  library(dplyr)
  if(!file.exists("data/GDP.csv")){
    print("Downloading File...")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "data/GDP.csv")
  }
  
  file1 <- read.csv("data/GDP.csv")
  file1 <- rename(file1, countrycode=X, gdprank=Gross.domestic.product.2012, longname = X.2, gdp=X.3) %>%
    select(countrycode, gdprank, longname, gdp) %>%
    filter(grepl("^( ){0,1}[1-9]", gdp), gdprank != "")
  
  removeCommas <- function(x) as.numeric(gsub(",", "",x))
  
  gdpVec <- sapply(file1$gdp, removeCommas)
  print(mean(gdpVec))
  
  print(grep("^United", file1$longname, value=TRUE))
}

Q4 <- function(){
  library(dplyr)
  if(!file.exists("data/GDP.csv")){
    print("Downloading File...")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "data/GDP.csv")
  }
  if(!file.exists("data/Educ.csv")){
    print("Downloading File...")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "data/Educ.csv")
  }
  
  file1 <- read.csv("data/GDP.csv")
  file1 <- rename(file1, countrycode=X, gdprank=Gross.domestic.product.2012, longname = X.2, gdp=X.3) %>%
    select(countrycode, gdprank, longname, gdp)
  
  file2 <- read.csv("data/Educ.csv")
  file2 <- rename(file2, countrycode=CountryCode, longname = Long.Name, specialnotes = Special.Notes) %>%
    select(countrycode, longname, specialnotes) %>%
    filter(grepl("Fiscal year end: June", specialnotes))
  
  mergedData <- merge(file1, file2, by="countrycode")
  print(dim(mergedData))
}

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
print(length(grep("2012", sampleTimes)))
sampleTimes <- as.POSIXct(sampleTimes)
sampleTimes <- format(sampleTimes, "%a, %Y")
YearFilter <- grep("2012", sampleTimes, value=TRUE)
DayFilter <- grep("Mon, 2012", sampleTimes, value=TRUE)

print(paste(length(YearFilter), length(DayFilter)))