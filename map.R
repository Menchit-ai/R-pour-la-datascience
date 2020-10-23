library(leaflet)
library(geojsonio)
library(geojsonR)


states <- geojsonio::geojson_read("world.json", what = "sp");
class(states);

m <- leaflet(states) %>%
  addTiles() %>%
  addPolygons() %>%
  setView(-96, 37.8, 4) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))

