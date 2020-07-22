#Tidy Tuesday 7/21/2020
#Australian Animals
#Created by Jennica Moffat

library(tidyverse)
library(treemap)
library(PNWColors)

#Clear environment
rm(list=ls())
# Get the Data
animal_outcomes <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-21/animal_outcomes.csv')
animal_complaints <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-21/animal_complaints.csv')

View(animal_outcomes)
View(animal_complaints)

#Exploring data
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

#Basic tree map
treemap(outcomes.data, #Your data frame object
        index=c("animal_type","outcome","region"),  #A list of your categorical variables
        vSize = "total",  #This is your quantitative variable
        type="index", #Type sets the organization and color scheme of your treemap
        palette = "Reds",  #Select your color palette from the RColorBrewer presets or make your own.
        title="Animal Complaint Outcomes", #Customize your title
        fontsize.title = 14 #Change the font size of the title
)

#Set palette
pal=pnw_palette("Shuksan2",8)

#Removed region because it was too much for this plot
plot <- treemap(outcomes.data, #Your data frame object
        index=c("animal_type","outcome"),  #A list of your categorical variables
        vSize = "total",  #This is your quantitative variable
        vColor= "outcome", #This is a categorical variable
        type="categorical", #Type sets the organization and color scheme of your treemap
        palette = pal,  #Select your color palette from the RColorBrewer presets or make your own.
        title="Animal Complaint Outcomes", #Customize your title
        fontsize.title = 15, #Change the font size of the title
        title.legend="Outcome", #Titles plot
        position.legend="right", #Position the legend
        fontsize.labels	= c(20, 12), #Change the font size of each level
        overlap.labels = 0.5, #Labels will not show up if they overlap more than 50%
        align.labels=list(
          c("center", "center"), 
          c("right", "bottom") #Align the labels. Main subject in center, subsubject is bottom right
        ))


