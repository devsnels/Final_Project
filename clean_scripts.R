# Loading packages
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

#Loading data set 

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
report <-  read_csv( "Data/wnv_human_cases.csv")

# cleaning report data

cases <- report %>% 
  select(Year, 
         county = County, 
         positive_cases = "Positive Cases") %>% 
  mutate(date = Year) %>% 
  filter(date %in% c("2006", "2007", "2008", "2009", "2010")) %>% 
  group_by(date, county) %>% 
  summarize(positive_cases = sum(positive_cases)) %>% 
  ungroup %>% 
  arrange(date)

unique(cases$date)

# cleaning weather data

temp <- rbind(temp_2006, temp_2007, temp_2008, temp_2009, temp_2010)

temp <- temp %>% 
  select(County, "County Code", "Month Day, Year Code", "Day of Year", 
         "Avg Daily Max Air Temperature (F)", 
         "Avg Daily Min Air Temperature (F)") %>% 
  rename(county = County,
         fips = "County Code",
         date = "Month Day, Year Code",
         day_year = "Day of Year",
         max_temp = "Avg Daily Max Air Temperature (F)",
         min_temp_f = "Avg Daily Min Air Temperature (F)") %>% 
  mutate(date = mdy(date)) 
head(temp)
tail(temp)

precip <- rbind(precip_2006, precip_2007, precip_2008, precip_2009, precip_2010)

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
  select(county, date, fips, avg_precip, max_temp) %>% 
  separate(county, c("county", "state"), sep = " County, CA") %>% 
  select(county, date, fips, avg_precip, max_temp) %>% 
  mutate(date = year(date)) %>% 
  group_by(county, fips, date) %>% 
  summarise(avg_precip = mean(avg_precip), avg_max_temp = mean(max_temp)) %>% 
  ungroup 

ca_precip

ca_precip_cases <- full_join(ca_precip, cases, by = c('date', 'county')) 

ca_precip_cases <- ca_precip_cases %>% 
  mutate(positive_cases = ifelse(!is.na(positive_cases), positive_cases, 0))

ca_precip_cases <- ca_precip_cases %>% 
  arrange(positive_cases)

ca_precip_cases

ca_counties <- counties(state = "CA", cb = TRUE, class = "sf")

ca_county_cases <- ca_counties %>% 
  mutate(fips = paste(STATEFP, COUNTYFP, sep = "")) %>% 
  full_join(ca_precip_cases, by = "fips") %>% 
  filter(county %in% c("Imperial" , "Kern", "Los Angeles", "Orange",
                       "Riverside", "San Bernardino", "San Diego", 
                       "San Luis Obispo", "Santa Barbara", "Ventura"))

head(ca_county_cases)
tail(ca_county_cases)
unique(ca_county_cases$county)

write_tsv(ca_county_cases, path = "ca_county_cases.txt")

read_tsv('ca_county_cases.txt')


