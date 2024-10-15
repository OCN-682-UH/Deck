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
