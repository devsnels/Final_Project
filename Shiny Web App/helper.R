load("/Users/anastasiaratcliff/Desktop/R- Programing /Final_Project/Data/ca_county_cases_final.RData")

plot_map <- function(df = ca_county_cases,
                     start.date = 2006,
                     end.date = 2010){
  library(ggplot2)
  library(dplyr)
  library(sf)
  library(RColorBrewer)
    
    start.date <- as.numeric(start.date)
    end.date <- as.numeric(end.date)
    
    df <- dplyr::select(df, geometry, positive_cases, avg_precip, date) %>%
      filter(date >= start.date & date <= end.date)
    #!is.na(geometry) & 
  
  cases_plot <- ggplot(data = df) + 
    geom_sf(data = df, aes(fill = positive_cases))  +
    viridis::scale_fill_viridis(aes(name = "Number of cases")) +
    ggpubr::rotate_x_text(angle = 60) 
  
  
  precip_plot <- ggplot(data = df) + 
   geom_sf(data = df, aes(fill = avg_precip)) +
   viridis::scale_fill_viridis(aes(name = "Average Precipitation")) +
    ggpubr::rotate_x_text(angle = 60) 
  
  
  
  final_plot <- grid.arrange(cases_plot, precip_plot, nrow = 1)
  
  return(final_plot)
  
}

