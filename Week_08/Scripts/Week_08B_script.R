### In class week 8 - working with stringr

##Created by: Annie Deck

##Created on 2024-10-15

############################################

##load libraries 
library(here)
library(tidyverse)
library(patchwork)
library(gganimate)
library(ggrepel)
library(magick)
library(palmerpenguins)

                          ########patchwork########

##Plot 1 
p1 <- penguins %>%
  ggplot(aes(x=body_mass_g,
             y= bill_length_mm,
             color=species)) +
  geom_point()
p1

##Plot 2
p2 <- penguins %>%
  ggplot(aes(x=sex,
             y=body_mass_g,
             color=species)) +
  geom_jitter(width=0.2)
p2

p1+p2 +
  plot_layout(guides= 'collect') + ##merging legends
  plot_annotation(tag_levels= 'A') ##adding A and B labels

p1/p2 +
  plot_layout(guides= 'collect') + ##merging legends
  plot_annotation(tag_levels= 'A') ##adding A and B labels

                     ########ggrepel########

view(mtcars) ##this dataset just comes with ggplot

ggplot(mtcars, aes(x= wt,
                   y=mpg,
                   label=rownames(mtcars))) + ##labeling each data point with it's row name
  geom_text() + ##takes what you put in for label and puts it at the point
  geom_point(color='red')

##note: if you had a column named Car_IDs for example you could just set label = Car_IDs

##use ggrepel to repel them away from the points so we can actually read them 

ggplot(mtcars, aes(x= wt,
                   y=mpg,
                   label=rownames(mtcars))) + 
  geom_text_repel() +  
  geom_point(color='red')

                         ########gganimate########

penguins %>%
  ggplot(aes(x=body_mass_g,
             y= bill_depth_mm,
             color=species)) +
  geom_point() +
  transition_states(
    year, ##what we are animating by
    transition_length =2, ##relative length of transition (how long it takes to go from one year to the next)
    state_length= 1)  + ##length it shows the data points
  labs(title = 'Year: {closest_state}')+ ##I am in state 2008, 2009 etc.
anim_save(here("Week_08", "Output", "Penguin_animation.giff"))

                         ########magick########

##for image processing 

##for putting a penguin in our plot

##first read in an image from google. should end in jpeg or png etc.
penguin<- image_read("http://pngimg.com/uploads/penguin/pinguin_PNG9.png")
penguin

##you could also put an image in one of your folders and read it in that way. The above it getting it from google or its source.
penguins %>%
  ggplot(aes(x=body_mass_g,
             y= bill_depth_mm,
             color=species)) +
  geom_point() +
  ggsave(here("Week_08", "Output", "Penguin_plot.png")) ##first have to save your plot

##then read it back in with magic to combine with image
penplot<- image_read(here("Week_08", "Output", "Penguin_plot.png"))
out <-image_composite(penplot, penguin, offset = "+70+30") ##whatever you want in the background goes first
out

image_write(out, path = here("Week_08", "Output", "out.png")) ##this is a save function in the magick package that I looked up

##Can also add gifs (see lecture video for code)
