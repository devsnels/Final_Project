load("~/Desktop/Final_Project/Data/ca_county_cases_final.RData")

plot_map <- function(df = ca_county_cases, date = "all", 
                     start.date = "2006-01-01",
                     end.date = "2010-12-31"){
    library(dplyr)
    
    start.date<- as.Date(start.date, tz = "America/Los_Angeles")
    end.date <- as.Date(end.date, tz = "America/Los_Angeles")

    df <- dplyr::select(df, avg_precip, positive_cases, geometry, date) #%>%
      filter(df, !is.na(date))
  #if(date != "all"){df <- df[df$date == date, ]}

  if(date != "all"){
    if(!(date %in% df$date)){
      stop(paste("That date is not in the data. Try one of the following dates instead: ", paste(unique(df$date), collapse = ", ")))
    }
    to_plot <- df[df$date == date, ]
  } else {
    to_plot <- df
  }
  
  
  cases_plot <- ggplot(data = to_plot, extent = "device") + 
    geom_sf(data = to_plot, aes(fill = positive_cases))  +
    viridis::scale_fill_viridis(aes(name = "Number of cases")) +
    ggpubr::rotate_x_text(angle = 60) 
  
  
  precip_plot <- ggplot(data = to_plot, extent = "device") + 
    geom_sf(data = to_plot, aes(fill = avg_precip)) +
    viridis::scale_fill_viridis(aes(name = "Average Precipitation")) +
    ggpubr::rotate_x_text(angle = 60) 
  
  
  final_plot <- grid.arrange(cases_plot, precip_plot, nrow = 1)
  
  return(final_plot)
  
}

