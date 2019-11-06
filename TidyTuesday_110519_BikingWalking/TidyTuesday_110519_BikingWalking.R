#Tidy Tuesday 10/29/2019
#Biking and walking
#Created by Jennica Moffat

library(tidyverse)
library(usmap)


#Clear environment
rm(list=ls())
#load data
commute_mode <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-11-05/commute.csv")


commute_mode %>% filter(!is.na(state_abb))
mydata <- commute_mode %>% group_by(state_abb, mode) %>%
  summarize(meanPerc=mean(percent, na.rm=T))
View(mydata)


plot_usmap(data = statepop, values = "pop_2015", color = "red") + 
  scale_fill_continuous(name = "Population (2015)", label = scales::comma) + 
  theme(legend.position = "right")