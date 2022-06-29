library(tidyverse)
library(shiny)
library(shinydashboard)
library(tigris)
library(tidycensus)
library(sf)
library(ggplot2)
library(ggiraph)
library(scales)
library(stringi)

options(tigris_use_cache = TRUE)


#Create a data frame with the obesity data
#------------------------------------------
df_npa = read_csv("./Nutrition__Physical_Activity__and_Obesity_-_Behavioral_Risk_Factor_Surveillance_System.csv")%>% 
  select_if(~!all(is.na(.)))%>%
  rename(demographic = StratificationCategory1, Year = YearEnd)%>%
  mutate(demographic = if_else(grepl("Age \\(years\\)" ,demographic), "Age", as.character(demographic)))%>%
  select(Year, LocationDesc,demographic,Stratification1,Data_Value, Class,Question,QuestionID,Topic)%>%
  filter(Class=="Obesity / Weight Status")



#Merge obesity data with map data to create a data frame for interactive map plots
#--------------------------------------------------------------------------------
df_map = merge((get_acs(
  geography = "state",
  variables = "B25077_001",
  year = 2019,
  survey = "acs1",
  geometry = TRUE,
  key = "6640ac063e881a69cd6b2bebd29ab6b6d141923b",
  resolution = "20m"
)%>%shift_geometry()%>%
  dplyr::select(.,-c("estimate","moe"))),df_npa, by.x="NAME",by.y ="LocationDesc" )%>%
  mutate(tooltip = paste(NAME, paste(Data_Value,"%",sep=""), sep = ": "))



