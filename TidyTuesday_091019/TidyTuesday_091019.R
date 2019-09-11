#Tidy Tuesday week 3 09/10/2019
#Created by Jennica Moffat

library(tidyverse)
library(lubridate)
library(hrbrthemes)
library(zoo)
library(plotly)
#Clear the environment
rm(list=ls())

#Load the data
tx_injuries <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-10/tx_injuries.csv")
safer_parks <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-10/saferparks.csv")
View(tx_injuries)
View(safer_parks)

#change date from Character to Date
safer_parks$acc_date<-as.Date(safer_parks$acc_date, "%m/%d/%Y")

#Total accidents per day
SummaryByGroup <- safer_parks %>%
  group_by(acc_date) %>%
  summarize(sum=sum(num_injured, na.rm=TRUE))
SummaryByGroup

#Accidents per day
AllAccidents <- SummaryByGroup %>%
  ggplot( aes(x=acc_date, y=sum)) +
  geom_area(fill="#69b3a2", alpha=0.5) +
  geom_line(color="#69b3a2") +
  ylab("Total accidents") +
  theme_ipsum()+
  scale_x_date()+ 
  theme_bw()
AllAccidents

#Kinda overwhelming. I want to group by month. 
#Set StringsAsFactors to FALSE
options(stringsAsFactors = FALSE)
# extract just the month from the date field in your data.frame
head(month(safer_parks$acc_date))
# add a month column to safer_parks
safer_parks <- safer_parks %>%
  mutate(month = month(acc_date))
View(safer_parks)
#Looks like it worked

#Also need to make new year column
# extract just the month from the date field in your data.frame
head(year(safer_parks$acc_date))
# add a month column to safer_parks
safer_parks <- safer_parks %>%
  mutate(year = year(acc_date))
View(safer_parks)
#Lookin good

#Now summarize by month and year
AccByMoYr<- safer_parks%>%
  group_by(month,year) %>%
  summarize(sum=sum(num_injured, na.rm=TRUE))
AccByMoYr

#Graph summed data
AllAccidentsMoYr <- AccByMoYr %>%
  ggplot( aes(x=year, y=sum)) +
  geom_line(color="#69b3a2") +
  ylab("Total accidents") +
  theme_ipsum()+
  theme_bw()
AllAccidentsMoYr
#Not what I want...

#Gonna try with the original data
Graph<-safer_parks %>%
  ggplot(aes(x=month, y=num_injured))+
  geom_point(color="#69b3a2") +
  ylab("Total accidents") +
  theme_ipsum()+
  theme_bw()
Graph
#still not what I want

#Using zoo library you can transform the date
safer_parks$MonthYear <- as.Date(as.yearmon(safer_parks$acc_date))
View(safer_parks)
#Looks like it kinda worked, but all dates have -01 after them for some reason. 

SummaryMonthYear<- safer_parks %>%
  group_by(MonthYear)%>%
  summarize(sum=sum(num_injured, na.rm=TRUE))
SummaryMonthYear

#Now I'm gonna try to graph it again
GraphMonthYear<-SummaryMonthYear %>%
  ggplot(aes(x=MonthYear, y=sum))+
  geom_line(color="#69b3a2") +
  geom_area(fill="#69b3a2", alpha=0.5) +
  ylab("Total accidents") +
  theme_ipsum()+
  theme_bw()+
  xlab("Date")
GraphMonthYear
#FINALLY

#To make it interactive
GraphMonthYearInt<-ggplotly(GraphMonthYear)
GraphMonthYearInt

#Can I make it from the full data

GraphMonthYear <- safer_parks %>%
  ggplot(aes(x=MonthYear, y=num_injured))+
  geom_point(color="#69b3a2") +
  ylab("Total accidents") +
  theme_ipsum()+
  theme_bw()+
  xlab("Date")
GraphMonthYear
#Hmm not really. Doesn't automatically sum.

#WAnt to add labeles to specific points. 
geom_text(aes(label=ifelse(PTS>24,as.character(Name),'')),hjust=0,vjust=0)
