shinyUI(fluidPage(
  titlePanel(
    h1(textOutput("projTitle"), 
       textOutput("expTitle"),
       style = "border-bottom: solid 1px; padding-bottom: 5px; margin-top: 0")
  ),
  
  sidebarLayout(
    sidebarPanel(
      div("Select which waveform data set to view",
          br(),
          uiOutput("dsSelect"),
          style = "border: solid lightgray 1px; margin-bottom: 10px; padding: 10px"
      ),
      div("Select which column to view",
          br(),
          uiOutput("colSelect"),
          style = "border: solid lightgray 1px; margin-bottom: 10px; padding: 10px"
      ),
      div("Use sliders to zoom data along axes",
        uiOutput("xSlider"),
        uiOutput("ySlider"),
        style = "border: solid lightgray 1px; margin-bottom: 10px; padding: 10px"
      )
    ), # end sidebarPanel
    
    mainPanel(
      plotOutput("plot"),
      textOutput("dsNotes")
      )# end mainPanel
    
    )# end sidebarLayout
  
))