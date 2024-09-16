##Homework for week 3- creating our own publication ready figure using ggplot
##Created by Annie Deck
##Created on 2024-09-13

###############################

##load libraries 
##load libraries 
library(palmerpenguins)
library(tidyverse)
library(here)
library(beyonce)

##take a look at the data to decide what variables I want to work with for my figure
view(penguins)

##building my figure
ggplot(data=penguins, 
       mapping= aes(x=species, ##plot species on the x axis
                    y=body_mass_g)) + ##plot body mass on the y axis
  geom_violin()+ ##my geometry is going to be a box plot
  labs(x= "Penguin Species", ##label axes 
       y= "Body Mass (g)",)

##adding a theme, colors, and title
ggplot(data=penguins, 
       mapping= aes(x=species, ##plot species on the x axis
                    y=body_mass_g,
                    fill=species)) + ##plot body mass on the y axis
  geom_boxplot()+ ##my geometry is going to be a box plot
  labs(x= "Penguin Species", ##label axes 
       y= "Body Mass (g)",)+
  theme_bw()+ ##adding a theme (gets ride of the grey)
  scale_fill_manual(values=beyonce_palette(11))+ ##changing colors of species (box plots filled in)
  labs(title= "Body Mass (g) Across Penguin Species", ##adding a title
       fill="Species") ##making species capitalized in the legend 

##now changing the size of text
ggplot(data=penguins, 
       mapping= aes(x=species, ##plot species on the x axis
                    y=body_mass_g,
                    fill=species)) + ##plot body mass on the y axis
  geom_boxplot()+ ##my geometry is going to be a box plot
  labs(x= "Penguin Species", ##label axes 
       y= "Body Mass (g)",)+
  theme_bw()+ ##adding a theme (gets ride of the grey)
  scale_fill_manual(values=beyonce_palette(11))+ ##changing colors of species (box plots filled in)
  labs(title= "Body Mass (g) Across Penguin Species", ##adding a title
       fill="Species") +##making species capitalized in the legend
  theme(axis.title=element_text(size=20), ##make axis titles larger
        axis.text.y = element_text(size= 17),##make y axis labels larger
        axis.text.x = element_text(size= 17),##make y axis labels larger
        title =element_text(size=16)) ##make title larger

##exporting
ggsave(here("Week_03","Output", "Penguin.png"),
       width=7,
       height=6)
