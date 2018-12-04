shinyUI(fluidPage(

  titlePanel("California Maps"),
  
  sidebarLayout(position = "left",
                sidebarPanel("Choose what month and year to display",
                             sliderInput(inputId = "year",
                                         label = "Select the year: ",
                                         min = as.Date("2006-01-01",
                                                       tz = "America/Los_Angeles"),
                                         max = as.Date("2010-12-01", 
                                                       tz = "America/Los_Angeles"),
                                         value = c(as.Date("2006-01-01"), 
                                                   as.Date("2010-12-01")),
                                         timeFormat="%Y",
                                         step = 365.35)),
                mainPanel("Map of California",
                          plotOutput("california_map"))
  ))
  
)



