library("shiny")

shinyServer(function(input, output) {
    
    #install.packages(c("tm", "RWeka", "SnowballC"))
    library(tm)
    library(RWeka)
    library(SnowballC)
     
    source("functions.R")
    
    setwd("/Users/kwalker/git_projects/DS_Capstone")
    #setwd("/Users/kaylinwalker/R/DS_Capstone")
    unigrams <- read.csv("compressed_freq/uniCompress.csv", stringsAsFactors=FALSE)
    bigrams <- read.csv("compressed_freq/biCompress.csv", stringsAsFactors=FALSE)
    trigrams <- read.csv("compressed_freq/triCompress.csv", stringsAsFactors=FALSE)
    quadgrams <- read.csv("compressed_freq/quadCompress.csv", stringsAsFactors=FALSE)
    
    
    output$text1 <- renderText({
        
        mostLikely(input$text)
        
    })
    
})