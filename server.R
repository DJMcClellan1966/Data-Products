library(shiny)
library(ggplot2)
library(wordcloud)

shinyServer(function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    mtcars[, c(input$xcol, input$ycol)]
  })
  factorData <- reactive({
   mtcars[,c(input$factor)] 
  })  
  
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
 
  
  output$plot1 <- renderPlot({
    
    if (input$plotType == "plot1"){
    plot(selectedData(),
         type = input$plotType,
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    } else if (input$plotType == "plot2"){
          plot.default(selectedData(),
                       type= input$plotType)
               
    } else if(input$plotType == "plot3"){
      wordcloud(rownames(mtcars), min.freq=1,
                colors=brewer.pal(7, "Accent"))
    } else if(input$plotType == "plot4"){
                 hist(x=factorData(),
                      breaks = as.numeric(input$n_breaks),
                      main = "Histogram of factor selction")
               }
  })
  
  output$summary <- renderPrint({
    datasets <- selectedData()
    summary(datasets)
  })
  
  output$view <- renderTable({
    head(selectedData(), n=input$obs)
})
  
  output$lm <- renderPrint({
    model <-lm(mpg~ factorData(), mtcars)
    summary(model)
    })
    })
