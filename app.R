library(shiny)
library(dplyr)

# Song data
data <- read.csv("data.csv")
mg_songs <- data %>% 
  filter(artist == "Martin Garrix") %>% 
  select(-artist)

il_songs <- data %>% 
  filter(artist == "Illenium") %>% 
  select(-artist)

# UI
ui <- fluidPage(
  titlePanel("When tears?"),
  sidebarLayout(
    sidebarPanel(
      br(),
      selectInput("artist", "Choose an artist:", choices = c("Martin Garrix", "Illenium")),
      br(),
      actionButton("generate", "Generate URL")
    ),
    mainPanel(
      h4(textOutput("title")),
      br(),
      uiOutput("tab")
    )
  )
)

# Server
server <- function(input, output, session) {
  # Function to generate a random song URL
  generate_url <- function(artist) {
    if (artist == "Martin Garrix") {
      id <- sample(mg_songs$id, 1)
      song <- mg_songs$song[id]
      url <- a("surprise", href=mg_songs$url[id])
    } else if (artist == "Illenium") {
      id <- sample(il_songs$id, 1)
      song <- il_songs$song[id]
      url <- a("surprise", href=il_songs$url[id])
    }
    return(list(song = song, url = url))
  }
  
  # Generate URL on button click
  observeEvent(input$generate, {
    result <- generate_url(input$artist)
    output$title <- renderText(paste0("Song Title: ", result$song))
    output$tab <- renderUI({
      tagList("URL link:", result$url)
    })
  })
}

# Run app
shinyApp(ui, server)