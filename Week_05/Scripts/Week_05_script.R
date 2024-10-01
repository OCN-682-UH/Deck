### In class week 5 - learning ways to joining datasets with Becker & Silbiger 2020 data set 

##Created by: Annie Deck

##Created on 2024-09-24

############################################

##load libraries 
library(tidyverse)
library(here)

##Tip in general: always have a unique ID for every single sample you collect!!

##Load in data

##environmental data from each site
EnviroData<-read_csv(here("Week_05", "Data", "site.characteristics.data.csv"))

##Thermal performance data
TPCData<-read_csv(here("Week_05", "Data", "Topt_data.csv"))

##look at the data
view(EnviroData)
view(TPCData)

##site letter is the thing that is shared between these data sets

##however one is in long format and one is in wide! so first we have to fix that
EnviroData_wide<-EnviroData %>%
  pivot_wider(names_from=parameter.measured,
              values_from=values) %>%
  arrange(site.letter) ##makes site letter in alphabetical order (can add any variable here I believe)

##now using left_join to bring these together 

FullData_left<- left_join(TPCData, EnviroData_wide)
head(FullData_left)

##relocate 
FullData_left<- left_join(TPCData, EnviroData_wide) %>%
  relocate(where(is.numeric), .after=where(is.character))

##think, pair, share 
FullData_mean_var <- FullData_left %>%
  pivot_longer(cols = E:substrate.cover,
               names_to = "Variables",
               values_to = "Values") %>%
  group_by(Variables, site.letter)%>%
  summarise(Param_means=mean(Values, na.rm=TRUE),
            Param_vars = var(Values, na.rm=TRUE)) 

##there are many options within summarise 
?summarise_at

##another way to this
FullData_mean_var <- FullData_left %>%
  select(-site.block) %>%
  group_by(site.letter) %>%
  summarise_if(is.numeric, funs(mean=mean, var=var),
               na.rm=TRUE)

##creating a tibble 
T1 <- tibble(Site.ID = c("A", "B", "C", "D"),
             Temperature=c(14.1, 16.7, 15.3, 12.8))

##didn't finish this tibble see slides 
T2<-tibble(Site.ID = c("A", "B", "C", "D"),
           pH=c(7.3, 7.8, 15.3, 12.8))

##joining tibbles
##order matters! Retains what is on the left 
left_join(T1, T2)
right_join(T1, T2)

##full_join keeps everything- puts NAs where data is missing (this is the tidy version of merge)

##anti join is good for finding missing data
