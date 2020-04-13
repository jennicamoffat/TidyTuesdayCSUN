#Tidy Tuesday 3/3/2020
#NHL Goals
#Created by Jennica Moffat

library(tidyverse)

#Clear environment
rm(list=ls())

#Load data
game_goals <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-03/game_goals.csv')
top_250 <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-03/top_250.csv')
season_goals <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-03/season_goals.csv')

View(game_goals)
View(top_250)
View(season_goals)


