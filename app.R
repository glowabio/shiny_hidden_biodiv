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
  
  # Track if welcome modal has been shown
  show_once <- reactiveVal(TRUE)
  
  # Text welcome modal
  text_modal <- div(
    class = "text-center",
    img(src = "logo.png", height = "100px", style = "margin-bottom: 1rem;"),
    tags$h4("Welcome to the Hidden Biodiversity Tracker"),
    HTML("
      <p>
        This app showcases examples of biodiversity that are often overlooked, 
        categorized across different dimensions — such as taxonomic, functional, spatial, 
        temporal, and social — and visualized using interactive tools.
      </p>
      <p>
        Use the map to explore where these hidden biodiversity examples are located, 
        and the sunburst chart to understand how they relate to different dimensions 
        and contexts.
      </p>
      <hr>
      <p>
        <strong>Contribute your knowledge:</strong> Use the <span style='color:#006d5b; font-weight:bold;'>gear icon</span> 
        at the top right of the screen to submit your own example of hidden biodiversity. 
        Your contribution helps build a richer and more inclusive understanding of life on Earth.
      </p>
    ")
  )
  # Show on first load
  observe({
    if (show_once()) {
      showModal(modalDialog(
        title = NULL,
        text_modal,
        easyClose = TRUE
      ))
      show_once(FALSE)  # Don't show again unless manually triggered
    }
  })
  
  # Also show when home icon is clicked
  observeEvent(input$open_home_modal, {
    showModal(modalDialog(
      title = NULL,
      text_modal,
      easyClose = TRUE
    ))
  })
}


shinyApp(ui, server)












