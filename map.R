library(shiny)
library(shinythemes)      # Bootswatch color themes for shiny
library(choroplethr)      # Creating Choropleth Maps in R
library(choroplethrMaps)  # Maps used by the choroplethr package
library(tidyverse)

# load the data set from the choroplethrMaps package
df <- read.table("data_world/happiness-cantril-ladder.csv", header = TRUE, sep = ",")
names(df) <- c("Entity", "Code", "Year", "Life.Satisfaction")

ui <- fluidPage(title = 'My First App!',
                theme = shinythemes::shinytheme('flatly'),
                
                sidebarLayout(
                  sidebarPanel(width = 3,
                               sliderInput("num_colors",
                                           label = "Number of colors:",
                                           min = 2005,
                                           max = 2012,
                                           value = 2005),
                               selectInput("select", 
                                           label = "Select Demographic:", 
                                           choices = colnames(map_data)[2:9], 
                                           selected = 1)),
                  
                  mainPanel(width = 9, 
                            tabsetPanel( 
                              tabPanel(title = 'Output Map', 
                                       plotOutput(outputId = "map")),
                              tabPanel(title = 'Data Table', 
                                       dataTableOutput(outputId = 'table'))))))

server <- function(input, output) {
  
  output$map <- renderPlot({
    
    data <- df %>% filter(df$Year == input$num_colors)
    map_data$value = data$Life.Satisfaction
    
    region_choropleth(map_data,
                     title = 'test', 
                     num_colors = 4)
  })
  
  output$table <- renderDataTable({
    
    map_data[order(map_data[input$select]), ]
  })
}


