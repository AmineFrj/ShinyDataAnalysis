library(shiny)
library(ggplot2)
library(UsingR)
library(DT)
library(reshape)
library(Amelia)
library(psych)

source('UI.R', local = TRUE)
source('Server.R')

shinyApp(ui = ui, server = server)
