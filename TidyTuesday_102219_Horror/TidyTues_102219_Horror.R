#Tidy Tuesday 10/22/2019
#Horror Movies
#Created by Jennica Moffat

library(tidyverse)
library(hrbrthemes)

#Clear the environment
rm(list=ls())

#Load the data
horror_movies <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-22/horror_movies.csv")
