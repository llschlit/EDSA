shinyServer(function(input, output) {
  # create welcome dialog with uid greeting
  output$userName <- renderText(paste("Welcome, ", user))
  output$expSelectText <- renderText(paste("Select which experiments to visualize from ", 
                                          input$projChoice))
  
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
      output$emptyTable <- renderText ({
        paste("")
      })
    }
    # display table
    myTable
  })
  
  # dynamically update table title based on which is selected
  output$projTableTitle <- renderText({
    paste(toString(input$projChoice))
  })
  
  output$expTableTitle <- renderText({
    paste(toString(input$expChoice))
  })
  
  output$expSelect <- renderUI({
    list <- getProjExp(input$projChoice)
    if (nrow(list) == 0) {
      list <- c("(no experiments)")
    }
    selectInput("expChoice", "Select experiment", list)
  })
  
  # eventually add code to make visualize button work
  # output$visualize <-
  
})
  
  
  