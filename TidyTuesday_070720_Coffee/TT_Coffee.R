#Tidy Tuesday 7/7/2020
#Coffee
#Created by Jennica Moffat

library(tidyverse)
library(ggridges)
library(PNWColors)
library(png)
library(grid)
library(ggimage)

#Clear environment
rm(list=ls())
# Get the Data
coffee_ratings <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-07/coffee_ratings.csv')

View(coffee_ratings)

coffee_ratings$species<-as.factor(coffee_ratings$species)
nlevels(coffee_ratings$species)
summary(coffee_ratings$species)
#Waaaaaaaay more Arabica
#1311 Arabica, 28 Robusta

#Scatter of total and cupper points
ggplot(coffee_ratings, aes(x=total_cup_points, y=cupper_points)) + 
  geom_point()

#PCA
coffee.pca <- prcomp(coffee_ratings[,21:30])
summary(coffee.pca)
library(ggfortify)
pca.plot <- autoplot(coffee.pca, data = coffee_ratings, colour = 'species')
pca.plot

mean(coffee_ratings$total_cup_points)

#Remove the one with a score of 0 for everything, I'm guessing that was a mistake.
coffee.data<-coffee_ratings%>%
  filter(total_cup_points>1)

#Ridgeplot
ggplot(coffee.data, aes(x = total_cup_points, y = species, fill = species)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")

#Boxplot
ggplot(coffee.data, aes(x=species, y=total_cup_points))+  #basic plot
  theme_bw()+
  geom_boxplot()+
  labs(x="Species", y="Total Cup Points")

#More complicated ridgeplot
#I need to tidy my data quite a bit. 
coffee.data2 = subset(coffee.data, select = c(aroma, flavor, aftertaste, acidity, body, balance, uniformity, clean_cup, sweetness, cupper_points))
View(coffee.data2)
#Rotate data long
coffee.long<-gather(data=coffee.data2, key='criteria', value='grade', aroma, flavor, aftertaste, acidity, body, balance, uniformity, clean_cup, sweetness, cupper_points)
View(coffee.long)

#Plot
#Palatte
pal=pnw_palette("Mushroom",10, type = "continuous")

plot<-ggplot(coffee.long, aes(x = grade, y = criteria, fill = criteria)) +
  geom_density_ridges(rel_min_height=0.0001) +
  theme_ridges() + 
  theme(legend.position = "none")+
  scale_fill_manual(values=pal)+
  labs(x="", y="")+
  ggtitle("Distribution of Coffee Ratings")+
  theme(plot.title = element_text(size=25, hjust=0.5, face="bold"), axis.text.x=element_text(size=14), axis.text.y=element_text(size=14))+
  scale_y_discrete(labels=c("Acidity", "Aftertaste", "Aroma", "Balance", "Body", "Clean Cup", "Cupper Points", "Flavor", "Sweetness", "Uniformity"))
plot

#Adding coffee image
img <- readPNG("TidyTuesday_070720_Coffee/coffee.png")
g <- rasterGrob(img, interpolate=TRUE)

coffee.plot <- plot + annotation_custom(g, xmin=-0.4, xmax=3, ymin=1, ymax=5)
coffee.plot
