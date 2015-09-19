library(shiny)
library(ggplot2)
library(wordcloud)
library("corrplot")


shinyServer(function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    mtcars[, c(input$xcol, input$ycol)]
  })
  factorData <- reactive({
    mtcars[,c(input$factor)] 
  })
split.data <- function(mtcars, p=.75, s= 2015){
  set.seed(s)
  index <- sample(1:dim(mtcars)[1])
  train <- mtcars[index[1:floor(dim(mtcars)[1]*p)], ]
  test <- mtcars[index[((ceiling(dim(mtcars)[1]*p)) +
                          1):dim(mtcars)[1]],]
}  
  
all.set <- split.data(mtcars, p=0.7)
trainset <- all.set$train
testset <- all.set$test

  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  
  
  output$plot1 <- renderPlot({
    
    if (input$plotType == "plot1"){
      plot(selectedData(),
           type = input$plotType,
           col = clusters()$cluster,
           pch = 20, cex = 3)
      points(clusters()$centers, pch = 3, cex = 4, lwd = 4)
    } else if (input$plotType == "plot2"){
      plot.default(selectedData(),
                   type= input$plotType
   ) }  else if(input$plotType == "plot3"){
      wordcloud(rownames(mtcars), min.freq=1,
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
    } else if(input$plotType == "plot7"){
      
      p <- ggplot(factorData(), aes_string(x=input$xcol, y=input$ycol)) + geom_point()
      
      if (input$factor != 'None')
        p <- p + aes_string(color=input$factor)
      
      facets <- paste(input$facet_row, '~', input$facet_col)
      if (facets != '. ~ .')
        p <- p + facet_grid(facets)
      
      if (input$jitter)
        p <- p + geom_jitter()
      if (input$smooth)
        p <- p + geom_smooth()
      
      print(p)
      
    
  
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
