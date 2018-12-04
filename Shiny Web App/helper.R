ca_county_cases$date <- as.Date(ca_county_cases$date, tz = "America/Los_Angeles")
save(ca_county_cases, file = "~/Desktop/Final_Project/Data/ca_county_cases_final.RData")
load("~/Desktop/Final_Project/Data/ca_county_cases_final.RData")

plot_map <- function(df = ca_county_cases, #date = "date", 
                     start.date = "2006-01-01",
                     end.date = "2010-12-31"){
    library(dplyr)
    
    start.date<- as.Date(start.date, tz = "America/Los_Angeles")
    end.date <- as.Date(end.date, tz = "America/Los_Angeles")

    df <- dplyr::select(df, avg_precip, positive_cases, geometry, date) #%>%
      filter(df, !is.na(date), !is.na(geometry))
  #if(date != "all"){df <- df[df$date == date, ]}

  #if(date != "date"){
    #if(!(date %in% df$date))
   # to_plot <- df[df$date == date, ]
  #} else {
   # to_plot <- df
  #}
  
  
  cases_plot <- ggplot(data = df, extent = "device") + 
    geom_sf(data = df, aes(fill = positive_cases))  +
    viridis::scale_fill_viridis(aes(name = "Number of cases")) +
    ggpubr::rotate_x_text(angle = 60) 
  
  
  precip_plot <- ggplot(data = df, extent = "device") + 
    geom_sf(data = df, aes(fill = avg_precip)) +
    viridis::scale_fill_viridis(aes(name = "Average Precipitation")) +
    ggpubr::rotate_x_text(angle = 60) 
  
  
  final_plot <- grid.arrange(cases_plot, precip_plot, nrow = 1)
  
  return(final_plot)
  
}

