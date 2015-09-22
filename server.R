palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))#colors for kmean plots
library(shiny)
library(ggplot2)
library(wordcloud)
library(tm)
library("corrplot")

#define server
shinyServer(function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  #selected varials are reactive so should change as different variable selected
  selectedData <- reactive({
    mtcars[ ,c(input$xcol, input$ycol)]
  })
  factorData <- reactive({
    mtcars[ ,c(input$factor)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  #different plot selections and output
  output$plot1 <- renderPlot({
    
    if (input$plotType == "plot1"){
      plot(selectedData(),
           type = input$plotType,
           col = clusters()$cluster,
           pch = 20, cex = 3)
      points(clusters()$centers, pch = 3, cex = 4, lwd = 4)
    } else if (input$plotType == "plot2"){
      plot(selectedData(),
           col = clusters()$cluster
           
      ) }  else if(input$plotType == "plot3"){
        wordcloud(rownames(selectedData()+factorData()), min.freq=0,
                  colors=brewer.pal(7, "Accent"))
      } else if(input$plotType == "plot4"){
        hist(x=factorData(),
             breaks = as.numeric(input$n_breaks),
             main = "Histogram of factor selction")
      } else if(input$plotType == "plot5"){
        pairs(selectedData())
      } else if(input$plotType =="plot6"){
        mtscaled <-as.matrix(scale(selectedData()))
        heatmap(mtscaled,
                col = topo.colors(200, alpha=0.5),
                Colv=F, scale="none")
      } 
    
    
  })
  
  
  output$summary <- renderPrint({
    datasets <- selectedData()
    summary(datasets)#summary output of x and y
  })
  
  output$view <- renderTable({
    head(selectedData(), n=input$obs) #table view of x and y with selected number of objects
  })
  
  output$lm <- renderPrint({
    model <-lm(mpg~ factorData(), mtcars)
    
    summary(model) # linear model of factor vs set mpg variable
  })
})
