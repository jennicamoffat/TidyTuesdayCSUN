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

#Merge cpu and gpu
df<-merge(x=cpu,y=gpu, by="date_of_introduction")
View(df)
#Merge new df with ram so all df's are merged
alldata<-merge(x=df, y=ram, by="date_of_introduction")
View(alldata)

#Make basic line graph
ggplot(alldata, aes(x=date_of_introduction, y=capacity_bits))+
  geom_point()
#Not interesting but at least I remember how to make a plot. 

