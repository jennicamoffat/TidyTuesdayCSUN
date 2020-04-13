#Tidy Tuesday 11/19/2019
#NZ Birds
#Created by Jennica Moffat

library(tidyverse)
library(wesanderson)
library(ggpubr)
library(png)
library(ggimage)


#Clear environment
rm(list=ls())
#load data
nz_bird <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-11-19/nz_bird.csv")

View(nz_bird)
nz_bird<-na.omit(nz_bird)

nz_bird$bird_breed<-as.factor(nz_bird$bird_breed)
nlevels(nz_bird$bird_breed) #85 bird breeds are in this dataset

#Separating vote_rank column
nz_bird <- nz_bird %>% separate(vote_rank, c("Vote", "Rank"))
nz_bird$bird_breed<-as.factor(nz_bird$bird_breed)

#Summing #1 votes by bird species to see the top ranked birds
topbirds <- nz_bird %>% filter(Rank == "1") %>%
  group_by(bird_breed) %>%
  summarise(total = n())
topbirds <- arrange(topbirds, desc(total))
head(topbirds)

TopSpecies<-subset(nz_bird,bird_breed == "Yellow-eyed penguin" | bird_breed == "Kākāpō"| bird_breed == "Banded Dotterel"| bird_breed == "Fantail"| bird_breed == "Black Robin"| bird_breed == "Antipodean Albatross")
TopSpecies$bird_breed<-as.factor(TopSpecies$bird_breed)
TopSpecies$Rank<-as.numeric(TopSpecies$Rank)
TopSpecies$bird_breed <- factor(TopSpecies$bird_breed,levels = c("Yellow-eyed penguin", "Banded Dotterel", "Fantail", "Black Robin", "Antipodean Albatross"))

Top <- ggplot(TopSpecies, aes(x=bird_breed, y=Rank, fill=bird_breed)) + 
  geom_violin()+
  theme_classic()+
  scale_fill_manual(values = wes_palette("Royal2"))+
  theme(plot.title = element_text(size=14), axis.text.x=element_text(color="black", size=11), axis.text.y=element_text(size=12), axis.title.y = element_text(color="black", size=14), 
        panel.grid.major=element_blank(), panel.grid.minor=element_blank(), legend.position = "none") +
  ggtitle("Most Favored Birds")+
  labs(x=" ", y="Rank")
Top

#Adding Yellow-eyed penguin
img <- readPNG("YellowEyedPenguin.png")
g <- rasterGrob(img, interpolate=TRUE)

TopPeng <- Top + annotation_custom(g, xmin=0.6, xmax=2, ymin=1, ymax=3)
TopPeng

#Adding Black Robin
img1 <- readPNG("blackrobin.png")
g1 <- rasterGrob(img1, interpolate=TRUE)

TopPengRobin <- TopPeng + annotation_custom(g1, xmin=3.8, xmax=4.5, ymin=3, ymax=4)
TopPengRobin



#Birds with the least #1 ranks
topbirds <- arrange(topbirds, total)
head(topbirds)
#Little shag, Light-mantled Sooty Albatross, Westland Pentrel, Pied Shag, Salvin's Mollymawk

BottomBestSpecies<-subset(nz_bird, bird_breed == "Little shag" | bird_breed == "Light-mantled Sooty Albatross"| bird_breed == "Westland Petrel"| bird_breed == "Pied Shag"| bird_breed == "Salvin's Mollymawk")

BottomBestSpecies$bird_breed<-as.factor(BottomBestSpecies$bird_breed)
BottomBestSpecies$Rank<-as.numeric(BottomBestSpecies$Rank)
nlevels(BottomBestSpecies$bird_breed)

#Order breeds by ascending ranked order
BottomBestSpecies$bird_breed <- factor(BottomBestSpecies$bird_breed,levels = c("Little shag", "Light-mantled Sooty Albatross", "Westland Petrel", "Pied Shag", "Salvin's Mollymawk"))

Bottom <- ggplot(BottomBestSpecies, aes(x=bird_breed, y=Rank, fill=bird_breed)) + # fill=name allow to automatically dedicate a color for each group
  geom_violin()+
  theme_classic()+
  scale_fill_manual(values = wes_palette("Royal2"))+
  theme(plot.title = element_text(size=14), axis.text.x=element_text(color="black", size=11), axis.text.y=element_text(size=12), axis.title.y = element_text(color="black", size=14), 
        panel.grid.major=element_blank(), panel.grid.minor=element_blank(), legend.position = "none") +
  ggtitle("Least Favored Birds")+
  labs(x=" ", y="Rank")
Bottom

#Adding Little Shag
img2 <- readPNG("LittleShag.png")
g2 <- rasterGrob(img2, interpolate=TRUE)

BottomShag <- Bottom + annotation_custom(g2, xmin=0.1, xmax=1.3, ymin=0, ymax=4)
BottomShag

#Adding Salvin's Mollymawk
img3 <- readPNG("SalvinsMollymawk.png")
g3 <- rasterGrob(img3, interpolate=TRUE)

BottomShagSalvin <- BottomShag + annotation_custom(g3, xmin=4.5, xmax=5.5, ymin=3.6, ymax=5)
BottomShagSalvin

combined<- ggarrange(TopPengRobin,BottomShagSalvin, nrow=2, ncol=1)
combined

combined + ggsave("PutABirdOnIt.pdf", width=10, height=6.19, dpi=300, unit="in")
