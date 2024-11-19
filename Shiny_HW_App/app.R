##load libraries
library(shiny)
library(tidyverse)
library(DT)

##color palette
palette5 <- c("#2E8B57", "#4682B4", "#CD853F")

##I am using a percent cover figure I made for our factors homework and turning it into a shiny app
##Data is already converted to long format and cleaned up 
##I want to insert a select box where you can choose a site and it will show you percent cover of benthic organisms for that site by quadrat



##Making my app
##first UI chunk 
ui<-fluidPage(
  selectInput( ##first input: make a select box
    inputId= "site",  ##arbitrary name (reference this below in server)
    label= "ChooseSite:", ##label above box
    choices=unique(Intertidal_data_final$site)), ##choices are the unique values from the site column in my data set 
  textInput(inputId = "title", #second input is a changeable title
            label = "Title",
            value = "Benthic Cover Analysis for Scripps"), #title I want to appear initially 
  plotOutput("barplot"), #creates space for a plot called "barplot"
  dataTableOutput("data_table") #creates space for a table called "data_table"
)

##now server chunk
server<-function(input,output) {
    filtered_data <- reactive({ ##reactive= code will re-run when inputs (site, title) are changed
      Intertidal_data_final %>%
        filter(site == input$site) ##data in plot and table must be for site selected in the select box
  })
    output$barplot <- renderPlot({ ##inserted "barplot" here to match above. Below is all my normal ggplot code
        ggplot(filtered_data (), aes(x = Cover, ##calling my data like a function 
                   y = Percent,
                   fill = quadrat)) +
        geom_bar(stat = "identity", position = "dodge") +
        scale_y_continuous(labels = function(x) paste0(x, "%")) +
        scale_fill_manual(values = palette5) +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(title = input$title,
             x = "Cover Type",
             y = "Percent Cover (%)",
             fill = "Quadrat") +
        scale_x_discrete(
          labels = c("algae" = "Algae",
                     "anemone" = "Anemone",
                     "bare_rock" = "Bare Rock",
                     "gooseneck_barnacles" = "Gooseneck Barnacles",
                     "large_barnacles" = "Large Barnacles",
                     "mussels" = "Mussels",
                     "small_barnacles" = "Small Barnacles"))
})
    output$data_table <- renderDataTable({ ##adds data table below plot. Using same spelling from IU "data_table"
      filtered_data()
    })
}

##can't forget this part or the run app button goes away
shinyApp(ui = ui, server = server)