plot_map <- function(datafr = ca_county_cases, date = "all"){
  
  to_plot <- filter(datafr, !is.na(date))
  if(date != "all"){to_plot <- to_plot[to_plot$date == date, ]}
  
  cases_plot <- ggplot(data = to_plot) + 
    geom_sf(data = to_plot, aes(fill = positive_cases))  +
    viridis::scale_fill_viridis(aes(name = "Number of cases"))
  
  
  precip_plot <- ggplot(data = to_plot) + 
    geom_sf(data = to_plot, aes(fill = avg_precip)) +
    viridis::scale_fill_viridis(aes(name = "Average Precipitation"))
  
  
  final_plot <- grid.arrange(cases_plot, precip_plot, nrow = 1)
  
return(final_plot)
  
}
