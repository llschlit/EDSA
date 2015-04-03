shinyUI(fluidPage(
  titlePanel("EDSA"
  ),
  
  sidebarLayout(
    sidebarPanel(
      div("Below are listed the projects that you are associated with.",
          br(),
          br(),
          selectInput("projectChoice", "Select project to view", getUserProjects()),
          style = "border: solid lightgray 1px; margin-bottom: 10px; padding: 10px"),
      
      div(textOutput("expSelectText"),
          br(),
          uiOutput("test"),
          style = "border: solid lightgray 1px; padding: 10px")
      
    ), # end sidebarPanel
    
    mainPanel(
      h1(textOutput("userName"), style = "border-bottom: solid 1px; padding-bottom: 5px; margin-top: 0"),
      h2(textOutput("tableTitle"), style ="margin-top: 0; text-align: center"),
      dataTableOutput("table"),
      textOutput("emptyTable")
    )# end mainPanel
  )# end sidebarLayout
  
))