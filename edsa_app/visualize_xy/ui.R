shinyUI(fluidPage(
  titlePanel(
    h1(textOutput("projTitle"), 
       textOutput("expTitle"),
       style = "border-bottom: solid 1px; padding-bottom: 5px; margin-top: 0")
  ),
  
  sidebarLayout(
    sidebarPanel(
      div("Select data to graph on the y axis:",
          br(),
          uiOutput("yDSSelect"),
          uiOutput("yAxisSelect"),
          style = "border: solid lightgray 1px; margin-bottom: 10px; padding: 10px"
      ),
      checkboxInput("addDS", label = "Plot against column in data set", value = FALSE),
      uiOutput("addDSUI")
      

    ), # end sidebarPanel
    
    mainPanel(
        plotOutput("graph"),
        uiOutput("xSlider"),
        uiOutput("ySlider")
      )# end mainPanel
    
    )# end sidebarLayout
  
))