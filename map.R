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



#county <- readOGR(dsn = "C:/Users/thoma/Documents/E4/4101_C R and data visualization/projet-dsia_4101c-r/world.json",
          #layer = "world", verbose = FALSE)

world <- geojson_read("world.geojson",what="sp")









stop("Execution ended")


world <- geojsonio::geojson_read("world.json", what = "sp")
world$features <- seq(1,180)


m <- leaflet(world) %>%
  #addTiles() %>%
  setView(40, 3, 1.8) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))

bins <- c(0,50,100,150,200,Inf)
pal <- colorBin("YlOrRd", domain = world$features, bins = bins)

m %>% addPolygons(
  fillColor = ~pal(density),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7)

