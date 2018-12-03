shinyUI(fluidPage(

  titlePanel("California Maps"),
  
  sidebarLayout(position = "right",
                sidebarPanel("Choose what month and year to display",
                             sliderInput(inputId = "time_range",
                                         label = "Select the time range: ",
                                         value = c(as.Date("2006-01-01",
                                                           tz = "America/Los_Angeles",
                                                           timeFormat="%m %Y")),
                                         min = as.Date("2006-01-01", tz = "America/Los_Angeles"),
                                         max = as.Date("2010-12-01", tz = "America/Los_Angeles"),
                                         step = 1)),
                mainPanel("Map of California",
                          plotOutput("california_map"))
  )
  
))