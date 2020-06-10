#Tidy Tuesday 6/9/2020
#BLM
#Created by Jennica Moffat

library(tidyverse)
library(wordcloud2)
library("ggwordcloud")

#Clear environment
rm(list=ls())
# Get the Data
firsts <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-09/firsts.csv')
science <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-09/science.csv')

View(science)
View(firsts)

#Separate occuptions so each occupation has it's own column
science.occ <- science %>%
  separate(occupation_s, into = c("occ1", "occ2", "occ3", "occ4", "occ5", "occ6"), sep = "; ")
#Make occ 1 lowercase for combining
science.occ$occ1 <- tolower(science.occ$occ1)

#Pivot longer so all occupations are in one column
science.occ2<-science.occ %>%
  pivot_longer(
    cols = starts_with("occ"),
    names_to = "occupation",
    values_to = "occ",
    values_drop_na = TRUE
  )

#Summarize data
occupation<-science.occ2%>%
  group_by(occ)%>%
  tally()
View(occupation)
#removing rows with "citation needed"
occupation2<-occupation[-c(12, 14, 49),]
View(occupation2)

plot<-ggplot(occupation2, aes(label = occ, size = n, color=n)) +
  geom_text_wordcloud() +
  theme_minimal()+
  scale_size_area(max_size = 13)+
  scale_color_gradient(low="goldenrod1", high="red4")
plot

plot+ggsave("AfricanAmFirsts.png", width=10, height=5)
