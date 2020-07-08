#Common things that I forget


#Tells you how many levels, or unique categories, are in that column. Must be a factor. 
nlevels(data$column)


summary(data$column)
#Tells you the count of each level of that column

#Removing/keeping specific columns
coffee.data2 = subset(coffee.data, select = c(aroma, flavor, aftertaste, acidity, body, balance, uniformity, clean_cup, sweetness, cupper_points))
#Keeps columns specified
df = subset(mydata, select = -c(x,z) )
#Removes columns specified

coffee.long<-gather(data=coffee.data2, key='criteria', value='grade', aroma, flavor, aftertaste, acidity, body, balance, uniformity, clean_cup, sweetness, cupper_points)
#Rotate data long

#Saving plot as png file
plot+ggsave("Folder/Name.png", width=10, height=5)

#Gather data long
mydata2<-gather(data=mydata, key='Name of new column', value='value', column1, column2, etc.)
