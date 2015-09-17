library(shiny)
library(ggplot2)


shinyUI(pageWithSidebar(
  headerPanel('MTCARS'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', names(mtcars)),
    selectInput('ycol', 'Y Variable', names(mtcars),
                selected=names(mtcars)[[2]]),
    numericInput('clusters', 'Cluster count', 3,
                 min = 1, max = 31),
   
    numericInput("obs", "Number of observations to view:", 10)  
  ),
  mainPanel(
    tabsetPanel(
    tabPanel("plot", plotOutput('plot1')),
    tabPanel("Summary", verbatimTextOutput("summary")),
    tabPanel("Table", tableOutput('view'))
    )
  )
))
