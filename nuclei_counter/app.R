library(shiny)
library(EBImage)
library(dplyr)
library(ggplot2)
library(ggExtra)
library(stringr)

options(shiny.maxRequestSize = 20 * 1024^2) # max upload size extended from 5 to 20 MB 

ui <- fluidPage(
  titlePanel("Nuclei Counter"),
  
  sidebarLayout(
    sidebarPanel(
      h3(strong("Import")),
      fileInput("myFile", "Select image:", 
                accept = c("image/png","image/jpeg","image/jpg","image/tiff","image/tif")), # multiple = T
      
      br(),
      h3(strong("Parameters")),
      sliderInput("w", "Threshold width:", min = 1, max = 50, value = 25, step = 1),
      sliderInput("h", "Threshold height:", min = 1, max = 50, value = 25, step = 1),
      sliderInput("offset", "Offset:", min = 0, max = 1, value = .05, step = .05),
      sliderInput("brush", "Brush:", min = 1, max = 15, value = 3, step = 2),
      sliderInput("tolerance", "Tolerance:", min = 0, max = 10, value = 2, step = 1),
      
      br(),
      h3(strong("Export")),
      textInput("prefix", "Prefix for downloaded files:", placeholder = "My_Awesome_Analysis"),
      # downloadButton("downloadGraphics", "Download graphics"),
      # br(), br(),
      downloadButton("downloadData", "Download data"),
      br(), br(),
      downloadButton("downloadSettings", "Download log")
    ),
    mainPanel(
      h3(strong("Imported file info")),
      fluidRow(verbatimTextOutput("fileName")),
      fluidRow(verbatimTextOutput("path")),
      
      br(),
      fluidRow(
        column(5,
               h3(strong("F1 image")),
               plotOutput("original")),
        column(5,
               h3(strong("F2 image")),
               plotOutput("workbench"))
      ),
      br(),
      fluidRow(
        column(5,
               h3(strong("Graphical output")),
               verbatimTextOutput("n"),
               plotOutput("gg")),
        column(5,
               h3(strong("Table output")),
               dataTableOutput("table"))
      )
    )
  )
)

server <- function(input, output) {
  
  output$fileName <- renderPrint({ input$myFile$name })
  
  output$path <- renderPrint({ input$myFile$datapath })
  
  nuc <- reactive({
    f = input$myFile$datapath
    readImage(f)
  })
  
  output$original <- renderPlot({ plot(nuc()) })
  
  nmask <- reactive({
    nmask <- thresh(nuc(), w = input$w, h = input$h, offset = input$offset)
    nmask <- opening(nmask, makeBrush(input$brush, shape = "disc"))
    nmask <- fillHull(nmask)
    nmask <- watershed( distmap(nmask), input$tolerance ) # this part slows shiny down a lot
    nmask <- bwlabel(nmask)
    nmask
  })
  
  output$workbench <- renderPlot({ plot(nmask()) })
  
  output$n <- renderPrint({ paste(range(nmask())[2], "nuclei detected.") })
  
  df <- reactive({
    total <- range(nmask())[2]
    size <- tabulate(nmask())
    
    mean_expression <- tapply(nuc(), nmask(), mean)
    background_intensity <- mean_expression[1]
    mean_expression <- mean_expression[-1]
    
    df <- tibble(
      cluster_id = 1:total,
      size = size,
      mean = mean_expression - background_intensity
    )
    df
  })
  
  output$gg <- renderPlot({
    gg <- ggplot(df(), aes(size, mean)) + 
      geom_point() +
      labs(x = "Size", y = "Mean expression")
    gg <- ggMarginal(gg, type = "histogram")
    gg
  })
  
  output$table <- renderDataTable(options = list(pageLength = 10), { df() })
  
  output$downloadData <- downloadHandler(
    filename = function() { paste0(input$prefix, "_downloadData_", str_remove_all(Sys.Date(), pattern = "-"), ".csv") },
    content = function(file) { write.csv(df(), file) }
  )
  
  settings <- reactive({
    settings <- tibble(
      parameter = c("filename","threshold width","threshold height","offset","brush","tolerance"),
      value = c(input$myFile$name,input$w,input$h,input$offset,input$brush,input$tolerance)
    )
    settings
  })
  
  output$downloadSettings <- downloadHandler(
    filename = function() {paste0(input$prefix, "_downloadSettings_", str_remove_all(Sys.Date(), pattern = "-"), ".csv") },
    content = function(file) { write.csv(settings(), file) }
  )
  
}

shinyApp(ui = ui, server = server)