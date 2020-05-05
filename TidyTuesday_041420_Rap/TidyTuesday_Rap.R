#Tidy Tuesday 4/14/2020
#Rappers
#Created by Jennica Moffat

library(tidyverse)


#Clear environment
rm(list=ls())
#load data
polls <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-14/polls.csv')
rankings <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-14/rankings.csv')
View(polls)
View(rankings)

#How about, what is the best rap year?
best.year<- rankings %>%
  group_by(year) %>%
  summarize(total.pts=sum(points))
View(best.year)

YearPlot<-best.year %>%
  ggplot(aes(x=year, y=total.pts))+
  geom_point(size=2)
YearPlot  
#But this doesn't necessarily tell me which year has the most #1 votes. 

rank.years<-polls %>%
  group_by(year, rank, .drop=FALSE) %>%
  tally(name="count")
View(rank.years)


rank.plot<-rank.years %>%
  ggplot(aes(x=year, y=rank, size=count))+
  geom_point(alpha=0.3, color="#009999")+
  scale_size(range = c(1,14), name="Count")+
  theme_classic()+
  labs(x="Year", y="Rank", title="'90 Rap is Top Voted")+
  theme(plot.title = element_text(size=16), axis.text.x=element_text(color="black", size=12), axis.text.y=element_text(size=12), axis.title.y = element_text(color="black", size=14))
rank.plot+ggsave("RapPlot.pdf", width=10, height=6.19, dpi=300, unit="in") 

ggsave()

ggplot(polls, aes(x=year, y=rank) ) +
  geom_point()

ggplot(rankings, aes(x=year, y=points))+
  geom_point()

ggplot(polls, aes(x=year, y=rank) ) +
  geom_bin2d(bins = 10) +
  scale_fill_continuous(type = "viridis") +
  theme_bw()

artists.ranks<-polls %>%
  group_by(year, rank, artist) %>%
  tally(name="count")
View(artists.ranks)

artist.rank.plot<-artists.ranks %>%
  ggplot(aes(x=year, y=rank, size=count))+
  geom_point(alpha=0.3)+
  scale_size(range = c(0,14), name="Count")+
  theme_bw()
artist.rank.plot  

