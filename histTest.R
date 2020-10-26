df = read.table("data_world/happiness-cantril-ladder.csv", header = TRUE, sep = ",")
names(df) <- c("Entity", "Code", "Year", "Life.Satisfaction")

colnames(df)

df2 = read.table("data_world/human-development-index.csv", header = TRUE, sep = ",")
names(df2) <- c("Entity", "Code", "Year", "IDH")

colnames(df2)

df3 = inner_join(df, df2, by = NULL, copy = FALSE)

colnames(df3)

df3$Year <- as.factor(df3$Year)
levels(df3$Year)

p <- ggplot(df3, aes(x=Life.Satisfaction, y=IDH, color=Entity))
p = p + geom_point()
p = p + ggtitle("Life satifaction vs Human development index")
p = p + labs(x="Life satifaction", y="Human development index")

p

p2 <- ggplot(df3, aes(x=Life.Satisfaction))
p2 = p2 + geom_histogram(bins=10, colour="black", fill="#e5f5f9")
p2 = p2 + ggtitle("Life Satisfaction")

p2