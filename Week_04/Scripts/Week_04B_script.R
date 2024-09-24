##At home class lecture week 4. Learning  tidyr with Silbiger et al. 2020 data set 
##Created by: Annie Deck
##Created on: 2024-09-24

############################################

##load libraries
library(tidyverse)
library(here)

##load data
ChemData <- read_csv(here("Week_04", "data", "chemicaldata_maunalua.csv"))
view(ChemData)

ChemDataDictionary <-read_csv(here("Week_04", "data", "chem_data_dictionary.csv"))
view(ChemDataDictionary)

##Another way you can remove all NAs from a data set is with complete.cases
ChemData_clean <-ChemData %>%
  filter(complete.cases(.))

##Separate function (tide and time of data within one column)
ChemData_clean <-ChemData %>%
  filter(complete.cases(.)) %>%
  separate(col= Tide_time, ##selecting this column (the origional one)
           into= c("Tide", "Time"), ##specifying we want these in two columns now labeled Tide and Time
           sep= "_") ##separate by the underscore

##always check to make sure the result is what you were expecting
head(ChemData_clean)

##to keep the original Tide_time column you would add remove= FALSE in the sep function 

##Uniting columns 
##Notice quotes need to be around new column names but not around ones that already exist!
ChemData_clean <-ChemData %>%
  filter(complete.cases(.)) %>%
  separate(col= Tide_time, ##selecting this column (the original one)
           into= c("Tide", "Time"), ##specifying we want these in two columns now labeled Tide and Time
           sep= "_",##separate by the underscore
           remove= FALSE) %>%
  unite(col= "Site_Zone", ##create a NEW column called this
        c(Site,Zone), ##columns to unite 
        sep= ".", ##separate by a dot
        remove=FALSE) ##keep the original column 

head(ChemData_clean)

##Reminder that wide data is 1 observation per row and all the different variables for that observation are columns

##long data one measurement per row (column name measurement type) and sample ID is repeated for all of the different measurements

##our data set is currently in wide format 

##long format is helpful because it allows us to use the group_by function much easier and facet_wrap

##Pivot_longer
ChemData_long <- ChemData_clean %>%
  pivot_longer(cols = Temp_in:percent_sgd,
               names_to = "Variables",
               values_to = "Values") ##specific columns I want to pivot
view (ChemData_long)


ChemData_long %>%
  group_by(Variables, Site) %>%
  summarise(Param_means= mean(Values, na.rm=TRUE),
            Param_vars = var(Values, na.rm=TRUE))


ChemData_long %>%
  group_by(Variables, Site, Zone, Tide) %>%
  summarise(Param_means= mean(Values, na.rm=TRUE),
            Param_vars = var(Values, na.rm=TRUE),
            Param_SD= sd(Values, na.rm=TRUE))


##Facet wrapping 
ChemData_long %>%
  ggplot(aes(x= Site, y= Values)) +
  geom_boxplot() +
  facet_wrap(~Variables, scales= "free") ##this allows each axis to be appropriate for the given parameter 

##Now converting from long to wide
ChemData_wide <-ChemData_long %>%
  pivot_wider(names_from= Variables,
              values_from =Values)

##calculating summary statistics & exporting the CSV file 

##putting it all together
ChemData_clean <- ChemData %>%
  drop_na() %>% ##View(ChemData_clean) view in the console after each step!
  separate(col= Tide_time, 
           into= c("Tide", "Time"), 
           sep= "_",
           remove= FALSE) %>%
  pivot_longer(cols = Temp_in:percent_sgd,
               names_to = "Variables",
               values_to = "Values") %>%
  group_by(Variables, Site, Time) %>%
  summarise(mean_vals=mean(Values, na.rm=TRUE))%>%
  pivot_wider(names_from= Variables,
              values_from= mean_vals) %>%
  write_csv(here("Week_04", "Output", "summary.csv"))



