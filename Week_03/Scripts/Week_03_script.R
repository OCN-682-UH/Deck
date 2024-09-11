##Fundamentals in R class week 3 script. Learning to work in ggplot
##Created by Annie Deck
##Created on 2024-09-10

###############################

##load libraries 
library(palmerpenguins)
library(tidyverse)

##looking at the data
glimpse(penguins)
view(penguins)
head(penguins)

##building a plot
##entering after commas or plus signs helps keep the code a bit cleaner
##note here difference in variable type: body mass is continuous and species is discrete 
ggplot(data=penguins, 
       mapping= aes(x=bill_depth_mm,
                    y=bill_length_mm,
                    color=species,
                    size=body_mass_g)) +
  geom_point()+
  labs(title= "Bill Depth and Length", 
       subtitle= "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
       x= "Bill Depth (mm)",
       y= "Bill Length (mm)",
       color="Species",
       caption= "source: Palmer Penguins Package...") +
  scale_color_viridis_d()
## scale_color_viridis_d() is specifically designed for people who are color blind. the _d indicates these are discrete colors (categories)

##remember that things that pertain directly to your data goes in aes 
##settings=manual changes you are adding that are not based on the values of a variable in your data (EX: how transparent we want the data points to appear). Go in the geom() section


##faceting

##facet grid
ggplot(data=penguins, 
       mapping= aes(x=bill_depth_mm,
                    y=bill_length_mm)) +
  geom_point()+
  facet_grid(species~sex)

##facet wrap
ggplot(data=penguins, 
       mapping= aes(x=bill_depth_mm,
                    y=bill_length_mm)) +
  geom_point()+
  facet_wrap(~species, ncol=2) ##can species number of columns


##removing legend
ggplot(data=penguins, 
       mapping= aes(x=bill_depth_mm,
                    y=bill_length_mm,
                    color=species)) +
  geom_point()+
  scale_color_viridis_d()+
  facet_grid(species~sex)+
  guides(color=FALSE)

##Data to Viz website is really cool- suggests plot types based on the types of data you have and provides the code


