library(leaflet)
library(geojsonio)
library(tidyverse)
source("fetch-data.R")

arrJson <- fetch_trees_by_arrondissement()

#Generating a map of paris with the sum of trees by arrondissements
pal <- colorNumeric(palette = c("#C4E538", "#009432"), domain = arrJson$numberTrees)

labels <- sprintf(
  "<strong>%s</strong><br/>%g trees",
  arrJson$l_ar, arrJson$numberTrees
) %>% lapply(htmltools::HTML)

leaflet(arrJson) %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(numberTrees),
              weight = 2,
              opacity = 1,
              color = "white",
              dashArray = "3",
              fillOpacity = 0.7,
              highlight = highlightOptions(
                weight = 5,
                color = "#006266",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto")
              )
              
  
