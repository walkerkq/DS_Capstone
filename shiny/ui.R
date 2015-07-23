library("shiny")

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Sentence Finisher"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            h3("Directions"),
            p("Type in at least 2 words to receive a suggested next word."),
            textInput("text", label=h4("Your unfinished sentence"),
                      value="I can't wait to"),
            submitButton("Go")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            h3("Background"),
            p("Placeholder text"),
            h3("Possible sentences:"),
            strong(textOutput("yourSentence")),
            textOutput("text1"),
            textOutput("text2"),
            textOutput("text3"),
            textOutput("text4"),
            textOutput("text5"),
            br(),
            br(),
            p("Was I right?"),
            actionButton("correct", label="Jinx! You owe me a soda.")
        )
    )
))