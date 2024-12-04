### In class week 7 - working with maps!

##Created by: Annie Deck

##Created on 2024-10-08

############################################

##load libraries 
library(tidyverse)
library(here)
library(maps)
library(mapdata)
library(mapproj)

##read in data
popdata<- read.csv(here("Week_07", "Data", "CAPopdata.csv"))
stars<- read.csv(here("Week_07", "Data", "stars.csv"))

##practice getting data
world<-map_data("world")
head(world)

usa<-map_data("usa")
head(usa)

states<-map_data("state")
head(states)

county<-map_data("county")
head(county)

##map of the world
##remember color is not to do with data so it goes outside of aes (fill is!)
##guides to get rid of legend
ggplot()+
  geom_polygon(data=world, aes(x=long, y=lat, 
                               group=group,
                               fill=region),
               color="black") +
  guides(fill=FALSE) +
 coord_map(projection = "mercator",
           xlim=c(-180,180))

#map of California
##always need group=group when using polgyon 
head(states)

CA_data<- states %>%
  filter(region== "california") 

ggplot()+
  geom_polygon(data=CA_data, aes(x=long, 
                                 y=lat, 
                                 group=group),
               color="black") +
  coord_map(projection = "mercator") ##default is mercator so technically can leave coord_map blank inside 

##we want to combine these two data sets by county
head(county)
head(popdata)

##we need to make the county column for these two data sets the same to join them
##look up the janitor package is really helpful for cleaning data 
CApop_county <- popdata %>%
  select("subregion"= County, Population) %>%
  inner_join(county) %>%
  filter(region == "california")

head(CApop_county)

CA_data<- states %>%
  filter(region== "california") 

##mapping population by county 
ggplot()+
  geom_polygon(data=CApop_county, aes(x=long, 
                                 y=lat, 
                                 group=group,
                                 fill=Population),
               color="black") +
  coord_map()

##taking the log10 of the population to make the data representation a bit more accurate
ggplot()+
  geom_polygon(data=CApop_county, aes(x=long, 
                                      y=lat, 
                                      group=group,
                                      fill=Population),
               color="black") +
  coord_map()+
  theme_void()+
  scale_fill_gradient(trans= "log10")

##add sea star data layer to our map
head(stars)

##this is a good example of how to simply show the location of your sample sites on a map
ggplot()+
  geom_polygon(data=CApop_county, aes(x=long, 
                                      y=lat, 
                                      group=group,
                                      fill=Population),
               color="black") +
  geom_point(data=stars,
             aes(x=long,
                 y=lat)) +
  coord_map()+
  theme_void()+
  scale_fill_gradient(trans= "log10")

##make size of dots reflect population of sea stars
ggplot()+
  geom_polygon(data=CApop_county, aes(x=long, 
                                      y=lat, 
                                      group=group,
                                      fill=Population),
               color="black") +
  geom_point(data=stars,
             aes(x=long,
                 y=lat,
                 size=star_no)) +
  coord_map()+
  theme_void()+
  scale_fill_gradient(trans= "log10") 

