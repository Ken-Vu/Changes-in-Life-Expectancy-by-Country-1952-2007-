library(pacman)
p_load(ggplot2, gapminder, dplyr, tidyr, tibble)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  
  # Application title
  titlePanel(
    
    h1("Changes in Life Expectancy by Country (1952-2007)", align = "center")
    ),
  p("This RShiny dashboard presents data on changes in the life expectancy at birth
    for each country from one chosen year to another chosen year.  The data was taken
    from the ", a("gapminder", href = "https://cran.r-project.org/web/packages/gapminder/index.html"),
    "package in R and is presented as a dumbbell plot, which is
    derived from Chapter 8.2 in the book",
    a("Modern Data Visualization with R", href = "https://rkabacoff.github.io/datavis/index.html"),
    "by Robert Kamacoff."),
    br(), 
  p("You can access the code and instructions for this RShiny dashboard here:",
    a("GitHub for this RShiny application", href = "https://github.com/Ken-Vu/Changes-in-Life-Expectancy-by-Country-1952-2007-/tree/main")),
  br(),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      h4("Filter"),
      sliderInput("yr_range",
                  "Year(s):",
                  min = 1952,
                  max = 2007,
                  step = 5,
                  sep = "",
                  value = c(1952, 2007)),
      checkboxGroupInput("continentChoice",
                  "Continent(s):",
                  choices = gapminder$continent |>
                    unique(),
                  selected = "Asia"
      ),
      
      selectizeInput("countryChoice",
                  "Countries (max = 15):",
                  choices=c(),
                  multiple=T,
                  options = list(maxItems = 15),
                  ),
      downloadButton("downloadReport", "Download report")
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", 
                           br(),
                           downloadButton("downloadPlot", "Download plot"),
                           plotlyOutput("dbPlot", width = "100%",
                                                height = "100%")),
                  
                  tabPanel("Summary",
                           br(),
                           downloadButton("downloadSumTable", "Download summary"), 
                           br(),
                           br(),
                           fluidRow(style = "padding: 0px 0px; margin-bottom: 0px;",
                                    tableOutput("summaryTable")
                                    )
                           ),
                  
                  tabPanel("Data",
                           br(),
                           downloadButton("downloadData", "Download data"),
                           br(),
                           br(),
                           tableOutput("dataLifeExp")))

      )
      
    )
    
  )