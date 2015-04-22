shinyServer(function(input, output) {
  # create welcome dialog with uid greeting
  output$userName <- renderText(paste("Welcome, ", user))

  # dynamically update table title based on which is selected
  output$projTableTitle <- renderText({
    paste(toString(input$projChoice))
  })
  
  # render table of specific project data
  # user chooses project from drop down menu
  output$projTable <- renderDataTable({
    myTable <- getProjectInfo(input$projChoice)

    # test for empty table, and give feedback to user
    if (nrow(myTable) == 0) {
      output$emptyTable <- renderText({
        paste("(no rows)")
      })
    }
    # if table has contents, clear 'no rows' output
    else {
      output$emptyProjTable <- renderText ({
        paste("")
      })
    }
    # display table
    myTable
  })
  
  output$expSelectText <- renderText(paste("Select an experiment in \"", 
                                           input$projChoice,
                                           "\" to view"))
  
  output$expSelect <- renderUI({
    list <- getProjExp(input$projChoice)
    if (nrow(list) == 0) {
      list <- c("(no experiments)")
    }
    selectInput("expChoice", "Select experiment", list)
  })
  
  output$expTableTitle <- renderText({
    paste(toString(input$expChoice))
  })
  
  output$expTable <- renderDataTable ({
    myTable <- getExpInfo(input$expChoice, input$projChoice)
    
    # test for empty table, and give feedback to user
    if (nrow(myTable) == 0) {
      output$emptyExpTable <- renderText({
        paste("(no rows)")
      })
    }
    # if table has contents, clear 'no rows' output
    else {
      output$emptyExpTable <- renderText ({
        paste("")
      })
    }
    # display table
    myTable
  })
  
  output$dsSelectText <- renderText(paste("Select a dataset in \"", 
                                           input$expChoice,
                                           "\" to view"))
  
  output$dsSelect <- renderUI({
    list <- getExpDS(input$expChoice, input$projChoice)
    if (nrow(list) == 0) {
      list <- c("(no data sets)")
    }
    selectInput("dsChoice", "Select data set", list)
  })
  
  output$dsTableTitle <- renderText({
    paste(toString(input$dsChoice))
  })
  
  output$dsTable <- renderDataTable ({
    myTable <- getDSInfo(input$dsChoice, input$expChoice, input$projChoice)
    
    # test for empty table, and give feedback to user
    if (nrow(myTable) == 0) {
      output$emptyDSTable <- renderText({
        paste("(no rows)")
      })
    }
    # if table has contents, clear 'no rows' output
    else {
      output$emptyDSTable <- renderText ({
        paste("")
      })
    }
    # display table
    myTable
  })
  
  output$dsCheckbox <- renderUI ({
    ds <- getExpDS(input$expChoice, input$projChoice)
    
    if (nrow(ds) == 0) {
      
    }
    else {
      output$dsVisText <- renderText("Select all data sets to visualize")
      ds <- c(do.call("cbind", ds))
      checkboxGroupInput("dsVisualize", 
                         label = "Select data set",
                         choices = ds)
    }
  })
  
  output$howManyChecked <- renderText({
    paste(input$dsVisualize, length(input$dsVisualize))
  })
  
  output$vizButton <- renderText({
    paste("Visualize ", input$expChoice)
  })
  # eventually add code to make visualize button work
  # output$visualize <-
  
})
  
  
  