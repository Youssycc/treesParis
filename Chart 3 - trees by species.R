library(tidyverse)
library(leaflet)
source("fetch-data.R")

trees <- read.csv2("les-arbres.csv")

#get top 5 species

species <- trees %>% 
  group_by(GENRE) %>% 
  count() %>%
  arrange(desc(n))
topSpecies <- as.character(species$GENRE[1:15])

#Only keep trees in my surroundings 
treesFiltered <- fetch_trees_surroundings()
 
#Attribute colors to species
colors <- rep("#8395a7",length(levels(treesFiltered$GENRE)))

palette <- c("#ff9ff3","#feca57","#ff6b6b","#48dbfb","#1dd1a1",
             "#f368e0","#ff9f43","#ee5253","#0abde3","#10ac84","#00d2d3","#54a0ff",
             "#5f27cd","#01a3a4","#2e86de","#341f97")

for (i in seq(topSpecies)) {
  colors[match(topSpecies[i], levels(treesFiltered$GENRE))] <- palette[i]
}

pal <- colorFactor(colors, levels(treesFiltered$GENRE))


leaflet(treesFiltered) %>% setView(lng = 2.2952842712402344,
                                   lat = 48.875723794948826, zoom = 14.5) %>% 
  addTiles() %>%
  addCircleMarkers(radius = 1,
                   color = ~pal(GENRE),
                   opacity = 0.8
                   ) %>%
  addLegend("bottomright", pal = pal, values = c(topSpecies,"Other"), title = "Tree species")



