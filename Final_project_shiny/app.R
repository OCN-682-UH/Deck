##load libraries
library(shiny)
library(tidyverse)
library(pals)
library(shinythemes)
library(RColorBrewer)




##read in data
data <- read_csv('MCR_LTER_cleaned.csv')
line_plot_data <- read_csv("MCR_line_plot.csv")
fish_abund_data <- read_csv("fish_lollipop.csv")



                               #####UI chunk######

ui <- fluidPage(
  theme = shinytheme("united"),
  titlePanel("Final Project"),
  tabsetPanel(
    tabPanel("Introduction",
             tags$div(style = "margin: 20px;",
               tags$p("For my final project I analyzed data from the MCR LTER data base.")
             ),
    imageOutput("static_figure"),
  ),
     tabPanel("Question 1",
             selectInput( ##select box for year
               inputId = "Year", 
               label = "Year:",
               choices = unique(data$Year)
             ), 
             selectInput( ##select box for site
               inputId= "Site",  
               label= "Site:", 
               choices=unique(data$Site)
             ), 
             plotOutput("barplot") ##create space for bar plot 
    ),
    tabPanel("Question 2",
             selectInput( ##select box for site
               inputId= "Site",  
               label= "LTER Site:", 
               choices=unique(line_plot_data$Site)
             ), 
             selectInput( ##check box for site
               inputId = "Habitat",
               label = "Habitat:",
               choices = unique(line_plot_data$Habitat),
             ),
             plotOutput("linePlot") ##create space for line plot
    ),
    tabPanel("Question 3",
             selectInput(        ##select box for year
               inputId = "Year", 
               label = "Year:",
               choices = unique(fish_abund_data$Year)),
             plotOutput("lollipop")
  )
))



##now server chunk
server<-function(input,output) {
  output$static_figure <- renderImage ({
    list(
      src = "sample_sites.png", ##name of my figure
      width = "80%", ##reduce size of image
      style = "display: block; margin-left: auto; margin-right: auto;" ##make it centered
      
    )
  }, deleteFile = FALSE)

  filtered_data <- reactive({ ##reactive= code will re-run when inputs (site, title) are changed
    data %>%
      filter(Year == input$Year, 
             Site == input$Site) ##data in plot must be for year and site selected in the select box
  })
  output$barplot <- renderPlot({ ##inserted "barplot" here to match above. Below is all my normal ggplot code
    substrate_colors <- pals::cols25(length(unique(filtered_data()$Taxonomy_Substrate_Functional_Group)))
    
     ggplot(filtered_data (), aes(x = Taxonomy_Substrate_Functional_Group, ##calling my data like a function 
                                 y = mean_percent_cover,
                                 fill = Taxonomy_Substrate_Functional_Group)) +
      geom_bar(stat = "identity", position = "dodge") +
      scale_y_continuous(labels = function(x) paste0(x, "%")) +
      facet_wrap(~ Habitat) +
      scale_fill_manual(values= substrate_colors)+
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size=11),
            legend.position = "none",
            panel.grid.major.x = element_blank(),
            strip.text = element_text(face = "bold", size=13),
            axis.text.y = element_text(size = 11),
            axis.title.x= element_text(size = 14),
            axis.title.y= element_text(size = 14)) +
      labs(title = input$title,
           x = "Cover Type",
           y = "Percent Cover (%)",
           caption= "Long-term Population and Community Dynamics: Benthic Algae and Other Community Components, ongoing since 2005. Carpenter et al., 2023") 
  })
  
  line_data_filtered <- reactive({ 
    line_plot_data %>% 
      filter(Site == input$Site,
             Habitat ==input$Habitat)

})
  output$linePlot <- renderPlot ({
    ggplot(line_data_filtered(), aes(x = Year,
               y = mean_percent_cover,
               color = Taxonomy_Substrate_Functional_Group)) +
      geom_line(size=1.5) +
      scale_color_brewer(palette= "Set2") +
      facet_wrap(~ Taxonomy_Substrate_Functional_Group, ncol=1) +
      scale_y_continuous(labels = function(x) paste0(x, "%")) +
      theme_bw() +
      theme(strip.text = element_text(face = "bold", size=13),
            legend.position = "none",
            axis.text.x = element_text(size = 11),  
            axis.text.y = element_text(size = 11),,  
            axis.title.y = element_text(size = 14))+
      labs(x = "",
           y = "Percent Cover (%)",
           caption= "Long-term Population and Community Dynamics: Benthic Algae and Other Community Components, ongoing since 2005. Carpenter et al., 2023")
  })

  fish_abund_filtered <- reactive({ 
    fish_abund_data %>% 
      filter(Year == input$Year)
    
  })
  output$lollipop <- renderPlot ({
    ggplot(fish_abund_filtered (),aes(x = Change, 
               y = Fish_group)) +
      geom_segment(aes(x = 0, xend = Change, y = Fish_group, yend = Fish_group), 
                   color = "gray", size=0.8) +
      geom_point(aes(color = ifelse(Change < 0, "blue", "red")), size= 4) +
      scale_color_manual(values = c("red", "blue")) +
      theme_bw() +
      theme(legend.position = "none",
            plot.title = element_text(size = 16, hjust = 0.5),
            panel.grid.major.y = element_blank(),
            axis.text.x = element_text(size = 11),  
            axis.text.y = element_text(size = 11),  
            axis.title.x = element_text(size = 14)) +
      labs(
        x = "Change in Abundance",
        y = "",
        title = "Changes in abundance of fish functional groups",
        caption= "Coral Reef: Changes in the abundance of fish functional groups: Adam et al. 2014 Oecologia"
      )
  })
}

##can't forget this part or the run app button goes away
shinyApp(ui = ui, server = server)
