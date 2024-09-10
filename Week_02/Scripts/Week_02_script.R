##First script to Fundamentals in R class. Learning how to load libraries and bring in data.
##Created by Annie Deck
##Created on 2024-09-09

###############################

##load libraries 
library(tidyverse)
library(here)

##read in data
weightdata<- read_csv(here("Week_02", "Data","weightdata.csv"))

##looking at the data
head(weightdata)
tail(weightdata)
view(weightdata)