# Linking geo data
#
# Date updated:   2023-04-17
# Auhtor:         Christian Vedel 
# Purpose:        Geo data cleaning
#
# Output:         'merged_data' enriched with GIS_ID to join on shape file of parishes. 

# ==== Libraries and preparation ====
library(tidyverse)
source("000_functions.R")
library(rgdal)
library(fst)

# ==== Read data ====
merged_data = read_fst("Data/tmp_census.fst") 
merged_data_raw = read_fst("Data/tmp_census_raw.fst")

# ==== Shape files ====
shape_parish = readOGR("Data/sogne_shape") # From www.digdag.dk

# ==== Finding Lemvig ====
# Lemvig (market town in the Limfjord) is missing in 'event_parish'
# But the observations are there, just as 'NA'. Information is taken from
# the raw transcribed sources

# Check population counts in Lemvig according to raw census data
merged_data_raw %>% 
  filter(grepl("lemvig", tolower(Sogn))) %>% 
  group_by(Year, Sogn) %>% 
  count()

# This was compared to http://ddb.byhistorie.dk/koebstaeder/by.aspx?koebstadID=24
# The population count is within counting error of each other

# Finding pa_id, which is Lemvig
tmp = merged_data_raw %>% 
  filter(grepl("lemvig", tolower(Sogn))) %>% 
  select(Year, pa_id) %>% 
  mutate(
    place = "lemvig"
  )

merged_data1 = merged_data %>% # Check data
  left_join(
    tmp, by = c("Year", "pa_id")
  )

# Check manually
# merged_data1 %>%
#   filter(place=="lemvig") %>% 
#   select(Year, pa_id, name_cl, event_parish, event_district, place) %>% 
#   View()

# Check unique links
# merged_data1 %>% 
#   group_by(Year, pa_id) %>% 
#   count() %>% 
#   filter(n>1)

# Change event_parish
merged_data = merged_data1 %>% 
  mutate(
    event_parish = ifelse(is.na(place), event_parish, "Lemvig koebstad")
  ) %>% 
  select(-place)

rm(merged_data1)

# ==== Extract data to make manual key ====
tmp1 = merged_data %>% # Tmp 1 for making key
  distinct(event_county, event_district, event_parish) %>%
  mutate_all(.funs = sub_scandi)
  
# tmp1 %>% write_csv2("Tmp1.csv")

tmp2 = shape_parish@data %>% # Tmp 2 for making key
  select(AMT, HERRED, SOGN, GIS_ID, lat, long) %>%
  mutate_all(.funs = sub_scandi) %>%
  mutate(
    string = paste(AMT, SOGN, GIS_ID, sep = ", ")
  )

# tmp2 %>% write_csv2("Tmp2.csv")

# Key was manually made in this google sheet:
# https://docs.google.com/spreadsheets/d/11PWH1hgR6luXMXrjYSXMqLyPVqIc5LEOkghaoVlbL2M/edit?usp=sharing
# Read the finished key
key = read_csv2("Data/Key_census_to_shape.csv")

# 'GIS_ID' is the name of the unique ids in the shape file
key = key %>% 
  rowwise() %>% 
  mutate(
    GIS_ID = strsplit(GIS_ID, ", ")[[1]][3] # Only last part is the GIS_ID
  )

# Check key
tmp1 %>% 
  left_join(key, by = c("event_parish", "event_district", "event_county"))

# ==== GIS ID to census data ====
# Add coordinates to key
coords = shape_parish@data %>% 
  select(GIS_ID, long, lat)

key = key %>% left_join(coords, by = "GIS_ID")

# Join on key
merged_data = merged_data %>% 
  mutate(
    event_parish = sub_scandi(event_parish),
    event_district = sub_scandi(event_district),
    event_county = sub_scandi(event_county)
  ) %>% 
  left_join(key, by = c("event_parish", "event_district", "event_county"))

# Check join
merged_data %>%
  distinct(event_county, event_district, event_parish, GIS_ID) %>% 
  summarise(sum(is.na(GIS_ID)))
# 76 missing, which corresponds to the key

# ==== Place of birth ====
merged_data = merged_data %>% 
  mutate(
    Born_different_county = as.numeric(event_county != birth_county)
  )

merged_data %>% 
  group_by(Year, Born_different_county) %>% 
  count()

# ==== Saving data enriched data ====
write_fst(merged_data, "Data/tmp_census.fst", compress = 0) 

