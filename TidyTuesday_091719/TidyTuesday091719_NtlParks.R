#Tidy Tuesday week 4 09/17/2019
#Created by Jennica Moffat

library(tidyverse)
library(RColorBrewer)
library(gganimate)
library(gifski)
library(png)

#Clear the environment
rm(list=ls())

#Load the data
park_visits <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-17/national_parks.csv")
state_pop <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-17/state_pop.csv")
gas_price <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-17/gas_price.csv")

View(park_visits)
View(state_pop)
View(gas_price)


#Combining state_pop and park_visits
# merge two data frames by ID and Country
mydata <- merge(state_pop,park_visits,by=c("state","year"))
View(mydata)

#Adding per visits per person
mydata$visits_per_capita<-(mydata$visitors)/(mydata$pop)
View(mydata)

SummaryByGroup <- mydata %>%
  group_by(state, year) %>%
  summarize(mean=mean(visits_per_capita, na.rm=TRUE), SE=sd(visits_per_capita, na.rm=TRUE)/sqrt(length(na.omit(visits_per_capita))))
SummaryByGroup

#Removing dates pre-1950 because no pop data for AK
mydata2 <- subset(mydata, year > 1949)
View(mydata2)



SummaryByGroup <- mydata2 %>%
  group_by(state, year) %>%
  summarize(sum=sum(visits_per_capita, na.rm=TRUE))
SummaryByGroup

#Just data for 1950
mydata1950<-subset(mydata2, year==1950)

Summary1950<-mydata1950 %>%
  group_by(state) %>%
  summarize(sum=sum(visits_per_capita, na.rm=TRUE))

View(Summary1950)

#Just data for 2015, removing DC because it's misleading
mydata2015<-subset(mydata2, year==2015 & state !="DC")
View(mydata2015)

Summary2015<-mydata2015%>%
  group_by(state) %>%
  summarize(sum=sum(visits_per_capita, na.rm=TRUE))
View(Summary2015)

#Arrange data
Summary2015 <- Summary2015 %>%
  arrange(sum)
View(Summary2015)


#Start with basic bargraph
Graph2015<-Summary2015 %>%
         ggplot(aes(x=state, y=sum))+
  geom_bar(stat="identity")+
  theme_minimal()+
  ylim(-8, 17)+
  coord_polar(start = 0)+
  theme(
    panel.grid = element_blank(),
    plot.margin = unit(rep(-2,4), "cm"))
Graph2015

# ----- This section prepare a dataframe for labels ---- #
# Get the name and the y position of each label
Summary2015$np_id <- seq(1, nrow(Summary2015))
label_data <- Summary2015
label_data

# calculate the ANGLE of the labels
number_of_bar <- nrow(label_data)
angle <-  90 - 360 * (label_data$sum-0.5) /number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)

# calculate the alignment of labels: right or left
# If I am on the left part of the plot, my labels have currently an angle < -90
label_data$hjust<-ifelse( angle < -90, 1, 0)

# flip by angle to make them readable
label_data$angle<-ifelse(angle < -90, angle+180, angle)


Graph2015<-ggplot(data=Summary2015,aes(x=state, y=sum))+
  geom_bar(stat="identity",fill=alpha("skyblue", 0.7))+
  theme_minimal()+
  ylim(-20, 20)+
  coord_polar(start = 0)+
  theme(axis.text = element_blank(),axis.title = element_blank(),panel.grid = element_blank(),plot.margin = unit(rep(-2,4), "cm"))+
  ggtitle("Per Capita National Park Visits in 2015")+
  geom_text(data=label_data, aes(x=state, y=sum, label=state, hjust=hjust), color="black", fontface="bold",alpha=0.6, size=3.8, angle=label_data$angle, inherit.aes = FALSE )
Graph2015

##############################################################################
#I want to try to make it animate between years
Summary<-mydata%>%
  group_by(state, year) %>%
  summarize(sum=sum(visits_per_capita, na.rm=TRUE))
View(Summary)


# Get the name and the y position of each label
Summary$np_id <- seq(1, nrow(Summary))
label_data <- Summary
label_data

# calculate the ANGLE of the labels
number_of_bar <- nrow(label_data)
angle <-  90 - 360 * (label_data$sum-0.5) /number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)

# calculate the alignment of labels: right or left
# If I am on the left part of the plot, my labels have currently an angle < -90
label_data$hjust<-ifelse( angle < -90, 1, 0)

# flip by angle to make them readable
label_data$angle<-ifelse(angle < -90, angle+180, angle)


PerCapitaGraph<-ggplot(data=Summary,aes(x=state, y=sum), fill=year)+
  geom_bar(stat="identity")+
  theme_minimal()+
  ylim(-80, 63)+
  coord_polar(start = 0)+
  theme(axis.text = element_blank(),axis.title = element_blank(),panel.grid = element_blank(),plot.margin = unit(rep(-2,4), "cm"))+
  ggtitle("Per Capita National Park Visits")+
  geom_text(data=label_data, aes(x=state, y=sum, label=state, hjust=hjust), color="black", fontface="bold",alpha=0.6, size=3.8, angle=label_data$angle, inherit.aes = FALSE )+
  transition_states(frame, transition_length = 2, state_length = 1) +
  ease_aes('sine-in-out')
PerCapitaGraph
