#Tidy Tuesday week 5 10/1/2019
#Created by Jennica Moffat

library(tidyverse)
library(RColorBrewer)
library(wordcloud2) 

#Clear the environment
rm(list=ls())

#Load the data
pizza_jared <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_jared.csv")
pizza_barstool <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_barstool.csv")
pizza_datafiniti <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_datafiniti.csv")#Tidy Tuesday week 4 09/17/2019
View(pizza_jared)
View(pizza_barstool)
View(pizza_datafiniti)

#Renaming place to name in jared data so it matches barstool
colnames(pizza_jared)[colnames(pizza_jared)=="place"] <- "name"
View(pizza_jared)

#merging jared and barstool datasets
#removing not matching pizza places
mydata <-merge(pizza_jared, pizza_barstool, by.x = "name", by.y = "name", all.x = FALSE)
View(mydata)


#New strategy
#I want to do a word cloud with names of pizza places corresponding to their percentage of "Excellent"

#Subsetting data to just be percent of Excellent
datasubset<-subset(pizza_jared, answer=="Excellent")
View(datasubset)
#Looks good

#Now remove all other columns that aren't name and percent (ie: frequency)
data <- datasubset[ -c(1:5,7:8) ]
View(data)

#Renaming place to be word
colnames(pizza_jared)[colnames(pizza_jared)=="place"] <- "word"

# Basic plot
wordcloud2(data=data, size=1)

#Hmm won't do anything. Maybe it needs to be whole numbers?
data$percent<- 10000*data$percent+1

#Renaming percent to be freq
colnames(pizza_jared)[colnames(pizza_jared)=="percent"] <- "freq"


# Change the shape:
wordcloud2(data, size = 0.7, shape = 'triangle-forward')
head(data)

# Change the shape using your image
wordcloud2(demoFreq, figPath = "~/Desktop/R-graph-gallery/img/other/peaceAndLove.jpg", size = 1.5, color = "skyblue", backgroundColor="black")

#####################################
#Trying a different package
library("ggwordcloud")
#Clear the environment
rm(list=ls())

#Load the data
pizza_jared <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_jared.csv")

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

ggplot(data, aes(label = place, size = percent, color = percent)) +
  geom_text_wordcloud_area() +
  scale_radius(range = c(0, 20), limits = c(0, NA)) +
  theme_minimal()+ ggtitle(shape)+
  geom_text_wordcloud_area(shape = shape) +
  scale_color_gradient(low = "red", high = "darkred")


