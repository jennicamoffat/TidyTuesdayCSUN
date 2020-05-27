#Tidy Tuesday 5/5/2020
#Animal crossing
#Created by Jennica Moffat

library(tidyverse)
library(PNWColors)

#Clear environment
rm(list=ls())
#load data
mydata <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-19/vb_matches.csv', guess_max = 76000)
View(mydata)
#Removing NA's
mydata2<-subset(mydata, w_p2_tot_errors != "NA")
#Doesn't remove all of them, but makes data a little more manageable
View(mydata2)

action.data <- select(mydata, w_p1_tot_digs, w_p2_tot_digs, l_p1_tot_digs, l_p2_tot_digs, 
                      w_p1_tot_aces, w_p2_tot_aces, l_p1_tot_aces, l_p2_tot_aces, 
                      w_p1_tot_blocks, w_p2_tot_blocks, l_p1_tot_blocks, l_p2_tot_blocks, 
                      w_p1_tot_attacks, w_p2_tot_attacks, l_p1_tot_attacks, l_p2_tot_attacks,
                      w_p1_tot_kills, w_p2_tot_kills, l_p1_tot_kills, l_p2_tot_kills, 
                      w_p1_tot_errors, w_p2_tot_errors, l_p1_tot_errors, l_p2_tot_errors, 
                      w_p1_tot_serve_errors, w_p2_tot_serve_errors, l_p1_tot_serve_errors, l_p2_tot_serve_errors)
View(action.data)


#convert to long format
data_long <- gather(action.data, action, count, w_p1_tot_digs, w_p2_tot_digs, l_p1_tot_digs, l_p2_tot_digs, 
                    w_p1_tot_aces, w_p2_tot_aces, l_p1_tot_aces, l_p2_tot_aces, 
                    w_p1_tot_blocks, w_p2_tot_blocks, l_p1_tot_blocks, l_p2_tot_blocks, 
                    w_p1_tot_attacks, w_p2_tot_attacks, l_p1_tot_attacks, l_p2_tot_attacks,
                    w_p1_tot_kills, w_p2_tot_kills, l_p1_tot_kills, l_p2_tot_kills, 
                    w_p1_tot_errors, w_p2_tot_errors, l_p1_tot_errors, l_p2_tot_errors, 
                    w_p1_tot_serve_errors, w_p2_tot_serve_errors, l_p1_tot_serve_errors, l_p2_tot_serve_errors, factor_key=TRUE)
data_long2<-data_long %>% drop_na()
View(data_long2)

#split to have column with w and l
winlosedata <- data_long2 %>%
  separate(action, into = c("outcome", "player", "total", "move"), sep = "_") %>%
  na.omit()
View(winlosedata)

summary <- winlosedata %>% 
  group_by(outcome, move) %>% 
  summarize(Avg = mean(count, na.rm = TRUE))
View(summary)

VBPlot<-ggplot(summary, aes(x=outcome, y=Avg, fill=factor(move), group=factor(move)))+  #basic plot
  geom_bar(stat="identity", size=0.6) + 
  theme_classic()+ 
  theme(plot.title = element_text(face = "bold", size=16), axis.text.x=element_text(color="black", size=13), axis.text.y=element_text(color="black", size=12), axis.title.x = element_text(color="black", size=14), axis.title.y = element_text(color="black", size=16),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  scale_y_continuous(expand=c(0,0))+
  labs(x="", y="Average of each move" , fill="Moves")+ #labels the x and y axes
  scale_fill_manual(values=c("aces"="blue4", "attacks"="cornflowerblue", "blocks"="cyan4", "digs"="cyan3", "kills"="cadetblue1", "errors"="coral1", "serve"="orangered4"), name="Move",labels=c("Aces", "Attacks", "Blocks", "Digs", "Errors", "Kills", "Serve Errors" ))+
  ggtitle("Volleyball losers only make slightly greater error than winners")
VBPlot


