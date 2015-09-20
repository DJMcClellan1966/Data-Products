library(shiny)
library(ggplot2)


#define the ui
shinyUI(pageWithSidebar(
  headerPanel('MTCARS'),
 
  sidebarPanel(
    helpText("Create Different plots, summary data, tables, and linear model
             based on different selections on the mtcars dataset."),
    selectInput('xcol', 'X Variable', names(mtcars)),#create dropdown to select x
    
    selectInput('ycol', 'Y Variable', names(mtcars),#create dropdown to select y
                selected=names(mtcars)[[2]]),
    
    selectInput('factor', 'Factor', names(mtcars),#create dropdown for variety 
                selected = names(mtcars)[[3]]),
   
  
    selectInput(inputId = "n_breaks",
                label = "Number of bins in Histogram",
                choices = c(8,11, 16, 24, 32),
                selected =  8),# of breaks if hist plot selected
    
    numericInput('clusters', 'Cluster count', 3,
                 min = 1, max = 31),# cluster selection up to 31
    
    numericInput("obs", "Number of observations to view:", 10),
    
    radioButtons("plotType", "Select plot type",
                 c("plot with kmeans: x and y, clusters" = "plot1",
                   "plot without kmeans: x and y " = "plot2",
                   "wordCloud: no choices" = "plot3",
                   "Histogram: factor and # bins" = "plot4",
                   "pairs: x and y" = "plot5",
                   "heatmap: x and y" = "plot6")#different plot selections
                   
    )),
  mainPanel(
    tabsetPanel(
      tabPanel("plot", plotOutput('plot1')),#to view plots
      tabPanel("Summary:
               choose x and y, number of observations",
               verbatimTextOutput("summary")),#summary of x and y 
      tabPanel("Table:
               choose x and y, number of observations", tableOutput('view')),#table of x and y
      tabPanel("linearmodel:
               choose factor vs set mpg", verbatimTextOutput("lm"))#linear model of factor vs mpg
    )
  )
))
