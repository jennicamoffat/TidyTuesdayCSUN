#Tidy Tuesday 7/21/2020
#Australian Animals
#Created by Jennica Moffat

library(tidyverse)
library(treemap)
library(PNWColors)
library(png)
library(grid)
library(ggimage)


#Clear environment
rm(list=ls())
# Get the Data
animal_outcomes <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-21/animal_outcomes.csv')
animal_complaints <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-21/animal_complaints.csv')

View(animal_outcomes)
View(animal_complaints)

animal_complaints$`Animal Type`<-as.factor(animal_complaints$`Animal Type`)
View(summary(animal_complaints$`Complaint Type`))
animal_complaints$Suburb<-as.factor(animal_complaints$Suburb)
View(summary(animal_complaints$`Animal Type`))

animal_outcomes$animal_type<-as.factor(animal_outcomes$animal_type)
summary(animal_outcomes$animal_type)
animal_outcomes$outcome<-as.factor(animal_outcomes$outcome)
summary(animal_outcomes$outcome)

#Right now each region is it's own column, but I want them to be in rows with counts in a column
#pivot data longer by region
outcomes.long<-gather(data=animal_outcomes, key='region', value='count', ACT, NSW, NT, QLD, SA, TAS, VIC, WA)
View(outcomes.long)

#summarize data to count across years
outcomes.data<-outcomes.long%>%
  group_by(animal_type, outcome, region)%>%
  summarize(total=sum(count))
View(outcomes.data)
outcomes.data$region<-as.factor(outcomes.data$region)

treemap(outcomes.data, #Your data frame object
        index=c("animal_type","outcome","region"),  #A list of your categorical variables
        vSize = "total",  #This is your quantitative variable
        type="index", #Type sets the organization and color scheme of your treemap
        palette = "Reds",  #Select your color palette from the RColorBrewer presets or make your own.
        title="Animal Complaint Outcomes", #Customize your title
        fontsize.title = 14 #Change the font size of the title
)

pal=pnw_palette("Shuksan2",8)

plot <- treemap(outcomes.data, #Your data frame object
        index=c("animal_type","outcome"),  #A list of your categorical variables
        vSize = "total",  #This is your quantitative variable
        vColor= "outcome", #This is a categorical variable
        type="categorical", #Type sets the organization and color scheme of your treemap
        palette = pal,  #Select your color palette from the RColorBrewer presets or make your own.
        title="Animal Complaint Outcomes", #Customize your title
        fontsize.title = 15, #Change the font size of the title
        title.legend="Outcome",
        position.legend="right", 
        fontsize.labels	= c(20, 12),
        overlap.labels = 0.5,
        align.labels=list(
          c("center", "center"), 
          c("center", "right")
        ))

plot+ggsave("AnimalComplaints.png", width=10, height=5)

