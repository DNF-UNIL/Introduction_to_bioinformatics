library(shiny)
library(EBImage)
library(dplyr)
library(ggplot2)
library(ggExtra)
library(stringr)
library(shinythemes)

# max upload size extended from 5 (default) to 20 MB 
options(shiny.maxRequestSize = 20 * 1024^2) 

ui <- fluidPage(
  # themeSelector(),
  theme = shinythemes::shinytheme("spacelab"),
  
  titlePanel("Nuclei Counter", windowTitle = "NucleiCounter"),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      
      # import ui
      h3(strong("Import")),
      fileInput("myFile", "Select Image:", 
                accept = c("image/png","image/jpeg","image/jpg","image/tiff","image/tif"), 
                placeholder = "No File Selected"), # multiple = T
      
      # parameters ui
      h3(strong("Parameters")),
      sliderInput("w", "Threshold Width:", min = 1, max = 50, value = 25, step = 1),
      sliderInput("h", "Threshold Height:", min = 1, max = 50, value = 25, step = 1),
      sliderInput("offset", "Offset:", min = 0, max = 1, value = .05, step = .05),
      sliderInput("brush", "Brush:", min = 1, max = 15, value = 3, step = 2),
      sliderInput("tolerance", "Tolerance:", min = 0, max = 10, value = 2, step = 1),
      
      # analysis ui
      h3(strong("Analysis")),
      actionButton("analyze", "Start Analysis"),
      
      # export ui
      h3(strong("Export")),
      textInput("prefix", "Prefix Exported Files:", placeholder = "My_Awesome_Analysis"),
      # downloadButton("downloadGraphics", "Download graphics"),
      # br(), br(),
      downloadButton("downloadData", "Download Data"),
      br(), br(),
      downloadButton("downloadSettings", "Download Log")
    ),
    mainPanel(
      h3(strong("Imported File Info")),
      fluidRow(verbatimTextOutput("fileName")),
      fluidRow(verbatimTextOutput("path")),
      
      # show original and final rendered images
      br(),
      fluidRow(
        column(5,
               h3(strong("F1 Image")),
               plotOutput("original")
        ),
        column(5,
               h3(strong("F2 Image")),
               plotOutput("workbench")
        )
      ),
      br(),
      
      # graphical and tabular output of data
      conditionalPanel("input.analyze != 0",
                       fluidRow(
                         column(5,
                                h3(strong("Graphical Output")),
                                verbatimTextOutput("n"),
                                plotOutput("gg")
                         ),
                         column(5,
                                h3(strong("Table Output")),
                                dataTableOutput("table")
                         )
                       )
      )
    )
  )
)

server <- function(input, output) {
  
  # import server
  output$fileName <- renderPrint({ input$myFile$name })
  output$path <- renderPrint({ input$myFile$datapath })
  
  # import original image
  nuc <- reactive({
    f = input$myFile$datapath
    readImage(f)
  })
  
  # manipulate original image
  nmask <- reactive({
    nmask <- thresh(nuc(), w = input$w, h = input$h, offset = input$offset)
    nmask <- opening(nmask, makeBrush(input$brush, shape = "disc"))
    nmask <- fillHull(nmask)
    nmask <- watershed( distmap(nmask), input$tolerance ) # this part slows down shiny a lot
    nmask <- bwlabel(nmask)
    nmask
  })
  
  # display images
  output$original <- renderPlot({ plot(nuc()) })
  output$workbench <- renderPlot({ plot(nmask()) })
  
  output$n <- renderPrint({ paste(range(nmask())[2], "nuclei detected.") })
  
  # display size vs expression: graphical and tabular
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
  
  # download data table and log
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