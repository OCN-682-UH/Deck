### At home lecture week 7 - working with google maps

##Created by: Annie Deck

##Created on 2024-10-14

############################################

##load libraries 
library(ggmap)
library(tidyverse)
library(here)
library(ggspatial)

## read in data
ChemData <- read_csv(here("Week_07", "Data", "chemicaldata_maunalua.csv"))
glimpse(ChemData)


##get base maps from ggmap
Oahu <- get_map("Oahu")
ggmap(Oahu)

##make place you are interested in the center of your map
WP <- data.frame(lon = -157.7621, lat= 21.27427)

##get base layer
Map1 <- get_map(WP)

##plot
ggmap(Map1)

##zoom in on a location (zoom range is from 3 to 20)
Map1<- get_map(WP, zoom=17)
ggmap(Map1)

##change map type (couple different maptype options you can explore)
Map1<- get_map(WP, zoom=17, maptype= "satellite")
ggmap(Map1)

?get_map

##layering salinity data
ggmap(Map1) +
  geom_point(data= ChemData,
             aes(x= Long, y= Lat, color=Salinity),
             size=4) +
  scale_color_viridis_c() +
  annotation_scale(bar_cols= c("black", "white"),
                   location= "bl") + ## location is bottom left
  annotation_north_arrow(location="tl") + ## can specify between grid north and true north
  coord_sf(crs =4326) ## very important for using scale bar. Tells R what coordinate system this is (it is a map). 4326 is the coordinate reference system most GPS systems are in (WGS84)
