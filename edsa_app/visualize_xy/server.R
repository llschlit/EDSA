
shinyServer(function(input, output) {
  output$projTitle <- renderText(paste("Project: ", projTitle))
  output$expTitle <- renderText(paste("Experiment: ", expTitle))
  
  # loads data_set metadata for x axis choice
  xDS <- reactive ({
    if(input$addDS) {
      xDS <- loadDSInfo(input$xDSChoice)
    }
  })
  
  # loads data_set metadata for x axis choice
  yDS <- reactive ({
    if(!is.null(input$yDSChoice)) {
      yDS <- loadDSInfo(input$yDSChoice)
    }
  })
  
  # loads data to plot on x axis
  xData <- reactive ({
    if(!input$addDS) {
        x <- seq(1:nrow(yData()))
    }
    else {
      theData <- loadXY(input$xDSChoice)
    }
  })
  
  # loads data to plot on y axis
  yData <- reactive ({
    if(!is.null(input$yDSChoice)) {
      theData <- loadXY(input$yDSChoice)
    }
  })
  
  # retreives x unit
  xUnit <- reactive ({
    if(input$addDS) {
      l <- parseUnits(toString(xDS()$yunit))
      xu <- l[input$xChoice]
      paste(input$xDSChoice, "(", input$xChoice, "[", xu, "]", ")")
    }
    else {
      yDS()$xunit
    }
  })
  
  # retreives y unit
  yUnit <- reactive ({
    l <- parseUnits(toString(yDS()$yunit))
    yu <- l[input$yChoice]
    paste(input$yDSChoice, "(", input$yChoice, "[", yu, "]", ")")
  })
  
  # create the x data_set drop down menu
  output$xDSSelect <- renderUI ({
    l <- getXYDS()
    if (nrow(l) == 0) {
      l <- c("(no data sets)")
    }
    selectInput("xDSChoice", "Select data set", l)
  })
  
  # create the drop down menu to allow user to select 
  # which column of the selected data set to graph on x axis
  output$xAxisSelect <- renderUI ({
    l <- list(colnames(xData()))
    l <- c(do.call("cbind", l))
    if (length(l) == 0) {
      l <- c("(empty data set)")
    }
    selectInput("xChoice", "Select column", l)
  })
  
  # create the y data_set drop down menu
  output$yDSSelect <- renderUI ({
    l <- getXYDS()
    if (nrow(l) == 0) {
      l <- c("(no data sets)")
    }
    selectInput("yDSChoice", "Select data set", l)
  })
  
  # create the drop down menu to allow user to select 
  # which column of the selected data set to graph on y axis
  output$yAxisSelect <- renderUI ({
    l <- list(colnames(yData()))
    l <- c(do.call("cbind", l))
    if (length(l) == 0) {
      l <- c("(empty data set)")
    }
    selectInput("yChoice", "Select column", l)
  })
  
  # generate the plot based on user input
  output$graph <- renderPlot ({
    if (input$addDS) {
      x <- c(do.call("cbind", xData()[input$xChoice]))
    }else {
      x <- xData()
    }
    y <- c(do.call("cbind", yData()[input$yChoice]))
    plot(x, y, pch=20,
      #   xlim = c(input$xRange[1], input$xRange[2]), 
      #   ylim = c(input$yRange[1], input$yRange[2]),
         xlab = xUnit(), 
         ylab = yUnit()
    )
  })
  
  output$xSlider <- renderUI ({
    xMin <- min(xData())
    xMax <- max(xData())
    sliderInput("xRange", label = "x range", 
                min = xMin, max = xMax, 
                value = c(xMin, xMax)
    )
  })
  
  output$ySlider <- renderUI ({
    yMin <- min(yData())
    yMax <- max(yData())
    sliderInput("yRange", label = "y range", 
                min = yMin, max = yMax, 
                value = c(yMin, yMax)
    )
  }) 
  
  # check box for user to plot y data against different data set
  # on the x axis
  output$addDSUI <- renderUI ({
    if (input$addDS) {
      div("Select data to graph on the x axis:",
          br(),
          uiOutput("xDSSelect"),
          uiOutput("xAxisSelect"),
          style = "border: solid lightgray 1px; margin-bottom: 10px; padding: 10px"
      )
    }
  })


})

  



