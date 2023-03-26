library(shiny)
library(tibble)

# Song data
mg_songs <- data.frame(id = 1:2,
                       song = c("me cri", "me cri2"),
                       url = c("https://www.youtube.com/embed/o3YadwGH0ZA&t=1962s", "https://www.youtube.com/embed/o3YadwGH0ZA?t=3819"))
il_songs <- data.frame(id = 1:2,
                       song = c("sadboi1", "sadboi2"),
                       url = c("https://www.youtube.com/embed/fJVoozJ7IPE&ab_channel=ILLENIUM", "https://www.youtube.com/embed/E1ZCQqQhRTU?t=2823"))
# UI
ui <- fluidPage(
  titlePanel("Random Song URL"),
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
