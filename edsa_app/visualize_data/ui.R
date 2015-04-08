shinyUI(fluidPage(
  titlePanel(
    h1(textOutput("userName"), style = "border-bottom: solid 1px; padding-bottom: 5px; margin-top: 0")
  ),
  
  sidebarLayout(
    sidebarPanel(
      uiOutput("xSlider"),
      br(),
      uiOutput("ySlider")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
))