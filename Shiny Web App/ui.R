shinyUI(fluidPage(

  titlePanel("California WNV, Temperature, and Precipitation Maps by Year"),

  sidebarLayout(position = "left", 
                sidebarPanel("Choose what year to display",
                             sliderInput(inputId = "time_range",
                                         label = "Select year: ",
                                         min = 2006,
                                         max = 2010,
                                         value = c(2006,
                                                   2010),
                                         step = 1,
                                         sep = ""),
                             p("By designing an interactive map, we hoped to provide year by year
                               visualizations of how precipitation and temperature may have 
                               impacted the number of cases of West Niles Virus (WNV) in Southern California,
                               with a specific emphasis on El Nino Years. Based off of these maps,
                               the county with the highest count of WNV cases was Los Angeles in 2008.
                               Precipitation did appear to be higher that year, but this was not
                               associated with an El Nino year. Temperature stayed at about an average
                               of 75 degrees all four years. Due to know immediate pattern standing out
                               between precipitation, temperature and WNV cases in Southern California, it would
                               be of interest to alter the timeline to move by month, look at storm
                               events such as floods, look at precipitation as amount above average, 
                               or categorize by season")),
                mainPanel("",
                          plotOutput("california_map")))
    ))
               

  




