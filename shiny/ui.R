library("shiny")

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Sentence Finisher"),
    
    sidebarLayout(

      sidebarPanel(
           h3("Background"),
           p("This word predictor was bulit from three large text files based on news, blog and Twitter content.
             The files were sampled and split into smaller and smaller phrases, which were each given a probability 
             based on the frequency of their appearance.")
            ),

      mainPanel(
           tabsetPanel(
                tabPanel("Predictor",
                         fluidRow( 
                              column(6, 
                                     h3("Directions"),
                                     p("Type in at least 2 words to receive a suggested next word."),
                                     textInput("text", label=h4("Your unfinished sentence"),
                                               value="I can't wait to"),
                                     submitButton("Go")
                                     ),
                              column(6,
                                     h3("Your next word:"),
                                     strong(textOutput("yourSentence")),
                                     textOutput("text1"),
                                     textOutput("text2"),
                                     textOutput("text3"),
                                     textOutput("text4"),
                                     textOutput("text5")
                                     )
                              )

                ),
                tabPanel("Model",
                         h3("Data source, pre-processing and compression"),
                         p("Three large text files were collected from three sources: blogs, news and Twitter. The data is from a corpus called HC Corpora (see link below)."),
                         a("HC Corpora", href="http://corpora.heliohost.org/"),
                         p("The files cleaned by removing numbers, punctuation and whitespace. From there, the text was split into a corpus each of unigrams, bigrams, trigrams and quadgrams."),
                         a("Exploratory Analysis", href="http://rpubs.com/walkerkq/dscnlpea"),
                         p("Due to the long tail nature of n-gram frequency, each corpus was then compressed, keeping enough to cover 90% of all tokens. The final model 
                              is based on the compressed corpora of 4,826 unigrams, 42,073 bigrams, 27,829 trigrams and 5,913 quadgrams."),
                         h3("Probability and Kneser-Ney Smoothing"),
                         p("The model takes a user's input and matches it to a certain corpus of n-grams. It takes the n-1 last words of the phrase and looks for n-grams starting with those words.
                           Each phrase is given a probability based on the number of times the matching n-gram appears, divided by the number of times the n-1 phrase occurs.
                           With 'nice to meet' as an example input, the n-1 phrase looking for a trigram match is 'to meet', which appears in the bigram corpus 292 times. The 
                           matching tri-gram 'to meet you' appears in the trigram corpus 61 times, so its probability as the finishing word is 61/292 or 20.8%."),
                         p("The model then smooths these probabilities using Kneser-Ney smoothing to help account for n-grams that are unseen in the sample corpora by 
                         redistributing probability from very frequent n-grams to less frequent n-grams."),
                         a("A great Kneser-Ney tutorial", href="http://www.foldl.me/2014/kneser-ney-smoothing/"),
                         img(src="pKN.png"),
                         p("This process is then repeated for quad-, tri- and bigrams. The most likely word choice is then chosen from the n-gram with the highest KN probability.")
                         )
                )
                    
             )
                  
        )
))
