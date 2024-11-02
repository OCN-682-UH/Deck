### At home week 9 lecture- working with factors

##Created by: Annie Deck

##Created on 2024-10-29

############################################

##load libraries 
library(here)
library(tidyverse)

##bring in data from tidy tuesday
income_mean <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/income_mean.csv')

##making a factor
fruits<-factor(c("Apple", "Grape", "Banana"))
fruits

##where this can go wrong...
test<-c("A", "1", "2")
as.numeric(test)

##factors store everything as integers in the background and this can introduce not real data
test<-factor(test) # covert to factor
as.numeric(test)

##this is why you should always use read_csv() instead of read.csv() so your stings are imported automatically as characters instead of factors

##forcats package 

glimpse(starwars)

#How many species and how many characters in each of those species
starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE)

##using fct_lump() to lump species with less than 3 characters into an "other" category
##this function also converts our data into a factor in this process
star_counts<-starwars %>%
  filter(!is.na(species)) %>%
  mutate(species = fct_lump(species, n = 3)) %>%
  count(species)
star_counts

#plotting and ordering lowest to highest
star_counts %>%
  ggplot(aes(x = fct_reorder(species, n), y = n))+ # reorder the factor of species by n
  geom_col()

##descending order 
star_counts %>%
  ggplot(aes(x = fct_reorder(species, n, .desc = TRUE), y = n))+ # reorder the factor of species by n
  geom_col() +
  labs(x = "Species")


##re-ordering the legend with the fct_reorder2 function (ordering by multiple variables)
glimpse(income_mean)

##first tidying the data
total_income<-income_mean %>%
  group_by(year, income_quintile)%>% ##group income mean by year and income quintile
  summarise(income_dollars_sum = sum(income_dollars))%>% 
  mutate(income_quintile = factor(income_quintile)) # make income quintile a factor

##simple plot of this
total_income%>%
  ggplot(aes(x = year, y = income_dollars_sum, color = income_quintile))+
  geom_line()

##now re-ordering

##re-ordering income_quintile by year AND income_dollars_sum 
total_income%>%
  ggplot(aes(x = year, y = income_dollars_sum, 
             color = fct_reorder2(income_quintile,year,income_dollars_sum)))+
  geom_line()+
  labs(color = "income quantile")

##now ordering manually (not based on the data- just an order that we want for whatever reason)

x1 <- factor(c("Jan", "Mar", "Apr", "Dec"))
x1

#specifying order
x1 <- factor(c("Jan", "Mar", "Apr", "Dec"), levels = c("Jan", "Mar", "Apr", "Dec"))
x1

##just filter out species that have more than 3 now
starwars_clean<-starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) %>%
  mutate(species = factor(species)) %>% # make species a factor
  filter(n>3) # only keep species that have more than 3

starwars_clean

##check levels- all 38 species are still there even though we filtered it out
levels(starwars_clean$species)

##anytime you filter anything out you need to include function drop_levels
##fct_drop will do the same thing
starwars_clean<-starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) %>%
  mutate(species = factor(species)) %>% # make species a factor 
  filter(n>3)  %>% # only keep species that have more than 3 
  droplevels() # drop extra levels

##now we only retain droid and human like we wanted
levels(starwars_clean$species)

##re-name or recode a level
starwars_clean<-starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) %>%
  mutate(species = factor(species)) %>% # make species a factor 
  filter(n>3)  %>% # only keep species that have more than 3 
  droplevels() %>% # drop extra levels 
  mutate(species = fct_recode(species, "Humanoid" = "Human"))

starwars_clean
