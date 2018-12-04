#in this draft I used the function yearmon from zoo package to order 
#our dates in month and year (jan 2006). The only problem is that I haven't came up with 
#the right code to run the UI.R.
#Function and maps work with this code

library(zoo)
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


report <-  read_csv( "Data/wnv_human_cases.csv")


a <- report %>%
  filter(Year == "2006") 
a <- a %>% 
  mutate(Date = lubridate::ymd( "2006-01-01" ) + lubridate::weeks(a$`Week Reported` - 1 ))
b <- report %>%
  filter(Year == "2007")
b <- b %>% 
  mutate(Date = lubridate::ymd( "2007-01-01" ) + lubridate::weeks(b$`Week Reported` - 1 ))
c <- report %>%
  filter(Year == "2008")
c <- c %>% 
  mutate(Date = lubridate::ymd( "2008-01-01" ) + lubridate::weeks(c$`Week Reported` - 1 ))
d <- report %>%
  filter(Year == "2009")
d <- d %>% 
  mutate(Date = lubridate::ymd( "2009-01-01" ) + lubridate::weeks(d$`Week Reported` - 1 ))
e <- report %>%
  filter(Year == "2010")
e <- e %>% 
  mutate(Date = lubridate::ymd( "2010-01-01" ) + lubridate::weeks(e$`Week Reported` - 1 ))

ab <- merge(a,b, all = TRUE)
abc <- merge(ab, c, all = TRUE)
abcd <- merge(abc, d, all = TRUE)
abcde <- merge(abcd, e, all = TRUE)

cases <- abcde %>% 
  select(year = Year, 
         county = County, 
         positive_cases = "Positive Cases",
         date = Date) %>% 
  mutate(date = as.yearmon(date)) %>% 
  group_by(date, county) %>% 
  summarize(positive_cases = sum(positive_cases)) %>% 
  ungroup

head(cases)  

#uploading datasets
temp_2006 <- read_csv("Data/temp/temp_2006.csv")
temp_2007 <- read_csv("Data/temp/temp_2007.csv")
temp_2008 <- read_csv("Data/temp/temp_2008.csv")
temp_2009 <- read_csv("Data/temp/temp_2009.csv")
temp_2010 <- read_csv("Data/temp/temp_2010.csv")
precip_2006 <- read_csv("Data/precip/precip_2006.csv")
precip_2007 <- read_csv("Data/precip/precip_2007.csv")
precip_2008 <- read_csv("Data/precip/precip_2008.csv")
precip_2009 <- read_csv("Data/precip/precip_2009.csv")
precip_2010 <- read_csv("Data/precip/precip_2010.csv")


temp <- rbind(temp_2006, temp_2007, temp_2008, temp_2009, 
              temp_2010 )

temp <- temp %>% 
  select(County, "County Code", "Month Day, Year Code", "Day of Year", "Avg Daily Max Air Temperature (F)", "Avg Daily Min Air Temperature (F)") %>% 
  rename(county = County,
         fips = "County Code",
         date = "Month Day, Year Code",
         day_year = "Day of Year",
         max_temp_f = "Avg Daily Max Air Temperature (F)",
         min_temp_f = "Avg Daily Min Air Temperature (F)") %>% 
  mutate(date = mdy(date))
head(temp)
tail(temp)

precip <- rbind(precip_2006, precip_2007, precip_2008, precip_2009, 
                precip_2010)

precip <- precip %>%
  select(County, "Month Day, Year Code", "Avg Daily Precipitation (mm)")%>%
  rename(county = County,
         date = "Month Day, Year Code",
         avg_precip = "Avg Daily Precipitation (mm)") %>% 
  mutate(date = mdy(date))

head(precip)
tail(precip)


ca_weather <- merge(temp, precip, by = c("county", "date"))
head(ca_weather)
tail(ca_weather)

ca_precip <- ca_weather %>% 
  select(county, date, fips, avg_precip) %>% 
  separate(county, c("county", "state"), sep = " County, CA") %>% 
  select(county, date, fips, avg_precip) %>% 
  
  mutate(date = as.yearmon(date)) %>% 
  group_by(county, fips, date) %>% 
  summarise(avg_precip = mean(avg_precip)) %>% 
  ungroup %>% 
  arrange(date)

head(ca_precip) 
tail(ca_precip)

#Merge datasets


ca_precip_cases <- full_join(ca_precip, cases, by = c('date', 'county'))

ca_precip_cases$positive_cases[is.na(ca_precip_cases$positive_cases)] <- 0

ca_precip_cases <- ca_precip_cases %>% 
  arrange(desc(positive_cases))

head(ca_precip_cases)


ca_counties <- counties(state = "CA", cb = TRUE, class = "sf")

ggplot() + 
  geom_sf(data = ca_counties)


ca_county_cases <- ca_counties %>% 
  mutate(fips = paste(STATEFP, COUNTYFP, sep = "")) %>% 
  full_join(ca_precip_cases, by = "fips") %>% 
  arrange(desc(positive_cases))
head(ca_county_cases)


cases_plot <- ca_county_cases %>% 
  filter(date == "Aug 2008") %>% 
  ggplot() + 
  geom_sf(aes(fill = positive_cases)) + 
  scale_fill_viridis(name = "Number of cases")

precip_plot <- ca_county_cases %>% 
  filter(date == "Aug 2008")  %>% 
  ggplot() + 
  geom_sf(aes(fill = avg_precip)) + 
  scale_fill_viridis(name = "Average Precipitation")

grid.arrange(cases_plot, precip_plot, nrow = 1)


#Function!!!!!!!!!!!!!!!!

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
  
}

plot_map(date = "Aug 2008")





