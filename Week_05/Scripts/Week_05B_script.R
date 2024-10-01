### At home week 5 lecture- working with the lubridate package- learning about working with dates and times

##Created by: Annie Deck

##Created on 2024-09-29

############################################

##load libraries 
library(tidyverse)
library(here)
library(lubridate)

##lubridate can tell you what the date is with these functions
now()

today(tzone= "GMT")

##dates must be a character to work with lubridate! Putting quotes around it makes it a character

##use these functions to tell lubridate what order your dates are in and it will convert it to ISO format 
ymd("2021-02-24")
##output is the same because that was the order it was already in 

##here we are telling it, it is currently in mdy format and it spits it out in ISO format 
mdy("02/24/2021")

##if you are changing a column you must use mutate first and then pipe into lubridate functions 

##also good with times (first m is month and second m is minutes)
##this is military time. It assumes military time unless you have AM or PM next to it 
mdy_hms("02/24/2021 22:22:20")

##can also do this with a vector of dates
##need to have the same format within a vector! So you canʻt have some date formats for some entries and different for others
datetimes <- c("02/24/2021 22:22:20",
                "02/25/2021 11:21:10",
                "02/26/2021 8:01:52")

datetimes <- mdy_hms(datetimes)
datetimes

##can ask for a list of months you have- you can make a new column of just months if you want to average values by month for example
month(datetimes)

##now month is a factor because there are levels 
month(datetimes, label= TRUE)

#spell it out- this is good for making plots
month(datetimes, label= TRUE, abbr =FALSE)

##you can do the same above using day and wday functions 

##this adds 4 hours (if you need to adjust for timezone)
##can also do this for days, minutes, seconds
datetimes + hours(4)

##can round to the nearest minute, hour etc. 
round_date(datetimes, "minute")

round_date(datetimes, "5 mins")


