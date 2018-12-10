ca_county_cases <- readRDS("ca_county_cases.RData")

plot_map <- function(df = ca_county_cases,
                     start.date = 2006,
                     end.date = 2010){
  library(ggplot2)
  library(dplyr)
  library(sf)
  library(RColorBrewer)
  library(dplyr)
  library(stringr)
  library(tidyselect)
  library(ggplot2)
  library(rmarkdown)
  library(RColorBrewer)
  library(knitr)
  library(forcats)
  library(readr)
  library(tidyr)
  library(broom)
  library(purrr)
  library(scales)
  library(lubridate)
  library(viridis)
  library(RColorBrewer)
  library(scales)
  library(tidyverse)
  library(tigris)
  library(sf)
  library(cowplot)
  library(gridExtra)
    
    start.date <- as.numeric(start.date)
    end.date <- as.numeric(end.date)
    
    df <- dplyr::select(df, geometry, positive_cases, avg_precip, avg_max_temp, date) %>%
      filter(date >= start.date & date <= end.date)
    
  cases_plot <- ggplot(data = df) + 
    geom_sf(data = df, aes(fill = positive_cases))  +
    viridis::scale_fill_viridis(aes(name = "Number of Cases"), limits = c(0, 160)) +
    ggpubr::rotate_x_text(angle = 60) 
  
  
  precip_plot <- ggplot(data = df) + 
   geom_sf(data = df, aes(fill = avg_precip)) +
   viridis::scale_fill_viridis(aes(name = "Average Precipitation (mm)"), limits = c(0,2.5)) +
    ggpubr::rotate_x_text(angle = 60) 

  temp_plot <- ggplot(data = df) + 
    geom_sf(data = df, aes(fill = avg_max_temp)) +
    viridis::scale_fill_viridis(aes(name = " Average Temperature (F)"), limits = c(0,100)) +
    ggpubr::rotate_x_text(angle = 60) 
  
  
  final_plot <- grid.arrange(cases_plot, precip_plot, temp_plot, ncol = 1, nrow = 3)

  return(final_plot)
  
}

