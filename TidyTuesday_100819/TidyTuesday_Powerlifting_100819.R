#Tidy Tuesday 10/8/2019
#Powerlifting
#Created by Jennica Moffat

library(tidyverse)
library(RColorBrewer)

#Clear the environment
rm(list=ls())

#load data
mydata <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-08/ipf_lifts.csv")
View(mydata)

#Subsetting to just have first place
champdata<-subset(mydata, place=="1")
View(champdata)

#Average squat, bench, and deadlift for each date, separated by male/female
SummaryChamps<-champdata %>%
  group_by(date, sex) %>%
  summarize(avgsquat=mean(best3squat_kg, na.rm=TRUE), avgbench=mean(best3bench_kg, na.rm=TRUE), avgdeadlift=mean(best3deadlift_kg, na.rm=TRUE))
View(SummaryChamps)
#Max of everything instead of average
MaxData<-champdata %>%
  group_by(date, sex) %>%
  summarize(maxsquat=max(best3squat_kg, na.rm=TRUE), maxbench=max(best3bench_kg, na.rm=TRUE), maxdeadlift=max(best3deadlift_kg, na.rm=TRUE))
View(MaxData)
#Or datafram with both max and average. Let's get real crazy. 
SummaryData<-champdata %>%
  group_by(date, sex) %>%
  summarize(maxsquat=max(best3squat_kg, na.rm=TRUE), maxbench=max(best3bench_kg, na.rm=TRUE), maxdeadlift=max(best3deadlift_kg, na.rm=TRUE), 
            avgsquat=mean(best3squat_kg, na.rm=TRUE), avgbench=mean(best3bench_kg, na.rm=TRUE), avgdeadlift=mean(best3deadlift_kg, na.rm=TRUE))
View(SummaryData)

#Subsetting data by activity
Squats<-SummaryData[ -c(4, 5, 7, 8) ]
Bench<-SummaryData[ -c(3, 5, 6, 8)]
Deadlift<-SummaryData[-c(3, 4, 6, 7)]

#Squats graph. Graphing max and average for each sex over time




#to print two graphs in one
grid.arrange(graph1, graph2, ncol=1)