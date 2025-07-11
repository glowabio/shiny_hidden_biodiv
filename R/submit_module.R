
library(shiny)
library(bslib)

submitUI <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "mb-3",
      div(
        "Dimension ",
        tooltip(
          bs_icon("info-circle"),
          "Taxonomic, Functional, Genetic, Spatio-temporal, Methodological, Social",
          placement = "right"
        )
      ),
      textInput(ns("dimension"), NULL)
    ),
    div(
      class = "mb-3",
      div(
        "What is hidden? ",
        tooltip(
          bs_icon("info-circle"),
          "Describe the hidden aspect of biodiversity.",
          placement = "right"
        )
      ),
      textInput(ns("what_hidden"), NULL)
    ),
    div(
      class = "mb-3",
      div(
        "Why is it hidden? ",
        tooltip(
          bs_icon("info-circle"),
          "Explain why this biodiversity is overlooked or obscured.",
          placement = "right"
        )
      ),
      textInput(ns("why_hidden"), NULL)
    ),
    div(
      class = "mb-3",
      div(
        "Why is it relevant? ",
        tooltip(
          bs_icon("info-circle"),
          "State why this hidden biodiversity matters.",
          placement = "right"
        )
      ),
      textInput(ns("why_relevant"), NULL)
    ),
    div(
      class = "mb-3",
      div(
        "Reference",
        tooltip(
          bs_icon("info-circle"),
          "DOI",
          placement = "right"
        )
      ),
      textInput(ns("doi"), NULL)
    ),
    
    actionButton(ns("submit_btn"), "Submit", icon = icon("paper-plane"))
  )
}


submitServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$submit_btn, {
      showModal(modalDialog(
        title = "Entry Submitted",
        "Thank you for contributing!",
        easyClose = TRUE
      ))
      
      # You can add logic here to append to a data.frame or write to a file
    })
  })
}
