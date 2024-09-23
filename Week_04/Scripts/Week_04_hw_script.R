##Homework for week 4. Continue to practice with dplyr and the penguin data
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

##part 1
penguins %>%
  drop_na(species,island,sex) %>% ##removes NAs from columns I am interested in
  group_by (species,island,sex) %>% ##group by these columns
  summarise(mean_body_mass= mean(body_mass_g, na.rm=TRUE), ##calculate mean body mass for each of these columns
  var_body_mass= var(body_mass_g, na.rm=TRUE)) ##calculate variance for each of these columns

##part 2
penguins_2<-penguins %>% ##creating a new data frame called penguins_2
  filter (sex == "female") %>% ##excludes males
  mutate(log_mass=log(body_mass_g)) %>% ##calculates log body mass
  select(species, island, sex, log_mass) ##selects only these columns I am interested in

##creating a plot with my new data frame
ggplot(data=penguins_2, 
       mapping= aes(x=species, 
                    y=log_mass,
                    color=species))+
  geom_violin(show.legend = FALSE)+
  theme_bw()+
  labs(x= "Species", 
       y= "Log Body Mass (g)",
       title= "Log Body Mass Across Penguin Species")

##saving plot
ggsave(here("Week_04","Output", "Dplr_practice_plot.png"),
       width=6,
       height=6)
