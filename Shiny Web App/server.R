library(shiny)
library(dplyr)
library(lubridate)
library(BH)
source("helper.R")

california_counties <- readRDS("../ca_county_cases_final.RDS") 
california_counties$date <- ymd(california_counties$date, tz = "America/Los_Angeles")

shinyServer(function(input, output) {
  output$california_map <- renderPlot({plot_map(start.time = input$time_range[1],
                                                end.time = input$time_range[2])
    })
})
  
  


    
  
    
    
    
    