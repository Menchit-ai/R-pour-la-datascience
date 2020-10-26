library(leaflet)
library(geojsonio)
library(geojsonR)

#install.packages(rgdal)
#install.packages(spdplyr)
#install.packages(geojsonio)
#1install.packages(rmapshaper)
library(rgdal)
library(spdplyr)
library(geojsonio)
library(rmapshaper)
library(jsonlite)

df = read.table("data_world/happiness-cantril-ladder.csv", header = TRUE, sep = ",")

#rename(df, Life.Satisfaction = Life.satisfaction.in.Cantril.Ladder..World.Happiness.Report.2019.)

names(df) <- c("Entity", "Code", "Year", "Life.Satisfaction")

colnames(df)

world <- geojsonio::geojson_read("world.json", what = "sp")

m <- leaflet(world) %>%
  setView(-7, 37.8, 1) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))

bins <- c(2, 3, 4, 5, 6, 7, 8)
pal <- colorBin("YlOrRd", domain = df$Life.Satisfaction, bins = bins)

m %>% addPolygons(
  fillColor = ~pal(df$Life.Satisfaction),
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
    bringToFront = TRUE))

