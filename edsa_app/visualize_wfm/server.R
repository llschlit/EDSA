
shinyServer(function(input, output) {
  output$projTitle <- renderText(paste("Project: ", projTitle))
  output$expTitle <- renderText(paste("Experiment: ", expTitle))
  
  ds <- reactive({
    ds <- loadDSInfo(input$dsSelect)
  })
  
  wfm <- reactive ({
    theData <- loadWfm(input$dsSelect)
  })
  
  x <- reactive ({
    x <- seq(from = 0, to = (nrow(wfm()) * ds()$dt), length.out = nrow(wfm()))
  })

  xUnit <- reactive ({
    xu <- parseUnits(toString(ds()$xunit))
  })
  
  yUnit <- reactive ({
    yu <- parseUnits(toString(ds()$yunit))
    yu[input$colChoice]
  })
  
  y <- reactive ({
    # convert list object into a vector
    y <- c(do.call("cbind", wfm()[input$colChoice]))
  })
  
  output$dsSelect <- renderUI({
    list <- getWfmDS()
    if (nrow(list) == 0) {
      list <- c("(no data sets)")
    }
    selectInput("dsSelect", "Select data set", list)
  })
  
  output$colSelect <- renderUI ({
    l <- list(colnames(wfm()))
    l <- c(do.call("cbind", l))
    if (length(l) == 0) {
      l <- c("(empty data set)")
    }
    selectInput("colChoice", "Select column", l)
  })
  
  output$xSlider <- renderUI ({
    xMin <- min(x())
    xMax <- max(x())
    sliderInput("xRange", label = "x range", 
                  min = xMin, max = xMax, 
                  value = c(xMin, xMax)
    )
  })
    
  output$ySlider <- renderUI ({
    yMin <- min(y())
    yMax <- max(y())
    sliderInput("yRange", label = "y range", 
                  min = yMin, max = yMax, 
                  value = c(yMin, yMax)
    )
  })  
  
  output$plot <- renderPlot ({
    plot(x(), y(), type='l', 
         xlim = c(input$xRange[1], input$xRange[2]), 
         ylim = c(input$yRange[1], input$yRange[2]),
         main = input$colChoice,
         ylab = paste(yUnit()),
         xlab = paste("dt = ", toString(ds()$dt), xUnit())
    )
  })
  
  output$dsNotes <- renderText ({
    paste("Notes: ", ds()$notes)
  })
})

  



