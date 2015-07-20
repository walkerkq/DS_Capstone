# Model functions

cleanInput <- function(x) {
    raw_input <- x
    input <- tolower(raw_input)
    input <- gsub("[^[:alpha:] ]", "", input)
    input <- strsplit(input, " ")
    return(input)
}

match <- function(input, nlength, grams, onelessgrams) {
    input <- cleanInput(input)
    if(nlength != 1) { nlength2 <- nlength -2; end <- "\\s" 
    } else { nlength2 <- 0; end <- "$" }
    chunk <- input[[1]][ (length(input[[1]])-nlength2):length(input[[1]]) ] 
    chunk <- paste(chunk, collapse=" ")
    chunk <- gsub("^\\s+|\\s+$", "", chunk)
    n <- grams[grep(paste("^", chunk, end, sep=""), grams$word), ]
    m <- onelessgrams[grep(paste("^", chunk, "$", sep=""), onelessgrams$word), ]
    n$prob <- n$freq/m$freq[1]
    return(n)
}

mostLikely <- function(input) {
    m4 <- match(input, 4, quadgrams, trigrams)
    m3 <- match(input, 3, trigrams, bigrams)
    m2 <- match(input, 2, bigrams, unigrams)
    jumble <- rbind(m4, m3, m2)
    jumble <- jumble[order(-jumble$prob),]
    winner <- jumble[1,1]
    winner <- strsplit(winner, " ")
    winner <- winner[[1]][length(winner[[1]])]
    return(winner)
}