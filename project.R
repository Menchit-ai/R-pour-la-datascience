library(tidyr)
library(ggplot2)
library(dplyr)
library(lubridate)

data <- read.table("abo.csv",header = TRUE, sep = ",")
#print(head(data))
#data_long <- pivot_longer(data, "Variable")

colnames(data) <- c("LOCATION","Pays","VAR","Variable","TIME","Temps","Unit Code","Unit","PowerCode Code","PowerCode","Reference Period Code","Reference Period","Value","Flag Codes","Flags")

select <- c("LOCATION","VAR","TIME","Unit Code","PowerCode Code","PowerCode","Value")
data_c <- data[select]
data_c$VAR <- as.factor(data_c$VAR)


df = read.table("abo.csv", header = TRUE, sep = ",")
colnames(df)[1] <- "LOCATION"
data <- subset(df, select=c(LOCATION, VAR, TIME, Value))
summary(data)
data$LOCATION <- as.factor(data$LOCATION)
data$VAR <- as.factor(data$VAR)
data$TIME <- as.factor(data$TIME)
summary(data)
dataTotAbo = subset(data, subset= VAR=="BB-P100-TOT")

select <- c("2016","2017","2018","2019")
data <- subset(data, subset = TIME %in% select)
data$TIME <- year(as.Date(data$TIME, format="%Y"))
data <- group_by(data,LOCATION)


write.csv(data, file = "data.csv", row.names=FALSE)
cat("\n########################\n")
cat("          Done")
cat("\n########################\n")