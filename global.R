#install.packages("shiny")
#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("tidyr")
#install.packages("readr")
#install.packages("gridExtra")
#install.packages("shinyWidgets")
#install.packages("countrycode")
#install.packages("leaflet")
#install.packages("geojsonio")
#install.packages("geojsonR")
#install.packages("rgdal")
#install.packages("spdplyr")
#install.packages("geojsonio")
#install.packages("rmapshaper")
#install.packages("jsonlite")
#install.packages("maps")

library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)
library(gridExtra)
library(shinyWidgets)
library(countrycode)
library(leaflet)
library(geojsonio)
library(geojsonR)
library(rgdal)
library(spdplyr)
library(geojsonio)
library(rmapshaper)
library(jsonlite)
library(maps)

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
diffyears <- df$Year %>% unique() %>% sort()


world$Value <- df$Value[match(world$name, df$Entity)]
bins <- c(2, 3, 4, 5, 6, 7, 8, 9)
pal <- colorBin("GnBu", domain = df$Value, bins = bins)


df <- df %>% mutate(Code = replace(Code, Code ==  "OWID_KOS",  "KOS"))
df <- df %>% mutate(Code = replace(Code, Code ==  "OWID_CYN",  "CYN"))
write.csv(df,file="happiness-cantril-ladder.csv")

