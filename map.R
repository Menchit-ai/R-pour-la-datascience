library(shiny)
library(leaflet)
library(reshape2)
library(maps)
library(mapproj)
library(rgdal)
library(RColorBrewer)
library(sp)
library(rgeos)



ui <- fluidPage(
  
  titlePanel("Title"),
  
  sidebarLayout(
    
    sidebarPanel(
      tabsetPanel(id= "tabs",
                  
                  tabPanel("Map", id = "Map", 
                           br(), 
                           
                           p("Choose options below to interact with the Map"), 
                           
                           sliderInput("hour", "Select the hours", min = 0 , max = 23, 
                                       value = 7, step = 1, dragRange= TRUE)
                  )
      )
    ),
    
    mainPanel(
      
      tabsetPanel(type= "tabs",
                  
                  
                  tabPanel("Map", leafletOutput(outputId = "map"))
      )
    )
  )
)



server <- function(input, output) {
  
  
  layer <- reactive( {
    
    shp = readOGR("shp",layer = "attractiveness_day3")
    shp_p <- spTransform(shp, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
    
  })
  
  output$map <- renderLeaflet({
    bins<- c(0, 2000, 4000, 8000, 16000, Inf)
    pal <- colorBin("YlOrRd", domain = layer()$h_7, bins = bins)
    
    leaflet(layer()) %>% 
      setView(13.4, 52.5, 9) %>% 
      addTiles()%>%
      addPolygons( 
        fillColor = ~pal(h_7),
        weight = 0.0,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7 
      )  %>% 
      addLegend(pal = pal, values = ~h_7, opacity = 0.7, title = NULL, position = "bottomright")
    
    
  })
  #until here it works but onwards not. 
  observe(leafletProxy("map", layer())%>%
            clearShapes()%>%
            addPolygons( 
              fillColor = ~pal(h_7),  # is it possible here to pass column name dynamically
              weight = 0.0,
              opacity = 1,
              color = "white",
              dashArray = "3",
              fillOpacity = 0.7 
            )  %>% 
            addLegend(pal = pal, values = ~h_7, opacity = 0.7, title = NULL, position = "bottomright")
  )
  
}


shinyApp(ui, server)