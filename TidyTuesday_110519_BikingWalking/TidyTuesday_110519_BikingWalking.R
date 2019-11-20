#Tidy Tuesday 10/29/2019
#Biking and walking
#Created by Jennica Moffat

library(tidyverse)
library(usmap)
library(maps)


#Clear environment
rm(list=ls())
#load data
commute_mode <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-11-05/commute.csv")

us_states <- map_data("state")
head(us_states)

commute_mode %>% filter(!is.na(state_abb))

mydata <- commute_mode %>% group_by(state_abb, mode) %>%
  summarize(meanPerc=mean(percent, na.rm=T))


biking <- mydata %>% filter(mode=="Bike")
biking$state_abb <- tolower(biking$state_abb)
us_biking <- left_join(us_states, biking)

walking <- mydata %>% filter(mode=="Walk")
View(biking)

plot_usmap(data = biking, values = "meanPerc")

plot_usmap(data = biking, values = "meanPerc", col = "black") + 
  scale_fill_continuous(low = "white", high = "red", name = "Mean Percent Bikers by State", label = scales::comma) + 
  theme(legend.position = "right")

