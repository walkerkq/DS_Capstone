library("shiny")

shinyServer(function(input, output) {
     
    #source("functions.R")
    source("functions_pKN.R")
    
    output$text1 <- renderText({
        mostLikely(input$text, 1)
    })
    output$text2 <- renderText({
        mostLikely(input$text, 2)
    })
    output$text3 <- renderText({
        mostLikely(input$text, 3)
    })
    output$text4 <- renderText({
        mostLikely(input$text, 4)
    })
    output$text5 <- renderText({
        mostLikely(input$text, 5)
        
    })
    
    output$yourSentence <- renderText({
        
        input$text
        
    })
    
})