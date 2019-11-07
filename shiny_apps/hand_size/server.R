# Sys.setlocale(locale="en_US.UTF-8") # Mac
# Sys.setlocale(locale="English")

library(shiny)
library(ggplot2)
library(dplyr)

dat = read.table("./data/ANSUR.txt", header = TRUE, dec = ".")

shinyServer(
    function(input, output) {
        output$height = renderPlot({
            if(input$my_gender == "M") dat = filter(dat, GENDER == "M")
            else dat = filter(dat, GENDER == "F")
            
            ggplot(dat, aes(x = HEIGHT_CM)) +
                geom_density(fill = "steelblue4", color = "steelblue4", alpha = 1/2) +
                theme(legend.position = "null") +
                scale_y_continuous(limits = c(0, .065)) +
                labs(x = "Body Height (cm)", title = "Body height distribution") +
                geom_vline(xintercept = input$my_height, color = "black", size = 1.1) +
                annotate("text", x = input$my_height - 2, y = 0, angle = 90, hjust = 0, color = "black", label = input$my_name, size = 6) +
                annotate("text", x = mean(dat[,2]), y = .01, 
                         label = paste0(round(100 - pnorm(input$my_height, mean(dat[,2]), sd(dat[,2])) * 100, 1), "%"), 
                         color = "white", size = 10)
        })
        
        output$hand = renderPlot({
            if(input$my_gender == "M") dat = filter(dat, GENDER == "M")
            else dat = filter(dat, GENDER == "F")
            
            ggplot(dat, aes(x = HAND_LNTH)) +
                geom_density(fill = "steelblue4", color = "steelblue4", alpha = 1/2) +
                theme(legend.position = "null") +
                scale_y_continuous(limits = c(0, .065)) +
                labs(x = "Hand length (mm)", title = "Hand length distribution") +
                geom_vline(xintercept = input$my_hand, color = "black", size = 1.1) +
                annotate("text", x = input$my_hand - 2, y = 0, angle = 90, hjust = 0, color = "black", label = input$my_name, size = 6) +
                annotate("text", x = mean(dat[,3]), y = .01,
                         label = paste0(round(100 - pnorm(input$my_hand, mean(dat[,3]), sd(dat[,3])) * 100, 1), "%"),
                         color = "white", size = 10)
        })
        
        output$regression = renderPlot ({
            if(input$my_gender == "M") dat = filter(dat, GENDER == "M")
            else dat = filter(dat, GENDER == "F")
            
            arrow = tibble(x1 = input$my_height, x2 = 200, 
                           y1 = input$my_hand, y2 = 160)
            
            ggplot(dat, aes(x = HEIGHT_CM, y = HAND_LNTH)) +
                geom_point() + geom_jitter() +
                geom_smooth(method = "lm", se = FALSE, size = 1.5, linetype = "dashed", color = "blue") +
                geom_point(aes(x = input$my_height, y = input$my_hand), color = "red",  cex = 2.5) +
                geom_vline(xintercept = input$my_height, color = "red", linetype = "dashed", alpha = 1/2) +
                geom_hline(yintercept = input$my_hand, color = "red", linetype = "dashed", alpha = 1/2) +
                labs(x = "Body Height (cm)", y = "Hand Length (mm)", title = "Relationship body height and hand length") +
                geom_curve(data = arrow, aes(x = x1, y = y1, xend = x2, yend = y2), 
                           arrow = arrow(length = unit(0.1, "inch")),
                           size = .3, curvature = -.3, color = "red") +
                annotate("text", x = 200, y = 160, color = "red", label = input$my_name, size = 6, fontface = "bold", vjust = 1, hjust = .8)
        })
        
        output$givenHeight = renderPlot({
            if(input$my_gender == "M") dat = filter(dat, GENDER == "M")
            else dat = filter(dat, GENDER == "F")
            
            subset = filter(dat, between(HEIGHT_CM, input$my_height - 2.5, input$my_height + 2.5))
            mean_sim = mean(subset[,3])
            sd_sim = sd(subset[,3])
            
            ggplot() +
                geom_density(data = subset, aes(HAND_LNTH), fill = "steelblue4", color = "steelblue4", alpha = 1/2) +
                labs(x = "Hand length (mm)", title = paste0("Subdata: P(Hand > ", input$my_hand, " | Height)")) +
                geom_vline(aes(xintercept = input$my_hand), color = "black", size = 1.2) +
                annotate("text", x = input$my_hand - 2, y = 0, hjust = 0, angle = 90, color = "black", label = input$my_name, size = 6) +
                annotate("text", x = mean_sim,
                         y = .020,
                         label = paste0(round(100 - pnorm(input$my_hand, mean_sim,
                                                          sd_sim) * 100, 1), "%"), color = "white", size = 10) +
                scale_y_continuous(limits = c(0, .1))
        })
    }
)