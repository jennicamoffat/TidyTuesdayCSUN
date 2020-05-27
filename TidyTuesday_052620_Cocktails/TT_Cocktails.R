#Tidy Tuesday 5/26/2020
#Cocktails!
#Created by Jennica Moffat

library(tidyverse)


#Clear environment
rm(list=ls())
#load data
cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/cocktails.csv')
boston_cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/boston_cocktails.csv')

View(cocktails)
cocktails$drink<-as.factor(cocktails$drink)
numb.ingredients<-cocktails%>%
  count(drink)
View(numb.ingredients)

View(boston_cocktails)
boston_cocktails$ingredient<-as.factor(boston_cocktails$ingredient)
popular.ingredients<-boston_cocktails%>%
  group_by(ingredient)%>%
  tally()%>%
  arrange(desc(n))
View(popular.ingredients)
nlevels(popular.ingredients$ingredient)
#Oh wow there are 569 ingredients. 
popular.ingredients$category<-as.factor(popular.ingredients$category)
nlevels(popular.ingredients$category)
#11 categories, so let's filter for the top 11 ingredients

popular.ingredients<-boston_cocktails%>%
  group_by(category, ingredient)%>%
  tally()%>%
  desc(ingredient)
top_n(11, ingredient)%>%
  droplevels


desc(ingredient)

