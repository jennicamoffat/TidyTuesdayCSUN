#Tidy Tuesday 2/4/2020
#NFL attendance
#Created by Jennica Moffat

library(tidyverse)

#Clear environment
rm(list=ls())
#load data
attendance <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-02-04/attendance.csv')
standings <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-02-04/standings.csv')
games <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-02-04/games.csv')

View(attendance)
View(standings)
View(games)


#Filter out Superbowl Wins
standings$sb_winner<-as.factor(standings$sb_winner)

SuperbowlWinsbyYear <- standings %>% filter(sb_winner == "Won Superbowl") %>%
  group_by(team_name, year) %>%
  summarise(total = n())
SuperbowlWinsbyYear <- arrange(SuperbowlWinsbyYear, desc(year))
View(SuperbowlWinsbyYear)

SuperbowlWins <- standings %>% filter(sb_winner == "Won Superbowl") %>%
  group_by(team_name) %>%
  summarise(SBwins = n())
SuperbowlWins <- arrange(SuperbowlWins, desc(SBwins))
View(SuperbowlWins)
SuperbowlWins$SBwins<-as.numeric(SuperbowlWins$SBwins)

#Basic plot of NFL wins
NFLPlot<-ggplot(data=SuperbowlWins, aes(x = reorder(team_name, -SBwins), y=SBwins, fill=SBwins))+  #basic plot
  geom_bar(stat="identity", width=0.8) + 
  theme_classic()+ 
  theme(plot.title = element_text(face = "bold", size=16), axis.text.x=element_text(color="black", size=9), axis.text.y=element_text(color="black", size=12), axis.title.x = element_text(color="black", size=14), axis.title.y = element_text(color="black", size=16),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  labs(x="Team Name", y="Number of Superbowl Wins")+ #labels the x and y axes
  scale_y_continuous(expand=c(0,0))+
  ggtitle("Superbowl Wins 2000-2019")+
  guides(fill=FALSE) #remove legend
NFLPlot

#Total wins by team across all years
TotalWins<-standings %>%
  group_by(team_name) %>%
  summarise(TotalWins = sum(wins))
TotalWins

CombinedData<-inner_join(SuperbowlWins, TotalWins, by = c("team_name"))
View(CombinedData)

#Barplot of just total wins
TotalWins<-ggplot(data=CombinedData, aes(x = reorder(team_name, -SBwins), y=TotalWins, fill=TotalWins))+  #basic plot
  geom_bar(stat="identity", width=0.8) + 
  theme_classic()+ 
  theme(plot.title = element_text(face = "bold", size=16), axis.text.x=element_text(color="black", size=9), axis.text.y=element_text(color="black", size=12), axis.title.x = element_text(color="black", size=14), axis.title.y = element_text(color="black", size=16),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  labs(x="Team Name", y="Total Wins")+ #labels the x and y axes
  scale_y_continuous(expand=c(0,0))+
  ggtitle("Total Wins 2000-2019")
TotalWins

#Barplot of total wins and points of superbowl wins
CombinedPlot <- ggplot(data=CombinedData, aes(x = reorder(team_name, -SBwins), y=TotalWins, fill=TotalWins))+  #basic plot
  geom_bar(stat="identity", width=0.8) + 
  geom_point(data=CombinedData, aes(x=team_name, y=SBwins))+
  theme_classic()+
  labs(x="Team Name", y="Total Wins")+
  scale_y_continuous(expand=c(0,0))
CombinedPlot
#ggplot hates having two scales, so I'm trying something else.


CombinedPlot2 <- ggplot(data=CombinedData, aes(x = reorder(team_name, -SBwins), y=TotalWins, fill=TotalWins))+  #basic plot
  geom_bar(stat="identity", width=0.8) + 
  theme_classic()+
  labs(x="Team Name", y="Total Wins", fill="Total Wins")+
  scale_y_continuous(expand=c(0,0), limits = c(0, 260))+
  geom_text(aes(label=SBwins), position=position_dodge(width=0.9), vjust=-0.25, size=7, colour="firebrick4")+
  theme(plot.title = element_text(face = "bold", size=16), axis.text.x=element_text(color="black", size=10), axis.text.y=element_text(color="black", size=12), axis.title.x = element_text(color="black", size=14), axis.title.y = element_text(color="black", size=16),panel.grid.major=element_blank(), panel.grid.minor=element_blank())+
  ggtitle("Total and Superbowl Wins 2000-2019")
CombinedPlot2

CombinedPlot2 + ggsave("NFLplot.pdf", width=10, height=6.19, dpi=300, unit="in")

