#TidyTuesday 9/3/2019

library('tidyverse')
library(ggplot2)
#Clear the environment
rm(list=ls())

cpu <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/cpu.csv")
gpu <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/gpu.csv")
ram <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/ram.csv")

View(cpu)
View(gpu)
View(ram)

df<-merge(x=cpu,y=gpu, by="date_of_introduction")
View(df)

alldata<-merge(x=df, y=ram, by="date_of_introduction")
View(alldata)

