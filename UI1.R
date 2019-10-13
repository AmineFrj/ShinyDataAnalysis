ui <- fluidPage(
  titlePanel("Data Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput(inputId = "file", label = "Choose CSV File",accept = c("text/plain", ".csv")),
      actionButton(inputId = "go", label = "Load", icon("download")),
      hr(),
      selectInput("dimensionSize", "Select Dimension",c("Unidimentional","Bidimentional","Multidimentional")),
      uiOutput(outputId = "checkbox", label = "Select Columns")
      #,submitButton("Apply Changes", icon("redo-alt"))
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("table", DTOutput("table"), style = "font-size: 85%"),
        tabPanel("Nuage de points", 
                 fluidRow(
                   column(8, offset = 1, plotOutput("nuagePoints"))
                 ),
                 fluidRow(
                   column(4, offset = 3, textOutput("correlation"))
                 )
        ),
        tabPanel("Nuage de points et Histogrammes",plotOutput("nuagePointshist")),
        tabPanel("Boîtes parallèles", 
                 fluidRow(
                   column(6, plotOutput("boxplotBasic")),
                   column(6, plotOutput("boxplotGgplot"))
                 )),
        tabPanel("Diag. Barres", 
                 fluidRow(
                   column(6, plotOutput("barplotBi")),
                   column(6, plotOutput("barplotDodgeBi"))
                 )
        )
        #  fluidRow(
        #    column(4, offset = 4, textOutput("correlation"))
        #  )
      ),
      style = "font-size: 75%"
    )
  )
)