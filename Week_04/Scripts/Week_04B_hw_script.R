##Homework week 4. Practicing tidyr with Silbiger et al. 2020 data set 
##Created by: Annie Deck
##Created on: 2024-09-24

############################################

##load libraries
library(tidyverse)
library(here)

##load & view data
ChemData <- read_csv(here("Week_04", "data", "chemicaldata_maunalua.csv"))
view(ChemData)

##Writing code
ChemData_filtered <- ChemData %>%
  drop_na() %>% ##remove NAs
  separate(col= Tide_time, ##separating tide and time into 2 columns 
           into= c("Tide", "Time"), 
           sep= "_",
           remove= FALSE) %>%
  pivot_longer(cols = Temp_in:percent_sgd, 
               names_to = "Variables",
               values_to = "Values") %>%
  group_by(Variables, Season, Zone) %>%
  summarise(mean_vals=mean(Values, na.rm=TRUE))%>%
  pivot_wider(names_from= Variables,
              values_from= mean_vals) %>%
  write_csv(here("Week_04", "Output", "ChemData_filtered.csv")) ##put it in my week 4 output folder in a csv format 

##plotting 
ChemData_filtered %>% ##using my newly formatted dataset 
  ggplot(aes(x= Season, y= Salinity)) + ##put season on x axis and salinity values on y
  geom_point() + ##make the geom be point 
  facet_wrap(~Zone) +##facet by zone 
  theme_bw() ##remove grey background

##saving to output folder
ggsave(here("Week_04","Output", "Chem_hw_fig.png"),
       width=7,
       height=5)

