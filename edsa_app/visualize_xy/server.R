
shinyServer(function(input, output) {
  output$projTitle <- renderText(paste("Project: ", projTitle))
  output$expTitle <- renderText(paste("Experiment: ", expTitle))
  
  # loads data_set metadata
  ds <- reactive ({
    ds <- loadDSInfo(input$dsChoice)
  })
  
  cols <- reactive ({
    cols <- loadDSColNames(toString(ds()$location))
  })
  
  # loads data to plot on x axis
  xData <- reactive ({
    if(!input$addDS) {
      x <- seq(1:length(yData()))
    }
    else {
      theData <- loadXY(input$dsChoice)
      x <- c(do.call("cbind", theData[input$xChoice]))
    }
  })
  
  # loads data to plot on y axis
  yData <- reactive ({
    if(!is.null(input$dsChoice)) {
      theData <- loadXY(input$dsChoice)
      y <- c(do.call("cbind", theData[input$yChoice]))
    }
  })
  
  # retreives x unit
  xUnit <- reactive ({
    if(input$addDS) {
      l <- parseUnits(toString(ds()$yunit))
      xu <- l[input$xChoice]
      paste(input$xChoice, "[", xu, "]")
    }
    else {
      ds()$xunit
    }
  })
  
  # retreives y unit
  yUnit <- reactive ({
    l <- parseUnits(toString(ds()$yunit))
    yu <- l[input$yChoice]
    paste(input$yChoice, "[", yu, "]")
  })
  
  # create the data_set drop down menu
  output$dsSelect <- renderUI ({
    l <- getXYDS()
    if (nrow(l) == 0) {
      l <- c("(no data sets)")
    }
    selectInput("dsChoice", "Select data set", l)
  })
  
  # create the drop down menu to allow user to select 
  # which column of the selected data set to graph on y axis
  output$yAxisSelect <- renderUI ({
    l <- cols()
    if (nrow(l) == 0) {
      l <- c("(empty data set)")
    }
    selectInput("yChoice", "Select column", l)
  })
  
  # create the drop down menu to allow user to select 
  # which column of the selected data set to graph on x axis
  output$xAxisSelect <- renderUI ({
    l <- cols()
    if (nrow(l) == 0) {
      l <- c("(empty data set)")
    }
    selectInput("xChoice", "Select column", l)
  })
  
  output$checkBoxPrompt <- renderText ({
    paste("Plot against another column in ", input$dsChoice )
  })
  
  # check box for user to plot y data against different data set
  # on the x axis
  output$addDSUI <- renderUI ({
    if (input$addDS) {
      div("Select data to graph on the x axis:",
          br(),
          uiOutput("xAxisSelect"),
          style = "border: solid lightgray 1px; margin-bottom: 10px; padding: 10px"
      )
    }
  })
  
  # generate the plot based on user input
  output$graph <- renderPlot ({
    x <- xData()
    y <- yData()
    if(input$graphType == 2) {
      plot(x, y, pch=20, type = 'l',
           xlim = c(input$xRange[1], input$xRange[2]), 
           ylim = c(input$yRange[1], input$yRange[2]),
           main = input$dsChoice,
           xlab = xUnit(), 
           ylab = yUnit()
      )
    }
    else {
      plot(x, y, pch=20,
           xlim = c(input$xRange[1], input$xRange[2]), 
           ylim = c(input$yRange[1], input$yRange[2]),
           main = input$dsChoice,
           xlab = xUnit(), 
           ylab = yUnit()
      )
    }
  })
  
  output$xSlider <- renderUI ({
    xMin <- min(xData())
    xMax <- max(xData())
    sliderInput("xRange",   label = "x range", 
                min = xMin, max = xMax, 
                value = c(xMin, xMax),
                width = "100%"
    )
  })
  
  output$ySlider <- renderUI ({
    yMin <- min(yData())
    yMax <- max(yData())
    sliderInput("yRange",   label = "y range", 
                min = yMin, max = yMax, 
                value = c(yMin, yMax),
                width = "100%"
    )
  }) 

})

  



