

shinyServer(function(input, output) {
  output$userName <- renderText(paste("Welcome, ", user))
  
  output$plot <- renderPlot ({
    result <- getWaveform('jbrown10210007', 'v_25')
    # get x domain
    count <- nrow(result)
    # generate x values
    x <- seq(1:count)
    # convert list object into a vector
    y <- c(do.call("cbind", result))
    # wfm <- cbind(x,y)
    plot(x, y, type='l', 
         xlim = c(input$xRange[1], input$xRange[2]), 
         ylim = c(input$yRange[1], input$yRange[2]))
  })

  output$xSlider <- renderUI ({
    result <- getWaveform('jbrown10210007', 'v_25')
    # get x domain
    count <- nrow(result)
    # generate x values
    x <- seq(1:count)
    xMin <- min(x)
    xMax <- max(x)
    sliderInput("xRange", label = "x range", min = xMin, max = xMax, value = c(xMin, xMax))
  })
  
  output$ySlider <- renderUI ({
    result <- getWaveform('jbrown10210007', 'v_25')
    # convert list object into a vector
    y <- c(do.call("cbind", result))
    yMin <- min(y)
    yMax <- max(y)
    sliderInput("yRange", label = "y range", min = yMin, max = yMax, value = c(yMin, yMax))
  })  

})