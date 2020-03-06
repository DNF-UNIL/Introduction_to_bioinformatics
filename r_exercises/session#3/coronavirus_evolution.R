devtools::install_github("RamiKrispin/coronavirus")
suppressPackageStartupMessages( library(coronavirus) )
suppressPackageStartupMessages( library(tidyverse) )
suppressPackageStartupMessages( library(viridis) ) # install.packages("viridis")
suppressPackageStartupMessages( library(lubridate) )

max(coronavirus$date) # check whether the dataset is up to date (i.e. yesterday)
coronavirus <- coronavirus %>% 
    mutate(Country.Region = case_when(
        Country.Region == "US" ~ "USA",
        Country.Region %in% c("Mainland China","Macau","Hong Kong") ~ "China",
        Country.Region == "North Macedonia" ~ "Macedonia",
        TRUE ~ as.character(Country.Region)
    ))

suppressPackageStartupMessages( library(ggplot2) )
suppressPackageStartupMessages( library(gganimate) )
suppressPackageStartupMessages( library(maps) )

world_map <- map_data("world")

coronavirus <- coronavirus %>% 
    filter(type == "confirmed") %>% 
    rename("long" = "Long",
           "lat" = "Lat") %>% 
    mutate(continent = case_when(
        Country.Region %in% c("Afghanistan","Armenia","Azerbaijan","Bahrain","Cambodia","China","Georgia","India","Iran",
                              "Iraq","Israel","Japan","Jordan","Kuwait","Lebanon","Malaysia","Nepal","Oman","Pakistan",
                              "Qatar","Saudi Arabia","Singapore","South Korea","Sri Lanka","Taiwan","Thailand","United Arab Emirates","Vietnam") ~ "Asia",
        Country.Region %in% c("Algeria","Egypt","Marocco","Nigeria","Senegal","Tunesia") ~ "Africa",
        Country.Region %in% c("Andorra","Austria","Belarus","Belgium","Croatia","Czech Republic","Denmark","Estonia",
                              "Finland","France","Germany","Gibraltar","Greece","Hungary","Iceland","Ireland","Italy",
                              "Latvia","Liechenstein","Lithuania","Luxembourg","Macedonia","Monaco","Netherlands","Norway",
                              "Poland","Portugal","Romania","Russia","San Marino","Spain","Sweden","Switzerland",
                              "UK","Ukraine") ~ "Europe",
        Country.Region %in% c("Canada","USA") ~ "North America",
        Country.Region %in% c("Mexico","Saint Barthelemy") ~ "Central America",
        Country.Region %in% c("Argentina","Brazil","Chile","Dominican Republic","Ecuador","Faroe Islands") ~ "South America",
        Country.Region %in% c("Australia","Indonesia","New Zealand","Philippines") ~ "Oceania",
        Country.Region == "Others" ~ "Others"
    )) %>% 
    mutate(date = ymd(date))

# coronavirus %>% pull(Country.Region) %>% unique() %>% sort()

ggplot(world_map, aes(long, lat)) +
    geom_polygon(fill = "lightgray", color = "white", aes(group = group)) +
    geom_point(data = filter(coronavirus, type == "confirmed"), aes(long, lat, size = cases), color = "red")

range(coronavirus$date)
date_selection <- coronavirus %>% 
    filter(type == "confirmed") %>% 
    filter(date %in% c(as.Date("2020-01-22"), as.Date("2020-02-14"), as.Date("2020-02-22"), 
                       as.Date("2020-02-25"), as.Date("2020-02-29"), max(date))) %>% 
    arrange(date) 

ggplot(world_map, aes(long, lat)) +
    geom_polygon(fill = "lightgray", color = "white", aes(group = group)) +
    geom_point(data = date_selection, aes(long, lat, size = cases), color = "red") +
    facet_wrap(~date)