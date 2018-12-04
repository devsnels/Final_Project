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
    }, width = 1000, height = 2000)
})
  
  


    
  
    
    
    
    