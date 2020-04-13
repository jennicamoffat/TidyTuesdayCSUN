#Tidy Tuesday 4/7/2020
#Tour de France
#Created by Jennica Moffat

library(tidyverse)
library(viridis)
library(plotly)

#Clear environment
rm(list=ls())
#load data
tdf_winners <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-07/tdf_winners.csv')
View(tdf_winners)

tdf_winners$nationality<-as.factor(tdf_winners$nationality)
nlevels(tdf_winners$nationality)
#14 nationalities

#adding year from start_date column
tdf_winners$race.year = as.numeric(format(tdf_winners$start_date, "%Y"))

#Which country has the most winners
winners<- tdf_winners %>%
  group_by(nationality) %>%
  summarise(total = n())
View(winners)

TimePlot<-tdf_winners %>%
  ggplot(aes(x=race.year, y=time_overall, color=distance, alpha=nationality))+
  geom_point(size=2)+
  theme_bw()+
  ggtitle("Tour de France race times and distance over the years")+
  scale_y_continuous(name="Total Race Time (hours)")+
  scale_x_continuous(name="")+
  theme(plot.title = element_text(size=14), axis.text.x=element_text(color="black", size=12), axis.text.y=element_text(size=12), axis.title.y = element_text(color="black", size=14))+
  labs(color="Race Distance (Km)")+
  scale_color_viridis()+
  guides(alpha = FALSE)
TimePlot

#Animate so that nationality comes up when you hover
ggplotly(TimePlot, tooltip= c("nationality"))