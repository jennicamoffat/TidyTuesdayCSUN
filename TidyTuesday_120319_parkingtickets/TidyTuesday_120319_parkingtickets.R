#Tidy Tuesday 12/3/2019
#Philly Parking Tickets
#Created by Jennica Moffat

library(tidyverse)
library(wesanderson)
library(ggmap)
library(lubridate)

#Clear environment
rm(list=ls())

#load data
tickets <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-12-03/tickets.csv")
View(tickets)

tickets$violation_desc<-as.factor(tickets$violation_desc)
nlevels(tickets$violation_desc) 

ViolationCounts <- tickets %>% group_by(violation_desc) %>% tally()
View(ViolationCounts)
#Meter expired and meter expired cc are the two most common violations, let's subset that

mydata<-subset(tickets,violation_desc == "METER EXPIRED CC" | violation_desc == "METER EXPIRED")
View(mydata)


if(!requireNamespace("devtools")) install.packages("devtools")
devtools::install_github("dkahle/ggmap", ref = "tidyup", force=TRUE)

#Create base map to put data on
p <- ggmap(get_googlemap(center = c(lon = -75.17, lat = 39.95),
                         zoom = 13, scale = 2,
                         maptype ='terrain',
                         color = 'color'))

p + stat_density2d(aes(x = lon, y = lat, colour = violation_desc), data = mydata, bins = 5)

qmplot(lon, lat, data = mydata, maptype = "toner-lite",
       color = violation_desc, size = violation_desc, legend = "topleft"
)


p + stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
               size = 2, bins = 4, data = mydata, geom = "polygon") +
  scale_fill_gradient("Meter\nExpired") +
  scale_alpha(range = c(.4, .75), guide = FALSE) +
  guides(fill = guide_colorbar(barwidth = 1.5, barheight = 10))



qmplot(lon, lat, data = mydata, geom = "blank",  
       zoom = 1, maptype = "toner-background", darken = .7, legend = "topleft"
) +
  stat_density_2d(aes(fill = ..level..), geom = "polygon", alpha = .3, color = NA) +
  scale_fill_gradient2("Robbery\nPropensity", low = "white", mid = "yellow", high = "red", midpoint = 650)
