## app.R ##
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Data Analysis"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Loader", tabName = "DataLoader", icon = icon("database")),
      menuItem("Unidimentional", tabName = "Unidimentional", icon = icon("chart-pie")),
      menuItem("Bidimentional", tabName = "Bidimentional", icon = icon("chart-bar")),
      menuItem("Multidimentional", tabName = "Multidimentional", icon = icon("project-diagram")),
      menuItem("Missing Values", tabName = "miss", icon = icon("screwdriver")),
      menuItem("Logistic Regression", tabName = "LR", icon = icon("chart-line"))
    )
  ),
  dashboardBody(
    tabItems(
      
      # ----------------------------- DATA TAB -------------------------------
      
      tabItem(tabName = "DataLoader",
              fluidRow(
                column( 9, offset = 3,
                  box( title = "Data", status = "primary", solidHeader = TRUE, collapsible = TRUE, 
                       fileInput(inputId = "file", label = "Choose CSV File",accept = c("text/plain", ".csv")),
                       actionButton(inputId = "go", label = "Load", icon("download"))
                       # submitButton("Apply Changes", icon("redo-alt"))
                  )
                )
              ),
              fluidRow(
                column( 11, offset = 1,
                  box( title = "Table", solidHeader = TRUE, collapsible = TRUE, width = 11,
                       DT::dataTableOutput("table"), style = "font-size: 85%"
                  )
                )
              )
      ),
      
      # ----------------------------- 1D TAB -------------------------------

            tabItem(tabName = "Unidimentional",
              # uiOutput(outputId = "checkbox", label = "Select Columns")
              fluidRow(
                column(8, offset = 4,
                  box( title = "Variable Choice", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                      uiOutput(outputId = "checkbox1", label = "Select Columns")
                  )
                )
              ),
              fluidRow(
                box( title = "Bar Plot", status = "success", solidHeader = TRUE, collapsible = TRUE,
                  plotOutput(outputId = "effectifsDiag")
                ),
                box( title = "Cumulative Diagram", status = "success", solidHeader = TRUE, collapsible = TRUE,
                     plotOutput(outputId = "effectifsCumDiag")
                ),
                box( title = "Box Plot", status = "success", solidHeader = TRUE, collapsible = TRUE,
                  plotOutput(outputId = "boiteMoustaches")
                ),
                box( title = "Effectives Diagram", status = "success", solidHeader = TRUE, collapsible = TRUE,
                  plotOutput("colonnes")
                ),
                box( title = "Pie", status = "success", solidHeader = TRUE, collapsible = TRUE,
                  plotOutput("secteurs")
                ),
                box( title = "Contents", status = "success", solidHeader = TRUE, collapsible = TRUE,
                  tableOutput(outputId = "contents")
                )
              )
        ),
      
      # ----------------------------- 2D TAB -------------------------------
      
      tabItem(tabName = "Bidimentional",
              fluidRow(
                column(8, offset = 4,
                  box( title = "Variables Choice", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                      uiOutput(outputId = "checkbox2", label = "Select Columns")
                  )
                )
              ),
              fluidRow(
                # box( title = "Nuage de points", status = "success", solidHeader = TRUE, collapsible = TRUE,
                #     fluidRow(
                #       column(8, offset = 1, plotOutput("nuagePoints"))
                #     ),
                #     fluidRow(
                #       column(4, offset = 3, textOutput("correlation"))
                #       )
                #     ),
                box( title = "Nuage de points et Histogrammes", status = "success", solidHeader = TRUE, collapsible = TRUE, width = 9,
                    plotOutput("nuagePointshist")
                ),
                box( title = "Diag. Barres", status = "success", solidHeader = TRUE, collapsible = TRUE, width = 9,
                     fluidRow(
                       column(6, plotOutput("barplotBi")),
                       column(6, plotOutput("barplotDodgeBi"))
                     )
                ),
                # box( title = "Missing Values", status = "success", solidHeader = TRUE, collapsible = TRUE, width = 3,
                #      tableOutput("force")
                # )
                
                
                #  fluidRow(
                #    column(4, offset = 4, textOutput("correlation"))
                #  )
              )
      ),
      
      # ----------------------------- +D TAB -------------------------------
      
      tabItem(tabName = "Multidimentional",
              fluidRow(
                column(8, offset = 2,
                       box( title = "Variables Choice", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                            uiOutput(outputId = "checkbox3", label = "Select Columns")
                       ),
                       box( title = "Info", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                         textOutput("info")
                       )
                ),
              ),
              fluidRow(
                box( title = "Boîtes parallèles", status = "success", solidHeader = TRUE, collapsible = TRUE, width = 12,
                     fluidRow(
                       column(6, plotOutput("boxplotBasic")),
                       column(6, plotOutput("boxplotGgplot"))
                     )
                )
              ),
              fluidRow(
                box( title = "caract", status = "success", solidHeader = TRUE, collapsible = TRUE,
                     tableOutput("caract")
                )
              )
      ),
      
      # ----------------------------- MISS TAB -------------------------------
      
      tabItem(tabName = "miss",
              box( title = "Missing Values", status = "success", solidHeader = TRUE, collapsible = TRUE, width = 8,
                  plotOutput(outputId = "miss")
              )
      ),
      
      tabItem(tabName = "LR",
              fluidRow(
                
                       box( title = "Remove vars", status = "warning", solidHeader = TRUE, collapsible = TRUE, width = 4,
                            uiOutput(outputId = "checkboxChurn")
                       ),
                
                       box( title = "Churn Variable", status = "success", solidHeader = TRUE, collapsible = TRUE, width = 4,
                            uiOutput(outputId = "checkboxChurn1")
                       ),

                box( title = "Informations", status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 4,
                     textOutput("info2")
                )
              ),
              fluidRow(
                box( title = "Churn Prediction", status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 7,
                     verbatimTextOutput(outputId = "churnPred")
                )
              )
      )
    )
  )
)


