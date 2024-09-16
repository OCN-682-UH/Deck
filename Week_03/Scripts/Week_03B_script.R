##Week 3 at home lecture. Learning how to add multiple layers with ggplot using the penguin data. 
##Created by Annie Deck
##Created on 2024-09-13

########################################

##load libraries 
library(palmerpenguins)
library(tidyverse)
library(here)
library(beyonce)
library(ggthemes)

##load data. This data (called penguins) is apart of the package so it is already loaded- we can go straight into looking at it. 
glimpse(penguins)

##starting to plot- using geom smooth to add a best fit line
##adding method= lm implements a linear model 
ggplot(data=penguins, 
       mapping= aes(x=bill_depth_mm,
                    y=bill_length_mm)) +
  geom_point()+
  geom_smooth(method= "lm")+
  labs(x= "Bill Depth (mm)",
       y= "Bill Length (mm)",)

##using group (shows a linear model for each species individually)
ggplot(data=penguins, 
       mapping= aes(x=bill_depth_mm,
                    y=bill_length_mm,
                    group=species,
                    color=species)) +
  geom_point()+
  geom_smooth(method= "lm")+
  labs(x= "Bill Depth (mm)",
       y= "Bill Length (mm)")

##using scale to manually change the x axis and colors
ggplot(data=penguins, 
       mapping= aes(x=bill_depth_mm,
                    y=bill_length_mm,
                    group=species,
                    color=species)) +
  geom_point()+
  geom_smooth(method= "lm")+
  labs(x= "Bill Depth (mm)",
       y= "Bill Length (mm)")+
  scale_color_viridis_d()+
  scale_x_continuous(limits=c(0,20))

ggplot(data=penguins, 
       mapping= aes(x=bill_depth_mm,
                    y=bill_length_mm,
                    group=species,
                    color=species)) +
  geom_point()+
  geom_smooth(method= "lm")+
  labs(x= "Bill Depth (mm)",
       y= "Bill Length (mm)")+
  scale_color_viridis_d()+
  scale_x_continuous(breaks=c(14,17,21),
                     labels=c("low","medium","high"))+
  scale_color_manual(values=c("orange", "purple", "blue"))

##using the beyonce palette
ggplot(data=penguins, 
       mapping= aes(x=bill_depth_mm,
                    y=bill_length_mm,
                    group=species,
                    color=species)) +
  geom_point()+
  geom_smooth(method= "lm")+
  labs(x= "Bill Depth (mm)",
       y= "Bill Length (mm)")+
  scale_color_viridis_d()+
  scale_x_continuous(breaks=c(14,17,21),
                     labels=c("low","medium","high"))+
  scale_color_manual(values=beyonce_palette(2))

## using coord function to flip x and y axis
ggplot(data=penguins, 
       mapping= aes(x=bill_depth_mm,
                    y=bill_length_mm,
                    group=species,
                    color=species)) +
  geom_point()+
  geom_smooth(method= "lm")+
  labs(x= "Bill Depth (mm)",
       y= "Bill Length (mm)")+
  scale_color_viridis_d()+
  scale_x_continuous(breaks=c(14,17,21),
                     labels=c("low","medium","high"))+
  scale_color_manual(values=beyonce_palette(2))+
  coord_flip()

##working with the theme function
ggplot(data=penguins, 
       mapping= aes(x=bill_depth_mm,
                    y=bill_length_mm,
                    group=species,
                    color=species)) +
  geom_point()+
  geom_smooth(method= "lm")+
  labs(x= "Bill Depth (mm)",
       y= "Bill Length (mm)")+
  scale_color_viridis_d()+
  scale_x_continuous(breaks=c(14,17,21),
                     labels=c("low","medium","high"))+
  scale_color_manual(values=beyonce_palette(2))+
  theme_bw()+
  theme(axis.title=element_text(size=20),
        panel.background=element_rect(fill="linen"))

ggsave(here("Week_03","Output", "Penguin.png"),
       width=7,
       height=5)
