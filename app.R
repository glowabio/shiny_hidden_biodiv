library(shiny)
library(bslib)
library(bsicons)
library(shinyWidgets)

# Load data
biodiv_points <- read.csv("./data/point_hidden.csv", stringsAsFactors = FALSE)
biodiv_graph <- read.csv("./data/sunburst_hidden.csv", stringsAsFactors = FALSE)

ui <- page_fluid(
  theme = bs_theme(
    version = 5,
    bootswatch = "minty",
    primary = "#006d5b",
    base_font = font_google("Open Sans"),
    heading_font = font_google("Montserrat")
  ),
  
  tags$head(
    tags$style(HTML("
      .top-toolbar {
        position: absolute;
        top: 1rem;
        right: 1.5rem;
        z-index: 1000;
      }
    "))
  ),
  
  # Floating input toolbar
  div(
    class = "top-toolbar d-flex gap-3 align-items-center",
    
    # Home icon (click triggers modal)
    actionLink("open_home_modal", bs_icon("house", size = 24), class = "text-dark"),
    
    # Gear icon (popover with submit UI)
    popover(
      bs_icon("gear", size = 24),
      submitUI("submit"),  # Submit module shown in popover
      title = "📝 Submit Hidden Biodiversity Entry",
      placement = "bottom",
      options = list(container = "body")
    )
  ),
  
  titlePanel("Hidden Biodiversity Tracker"),
  
  layout_column_wrap(
    width = 1/2,
    gap = "1.5rem",
    
    card(
      full_screen = TRUE,
      card_header("Hidden biodiversity across the world",
                  tooltip(
                    bs_icon("info-circle"),
                    "Examples of hidden biodiversity 
                    across the world along with their approximate distribution")
                  ),
      biodivMapUI("map")
    ),
    
    card(
      full_screen = TRUE,
      card_header("Dimensions of hidden biodiversity",
                  tooltip(
                    bs_icon("info-circle"),
                    "Examples for the different dimensions of hidden 
                    biodiversity, what specifically is hidden, why can be 
                    considered hidden, and why is it considered relevant and 
                    its relevance")),
      sunburstUI("sunburst")
    )
  ),
  tags$footer(
    class = "text-center text-muted p-3 mt-5",
    "Hidden Biodiversity Tracker"
  )
)


# Define Server
server <- function(input, output, session) {
  biodivMapServer("map", biodiv_points)
  sunburstServer("sunburst", biodiv_graph)
  submitServer("submit")
  
  observeEvent(input$open_home_modal, {
    showModal(modalDialog(
      title = "Welcome to the Hidden Biodiversity Tracker",
      HTML("<p>This project showcases examples of biodiversity that are often overlooked, categorized by dimension, and visualized with interactive tools. Use the map and chart below to explore!</p>"),
      easyClose = TRUE
    ))
  })
}

shinyApp(ui, server)












