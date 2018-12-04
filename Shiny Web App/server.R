library(shiny)
library(dplyr)
library(lubridate)
library(ggplot2)
library(BH)
source("helper.R")

shinyServer(function(input, output) {
  output$california_map <- renderPlot({
    plot_map(start.date = input$time_range[1],
             end.date = input$time_range[2])
    }, width = 1000, height = 400)
})
  
  


    
  
    
    
    
    