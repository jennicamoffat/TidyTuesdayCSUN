#082719 First day of tidy tuesday

#install and load library
install.packages('tidyverse')
library('tidyverse')

#Clear the environment
rm(list=ls())

# Read data
simpsons <- readr::read_delim("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-27/simpsons-guests.csv", delim = "|", quote = "")

View(simpsons)
