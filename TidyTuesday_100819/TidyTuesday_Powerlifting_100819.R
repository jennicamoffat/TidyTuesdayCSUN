#Tidy Tuesday 10/8/2019
#Powerlifting
#Created by Jennica Moffat

library(tidyverse)
library(tidyr)
library(gridExtra)


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

#Pivoting data using tidyr's pivot_longer fxn
SquatsLong<-pivot_longer(Squats, c(maxsquat, avgsquat), names_to="Squat", values_to = "Weight")
BenchLong<-pivot_longer(Bench, c(maxbench, avgbench), names_to="Bench", values_to = "Weight")
DeadliftLong<-pivot_longer(Deadlift, c(maxdeadlift, avgdeadlift), names_to="Deadlift", values_to = "Weight")


#Squats graph. Graphing max and average for each sex over time
SquatPlot<-ggplot(SquatsLong, aes(x=date, y=Weight, size=Squat, color=sex))+
  geom_point()+
  geom_smooth(method="lm")+
  theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="Date",y="Weight (kg)")+
  scale_color_manual(values = c("cadetblue3", "darkgoldenrod2"))+
  scale_size_manual(values=c(1,2))+
  theme(legend.position="none")+
  ggtitle("Annual average and maximum squat weight over time")
SquatPlot

#Bench graph
BenchPlot<-ggplot(BenchLong, aes(x=date, y=Weight, size=Bench, color=sex))+
  geom_point()+
  geom_smooth(method="lm")+
  theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="Date",y="Weight (kg)")+
  scale_color_manual(values = c("cadetblue3", "darkgoldenrod2"), name  ="Sex",
                     labels=c("Female", "Male"))+
  scale_size_manual(values=c(1,2), name  =" ",
                    labels=c("Average", "Maximum"))+
  theme(legend.position = "top")+
  ggtitle("Annual average and maximum bench weight over time")
BenchPlot

#Deadlift graph
DeadliftPlot<-ggplot(DeadliftLong, aes(x=date, y=Weight, size=Deadlift, color=sex))+
  geom_point()+
  geom_smooth(method="lm")+
  theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="Date",y="Weight (kg)")+
  scale_color_manual(values = c("cadetblue3", "darkgoldenrod2"))+
  scale_size_manual(values=c(1,2))+
  theme(legend.position="none")+
  ggtitle("Annual average and maximum deadlift weight over time")
DeadliftPlot

#to print two graphs in one
grid.arrange(BenchPlot, DeadliftPlot, SquatPlot, ncol=1)
