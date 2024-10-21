### In class week 8 - working with stringr

##Created by: Annie Deck

##Created on 2024-10-15

############################################

##load libraries 
library(tidytext)
library(wordcloud2)
library(janeaustenr)
library(stopwords)
library(here)
library(tidyverse)

##a string and a character are the same thing
##you can tell something is a string by the presence of ""
words <- "This is a string"
words

##removing white spaces
badtreatments<-c("High", " High", "High ", "Low", "Low")
badtreatments

str_trim(badtreatments) # this removes both

##pattern matching
##find all strings with an A
data<-c("AAA", "TATA", "CTAG", "GCTT")
str_view(data, pattern = "A")

##or if you want true/false use detect
str_detect(data, pattern = "A")

##metacharacters- use cheat sheet tables
##replace "." with spaces 
vals<-c("a.b", "b.c","c.d")
str_replace(vals, "\\.", " ")

##remember to use _all to apply for all instances

##subsetting to only keep strings with digits in the vector
val2<-c("test 123", "test 456", "test")
str_subset(val2, "\\d")

##finding phone numbers 
strings<-c("550-153-7578",
           "banana",
           "435.114.7586",
           "home: 672-442-6739")

phone <- "([2-9][0-9]{2})[- .]([0-9]{3})[- .]([0-9]{4})"

##which strings contain phone numbers
str_detect(strings, phone)

##subset for only strings with phone numbers 
test<-str_subset(strings, phone) 
test

##think, pair, share
test %>%
  str_replace_all(pattern = "\\.", replacement = "-") %>% # replace periods with -
  str_replace_all(pattern = "[a-zA-Z]|\\:", replacement = "") %>% # remove all the things we don't want
  str_trim() # trim the white space

##tidytext

head(austen_books())



