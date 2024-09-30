##In class lecture week 4. Learning to work with dplyr with the penguin data again
##Created by: Annie Deck
##Created on: 2024-09-17

############################################

##load libraries
library(palmerpenguins)
library(tidyverse)
library(here)

##look at data
head(penguins)
view(penguins)

##filter is for ROWS
##filter only the female penguins
##double equal signs means exactly equal to (will leave out males and NAs)
filter(.data= penguins, sex == "female")

## %in% is for when you want to give more than one option (want to keep 2 of the 3 species)

##filter just penguins measured in 2008
penguins_2008<-filter(.data= penguins, year == "2008")

##just penguins with a body mass > 5,000
penguins_mass<-filter(.data= penguins, body_mass_g > 5000)

##just penguins with a body mass greater than or equal 5,000
penguins_mass<-filter(.data= penguins, body_mass_g >= 5000)

##numbers generally do not need to be in quotes

##filtering several things at one time use a comma (but the & symbol will do the same thing)
filter(.data= penguins, sex == "female", body_mass_g > 5000)

##penguins collected in either 2008 or 2009
penguins_2008_or2009<-filter(.data= penguins, year == "2008" | year == "2009")
##you could also do this another way:
penguins_2008_or2009<-filter(.data= penguins, year %in% c("2008", "2009"))

##penguins are not from the island dream 
penguins_not_dream<-filter(.data= penguins, island != "Dream")

##Adelie or Gentoo
adelie_gentoo<- filter(.data= penguins, species == "Adelie" | species=="Gentoo")

##mutate adds a new column to your dataframe
data2<- mutate(.data=penguins, body_mass_kg=body_mass_g/1000)

view(data2)

##adding multiple columns. lets say we are interested in this ratio between bill length and depth
data2<- mutate(.data=penguins, body_mass_kg=body_mass_g/1000, bill_length_depth = bill_length_mm/bill_depth_mm)

##using ifelse
data2<-mutate(.data=penguins, after_2008 = ifelse(year>2008, "After 2008", "Before 2008"))

##new column that adds flipper length and body mass together
data2<- mutate(.data=penguins, length_body=flipper_length_mm+ body_mass_g)

##body mass > 4,000 is big and everything else is small
data2<-mutate(.data=penguins, Body_mass_class = ifelse(body_mass_g>4000, "Big", "Small"))


##using the pipe to include multiple verbs. Pipe which means "and then do..."
## %>% is within the tidyverse (so you have to load packages to use)
## |> has been recently added to base R in 2022
##they are like 90% the same but there are a few differences

##practice with %>%
penguins %>%
  filter(sex=="female") %>%
  mutate(log_mass=log(body_mass_g))

##select is for COLUMNS
##the logicals work for all of these verbs (!=)
penguins %>%
  filter(sex=="female") %>%
  mutate(log_mass=log(body_mass_g)) %>%
  select(species, island, sex, log_mass)

##re-name using select NEW=OLD
penguins %>%
  filter(sex=="female") %>%
  mutate(log_mass=log(body_mass_g)) %>%
  select(Species=species, island, sex, log_mass)

##summarize
##if there is even one NA in here it will cause an NA to come out when trying to calculate the mean so always include that na.rm function to remove NAs
penguins %>%
  summarize(mean_flipper= mean(flipper_length_mm, na.rm=TRUE))

##group by (very commonly used with summarize)
penguins %>%
  group_by(island) %>%
  summarize(mean_bill_length= mean(bill_length_mm, na.rm=TRUE),
            max_bill_length=max(bill_length_mm, na.rm=TRUE))

##Remove NAs
penguins %>%
  drop_na(sex)

##you might want to avoid making a bunch of new datasets when you go through this (you don't want mutated_penguins, drop_NA_penguins etc.)

##you can pipe right into ggplot but remember you have to switch to the plus signs once within ggplot and not the %>% anymore