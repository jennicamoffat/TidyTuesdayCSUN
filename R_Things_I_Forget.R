#Common things that I forget

#Filtering data
Data2<-Data%>%
  filter(Column=="criteria")%>%
  droplevels()

#Tells you how many levels, or unique categories, are in that column. Must be a factor. 
nlevels(data$column)

#Tells you the count of each level of that column
summary(data$column)

#Removing/keeping specific columns
#Keeps columns specified
coffee.data2 = subset(coffee.data, select = c(aroma, flavor, aftertaste, acidity, body, balance, uniformity, clean_cup, sweetness, cupper_points))
#Removes columns specified
df = subset(mydata, select = -c(x,z) )

#Rotate data long
coffee.long<-gather(data=coffee.data2, key='criteria', value='grade', aroma, flavor, aftertaste, acidity, body, balance, uniformity, clean_cup, sweetness, cupper_points)

#Saving plot as png file
plot+ggsave("Folder/Name.png", width=10, height=5)

#Gather data long
mydata2<-gather(data=mydata, key='Name of new column', value='value', column1, column2, etc.)

#Ordering x-axis within ggplot
data %>%
  mutate(country = fct_reorder(country, rounded_avg, .fun='sum')) %>%
  ggplot(aes(x=country, y=rounded_avg, fill=type))
#order things manually in dataframe
energy_avg2<-energy_avg%>%
  mutate(type=fct_relevel(type, "Conventional thermal", "Geothermal", "Hydro", "Nuclear", "Solar", "Wind", "Other"))
#More ways to reorder things: https://www.r-graph-gallery.com/267-reorder-a-variable-in-ggplot2.html