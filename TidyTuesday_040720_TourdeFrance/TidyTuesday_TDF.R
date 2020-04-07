#Tidy Tuesday 4/7/2020
#Tour de France
#Created by Jennica Moffat

library(tidyverse)

#Clear environment
rm(list=ls())
#load data
tdf_winners <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-07/tdf_winners.csv')
View(tdf_winners)
