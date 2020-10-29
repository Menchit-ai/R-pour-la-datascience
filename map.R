library(shiny)
library(shinythemes)      # Bootswatch color themes for shiny
library(choroplethr)      # Creating Choropleth Maps in R
library(choroplethrMaps)  # Maps used by the choroplethr package

# load the data set from the choroplethrMaps package
data('df_state_demographics')
map_data <- df_state_demographics

ui <- fluidPage(title = 'My First App!',
                theme = shinythemes::shinytheme('flatly'),
                
                sidebarLayout(
                  sidebarPanel(width = 3,
                               sliderInput("num_colors",
                                           label = "Number of colors:",
                                           min = 1,
                                           max = 9,
                                           value = 7),
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
    
    map_data$value = map_data[, input$select]
    
    state_choropleth(map_data,
                     title = input$select, 
                     num_colors = input$num_colors)
  })
  
  output$table <- renderDataTable({
    
    map_data[order(map_data[input$select]), ]
  })
}


shinyApp(ui, server)