#Tidy Tuesday 4/28/2020
#Broadway
#Created by Jennica Moffat

library(tidyverse)
library(PNWColors)
library(hrbrthemes)
library(viridis)

#Clear environment
rm(list=ls())
#load data
grosses <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-28/grosses.csv', guess_max = 40000)
synopses <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-28/synopses.csv')
cpi <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-28/cpi.csv')
pre_1985_starts <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-28/pre-1985-starts.csv')

View(grosses)

grosses$show<-as.factor(grosses$show)
nlevels(grosses$show)
#1122 shows...

grosses$year = as.numeric(format(grosses$week_ending, "%Y"))

grosses$year<-as.numeric(grosses$year)
mydata<-subset(grosses, year > "1994")
mydata$year<-as.factor(mydata$year)

p <- ggplot(mydata, aes(x=year, y=top_ticket_price, fill=year)) + # fill=name allow to automatically dedicate a color for each group
  geom_violin()+
  scale_x_discrete(limits=c("1995", "2000", "2005", "2010", "2015", "2020"))+
  stat_summary(fun.y=mean, geom="point", shape=23, size=1, fill="black")+
  scale_fill_manual(values=pnw_palette("Sailboat",6))+
  theme_classic()+
  theme(legend.position="none")+
  labs(title="Top Ticket Price by Year",x="", y = "Price ($USD)")
p

p2 <- ggplot(mydata, aes(x=year, y=avg_ticket_price, fill=year)) + # fill=name allow to automatically dedicate a color for each group
  geom_violin()+
  scale_x_discrete(limits=c("1995", "2000", "2005", "2010", "2015", "2020"))+
  stat_summary(fun.y=mean, geom="point", shape=23, size=1, fill="black")+
  scale_fill_manual(values=pnw_palette("Sailboat",6))+
  theme_classic()+
  theme(legend.position="none")+
  labs(title="Average Ticket Price by Year",x="", y = "Price ($USD)")
p2

