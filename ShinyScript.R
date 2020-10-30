library(shiny)
#library(gapminder)
library(dplyr)
library(ggplot2)
library(tidyr)

#install.packages("gridExtra")
library(gridExtra)

#install.packages("shinyWidgets")
library(shinyWidgets)

library(countrycode)

library(leaflet)
library(geojsonio)
library(geojsonR)

#install.packages("rgdal")
#install.packages("spdplyr")
#install.packages("geojsonio")
#install.packages("rmapshaper")
library(rgdal)
library(spdplyr)
library(geojsonio)
library(rmapshaper)
library(jsonlite)

df = read.table("data_world/happiness-cantril-ladder.csv", header = TRUE, sep = ",")
names(df) <- c("Entity", "Code", "Year", "Life.Satisfaction")

df2 = read.table("data_world/political-regime-updated2016.csv", header = TRUE, sep = ",")
names(df2) <- c("Entity", "Code", "Year", "IDH")

df3 = inner_join(df, df2, by = NULL, copy = FALSE)
df3$Year <- as.factor(df3$Year)
df3$Entity <- as.factor(df3$Entity)

df3 <- df3 %>% mutate(Entity = replace(Entity, Entity ==  "Timor",  "Timor-Leste"))
df3 <- df3 %>% mutate(Entity = replace(Entity, Entity ==  "Micronesia (country)",  "Micronesia"))

df3$Continent <- countrycode(sourcevar = df3[, "Entity"],
                            origin = "country.name",
                            destination = "continent")

df3$Continent <- as.factor(df3$Continent)

df4 = filter(df, Year == "2015")
#names(df) <- c("Entity", "Code", "Year", "Life.Satisfaction")

################

world <- geojsonio::geojson_read("world.json", what = "sp")

#world$Country <- vapply(strsplit(world$name, ":"), function(x) x[1], FUN.VALUE="a")

world$Value <- df4$Life.Satisfaction[match(world$name, df4$Entity)]

#show(df$Entity)
#show(world$name)
#show(world$Value)

bins <- c(2, 3, 4, 5, 6, 7, 8)
pal <- colorBin("YlOrRd", domain = df4$Life.Satisfaction, bins = bins)

labels <- sprintf(
    "<strong>%s</strong><br/>Level of life satisfaction : %g ",
    world$name, world$Value
) %>% lapply(htmltools::HTML)

################

ui <- fluidPage(
    titlePanel("Life satifaction vs Human development index"),
    sidebarLayout(
        sidebarPanel(
            sliderTextInput(inputId = "TIME",
                        label = "Year",
                        grid = TRUE,
                        choices = levels(df3$Year)
            ),
            sliderTextInput(inputId = "VAR",
                            label = "Category",
                            grid = TRUE,
                            choices = levels(df3$Continent)
            )
        ),
        mainPanel(
            
            tabsetPanel(type = "tabs",
                        tabPanel("Plot1", plotOutput(outputId = "plot1")),
                        tabPanel("Histo", plotOutput(outputId = "plot2")),
                        tabPanel("Plot3", leafletOutput("plot3"))
            )
        )
    )
)

server <- function(input, output) {
    output$plot1 <- renderPlot({
        df3 %>%
            filter(Year==input$TIME) %>%
            ggplot(aes(x=Life.Satisfaction, y=IDH, color=Continent)) +
            geom_point(size=4) +
            ggtitle(paste("Life satifaction vs Human development index in", toString(input$TIME))) +
            labs(x="Life satifaction", y="Human development index") +
            #geom_rug(sides ="bl") +
            theme(legend.position="right")
    }) 
    output$plot2 <- renderPlot({
        df3 %>%
            filter(Year==input$TIME) %>%
            filter(Continent==input$VAR) %>%
            ggplot(aes(x=Life.Satisfaction)) +
            geom_histogram(bins=10, colour="black", fill="#e5f5f9") +
            ggtitle(paste("Histogram of life satisfaction in", toString(input$TIME), "for", toString(input$VAR)))
    })
    output$plot3 <- renderLeaflet({ 
      data <- df4 %>% filter(Year==input$TIME)
      show(data)
        leaflet(world) %>%
            setView(-7, 37.8, 1) %>%
            addProviderTiles("MapBox", options = providerTileOptions(
                id = "mapbox.light",
                accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
            addPolygons(
                fillColor = ~pal(world$Value),
                weight = 2,
                opacity = 1,
                color = "white",
                dashArray = "3",
                fillOpacity = 0.7,
                
                highlight = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                    label = labels,
                    labelOptions = labelOptions(
                        style = list("font-weight" = "normal", padding = "3px 8px"),
                        textsize = "15px",
                        direction = "auto")) %>%
            addLegend(
                pal = pal, 
                values = data$Life.Satisfaction, 
                opacity = 0.7, 
                title = NULL,
                position = "bottomright")
    })
}

shinyApp(ui = ui, server = server)


