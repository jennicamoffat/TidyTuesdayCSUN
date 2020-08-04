#Tidy Tuesday 8/4/2020
#European energy production
#Created by Jennica Moffat

library(tidyverse)
library(PNWColors)

#Clear environment
rm(list=ls())
#load data
energy_types <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-04/energy_types.csv')
country_totals <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-04/country_totals.csv')
