shinyServer(function(input, output) {
  # create welcome dialog with uid greeting
  output$userName <- renderText(paste("Welcome, ", user))
  output$expSelectText <- renderText(paste("Select which experiments to visualize from ", 
                                          input$projectChoice))
  
  # render table of specific project data
  # user chooses project from drop down menu
  output$table <- renderDataTable({
    myTable <- getProjectInfo(input$projectChoice)

    # test for empty table, and give feedback to user
    if (nrow(myTable) == 0) {
      output$emptyTable <- renderText({
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
  output$tableTitle <- renderText({
    paste(toString(input$projectChoice))
  })
  
  output$test <- renderUI({
    list <- getProjExp(input$projectChoice)
    if (nrow(list) == 0) {
      list <- c("---")
    }
    selectInput("expChoice", "Select experiment to visualize", list)
  })
  
})
  
  
  