#Tidy Tuesday 7/21/2020
#Australian Animals
#Created by Jennica Moffat

library(tidyverse)
library(PNWColors)
library(png)
library(grid)
library(ggimage)

#Clear environment
rm(list=ls())
# Get the Data
animal_outcomes <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-21/animal_outcomes.csv')
animal_complaints <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-21/animal_complaints.csv')
brisbane_complaints <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-21/brisbane_complaints.csv')

View(animal_outcomes)
View(animal_complaints)
View(brisbane_complaints)
