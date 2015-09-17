
 library(shiny)
library(ggplot2)


shinyUI(pageWithSidebar(
  headerPanel('MTCARS'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', names(mtcars)),
    
    selectInput('ycol', 'Y Variable', names(mtcars),
                selected=names(mtcars)[[2]]),
    
    selectInput('factor', 'Factor', names(mtcars),
                selected = names(mtcars)[[3]]),
    
    selectInput(inputId = "n_breaks",
                label = "Number of bins in Histogram",
                choices = c(8, 16, 24, 32),
                selected =  16),
    
    numericInput('clusters', 'Cluster count', 3,
                 min = 1, max = 31),
    
    numericInput("obs", "Number of observations to view:", 10),
    
    radioButtons("plotType", "Select plot type",
                 c("plot with kmeans" = "plot1",
                   "plot without kmeans" = "plot2",
                   "wordCloud" = "plot3",
                   "Histogram" = "plot4")
  )),
  mainPanel(
    tabsetPanel(
      tabPanel("plot", plotOutput('plot1')),
      tabPanel("Summary", verbatimTextOutput("summary")),
      tabPanel("Table", tableOutput('view')),
      tabPanel("linearmodel", verbatimTextOutput("lm"))
    )
  )
))
