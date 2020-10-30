
ui <- fluidPage(
  titlePanel("On what depends life satifaction ?"),
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput("TIME", "Select Year", choices = 
                    diffyears, selected = diffyears[0]
      ),
      
      selectInput("FILE", "Choose a file to compare", choices=
                    files, selected = files[0]
      ),
      
      selectInput(inputId = "VAR",
                  label = "Category",
                  choices = c(levels(df3$Continent),"All"),
                  selected = levels(df3$Continent)[0]
      )
    ),
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  tabPanel("Plot1", plotOutput(outputId = "plot1")),
                  tabPanel("Histo", plotOutput(outputId = "plot2")),
                  tabPanel("Plot3", leafletOutput("plot3"))
      )
    )
  )
)