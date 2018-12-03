library(shiny)

shinyUI(fluidPage(
  titlePanel("CA Counties West Niles Virus Cases and Precipitation Averages 2006-2010"),
  sidebarLayout(position = "right",
                sidebarPanel("Date",
                             sliderInput(inputId = "time_range",
                                         label = "Select the time range: ",
                                         value = c(as.POSIXct("2006-01-01"),
                                                   as.POSIXct("2010-12-31")),
                                         min = as.POSIXct("2006-01-01"),
                                         max = as.POSIXct("2010-12-31"))),
                mainPanel("Map of California",
                plotOutput("california_map"))                
  )
))


