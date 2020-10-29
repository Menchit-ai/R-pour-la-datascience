library(shiny)
#library(gapminder)
library(dplyr)
library(ggplot2)
library(tidyr)

#install.packages("gridExtra")
library(gridExtra)

#install.packages("shinyWidgets")
library(shinyWidgets)

library(countrycode)

df = read.table("data_world/data.csv", header = TRUE, sep = ",")
colnames(df)[1] <- "LOCATION"
data <- subset(df, select=c(LOCATION, VAR, TIME, Value))
summary(data)
data$LOCATION <- as.factor(data$LOCATION)
data$VAR <- as.factor(data$VAR)
data$TIME <- as.factor(data$TIME)
summary(data)
dataTotAbo = subset(data, subset= VAR=="BB-P100-TOT")

#df = read.table("data_c.csv", header = TRUE, sep = ",")
#df$VAR = as.factor(df$VAR)
#dataTotAbo_c = subset(df, subset= VAR=="BB-P100-TOT")

p <- ggplot(dataTotAbo, aes(x=LOCATION, y=Value, color=LOCATION))
p <- p + geom_point()
p <- p + facet_wrap(~TIME, ncol=4)
p <- p + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))

df = read.table("data_world/happiness-cantril-ladder.csv", header = TRUE, sep = ",")
names(df) <- c("Entity", "Code", "Year", "Life.Satisfaction")

df2 = read.table("data_world/human-development-index.csv", header = TRUE, sep = ",")
names(df2) <- c("Entity", "Code", "Year", "IDH")

df3 = inner_join(df, df2, by = NULL, copy = FALSE)
df3$Year <- as.factor(df3$Year)
df3$Entity <- as.factor(df3$Entity)

df3 <- df3 %>% mutate(Entity = replace(Entity, Entity ==  "Timor",  "Timor-Leste"))
df3 <- df3 %>% mutate(Entity = replace(Entity, Entity ==  "Micronesia (country)",  "Micronesia"))

df3$Continent <- countrycode(sourcevar = df3[, "Entity"],
                            origin = "country.name",
                            destination = "continent")

df3$Continent <- as.factor(df3$Continent)

################

ui <- fluidPage(
    titlePanel("Total Abo par pays"),
    sidebarLayout(
        sidebarPanel(
            sliderTextInput(inputId = "TIME",
                        label = "Year",
                        grid = TRUE,
                        choices = levels(df3$Year)#dataTotAbo$TIME
            ),
            sliderTextInput(inputId = "VAR",
                            label = "Category",
                            grid = TRUE,
                            choices = levels(df3$Continent)
            )
        ),
        mainPanel(
            
            tabsetPanel(type = "tabs",
                        tabPanel("Plot1", plotOutput(outputId = "plot1")),
                        tabPanel("Histo", plotOutput(outputId = "plot2")),
                        tabPanel("Plot3", plotOutput(outputId = "plot3"))
            )
            #plotOutput(outputId = "plot"),
            #plotOutput(outputId = "plot2")
        )
    )
)

server <- function(input, output) {
    output$plot1 <- renderPlot({
        df3 %>%
            filter(Year==input$TIME) %>%
            ggplot(aes(x=Life.Satisfaction, y=IDH, color=Continent)) +
            geom_point(size=4) +
            ggtitle(paste("Life satifaction vs Human development index in", toString(input$TIME))) +
            labs(x="Life satifaction", y="Human development index") +
            #geom_rug(sides ="bl") +
            theme(legend.position="right")
    }) 
    output$plot2 <- renderPlot({
        df3 %>%
            filter(Year==input$TIME) %>%
            filter(Continent==input$VAR) %>%
            ggplot(aes(x=Life.Satisfaction)) +
            geom_histogram(bins=10, colour="black", fill="#e5f5f9") +
            ggtitle(paste("Histogram of life satisfaction in", toString(input$TIME), "for", toString(input$VAR)))
    })
    output$plot3 <- renderPlot({
        df3 %>%
            filter(Year==input$TIME) %>%
            ggplot() +
            geom_bar(aes(Entity, IDH, fill=Entity), stat = "identity") +
            theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
    })
}

shinyApp(ui = ui, server = server)


