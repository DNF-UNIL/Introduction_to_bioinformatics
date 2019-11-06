library(shiny)

ui <- fluidPage(
    textInput(inputId = "name", label = "What is your name?"),
    
    verbatimTextOutput("line")
)

server <- function(input, output) {
    
    output$line <- renderPrint({
        cat("Hello", input$name)
    })
}

shinyApp(ui = ui, server = server)