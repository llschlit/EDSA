shinyUI(fluidPage(
  titlePanel(
    h1(textOutput("projTitle"), 
       textOutput("expTitle"),
       style = "border-bottom: solid 1px; padding-bottom: 5px; margin-top: 0")
  ),
  
  sidebarLayout(
    sidebarPanel(
      div(uiOutput("dsSelect"),
          "Select data to graph on the y axis:",
          uiOutput("yAxisSelect"),
          style = "border: solid lightgray 1px; margin-bottom: 10px; padding: 10px"
      ),
      checkboxInput("addDS", label = textOutput("checkBoxPrompt"), value = FALSE),
      uiOutput("addDSUI")
    ), # end sidebarPanel
    
    mainPanel(
      plotOutput("graph"),
      fluidRow(
        column(9,
          div("Use sliders to zoom data along axes",
            uiOutput("xSlider"),
            uiOutput("ySlider"),
            style = "margin-left: 40px; margin-right: 40px;"
          )
        ),
        column(3,
          radioButtons("graphType", 
                       label = "Graph Type", 
                       choices = list("Scatter Plot" = 1, "Line Graph" = 2), 
                       selected = 1)
        )
      )
    )# end mainPanel
    
  )# end sidebarLayout
  
))