library(shiny)
#library(gapminder)
library(dplyr)
library(ggplot2)
library(tidyr)
<<<<<<< HEAD
=======

#install.packages("gridExtra")
library(gridExtra)

#install.packages("shinyWidgets")
>>>>>>> dae407e0594ea61a6ba813f7af6047f1897b8338
library(shinyWidgets)

df = read.table("abo.csv", header = TRUE, sep = ",")
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

ui <- fluidPage(
    titlePanel("Total Abo par pays"),
    mainPanel(plotOutput(outputId = "plot"))
)

server <- function(input, output) {
    output$plot <- renderPlot({
        dataTotAbo %>%
            filter(TIME=="2016") %>%
            ggplot(aes(x=LOCATION, y=Value, color=LOCATION)) +
            geom_point() +
            theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
    })
}

shinyApp(ui = ui, server = server)

################

ui <- fluidPage(
    titlePanel("Total Abo par pays"),
    sidebarLayout(
        sidebarPanel(
            sliderTextInput(inputId = "TIME",
                        label = "Year",
                        grid = TRUE,
                        choices = levels(dataTotAbo$TIME)
            ),
            sliderTextInput(inputId = "VAR",
                            label = "Category",
                            grid = TRUE,
                            choices = levels(data$VAR)
            )
        ),
        mainPanel(
            plotOutput(outputId = "plot"),
            plotOutput(outputId = "plot2")
        )
    )
)

server <- function(input, output) {
    output$plot <- renderPlot({
        dataTotAbo %>%
            filter(TIME==input$TIME) %>%
            ggplot() +
            geom_bar(aes(LOCATION, Value, fill=LOCATION), stat = "identity") +
            theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
    }) 
    output$plot2 <- renderPlot({
        data %>%
            filter(VAR==input$VAR) %>%
            ggplot() +
            geom_bar(aes(TIME, Value, fill=TIME), stat = "identity") +
            theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
    })
<<<<<<< HEAD
    output$plot2 <- renderPlot({
        dataTotAbo %>%
            filter(TIME==input$TIME) %>%
            ggplot(aes(x=LOCATION, y=Value, color=LOCATION)) +
            geom_point() +
            theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
    })
=======

>>>>>>> dae407e0594ea61a6ba813f7af6047f1897b8338
}

shinyApp(ui = ui, server = server)


