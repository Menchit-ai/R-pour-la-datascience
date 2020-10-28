library(countrycode)
library(dplyr)

df = read.table("data_world/human-development-index.csv", header = TRUE, sep = ",")
names(df2) <- c("Entity", "Code", "Year", "IDH")

df <- df %>% mutate(Entity = replace(Entity, Entity ==  "Timor",  "Timor-Leste"))
df <- df %>% mutate(Entity = replace(Entity, Entity ==  "Micronesia (country)",  "Micronesia"))


df$continent <- countrycode(sourcevar = df[, "Entity"],
                            origin = "country.name",
                            destination = "continent")
#warning
#In countrycode(sourcevar = df[, "country"], origin = "country.name",  :
#  Some values were not matched unambiguously: Micronesia (country), Timor