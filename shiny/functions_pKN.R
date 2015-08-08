#setwd("/Users/kwalker/git_projects/DS_Capstone/shiny")
#setwd("/Users/kaylinwalker/R/DS_Capstone/shiny")

# Model functions
unigrams <- read.csv("compressed_freq/uniCompress.csv", stringsAsFactors=FALSE)
bigrams <- read.csv("compressed_freq/biCompress.csv", stringsAsFactors=FALSE)
trigrams <- read.csv("compressed_freq/triCompress.csv", stringsAsFactors=FALSE)
quadgrams <- read.csv("compressed_freq/quadCompress.csv", stringsAsFactors=FALSE)

cleanInput <- function(input) {
     raw_input <- input
     input <- tolower(raw_input)
     input <- gsub("[^[:alpha:] ]", "", input)
     input <- strsplit(input, " ")
     return(input)
}

match <- function(input, nlength, grams, onelessgrams) {
     input <- cleanInput(input)
     if(length(input[[1]]) <= 1) { 
          return(0)
     } else { 
          if(nlength != 1) { nlength2 <- nlength -2; end <- "\\s" 
          } else { nlength2 <- 0; end <- "$"}
          chunk <- input[[1]][ (length(input[[1]])-nlength2):length(input[[1]]) ] 
          chunk <- paste(chunk, collapse=" ")
          chunk <- gsub("^\\s+|\\s+$", "", chunk)
          n <- grams[grep(paste("^", chunk, end, sep=""), grams$word), ]
          if (dim(n)[1]>=20) n <- n[1:20, ]
          
          if (dim(n)[1]!=0) { 
               # get predicted word counts
               predicted <- t(as.data.frame(strsplit(n$word, " ")))[,nlength]
               pp <- cbind(predicted, rep(0, length(predicted)))
               row.names(pp) <- NULL
               for (g in 1:length(pp[,1])) {
                    x <- unigrams[grep(paste("^", pp[g,1], "$", sep=""), unigrams$word), 2]
                    if (length(x)!=0) {
                         pp[g, 2] <- x
                    } else {  }
               }
               # get w i-1 count
               m <- onelessgrams[grep(paste("^", chunk, "$", sep=""), onelessgrams$word), ]
               n$prob <- n$freq/m$freq[1]
               n$lastCount <- as.numeric(pp[,2])
               
               # Kneser-Ney smoothing
               delta <- 0.796
               for (f in 1:length(n[,1])) { 
                    n$pKN[f] <- (max(n$freq[f] - delta, 0) / m$freq[1]) + (delta/m$freq[1]) * n$freq[f] * ( n$lastCount[f] / dim(bigrams)[1])
               }
          }
          return(n)
     }
}

mostLikely <- function(input, howMany) {
     m4 <- match(input, 4, quadgrams, trigrams)
     m3 <- match(input, 3, trigrams, bigrams)
     m2 <- match(input, 2, bigrams, unigrams)
     jumble <- rbind(m4, m3, m2)
     if(dim(jumble)[1]==0) {
          # handle unknown words or wrong words
          return("I don't know that word, please try again.")
     } else if (jumble[1,1]==0 ) {
          # handle user putting in only one word
          return("You'll need to enter at least 2 words.")
     } else { 
          jumble <- jumble[order(-jumble$pKN),]
          winner <- jumble[1:(howMany*2), 1]
          winner <- strsplit(winner, " ")
          words <- NULL
          for (i in 1:length(winner)) {
               lastWord <- winner[[i]][length(winner[[i]])]
               words <- c(words, lastWord)
               words <- unique(words)
          }
          return(words[howMany])
     }
}

