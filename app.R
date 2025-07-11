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
    class = "top-toolbar",
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
}

shinyApp(ui, server)





# library(shiny)
# library(plotly)
# library(shinyBS)
# 
# # Read CSV once when app starts
# biodiv_data <- read.csv("data/hidden_biodiversity.csv", stringsAsFactors = FALSE)
# 
# # Clean dimension column to ensure consistency
# biodiv_data$dimension <- trimws(biodiv_data$dimension)
# 
# # Ensure dimensions and labels are valid
# biodiv_data <- biodiv_data[!is.na(biodiv_data$dimension) & biodiv_data$dimension != "", ]
# biodiv_data$label <- make.unique(trimws(biodiv_data$what_hidden))
# 
# # Rebuild clean unique dimension names and remap them
# unique_dims <- unique(trimws(biodiv_data$dimension))
# dim_labels <- make.unique(unique_dims)
# dim_map <- setNames(dim_labels, unique_dims)
# biodiv_data$parent_dim <- dim_map[biodiv_data$dimension]
# 
# # Prepare sunburst labels and hierarchy
# root <- "All Entries"
# labels <- c(root, dim_labels, biodiv_data$label)
# parents <- c("", rep(root, length(dim_labels)), biodiv_data$parent_dim)
# values <- c(100, rep(5, length(dim_labels)), rep(1, nrow(biodiv_data)))
# 
# # Create details list using labels, support multiple references
# parse_references <- function(refs_str, ref_names_str) {
#   if (is.na(refs_str) || is.na(ref_names_str)) return("<i>No references provided</i>")
#   refs <- unlist(strsplit(refs_str, ";"))
#   ref_names <- unlist(strsplit(ref_names_str, ";"))
#   refs <- trimws(refs)
#   ref_names <- trimws(ref_names)
#   links <- mapply(function(url, name) {
#     sprintf("<li><a href='%s' target='_blank'>%s</a></li>", url, name)
#   }, refs, ref_names)
#   paste0("<ul>", paste(links, collapse = ""), "</ul>")
# }
# 
# details <- setNames(
#   lapply(seq_len(nrow(biodiv_data)), function(i) {
#     references_html <- parse_references(biodiv_data$reference[i], biodiv_data$ref_name[i])
#     paste0(
#       "<b>What is hidden:</b> ", biodiv_data$what_hidden[i],
#       "<br><b>Why is hidden:</b> ", biodiv_data$why_hidden[i],
#       "<br><b>Why is relevant:</b> ", biodiv_data$why_relevant[i],
#       "<br><b>References:</b> ", references_html
#     )
#   }),
#   biodiv_data$label
# )
# 
# ui <- fluidPage(
#   tags$head(
#     tags$style(HTML(".container-fluid { padding: 0 15px; }"))
#   ),
#   fluidRow(
#     column(12, align = "center",
#            tags$h2("🌍 Hidden Biodiversity Sunburst"),
#            plotlyOutput("sunburst", height = "calc(100vh - 150px)")
#     )
#   ),
#   bsModal("infoModal", "Detail", "hiddenBtn", size = "medium", htmlOutput("modal_text")),
#   actionButton("hiddenBtn", "", style = "display:none;")
# )
# 
# server <- function(input, output, session) {
#   output$sunburst <- renderPlotly({
#     plot_ly(
#       type = "sunburst",
#       labels = labels,
#       parents = parents,
#       values = values,
#       hoverinfo = "label",
#       branchvalues = "total",
#       insidetextorientation = "radial",
#       marker = list(line = list(width = 1, color = "white"))
#     ) %>% layout(
#       margin = list(t = 10, l = 10, r = 10, b = 10),
#       paper_bgcolor = "white",
#       font = list(size = 14, color = "black"),
#       autosize = TRUE,
#       width = NULL,
#       height = NULL,
#       xaxis = list(scaleanchor = "y", showgrid = FALSE, zeroline = FALSE, visible = FALSE),
#       yaxis = list(showgrid = FALSE, zeroline = FALSE, visible = FALSE)
#     )
#   })
# 
# 
#   observe({
#     click <- event_data("plotly_click")
#     if (!is.null(click$pointNumber)) {
#       label <- labels[click$pointNumber + 1]
#       if (label %in% names(details)) {
#         showModal(modalDialog(
#           title = label,
#           HTML(details[[label]]),
#           easyClose = TRUE
#         ))
#       }
#     }
#   })
# }
# 
# shinyApp(ui, server)









