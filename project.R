library(tidyr)
library(ggplot2)

data <- read.table("abo.csv",header = TRUE, sep = ",")
#print(head(data))
#data_long <- pivot_longer(data, "Variable")

colnames(data) <- c("LOCATION","Pays","VAR","Variable","TIME","Temps","Unit Code","Unit","PowerCode Code","PowerCode","Reference Period Code","Reference Period","Value","Flag Codes","Flags")

select <- c("LOCATION","VAR","TIME","Unit Code","PowerCode Code","PowerCode","Reference Period Code","Value")
data_c <- data[select]

print(summary(data_c))


write.csv(data_c, file = "data_c.csv", row.names=FALSE)
cat("\n########################\n")
cat("          Done")
cat("\n########################\n")