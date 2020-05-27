#Tidy Tuesday 5/26/2020
#Cocktails!
#Created by Jennica Moffat

library(tidyverse)
library(PNWColors)
library(cowplot)
library(ggpubr)

#Clear environment
rm(list=ls())
#load data
cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/cocktails.csv')
boston_cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/boston_cocktails.csv')

boston_cocktails$category<-as.factor(boston_cocktails$category)
boston_cocktails$ingredient<-as.factor(boston_cocktails$ingredient)

#Heatmap of counts of ingredients and drink categories
nlevels(boston_cocktails$ingredient)
#There are 569 ingredients, going to take the top 10

popular.ingredients<-boston_cocktails%>%
  group_by(ingredient)%>%
  tally()%>%
  arrange(desc(n))%>%
  top_n(10)
popular.ingredients
#Top 10 ingredients
#Gin, Fresh lemon juice, Simple Syrup, Vodka, Light Rum, Dry Vermouth, Fresh Lime Juice, 
#Triple Sec, Powdered Sugar, Grenadine

data<-boston_cocktails%>%
  group_by(category, ingredient)%>%
  tally()%>%
  filter(ingredient == "Gin"|ingredient == "Fresh lemon juice"|ingredient == "Simple Syrup"|ingredient == "Vodka"|ingredient == "Light Rum"|ingredient == "Dry Vermouth"|ingredient == "Fresh Lime Juice"|ingredient == "Triple Sec"|ingredient == "Powdered Sugar"|ingredient == "Grenadine")

pal=pnw_palette("Shuksan2",100)
plot<-ggplot(data, aes(category, ingredient, fill= n)) + 
  geom_tile()+
  theme_classic()+
  scale_fill_gradientn(colours = pal) +
  theme(plot.title = element_text(size=16, hjust=0.5, face="bold"), axis.text.x=element_text(angle = 45, hjust = 1, size=14), axis.text.y=element_text(size=14), axis.title.y = element_text(face="bold", size=16), axis.title.x = element_text(face="bold", size=16),
        panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  ggtitle("Raw Counts")+
  labs(x="Drink Category", y="Drink Ingredient", fill="Count")
#I would like to get it scaled by total drinks from categories dataset so it's proportion instead of counts

summary.data<-boston_cocktails%>%
  group_by(category, ingredient)%>%
  tally()
View(summary.data)

summary.categories<-summary.data%>%
  group_by(category)%>%
  summarize(total.drinks=sum(n))
summary.categories

#Combine data
combined.full.data<-full_join(summary.data, summary.categories, by = "category", copy = TRUE)
#Divide count by total drinks for each category to get proportion
combined.full.data$percent<-(combined.full.data$n/combined.full.data$total.drinks)*100
#Now filter to get dataset of just top 10 ingredients
combined.full.data.top.ing<-combined.full.data%>%
  filter(ingredient == "Gin"|ingredient == "Fresh lemon juice"|ingredient == "Simple Syrup"|ingredient == "Vodka"|ingredient == "Light Rum"|ingredient == "Dry Vermouth"|ingredient == "Fresh Lime Juice"|ingredient == "Triple Sec"|ingredient == "Powdered Sugar"|ingredient == "Grenadine")

percent.plot<-ggplot(combined.full.data.top.ing, aes(category, ingredient, fill= percent)) + 
  geom_tile()+
  theme_classic()+
  scale_fill_gradientn(colours = pal) +
  theme(plot.title = element_text(size=16, hjust=0.5, face="bold"), axis.text.x=element_text(angle = 45, hjust = 1, size=14), axis.text.y=element_text(size=14), axis.title.y = element_text(face="bold", size=16), axis.title.x = element_text(face="bold", size=16),
        panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  ggtitle("Proportion")+
  labs(x="Drink Category", y="", fill="Percent")

#Combine two plots into one 
combined.plots<-ggarrange(plot, percent.plot,
          ncol = 2, nrow = 1)
#Add title to combined plot
combined.plots.title<-annotate_figure(combined.plots,
                top = text_grob("Use of top 10 ingredients across drink categories - counts vs proportion", color = "black", face = "bold", size = 20,hjust=0.5))
combined.plots.title+ggsave("TT_cocktails_plot.png",width=10, height=5 )


