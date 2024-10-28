### In class week 9 - writing functions 

##Created by: Annie Deck

##Created on 2024-10-22

############################################

##load libraries 
library(here)
library(tidyverse)
library(palmerpenguins)
library(PNWColors)

##create a data frame
df <- tibble(
  a = rnorm(10), # draws 10 random values from a normal distribution
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
head(df)

##re-scale data in multiple columns 
df<-df %>%
  mutate(a = (a-min(a, na.rm = TRUE))/(max(a, na.rm = TRUE)-min(a, na.rm = TRUE)))

##easy to make mistakes...see error in column b line 
df<-df %>%
  mutate(a = (a-min(a, na.rm = TRUE))/(max(a, na.rm = TRUE)-min(a, na.rm = TRUE)),
         b = (b-min(b, na.rm = TRUE))/(max(a, na.rm = TRUE)-min(b, na.rm = TRUE)),
         c = (c-min(c, na.rm = TRUE))/(max(c, na.rm = TRUE)-min(c, na.rm = TRUE)),
         d = (d-min(d, na.rm = TRUE))/(max(d, na.rm = TRUE)-min(d, na.rm = TRUE)))

##so lets make a function! 
rescale01 <- function(x) {
  value<-(x-min(x, na.rm = TRUE))/(max(x, na.rm = TRUE)-min(x, na.rm = TRUE))
  return(value)
}

df %>%
  mutate(a = rescale01(a),
         b = rescale01(b),
         c = rescale01(c),
         d = rescale01(d))

##lets practice making a function to convert F to C
temp_C <- (temp_F - 32) * 5 / 9

##you put what you are providing or changing as the argument into the function function 
##you put what you want out in the return function 
fahrenheit_to_celsius <- function(temp_F) {temp_C <- (temp_F - 32) * 5 / 9
return(temp_C)}

##test it 
fahrenheit_to_celsius(32)

##now Celcius to kelvin (think, pair, share)
temp_K <- (temp_C + 273.15)

celsius_to_kelvin <- function(temp_C) {temp_C <- (temp_C + 273.15)
return(temp_K)}

##making plots into functions
pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 

ggplot(penguins, aes(x = body_mass_g, y = bill_length_mm, color = island))+
  geom_point()+
  geom_smooth(method = "lm")+ # add a linear model
  scale_color_manual("Island", values=pal)+   # use pretty colors and another example of how to manually change the legend title for colors
  theme_bw()

##making the function - error here
myplot<-function(data, x, y){
  pal<-pnw_palette("Lake",3, type = "discrete") 
  ggplot(data, aes(x = x, y = y, color = island))+
    geom_point()+
    geom_smooth(method = "lm")+ 
    scale_color_manual("Island", values=pal)+  
    theme_bw()
}

##return is if you are saving something so we don't have that here

##using curly curly to help assign variables that are within a dataframe
myplot<-function(data, x, y){ 
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
    geom_point()+
    geom_smooth(method = "lm")+ # add a linear model
    scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
    theme_bw()
}

##now you can change out the data frame, and what variables are plotted on the x and y axis (so you don't have to type out a million ggplot codes)
myplot(data = penguins, x = body_mass_g, y = flipper_length_mm)

##adding a default if you always want to use the same dataframe
myplot<-function(data = penguins, x, y){
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
    geom_point()+
    geom_smooth(method = "lm")+ # add a linear model
    scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
    theme_bw()
}

myplot(x = body_mass_g, y = flipper_length_mm)

##can modify the plot using functions easily:  
myplot(x = body_mass_g, y = flipper_length_mm)+
  labs(x = "Body mass (g)",
       y = "Flipper length (mm)")

## a quick aside on if else statements 
a <- 4
b <- 5

if (a > b) { # my question
  f <- 20 # if it is true give me answer 1
} else { # else give me answer 2
  f <- 10
}

f

##back to plotting 
##lines= TRUE and data=penguins are the defaults here. Remember we can override these in myplot function as shown below. 
myplot<-function(data = penguins, x, y, lines=TRUE ){ # add new argument for lines
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  if(lines==TRUE){
    ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
      geom_point()+
      geom_smooth(method = "lm")+ # add a linear model
      scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
      theme_bw()
  }
  else{
    ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
      geom_point()+
      scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
      theme_bw()
  }
}

myplot(x = body_mass_g, y = flipper_length_mm)
myplot(x = body_mass_g, y = flipper_length_mm, lines = FALSE)

##she recommends putting all of your functions at the top of your script like under your libraries or even in its own script that you can "call in"
#How you would do this: 
#source(here("Scripts", "custom_functions.R"))
