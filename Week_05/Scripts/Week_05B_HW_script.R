### At home week 5 lecture- working with the lubridate package- learning about working with dates and times

##Created by: Annie Deck

##Created on 2024-09-29

############################################

##load libraries 
library(tidyverse)
library(here)
library(lubridate)

##challenge- convert the date column to a datetime

##view data- looks like the dates are already characters 
View(CondData)
head(CondData)


CondData_fixed <- CondData %>% ##specify data and pipe to mutate function
  mutate(date=mdy_hms(date)) ##alter date column to datetime format (using same column name to alter the already existing column instead of adding a new one)
head(CondData_fixed) ##looks good- date is now in dttm

##homework!

##look at depth data- date column already looks to be in dttm format
head(DepthData)

##rounding conductivity to nearest 10 seconds 
CondData_rounded <- CondData_fixed %>% 
  mutate(date=round_date(date, "10 seconds"))

head(CondData_rounded) ##double check it worked- looks good

##join depth and cond dataframes with no NAs (using inner_join)
combined_data <- inner_join(CondData_rounded, DepthData)

head(combined_data) ##looks good

Combined_data_avg <- combined_data %>%
  mutate(minute= floor_date(date, "minute")) %>% ##create a new column called minute that rounds down each time enry to the nearest minute
  group_by(minute) %>% ##now I am grouping by minute 
  summarise(depth_avg = mean(Depth, na.rm = TRUE), ##avg depth by minute
            temperature_avg = mean(Temperature, na.rm = TRUE),##avg temp by minute
            salinity_avg = mean(Salinity, na.rm = TRUE)) ##avg salinity by minute


##plotting 
##fixing names for prettier plotting
Combined_data_avg_pretty <- Combined_data_avg %>%
  rename(Depth = depth_avg,
         Temperature = temperature_avg,
         Salinity= salinity_avg)

##convert data frame to long format 
df_long <- Combined_data_avg_pretty %>% ##make a new df called df_long
  pivot_longer(cols = c(Temperature, Salinity, Depth), ##combine these columns into one named variable
               names_to = "variable", values_to = "value")



final_plot_week5 <-ggplot(df_long, aes(x = minute, y = value, color = variable)) + ##x is time and y will be the values
  geom_line() + ##these will be line graphs
  facet_wrap(~variable, scales = "free_y", ncol = 1) + ##facet by variable and allow each y axis to be suitable for each variable
  theme_bw() + ##add black and white theme
  labs(title = "Temperature, Salinity, and Depth Over Time", ##labeling
       x = "Hour", y = "Value", color="Parameter Measured") 

##exporting
ggsave(here("Week_05","Outputs", "final_plot_week5.png"),
       width=7,
       height=5)
