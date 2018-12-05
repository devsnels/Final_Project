load("~/Desktop/Final_Project/Data/ca_county_cases_final.RData")

plot_map <- function(df = ca_county_cases,
                     start.date = 2006,
                     end.date = 2010){
  library(ggplot2)
  library(dplyr)
  library(sf)
  library(RColorBrewer)
    
    start.date <- as.numeric(start.date)
    end.date <- as.numeric(end.date)
    
    df <- dplyr::select(df, geometry, positive_cases, avg_precip, avg_max_temp, date) %>%
      filter(date >= start.date & date <= end.date)
    #!is.na(geometry) & 
    
  cases_plot <- ggplot(data = df) + 
    geom_sf(data = df, aes(fill = positive_cases))  +
    viridis::scale_fill_viridis(aes(name = "Number of Cases")) +
    ggpubr::rotate_x_text(angle = 60) 
  
  
  precip_plot <- ggplot(data = df) + 
   geom_sf(data = df, aes(fill = avg_precip)) +
   viridis::scale_fill_viridis(aes(name = "Average Precipitation")) +
    ggpubr::rotate_x_text(angle = 60) 

  temp_plot <- ggplot(data = df) + 
    geom_sf(data = df, aes(fill = avg_max_temp)) +
    viridis::scale_fill_viridis(aes(name = "Average High Temp")) +
    ggpubr::rotate_x_text(angle = 60) 
  
  
  final_plot <- grid.arrange(cases_plot, precip_plot, temp_plot, nrow = 2)
  
  return(final_plot)
  
}

