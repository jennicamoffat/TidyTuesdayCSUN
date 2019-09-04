#TidyTuesday 9/3/2019

library('tidyverse')
library(hrbrthemes)
#Clear the environment
rm(list=ls())

cpu <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/cpu.csv")
gpu <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/gpu.csv")
ram <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/ram.csv")

View(cpu)
View(gpu)
View(ram)

#Merge cpu and gpu
df<-merge(x=cpu,y=gpu, by="date_of_introduction")
View(df)
#Merge new df with ram so all df's are merged
alldata<-merge(x=df, y=ram, by="date_of_introduction")
View(alldata)

#Make basic scatterplot
ggplot(alldata, aes(x=date_of_introduction, y=capacity_bits))+
  geom_point()
#Not interesting but at least I remember how to make a plot. 


#basic scatterplot of CPU tansistor count, color coded by designer
ggplot(cpu, aes(x=date_of_introduction, y=transistor_count, color=designer, na.rm=TRUE)) + 
  geom_point(size=2) +
  theme_ipsum()+
  scale_y_log10()+
  labs(x="Date of Introduction", y="Log Transistor Count", fill="Designer")+
  ggsave(filename = "tidytuesday_090319/090319Plot.png")


#Renaming columns so they match then re-merging from beginning
#get column names
colnames(gpu)
names(gpu)[names(gpu) == "designer_s"] <-"designer"
View(gpu) #changed designer_s to designer so it matches the cpu dataset
#Merge datasets again
df<-merge(x=cpu,y=gpu, by="date_of_introduction")
View(df)
#Merge new df with ram so all df's are merged
alldata<-merge(x=df, y=ram, by="date_of_introduction")
View(alldata)
#Now labeled as designer.x and designer.y. 

tally <- cpu %>% 
  group_by(designer) %>% 
  tally()
print.data.frame(tally)

