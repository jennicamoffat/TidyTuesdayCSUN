#Tidy Tuesday week 3 09/10/2019
#Created by Jennica Moffat

library('tidyverse')
#Clear the environment
rm(list=ls())

#Load the data
tx_injuries <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-10/tx_injuries.csv")
safer_parks <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-10/saferparks.csv")

View(tx_injuries)
