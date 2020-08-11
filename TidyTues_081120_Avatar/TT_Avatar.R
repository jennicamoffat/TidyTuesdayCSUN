#Tidy Tuesday 8/11/2020
#Avatar the last airbender
#Created by Jennica Moffat

library(tidyverse)
library(PNWColors)
library(gganimate)
library(tvthemes)

#Clear environment
rm(list=ls())
#load data
avatar <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-11/avatar.csv')
scene_description <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-11/scene_description.csv')

View(avatar)

