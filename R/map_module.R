# biodiv_map_module.R
library(shiny)
library(leaflet)
library(dplyr)

# UI Module
biodivMapUI <- function(id) {
  ns <- NS(id)
  tagList(
    leafletOutput(ns("map"), height = "800px")
  )
}

# Server Module
biodivMapServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    rv <- reactiveValues(selected_label = NULL)
    
    # Ensure IDs are added
    data$id <- paste0("pt_", seq_len(nrow(data)))
    
    # Render base map
    output$map <- renderLeaflet({
      leaflet(data) |>
        addProviderTiles("CartoDB.Positron") |>
        addCircleMarkers(
          lng = ~longitude,
          lat = ~latitude,
          label = ~example,
          layerId = ~id,
          radius = 8,
          color = "orange",
          fillOpacity = 0.7,
          group = "points"
        )
    })
    
    # Handle marker clicks
    observeEvent(input$map_marker_click, {
      click <- input$map_marker_click
      if (is.null(click)) return()
      
      clicked_row <- data %>%
        filter(id == click$id)
      
      if (nrow(clicked_row) == 1) {
        lbl <- clicked_row$label[1]
        rv$selected_label <- lbl
        
        matched <- data %>% filter(label == lbl)
        
        leafletProxy(ns("map")) |>
          clearGroup("highlight") |>
          addCircleMarkers(
            data = matched,
            lng = ~longitude,
            lat = ~latitude,
            radius = 10,
            color = "red",
            fillOpacity = 1,
            stroke = TRUE,
            group = "highlight"
          ) |>
          addPopups(
            lng = clicked_row$longitude,
            lat = clicked_row$latitude,
            popup = paste0(
              "<b><i>", clicked_row$example, "</i></b><br>",
              "<b>Dimension:</b> ", clicked_row$dimension, "<br>",
              "<b>What is hidden:</b> ", clicked_row$what_hidden, "<br>",
              "<b>Why is it hidden:</b> ", clicked_row$why_hidden, "<br>",
              "<b>Why is it relevant:</b> ", clicked_row$why_relevant
            )
          )
      }
    })
  })
}
