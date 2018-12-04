library(shiny)
library(dplyr)
library(lubridate)
library(ggplot2)
library(BH)
source("helper.R")

shinyServer(function(input, output) {
  output$california_map <- renderPlot({
    plot_map(start.date = input$year[1],
             end.date = input$year[2])
    }, width = 750, height = 1600)
})
  
  


    
  
    
    
    
    