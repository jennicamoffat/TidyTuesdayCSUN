#Tidy Tuesday week 5 10/1/2019
#Created by Jennica Moffat

library(tidyverse)
library(RColorBrewer)
library(gganimate)
library(gifski)
library(png)

#Clear the environment
rm(list=ls())

#Load the data
pizza_jared <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_jared.csv")
pizza_barstool <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_barstool.csv")
pizza_datafiniti <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_datafiniti.csv")#Tidy Tuesday week 4 09/17/2019

