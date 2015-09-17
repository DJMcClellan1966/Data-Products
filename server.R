library(shiny)
library(ggplot2)
library(wordcloud)

shinyServer(function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    mtcars[, c(input$xcol, input$ycol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
 
  
  output$plot1 <- renderPlot({
    par(mar = c(5.1, 4.1, 0, 1))
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
      wordcloud(rownames(mtcars), min.freq=1)
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
    model <- lm(input$factor~input$xcol, data= mtcars)
    summary(model)
  })
})
  })
  
  output$summary <- renderPrint({
    datasets <- selectedData()
    summary(datasets)
  })
  
  output$view <- renderTable({
    head(selectedData(), n=input$obs)
})
  
  output$lm <- renderPrint({
    model <- lm(input$factor~input$xcol, data= mtcars)
    summary(model)
  })
})

  output$view <- renderTable({
    head(selectedData(), n=input$obs)
  })
})
