shinyUI(fluidPage(

  titlePanel("California Maps"),
  
  column(12, plotOutput("california_map")),


  fluidRow(
    column(12,
                sidebarPanel("Choose what month and year to display",
                             sliderInput(inputId = "time_range",
                                         label = "Select the year: ",
                                         min = 2006,
                                         max = 2010,
                                         value = c(2006,
                                                   2010),
                                         step = 1,
                                         sep = "")))
    )
                #mainPanel("Map of California",
  ))
  




