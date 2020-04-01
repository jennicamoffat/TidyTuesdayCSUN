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
beer_taxed <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/beer_taxed.csv')
brewer_size <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/brewer_size.csv')
beer_states <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/beer_states.csv')

View(brewing_materials)
View(beer_taxed)
View(brewer_size)
View(beer_states)

brewing_materials$year<-as.factor(brewing_materials$year)

#Basic connected scatter plot by year over the months
brewing_materials  %>%
  ggplot( aes(x=month, y=month_current, color=year)) +
  geom_line()+
  geom_point()
#Everything is connected. Summarizing data.


brewing<- brewing_materials %>%
  group_by(year, month)%>%
  summarize(mean=mean(month_current, na.rm=TRUE))
View(brewing)
brewing$scaled.mean<-(brewing$mean)/1000000
brewing <- transform(brewing, MonthAbb = month.abb[month])

#Connected scatter plot of barrels produced by year
BeerPlot<-brewing %>%
  ggplot(aes(x=month, y=scaled.mean, color=year))+
  geom_line(size=1)+
  geom_point(size=2)+
  theme_bw()+
  ggtitle("Average Barrels of Beer Produced by Year")+
  scale_x_discrete(name="", limits = month.abb)+ #Transforms numbers to month abbreviation
  scale_y_continuous(name="Avg Production (millions of barrels)")+
  theme(plot.title = element_text(size=14), axis.text.x=element_text(color="black", size=12), axis.text.y=element_text(size=12), axis.title.y = element_text(color="black", size=14))+
  labs(color="Year")
BeerPlot

#Adding barrels to plot. 
Barrel <- readPNG("Barrel.png")
g <- rasterGrob(Barrel, interpolate=TRUE)
BarrelPlot <- BeerPlot + annotation_custom(g, xmin=11, xmax=12, ymin=5, ymax=35)
BarrelPlot

Barrels <- readPNG("MultipleBarrels.png")
g2 <- rasterGrob(Barrels, interpolate=TRUE)
BarrelPlot2 <- BarrelPlot + annotation_custom(g2, xmin=0.5, xmax=4.5, ymin=50, ymax=120)
BarrelPlot2

BarrelPlot2 +ggsave("BeerPlot.pdf", width=10, height=6.19, dpi=300, unit="in")
