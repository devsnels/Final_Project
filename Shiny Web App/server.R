library(shiny)
library(dplyr)
library(lubridate)
source("helper.R")

california_counties <- readRDS("../ca_county_cases_final.RDS") %>% 
  mutate(date = ymd(date, tz = "America/Los_Angeles"))

shinyServer(function(input, output) {
  output$california_map <- renderPlot({plot_map()})
})
  
  


    
  
    
    
    
    