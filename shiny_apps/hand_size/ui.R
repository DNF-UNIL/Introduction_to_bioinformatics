library(shiny)

shinyUI(fluidPage(
     titlePanel("DDP Project: Are your hands in proportion with your height?"),
     
     sidebarLayout(
          sidebarPanel(
               p("This project was inspired by this ",
                 a("blog.",
                   href = "https://medium.com/@richarddmorey/about-trumps-hands-86fd9a2c7c5#.upmvz73c8"), 
                 " Briefly, the author wanted to test whether Trump's hands are small or not."),
               p("This can of course be generalized to all of us. Who does not want to know whether everything is in proportion?"),
               
               textInput("my_name", "Your name: ", value = "John Doe"),
               selectInput("my_gender", "Specify your gender", c("Male" = "M",
                                                                 "Female" = "F")),
               sliderInput("my_height", "Specify your height (cm):", min = 150, max = 210, step = 1, value = 174),
               sliderInput("my_hand", "Specify your hand length (mm) as depicted below:", min = 150, max = 240, step = 1, value = 191),
               img(src = "handMeasure.png", height = 280, width = 160)
          ),
          
          mainPanel(
               fluidRow(
                    column(5,
                           plotOutput("height")),
                    column(5,
                           plotOutput("hand"))
               ),
               fluidRow(
                    column(5,
                           plotOutput("regression")),
                    column(5,
                           plotOutput("givenHeight"))
               )
          )  
     )
))