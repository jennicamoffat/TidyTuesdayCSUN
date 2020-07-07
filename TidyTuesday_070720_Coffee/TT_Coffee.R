#Tidy Tuesday 7/7/2020
#Coffee
#Created by Jennica Moffat

library(tidyverse)

#Clear environment
rm(list=ls())
# Get the Data
coffee_ratings <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-07/coffee_ratings.csv')

View(coffee_ratings)
