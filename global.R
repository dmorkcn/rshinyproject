library(tidyverse)
library(shiny)
library(shinydashboard)
library(tigris)
library(tidycensus)
library(sf)
library(ggplot2)
library(ggiraph)
library(scales)
library(DT)
library(stringi)

options(tigris_use_cache = TRUE)

# Create a data frame to map the USA
#-------------------------------------------
us_value <- get_acs(
  geography = "state",
  variables = "B25077_001",
  year = 2019,
  survey = "acs1",
  geometry = TRUE,
  resolution = "20m"
)%>%shift_geometry()%>%
  dplyr::select(.,-c("estimate","moe"))


#Create a data frame with the obesity data
#------------------------------------------
df_npa = read_csv("../Nutrition__Physical_Activity__and_Obesity_-_Behavioral_Risk_Factor_Surveillance_System.csv")%>% 
  select_if(~!all(is.na(.)))%>%
  rename(demographic = StratificationCategory1, Year = YearEnd, Age = `Age(years)`)%>%
  mutate(demographic = if_else(grepl("Age \\(years\\)" ,demographic), "Age", as.character(demographic)))



#Merge obesity data with map data to create a data frame for interactive map plots
#--------------------------------------------------------------------------------
df_map = merge(us_value,df_npa, by.x="NAME",by.y ="LocationDesc" )%>%
  mutate(tooltip = paste(NAME, paste(Data_Value,"%",sep=""), sep = ": "))



