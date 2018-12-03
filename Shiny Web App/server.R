
library(shiny)
library(dplyr)
library(lubridate)
source("helper.R")


shinyServer(function(input, output) {
  output$map <- renderPlot({plot_map()})
})
  
  
  

    
  
    
    
    
    