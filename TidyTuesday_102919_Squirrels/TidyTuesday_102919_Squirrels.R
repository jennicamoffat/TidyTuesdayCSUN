#Tidy Tuesday 10/29/2019
#Squirrels!
#Created by Jennica Moffat

library(tidyverse)
library(wesanderson)
library(grid)
library(png)
library(grid)
library(ggimage)

#Clear environment
rm(list=ls())
#load data
mydata <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-29/nyc_squirrels.csv")

#Doesn't want to subset by two criteria for characters. so I'm resulting to this...
mydata2 <- subset(mydata, age == "Adult")
mydata3<-subset(mydata, age == "Juvenile")
mydata4 <- rbind(mydata2, mydata3)

#Group data by age class
agedata <- mydata4 %>% group_by(age) %>%
  summarize(running=sum(running, na.rm=T), chasing=sum(chasing, na.rm=T), climbing=sum(climbing, na.rm=T), eating=sum(eating, na.rm=T), foraging=sum(foraging, na.rm=T))
agedata

agedata.long<-gather(data=agedata, key='behavior', value='count', running, chasing, climbing, eating, foraging)

#Gonna make a percent stacked barplot

SquirrelPlot<-ggplot(agedata.long, aes(x=age, y=count, fill=factor(behavior), group=factor(behavior)))+  #basic plot
  geom_bar(stat="identity", position="fill", size=0.6) + 
  theme_classic()+ 
  theme(plot.title = element_text(face = "bold", size=16), axis.text.x=element_text(color="black", size=13), axis.text.y=element_text(color="black", size=12), axis.title.x = element_text(color="black", size=14), axis.title.y = element_text(color="black", size=16),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  scale_y_continuous(expand=c(0,0))+
  labs(x="Age Class", y="Behavior Proportions" , fill="Behaviors")+ #labels the x and y axes
  scale_fill_manual(values = wes_palette("Moonrise3", n = 5))+
  ggtitle("Adult vs Juvenile Squirrel Behavior in Central Park")
SquirrelPlot

#Adding adult squirrel image
img <- readPNG("adultsquirrel.png")
g <- rasterGrob(img, interpolate=TRUE)

SquirrelPlot2 <- SquirrelPlot + annotation_custom(g, xmin=-1.5, xmax=Inf, ymin=0, ymax=0.3)
SquirrelPlot2

#Adding juvenile squirrel
img <- readPNG("juvisquirrel.png")
g <- rasterGrob(img, interpolate=TRUE)

SquirrelPlot3 <- SquirrelPlot2 + annotation_custom(g, xmin=2, xmax=2.8, ymin=0, ymax=0.25)
SquirrelPlot3 + ggsave("SquirrelPlot.pdf", width=10, height=6.19, dpi=300, unit="in")
