ui <- fluidPage(
  titlePanel("On what depends life satifaction ?"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "TIME",
        "Select Year",
        choices =
          diffyears,
        selected = diffyears[0]
      ),
      
      selectInput(
        "FILE",
        "Choose a file to use",
        choices =
          files,
        selected = files[0]
      ),
      
      selectInput(
        inputId = "VAR",
        label = "Category (has only an effect on the histogram)",
        choices = c(levels(df3$Continent), "All"),
        selected = "All"
      )
    ),
    mainPanel(tabsetPanel(
      type = "tabs",
      tabPanel("Graph", plotOutput(outputId = "plot1")),
      tabPanel("Histo", plotOutput(outputId = "plot2")),
      tabPanel("Map", leafletOutput("plot3"))
    ))
  )
)