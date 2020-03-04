#Tidy Tuesday 2/18/2020
#Food's Carbon Footprint
#Created by Jennica Moffat

library(tidyverse)
library(ggridges)
library(hrbrthemes)
library(viridis)
library(ggalt)
library("ggalt")

#Clear environment
rm(list=ls())
#Load data
food_consumption <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-02-18/food_consumption.csv')

View(food_consumption)


food_consumption$country<-as.factor(food_consumption$country)
nlevels(food_consumption$country)

#Adding column of ratio of kg co2 emmission:consumption (units for both are Kg per person per year)
food_consumption$ratio<-food_consumption$co2_emmission/food_consumption$consumption
View(food_consumption)

#Rank countries by total sum of consumption across all categories
TotalConsumption<-food_consumption%>%
  group_by(country)%>%
  summarize(total=sum(consumption))
TotalConsumption
#Arrange in decreasing order
TopConsumption <- arrange(TotalConsumption, desc(total))
View(TopConsumption)


Data<-food_consumption%>%
  group_by(food_category)%>%
  summarize(meanratio=mean(ratio, na.rm = TRUE), meanconsumption=mean(consumption, na.rm=TRUE), meanCO2=mean(co2_emmission, na.rm=TRUE))
View(Data)

#Basic dumbell plot
Plot<-ggplot(Data, aes(x=meanconsumption, xend=meanCO2, y=food_category)) + 
  geom_segment(aes(x=meanconsumption, xend=meanCO2, y=food_category, yend=food_category),
               color="cyan4", size=1.25)+
  geom_dumbbell(color="cyan4", size_x=3.5, size_xend=3.5, 
                colour_x="darkgoldenrod", colour_xend="firebrick3")+
  labs(x=NULL, y=NULL, title="Consumption and CO2 emmission by food category", subtitle="CO2 emissions (red) vs Consumption (gold) in Kg/person/year ")+
  theme_bw()+
  theme(legend.position = "right")
Plot+ggsave("FoodCO2Plot.pdf", width=11, height=6.19, dpi=300, unit="in")


