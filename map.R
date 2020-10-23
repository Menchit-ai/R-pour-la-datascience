library(leaflet)
library(geojsonio)
library(geojsonR)


states <- geojsonio::geojson_read("world.json", what = "sp")
class(states)


m <- leaflet(states) %>%
  addTiles() %>%
  addPolygons() %>%
  setView(40, 3, 1.8) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))

