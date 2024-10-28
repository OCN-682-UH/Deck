Good plot bad plot challenge!!
================
Annie Deck
2024-10-23

- [Load libraries](#load-libraries)
- [Bring in data from tidy tuesday](#bring-in-data-from-tidy-tuesday)
- [Clean up and join data sets](#clean-up-and-join-data-sets)
- [Ugly plot boo :(](#ugly-plot-boo-)
- [Pretty plot yay!](#pretty-plot-yay)

# Load libraries

``` r
library(tidyverse)
library(here)
library(maps)
library(mapdata)
library(mapproj)
library(magick)
```

# Bring in data from tidy tuesday

``` r
outer_space_objects <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-04-23/outer_space_objects.csv')

view(outer_space_objects)
```

# Clean up and join data sets

``` r
# Get the world map data and fix the country names to match 
world <- map_data("world") %>%
  mutate(region = case_when(
    region == "USA" ~ "United States",
    region == "UK" ~ "United Kingdom",
    TRUE ~ region
  ))

# Group by country to get total objects launched across all years
space_by_country <- outer_space_objects %>%
  group_by(Entity) %>%
  summarize(total_objects = sum(num_objects))


##join the world data set with the space_by_country data set by country
world_space <- world %>%
  inner_join(space_by_country, by = c("region" = "Entity"))
```

# Ugly plot boo :(

- X axis is crowded making it difficult to discern between countries
- Y axis is not easy to understand due to the large variation in values
  across the countries
- Axis labels and title are not informative
- Yellow grid background is distracting and does not add anything to the
  figure

``` r
#bring in image of satellite
satellite <- image_read("https://t3.ftcdn.net/jpg/02/61/23/20/360_F_261232019_Aowz0vDUTDrqbj2NbBalcIB9I9sK3GL4.jpg")%>%
  image_transparent("white") #remove white background

#make bad plot
bad_plot <- world_space %>%
  ggplot(aes(x=region, 
               y= total_objects)) +
  geom_col() + #make it a simple bar plot
  theme(panel.background = element_rect(fill = "yellow")) + #make background a pretty yellow
  labs(title = "Launches!!!") #descriptive title

#saving 
ggsave(here("Week_09", "Output", "bad_plot.png"), plot= bad_plot)

##read plot back in to combine with image
bad_plot<- image_read(here("Week_09", "Output", "bad_plot.png"))
masterpiece <-image_composite(bad_plot, satellite, offset = "+200+150") 
masterpiece
```

<img src="goodplot_badplot_files/figure-gfm/unnamed-chunk-4-1.png" width="2099" />

# Pretty plot yay!

- Log transformation of the data makes values much easier to understand
- Titles are informative (states what is being visualized, what
  timeframe this data was gathered from etc.)
- Where the data comes from is clearly stated making this plot more
  reproducible
- Colors gradient creates a visual depiction of the values making it
  much easier for the viewer to identify key patterns in the data.

``` r
ggplot(world_space, aes(x = long, 
                        y = lat, 
                        group = group, 
                        fill = total_objects)) +
  geom_polygon(color = "white", size = 0.1) + ##adds country shapes and puts thin white line between them 
  scale_fill_gradient2( # add color scale 
    low = "#e5f5f9", #white
    mid = "#2ca25f", #light green
    high = "#006d2c", #dark green
    midpoint = median(space_by_country$total_objects), ##center color scale at median value
    trans = "log", #log transformation because large variation in values
    name = "Total Number of\nSpace Objects",
    labels = function(x) round(x, 0)  # Round the legend numbers
  ) +
  theme_minimal() + #add theme
  labs(title = "Total Space Objects Launched by Country (1962-2023)", #title
       caption = "Source: Tidy Tuesday outer_space_objects dataset") + #caption
  coord_map(projection = "mercator") +  #Mercator projection
  theme(plot.title = element_text(size = 14, face = "bold"), #make title look nice
    axis.title = element_blank(),
    axis.text = element_blank(),
    panel.grid = element_blank()) +
  scale_y_continuous(limits = c(-60, 90)) +  #Limit latitude to reduce polar distortion
  coord_fixed(ratio = 1.3)  # Adjusts width/height proportion to reduce distortion 
```

<img src="goodplot_badplot_files/figure-gfm/unnamed-chunk-5-1.png" style="display: block; margin: auto;" />
