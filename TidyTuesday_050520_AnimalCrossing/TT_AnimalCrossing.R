#Tidy Tuesday 5/5/2020
#Animal crossing
#Created by Jennica Moffat

library(tidyverse)
library(networkD3)
library(viridis)
library(patchwork)
library(hrbrthemes)
library(circlize)
library(PNWColors)

#Clear environment
rm(list=ls())
#load data
villagers <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-05/villagers.csv')

View(villagers)

villagers$species<-as.factor(villagers$species)
villagers$personality<-as.factor(villagers$personality)

nlevels(villagers$species)
#35 species
nlevels(villagers$personality)
#8 personality

#I want to make a flow diagram to see if some animals are more likely to have certain personalities
#I need a dataframe that has Species|Personality|Count
mydata<- villagers %>%
  group_by(species, personality) %>%
  summarise(total = n())
View(mydata)
#I think that's what I need. But it might be a very huge graph by the looks of it. 

nodes <- data.frame(
  name=c(as.character(mydata$personality), 
         as.character(mydata$species)) %>% unique()
)
View(nodes)

mydata$IDsource <- match(mydata$personality, nodes$name)-1
mydata$IDtarget <- match(mydata$species, nodes$name)-1


p <- sankeyNetwork(Links = mydata, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "total", NodeID = "name", 
                   sinksRight=FALSE)
p
#It worked!! But you can't tell what's going on because there are 35 species. 
#Maybe let's pick the top 8 to match with 8 personality types

species<-villagers %>%
  group_by(species)%>%
  summarize(total=n())
arrange(species, desc(total))
#Top eight species: cat, rabbit, frog, squirrel, duck, cub, dog, bear
topspp<-subset(villagers, species=="cat" | species=="rabbit" | species=="frog" | species=="squirrel" | species=="duck" | species=="cub" | species=="dog" | species=="bear")
View(topspp)

#making dataframe for sankeyNetwork
mydata<- topspp %>%
  group_by(species, personality) %>%
  summarise(total = n())
View(mydata)


nodes <- data.frame(
  name=c(as.character(mydata$personality), 
         as.character(mydata$species)) %>% unique()
)

mydata$IDsource <- match(mydata$personality, nodes$name)-1
mydata$IDtarget <- match(mydata$species, nodes$name)-1


p <- sankeyNetwork(Links = mydata, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "total", NodeID = "name")
#okay, that looks better! Still a bit much. But let's make it pretty. 

#This would let me get html color codes for viridis
cols<-viridis_pal(alpha = 1, begin = 0, end = 1, direction = 1,option = "C")
pal<-cols(8)
pal

#But I wanted to use PNW pallete, and luckily they have the codes on their github, so I used those. 
##https://github.com/jakelawlor/PNWColors
ColourScal ='d3.scaleOrdinal().range(["#24492e", "#015b58", "#2c6184", "#59629b", "#89689d", "#ba7999",
"#e69b99", "#fefbe9"])'

ACgraph <- sankeyNetwork(Links = mydata, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "total", NodeID = "name", 
                   sinksRight=FALSE, nodeWidth=40, fontSize=18, nodePadding=20, 
                   fontFamily = "Arial", colourScale=ColourScal, width= 600, height=475)
ACgraph
#Setting the size avoids cutting off the bottom once I add the title

#title
ACgraph.title<- htmlwidgets::prependContent(ACgraph, htmltools::tags$h2("Personalities of the top 8 Animal Crossing species"))
ACgraph.title

# save it
setwd("TidyTuesday_050520_AnimalCrossing/")
saveNetwork(ACgraph.title, file = "animalcrossing.html", selfcontained = TRUE)
