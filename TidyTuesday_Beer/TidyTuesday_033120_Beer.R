#Tidy Tuesday 3/31/2020
#BEER
#Created by Jennica Moffat

library(tidyverse)
library(png)
library(ggimage)
library(ggpubr)
library(grid)
library(ggimage)


#Clear environment
rm(list=ls())
#load data
brewing_materials <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/brewing_materials.csv')

View(brewing_materials)
brewing_materials$year<-as.factor(brewing_materials$year)

#Gonna just pull out "Total Used"
brewing.data<-subset(brewing_materials, type=="Total Used")
View(brewing.data)
brewing.data$scaled.total<-(brewing.data$month_current)/1000000

#Plot of total
Plot<-brewing.data %>%
  ggplot(aes(x=month, y=scaled.total, color=year))+
  geom_line(size=1)+
  geom_point(size=2)+
  theme_bw()+
  ggtitle("Total Barrels of Beer Produced by Year")+
  scale_x_discrete(name="", limits = month.abb)+ #Transforms numbers to month abbreviation
  scale_y_continuous(name="Total Production (millions of barrels)")+
  theme(plot.title = element_text(size=14), axis.text.x=element_text(color="black", size=12), axis.text.y=element_text(size=12), axis.title.y = element_text(color="black", size=14))+
  labs(color="Year")
Plot

#Adding barrels to plot. 
Barrel <- readPNG("Barrel.png")
g <- rasterGrob(Barrel, interpolate=TRUE)
BarrelPlot <- Plot + annotation_custom(g, xmin=11, xmax=12, ymin=25, ymax=125)
BarrelPlot

Barrels <- readPNG("MultipleBarrels.png")
g2 <- rasterGrob(Barrels, interpolate=TRUE)
BarrelPlot2 <- BarrelPlot + annotation_custom(g2, xmin=0.5, xmax=4.5, ymin=200, ymax=475)
BarrelPlot2

#Adding text to label barrels
BarrelPlot3<-BarrelPlot2+annotate("text", x = 11.5, y = 150, label = c("2016-2017"), color="brown", fontface="bold")
BarrelPlot3
BarrelPlot4<-BarrelPlot3+annotate("text", x = 4.2, y = 380, label = c("2008-2015"), color="brown", fontface="bold")
BarrelPlot4

BarrelPlot4 + ggsave("BeerPlot.pdf", width=10, height=6.19, dpi=300, unit="in")
