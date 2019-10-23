#Tidy Tuesday 10/22/2019
#Horror Movies
#Created by Jennica Moffat

library(tidyverse)
library(hrbrthemes)
library(fmsb) #spider plot
library(png) #to add an image
library(magick)
library(grid)



#Clear the environment
rm(list=ls())

#Load the data
horror_movies <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-22/horror_movies.csv")
View(horror_movies)
#Remove NA's for rating
#Also need to remove NA's for the FLCass flask that spilled
mydata <- subset(horror_movies, !is.na(review_rating))
View(mydata)

#Going to make a spider plot with category release country and value average rating
#First going to try to make one with all countries. I imagine it will be a shitshow. 

#New data frame
mydata2<-mydata %>%
  group_by(release_country) %>%
  summarize(AvgRating=mean(review_rating, na.rm=TRUE))
View(mydata2)

#Pivoting data using tidyr's pivot_wider fxn (long to wide data)
plotdata<-pivot_wider(mydata2, id_cols = NULL, names_from = release_country,
                      names_prefix = "", names_repair = "check_unique",
                      values_from = AvgRating, values_fill = NULL, values_fn = NULL)
View(plotdata)

# To use the fmsb package, I have to add 2 lines to the dataframe: the max and min of each topic to show on the plot!
data <- rbind(rep(10,71) , rep(0,71) , plotdata)
View(data)
# Check your data, it has to look like this!
# The default radar chart 
radarchart(data)
#Cool it worked. Definitely need to pick less countries though. 



#Randomly subsetting data
RandomData<-sample_n(mydata2, 10)
View(RandomData)
#Pivoting data using tidyr's pivot_wider fxn (long to wide data)
plotdata<-pivot_wider(RandomData, id_cols = NULL, names_from = release_country,
                      names_prefix = "", names_repair = "check_unique",
                      values_from = AvgRating, values_fill = NULL, values_fn = NULL)
View(plotdata)

# To use the fmsb package, I have to add 2 lines to the dataframe: the max and min of each topic to show on the plot!
data <- rbind(rep(10,10) , rep(0,10) , plotdata)
View(data)
# The default radar chart 
radarchart(data)



#Subsetting data by top and bottom 6 countries and combining the two dataframes
Highest<-mydata2 %>% top_n(6, AvgRating)
Lowest<-mydata2 %>% top_n(-6, AvgRating)
mydata3 <- rbind(Highest, Lowest)
View(mydata3)
#Pivoting data using tidyr's pivot_wider fxn (long to wide data)
plotdata<-pivot_wider(mydata3, id_cols = NULL, names_from = release_country,
                      names_prefix = "", names_repair = "check_unique",
                      values_from = AvgRating, values_fill = NULL, values_fn = NULL)
View(plotdata)

# To use the fmsb package, I have to add 2 lines to the dataframe: the max and min of each topic to show on the plot!
data <- rbind(rep(10,12) , rep(0,12) , plotdata)
View(data)
# The default radar chart 
radarchart(data)
#Basic plot done. Now let's get fancy. 


# Custom the radarChart !
spiderchart<-radarchart( data  , axistype=1 , 
            
            #custom polygon
            pcol=rgb(0.1, 0.1, 0 ,0.9) , pfcol=rgb(0.9, 0.4, 0.1 ,0.7), caxislabels=seq(0,10,2.5), plwd=3 , 
            
            #custom the grid
            cglcol="black", cglty=2, axislabcol="grey", cglwd=0.8,
            
            #custom labels
            vlcex=1 
)


#Adding an image to the center of the web

spider<-image_read("https://www.pinclipart.com/picdir/big/34-347558_spider-clipart-black-and-white-arachnophobia-overcoming-spider.png")

image_composite(spiderchart, spider)
print(spider)

image_write(spider, path="spider.png", format="png")
image_info(spider)
spider<-image_scale(spider, "50")

fig<-image_graph(width=400, height=400, res=96)

radarchart( data  , axistype=1 , 
            
            #custom polygon
            pcol=rgb(0.1, 0.1, 0 ,0.9) , pfcol=rgb(0.9, 0.4, 0.1 ,0.7), caxislabels=seq(0,10,2.5), plwd=3 , 
            
            #custom the grid
            cglcol="black", cglty=2, axislabcol="grey", cglwd=0.8,
            
            #custom labels
            vlcex=1 
) 
dev.off()

out<- image_composite(fig, spider, offset="+185+160")
out

ggsave(filename = 'Spiderplotchart.png',plot = out)
