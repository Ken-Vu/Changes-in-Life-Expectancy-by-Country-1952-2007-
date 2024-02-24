library(pacman)
p_load(ggplot2, gapminder, dplyr, tidyr, plotly, 
       tibble)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  
  # Application title
  titlePanel(
    
    h1("Changes in Life Expectancy by Country (1952-2007)", align = "center")
    ),
  h2("Description"),
  p("This RShiny dashboard presents data on changes in the life expectancy at birth
    for each country from one chosen year to another chosen year.  The data was taken
    from the ", a("gapminder", href = "https://cran.r-project.org/web/packages/gapminder/index.html"),
    "package in R and is presented as a dumbbell plot, which is
    derived from Chapter 8.2 in the book",
    a("Modern Data Visualization with R", href = "https://rkabacoff.github.io/datavis/index.html"),
    "by Robert Kamacoff."),
  p("Click on the tab ", tags$u("Instructions"), "below to read instructions on how to use this dashbaord."),
  h2("Link"),
  p("You can access the code for this RShiny dashboard here:",
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
                           tableOutput("dataLifeExp")),
                  
                  # SOURCE: https://shiny.posit.co/r/articles/build/tag-glossary/
                  tabPanel("Instructions",
                           br(),
                           strong("Instructions:"),
                           p("To use this dashboard, you can start by doing the following:"),
                           tags$ol(
                             br(),
                             tags$li("Go to the", tags$u("Filter"), "toolbar to the left of the screen."),
                             br(),
                             tags$li("Use the slider labeled", tags$u("Year(s)"),"to select the range of year(s) you want to compare between for life expectancy values."),
                             br(),
                             tags$li("Go to the filter labaled", tags$u("Continent(s)"), "to select the continents you want countries to be from.  This filter updates the list of countries you can pick in the",
                                     tags$em("Countries (max = 15)"), "filter at the bottom of the left sidebar."),
                             br(),
                             tags$li("Click on the text box under the filter labeled", tags$u("Countries (max=15):"),
                                     "to get a list of countries you can select from."),
                             br(),
                             tags$li("Once you make your selections, you can click on the tabs labeled",
                                     tags$u("Plot", .noWS = c("after")),",", 
                                     tags$u("Summary", .noWS = c("after")), ",",
                                     "and/or", tags$u("Data"),
                                     "to get the dumbbell plot, summary statistics, and the filtered data respectively, given
                                     the filters you set earlier."),
                             br()
                             
                           ),
                           
                           p(strong("NOTE:"), 
                             tags$ul(
                               tags$li("You can also download the dumbbell plot, summary statistics table, and the table of filtered data
                                 respectively using the download tab in each of the tabs",
                                 tags$u("Plot", .noWS = c("after")),",", 
                                 tags$u("Summary", .noWS = c("after")), ",", 
                                 "and/or", tags$u("Data"), "respectively."),
                               tags$li("Alternatively, you can download a formal summary report with the dumbbell plot, summary statistics,
                                       and filtered data using the download button at the button of the",
                                       tags$u("Filter"), "toolbar to the left of this screen."),
                               tags$li("All downloaded files are automatically sent to the",
                                       tags$em("Downloads"), "folder of your respective computer.")
                               )
                           )
                           
                           
                           )
                  )

      )
      
    )
    
  )