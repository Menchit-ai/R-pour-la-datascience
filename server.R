files <- list.files("./data_world")

world <- geojsonio::geojson_read("world.json", what = "sp")

labels <- sprintf(
  "<strong>%s</strong><br/>Level of life satisfaction : %g ",
  world$name, world$Value
) %>% lapply(htmltools::HTML)

df = read.csv("data_world/happiness-cantril-ladder.csv", header = TRUE, sep = ",")
names(df) <- c("Entity", "Code", "Year", "Value")

df2 = read.csv("data_world/political-regime-updated2016.csv", header = TRUE, sep = ",")
names(df2) <- c("Entity", "Code", "Year", "NewValue")

df3 = inner_join(df, df2, by = NULL, copy = FALSE)
df3$Year <- as.factor(df3$Year)
df3$Entity <- as.factor(df3$Entity)
df3$Continent <- countrycode(sourcevar = df3[, "Code"],
                             origin = "iso3c",
                             destination = "continent")

df3$Continent <- as.factor(df3$Continent)
yeardf <- df$Year %>% unique() %>% sort()
yeardf2 <- df2$Year %>% unique() %>% sort()
diffyears <- yeardf[yeardf %in% yeardf2]

world$Value <- df$Value[match(world$name, df$Entity)]
bins <- c(2, 3, 4, 5, 6, 7, 8, 9)
pal <- colorBin("GnBu", domain = df$Value, bins = bins)

server <- function(input, output) {
  
  output$plot1 <- renderPlot({
    df2 <- read.csv(paste("./data_world/",input$FILE,sep=""), header = TRUE, sep = ",")
    names(df2) <- c("Entity", "Code", "Year", "NewValue")
    df3 <- inner_join(df, df2, by = NULL, copy = FALSE)
    df3$Year <- as.factor(df3$Year)
    df3$Entity <- as.factor(df3$Entity)
    df3$Continent <- countrycode(sourcevar = df3[, "Code"],
                                 origin = "iso3c",
                                 destination = "continent")
    
    df3$Continent <- as.factor(df3$Continent)
    
    df3 %>%
      filter(Year==input$TIME) %>%
      ggplot(aes(x=Value, y=NewValue, color=Continent)) +
      geom_point(size=4) +
      ggtitle(paste("Life satifaction vs", substring(input$FILE,1,nchar(input$FILE)-4), "in", toString(input$TIME))) +
      labs(x="Life satifaction", y=substring(input$FILE,1,nchar(input$FILE)-4)) +
      #geom_rug(sides ="bl") +
      theme(legend.position="right")
  }) 
  output$plot2 <- renderPlot({
    df2 <- read.csv(paste("./data_world/",input$FILE,sep=""), header = TRUE, sep = ",")
    names(df2) <- c("Entity", "Code", "Year", "NewValue")
    df3 <- inner_join(df, df2, by = NULL, copy = FALSE)
    df3$Year <- as.factor(df3$Year)
    df3$Entity <- as.factor(df3$Entity)
    df3$Continent <- countrycode(sourcevar = df3[, "Code"],
                                 origin = "iso3c",
                                 destination = "continent")
    
    df3$Continent <- as.factor(df3$Continent)
    
    df3 %>%
      filter(Year==input$TIME) %>%
      filter(Continent==input$VAR) %>%
      ggplot(aes(x=NewValue)) +
      geom_histogram(bins=10, colour="black", fill="#e5f5f9") +
      labs(x="Life satifaction", y=substring(input$FILE,1,nchar(input$FILE)-4)) +
      ggtitle(paste("Histogram of", substring(input$FILE,1,nchar(input$FILE)-4), "in", toString(input$TIME), "for", toString(input$VAR)))
  })
  output$plot3 <- renderLeaflet({ 
    
    df2 <- read.csv(paste("./data_world/",input$FILE,sep=""), header = TRUE, sep = ",")
    names(df2) <- c("Entity", "Code", "Year", "NewValue")
    df3 <- inner_join(df, df2, by = NULL, copy = FALSE)
    df3$Year <- as.factor(df3$Year)
    df3$Entity <- as.factor(df3$Entity)
    df3$Continent <- countrycode(sourcevar = df3[, "Code"],
                                 origin = "iso3c",
                                 destination = "continent")
    
    df3$Continent <- as.factor(df3$Continent)
    
    world$Value <- df3$NewValue[match(world$name, df$Entity)]
    bins <- c(2, 3, 4, 5, 6, 7, 8, 9)
    pal <- colorBin("GnBu", domain = df3$NewValue)
    
    data <- df3 %>% filter(Year==input$TIME)
    
    leaflet(world) %>%
      setView(-7, 37.8, 1) %>%
      addProviderTiles("MapBox") %>%
      addPolygons(
        fillColor = ~pal(data$NewValue[match(world$id, data$Code)]),
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
        label = sprintf(
          "<strong>%s</strong><br/>Level of life satisfaction : %g ",
          world$name, data$NewValue[match(world$id, data$Code)]
        ) %>% lapply(htmltools::HTML),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto")) %>%
      addLegend(
        pal = pal, 
        values = data$NewValue[match(world$id, data$Code)], 
        opacity = 0.7, 
        title = NULL,
        position = "bottomright")
  })
}