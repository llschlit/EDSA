shinyUI(fluidPage(
  titlePanel(
    h1(textOutput("userName"), style = "border-bottom: solid 1px; padding-bottom: 5px; margin-top: 0")
  ),
  
  sidebarLayout(
    sidebarPanel(
      div("Below are listed the projects that you are associated with",
          br(),
          br(),
          selectInput("projChoice", "Select project", getUserProjects()),
          style = "border: solid lightgray 1px; margin-bottom: 10px; padding: 10px"
      ),
      
      div(textOutput("expSelectText"),
          br(),
          uiOutput("expSelect"),
          style = "border: solid lightgray 1px; padding: 10px"
      )
      
    ), # end sidebarPanel
    
    mainPanel(
      div(h2(textOutput("projTableTitle"), style ="margin-top: 0; text-align: center"),
          dataTableOutput("projTable"),
          textOutput("emptyProjTable"),
          style = "border: solid lightgray 1px; padding: 10px; margin-bottom: 10px"
      ),
      div(h2(textOutput("expTableTitle"), style ="margin-top: 0; text-align: center"),
          dataTableOutput("expTable"),
          textOutput("emptyExpTable"),
          style = "border: solid lightgray 1px; padding: 10px"
      ),
      br(),
      br(),
      div(actionButton("visualize", label = "Visualize Data"),
          style = "text-align: right;"
      )
    )# end mainPanel
  )# end sidebarLayout
  
))