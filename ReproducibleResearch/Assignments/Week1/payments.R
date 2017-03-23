library(dplyr)
library(ggplot2)

setwd("/Users/alex/Work/Coursera/ReproducibleResearch/Assignments/Week1")

#Open data csv if not already in memory (to save time during development if dataset is large)
#For this practice to work properly, must remember to not alter master dataset
if(!exists("paymentData")){
  "Opening file..."
  paymentData <- read.csv("../../data/payments.csv")
}

#Function to make plot of Total Payments vs. Covered Charges in New York State
makePlot1 <- function(){
  #Only take data from NY
  newYorkData <-filter(paymentData, Provider.State=="NY")
  
  #Open plot for plotting
  png("plot1.png")
  
  #Create a plot demonstrating the relationship between Total Payments and Covered Charges
  #For each line in newYorkData plot a point with x=Covered Charges and y=Total Payments
  #Fit a linear regression line to better see trend (though this may not be the best fit function)
  #Make pretty labels
  p1 <- ggplot(newYorkData, aes(x=Average.Covered.Charges, y=Average.Total.Payments))+
    geom_point(shape=1) +
    geom_smooth(method=lm) +
    labs(x="Average Covered Charges (Dollars)", 
         y="Average Total Payments (Dollars)", 
         title="Total Payments vs. Covered Charges in New York State")
  
  #Print plot to open png file
  print(p1)
  
  #Close png file
  dev.off()
}

#Function to make plot of Total Payments vs. Covered Charges grouped by state and medical condition
makePlot2 <- function(){
  
  #Medical conditions are too long to print as labels on plots so...
  #Create copy of original data with new column with the medical condition code (better for graphing purposes)
  paymentData2 <- mutate(paymentData, shortDef=substr(DRG.Definition, 1, 3))
  
  #Open plot for plotting
  png("plot2.png")
  
  #Create same plot as in makePlot1, but for each combination of medical condition and state (6x6 = 36 plots)
  p2 <- ggplot(paymentData2, aes(x=Average.Covered.Charges, y=Average.Total.Payments ))+
    geom_point() + 
    geom_smooth(method=lm) +
    facet_grid(shortDef~Provider.State) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    labs(x="Average Covered Charges (Dollars)", 
         y="Average Total Payments (Dollars)", 
         title="Total Payments vs. Covered Charges\n Grouped By Medical Condition & State")
  
  #Print plot to open png file
  print(p2)
  
  #Close png file
  dev.off()
  
  #Print out table to look up medical condition codes
  print("Medical Condition Lookup Table:")
  print(levels(paymentData$DRG.Definition))
}

makePlot1()
makePlot2()