#Tidy Tuesday week 5 10/1/2019
#Created by Jennica Moffat

library(tidyverse)
library(RColorBrewer)
library(wordcloud2) 

#Clear the environment
rm(list=ls())

#Load the data
pizza_jared <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_jared.csv")
View(pizza_jared)

#I want to do a word cloud with names of pizza places corresponding to their percentage of "Excellent"
library("ggwordcloud")

#Subsetting data to just be percent of Excellent
datasubset<-subset(pizza_jared, answer=="Excellent")
View(datasubset)
#Looks good

#Now remove all other columns that aren't name and percent (ie: frequency)
data <- datasubset[ -c(1:5,7:8) ]
View(data)

mydata<- data %>%
  group_by(place) %>%
  summarize(mean=mean(percent, na.rm=TRUE))
View(mydata)


for (shape in c(
  "circle", "cardioid", "diamond",
  "square", "triangle-forward", "triangle-upright",
  "pentagon", "star"
)) {
  print(ggplot(mydata, aes(label = place, size = mean, color = mean)) +
          scale_radius(range = c(0, 20), limits = c(0, NA)) +
          theme_minimal()+ ggtitle(shape)+
          geom_text_wordcloud_area(shape = shape) +
          scale_color_gradient(low = "red", high = "darkred"))
}

