#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(leaflet)

source("fetch-data.R")

# Define UI for application that draws a histogram
# ui <- fluidPage(
# 
#  
# 
#     # Sidebar with a slider input for number of bins 
#     sidebarLayout(
#         sidebarPanel(
#             sliderInput("circonference",
#                         "Circonference in centimeters",
#                         min = 0,
#                         max = 400,
#                         value = c(0,400)),
#             sliderInput("height",
#                         "Height in meters",
#                         min = 0,
#                         max = 30,
#                         value = c(0,30))
#         ),
# 
#         # Show a plot of the generated distribution
#         mainPanel(
#            leafletOutput("treesmap")
#         )
#     )
# )

ui <- bootstrapPage(
    tags$style(type = "text/css", "
    html,body {width:100%;height:100%}
    #controls {
        background-color: #f8f8ff;
        padding : 10px;
        border-radius: 5%;
      }"),
    leafletOutput("treesmap", width = "100%", height = "100%"),
    absolutePanel(top = 10, right = 10, id = "controls",
                  sliderInput("circonference",
                              "Circonference in centimeters",
                              min = 0,
                              max = 400,
                              value = c(0,400)),
                  sliderInput("height",
                              "Height in meters",
                              min = 0,
                              max = 30,
                              value = c(0,30))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    treesSurroundings <- fetch_trees_surroundings()
    userTrees <- reactive({
        treesSurroundings %>%
            filter(between(CIRCONFERENCE..cm.,input$circonference[1], input$circonference[2])) %>%
            filter(between(HAUTEUR..m., input$height[1], input$height[2]))
    })
    
    
    pal <- colorBin(
        palette = "Blues",
        domain = c(0,30),
        bins = 6
    )
    
    translateRadius <- function(circonf) {
        circonf*10/400 + 1
    }
    
    output$treesmap <- renderLeaflet({
        leaflet(userTrees()) %>% setView(lng = 2.2952842712402344,
                                           lat = 48.875723794948826, zoom = 14.5) %>% 
            addTiles() %>%
            addCircleMarkers(fillOpacity = 0.9,
                             color = ~pal(HAUTEUR..m.),
                             radius = ~translateRadius(CIRCONFERENCE..cm.),
                             stroke = FALSE
            ) %>%
            addLegend("bottomright", pal = pal, values = ~HAUTEUR..m.,
                      title = "Tree Height",
                      labFormat = labelFormat(suffix = "m"),
                      opacity = 1
            )
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
