#Tidy Tuesday 8/4/2020
#European energy production
#Created by Jennica Moffat

library(tidyverse)
library(PNWColors)
library(gganimate)

#Clear environment
rm(list=ls())
#load data
energy_types <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-04/energy_types.csv')

View(energy_types)
#Removing level 2 so I don't double count hydro power
energy<-energy_types%>%
  filter(level=="Level 1")

#Renaming Year columns in a very ugly way because they are numbers
names(energy)[5] <- "y2016"
names(energy)[6] <- "y2017"
names(energy)[7] <- "y2018"

#Average production for each country/energy type across years
energy_avg<-energy%>%
  mutate(Avg=rowMeans(cbind(y2016, y2017, y2018)))
#Rounding to nearest whole number
energy_avg$rounded_avg <- round(energy_avg$Avg)
#Reordering fill factor so that "other" comes last
energy_avg2<-energy_avg%>%
  mutate(type=fct_relevel(type, "Conventional thermal", "Geothermal", "Hydro", "Nuclear", "Solar", "Wind", "Other"))
#Removing NA country
energy_avg3<-energy_avg2%>%
  filter(country_name != "NA")

#Final stacked barplot
#palette
pal=pnw_palette("Cascades", 7, type = "continuous")

AvgPlot<-energy_avg3 %>%
  mutate(country_name = fct_reorder(country_name, desc(rounded_avg), .fun='sum')) %>% #Orders countries by total energy productions across types
  ggplot(aes(x=country_name, y=rounded_avg, fill=type)) + 
  geom_bar(position="stack", stat="identity")+
  scale_fill_manual(values=pal)+
  coord_flip()+ #flips so it is horizontal
  theme_bw()+
  labs(title="Energy Production by Country", subtitle="Averaged from 2016-2018", x="Country", y="Average Production (GWh)" , fill="Energy Type")+ 
  theme(plot.title = element_text(size=20, face="bold"),
    plot.subtitle = element_text(size=14))+
  scale_y_continuous(expand=c(0,0), limits=c(0,630000), labels=function(rounded_avg) format(rounded_avg, scientific = FALSE)) #Make production not sci notation
AvgPlot+ggsave("TidyTuesday_080420_EuropeEnergy/EuropeEnergy.png", width=8, height=5)

#If I want to animate it between years, I need to make year a column 
long_data<-gather(data=energy, key='Year', value='EnergyProd', "2016", "2017", "2018")

long_data$Year<-as.integer(long_data$Year)
long_data_ordered<-long_data%>%
  mutate(type=fct_relevel(type, "Conventional thermal", "Geothermal", "Hydro", "Nuclear", "Solar", "Wind", "Other"))
#Removing NA country
long_data_ordered2<-long_data_ordered%>%
  filter(country_name != "NA")

#palette
pal=pnw_palette("Cascades",7, type = "continuous")

graph.combined<-long_data_ordered2 %>%
  mutate(country_name = fct_reorder(country_name, desc(EnergyProd), .fun='sum')) %>%
  ggplot(aes(x=country_name, y=EnergyProd, fill=type)) + 
  geom_bar(position="stack", stat="identity")+
  scale_fill_manual(values=pal)+
  coord_flip()+
  theme_bw()+
  labs(title="Energy Production by Country", subtitle="Year: {frame_time}", x="Country", y="Average Production (GWh)" , fill="Energy Type")+ 
  theme(plot.title = element_text(size=18),
        plot.subtitle = element_text(size=15, face="bold"))+
  scale_y_continuous(expand=c(0,0), limits=c(0,650000), labels=function(EnergyProd) format(EnergyProd, scientific = FALSE))+
  transition_time(Year)
graph.combined
anim_save("TT_EuropeEnergyPlot", animation=last_animation())
#Okay, I can't get this to look smooth, but it works. 


