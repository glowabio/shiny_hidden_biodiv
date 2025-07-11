
# sunburst_module.R
library(shiny)
library(highcharter)
library(dplyr)

# UI function
sunburstUI <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      style = "height:600px;",
      highchartOutput(ns("sunburst"), height = "100%")
    )
  )
}

# Server function
sunburstServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Clean and validate input data
    data <- data %>%
      mutate(
        dimension = trimws(dimension),
        what_hidden = trimws(what_hidden)
      ) %>%
      filter(!is.na(dimension), dimension != "") %>%
      mutate(
        label = make.unique(what_hidden),
        parent_dim =  dimension
      )
    
    # Build hierarchy for highcharter
    sunburst_df <- tibble(
      id = c("All Entries", unique(data$parent_dim), data$label),
      parent = c(NA, rep("All Entries", length(unique(data$parent_dim))), data$parent_dim),
      value = c(NA, as.numeric(table(data$parent_dim)), rep(1, nrow(data)))
    )
    
    # Modal detail text
    parse_references <- function(refs_str, ref_names_str) {
      if (is.na(refs_str) || is.na(ref_names_str)) return("<i>No references provided</i>")
      refs <- unlist(strsplit(refs_str, ";"))
      ref_names <- unlist(strsplit(ref_names_str, ";"))
      refs <- trimws(refs)
      ref_names <- trimws(ref_names)
      links <- mapply(function(url, name) {
        sprintf("<li><a href='%s' target='_blank'>%s</a></li>", url, name)
      }, refs, ref_names)
      paste0("<ul>", paste(links, collapse = ""), "</ul>")
    }
    
    details <- setNames(
      lapply(seq_len(nrow(data)), function(i) {
        references_html <- parse_references(
          if ("reference" %in% names(data)) data$reference[i] else NA,
          if ("ref_name" %in% names(data)) data$ref_name[i] else NA
        )
        paste0(
          "<b>What is hidden:</b> ", data$what_hidden[i], "<br>",
          "<b>Why is it hidden:</b> ", data$why_hidden[i], "<br>",
          "<b>Why is it relevant:</b> ", data$why_relevant[i], "<br>",
          "<b>References:</b> ", references_html
        )
      }),
      data$label
    )
    
    # Render sunburst
    output$sunburst <- renderHighchart({
      highchart() %>%
        hc_chart(type = "sunburst") %>%
        hc_add_series(
          data = list_parse(sunburst_df),
          allowDrillToNode = TRUE,
          cursor = "pointer",
          dataLabels = list(format = "{point.name}", filter = list(property = "innerArcLength", operator = ">", value = 16)),
          levels = list(list(level = 1, levelIsConstant = FALSE))
        ) %>%
        hc_plotOptions(
          series = list(
            point = list(
              events = list(
                click = JS(sprintf("
                  function() {
                    Shiny.setInputValue('%s', this.id, {priority: 'event'});
                  }
                ", ns("sunburst_click")))
              )
            )
          )
        ) %>%
        hc_title(text = "")
    })
    
    # Observe clicks and show modal
    observeEvent(input$sunburst_click, {
      label <- input$sunburst_click
      if (!is.null(label) && label %in% names(details)) {
        showModal(modalDialog(
          title = label,
          HTML(details[[label]]),
          easyClose = TRUE
        ))
      }
    })
  })
}
