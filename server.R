library(pacman)
library(shiny)
p_load(ggplot2, ggalt, gapminder, tidyr, dplyr,
       stringr, plotly)

# Define server logic required to draw a dumbbell plot
server <- function(input, output, session) {
  rv <- reactiveValues(prev_CountrySelect = NULL)
  
  # preserve country choices when adding more continents
  observeEvent(input$countryChoice, {
    if(length(input$continentChoice) >= 1 &
       length(input$countryChoice) > 1){
      rv$prev_CountrySelect <- c(rv$prev_CountrySelect,
                               input$countryChoice)
    }
    
    else{
      rv$prev_CountrySelect <- c()
    }
  })
  
  # update list of countries based on selection
  observe({
    
    # get list of countries
    countrySelection <- gapminder |>
      select(continent, country) |>
      distinct() |> 
      arrange(country) |> 
      filter(continent %in% input$continentChoice) |> 
      pull(country)

    # check if continent choice is blank
    if(length(input$continentChoice) < 1){
      
      # blank out choices
      updateSelectInput(session, "countryChoice",
                        selected = character(0))
    }
    else{
      # update selection
      #Update the actual input depending on continent choice
      updateSelectInput(session, "countryChoice",
                        choices = countrySelection, 
                        selected = rv$prev_CountrySelect
                        )
    }
  })
  
  
  output$dbPlot <- renderPlotly({
    # load data
    data(gapminder, package = "gapminder")
    
    # subset data
    # check if only looking at data for one year
    if(input$yr_range[1] == input$yr_range[2]){
      plotdata_long <- 
        gapminder |>
        filter(continent %in% input$continentChoice &
               year %in% c(input$yr_range[1])) |> 
            slice(rep(c(1:n()), each = 2))
    }
    # otherwise, grab data for the two years 
    else{
      plotdata_long <- 
        gapminder |> 
        filter(continent %in% input$continentChoice &
                 year %in% c(input$yr_range[1],
                             input$yr_range[2]))
    }
    
    # check if got no countries or continents chosen
    if(!length(input$continentChoice) | 
       is.null(input$countryChoice) | !length(input$countryChoice)){
      plotdata_long <- plotdata_long |> 
        filter(country %in% input$countryChoice)
    }
    else{
      plotdata_long <- plotdata_long |> 
        filter(country %in% input$countryChoice) |> 
        mutate(paired = rep(c(1:(n()/2)), each = 2),
               year = factor(year))
    }
    # SOURCE: https://plotly.com/ggplot2/dumbbell-plots/
    
    # plotting
    # create dumbbell plot
    # check if there's no country and/or continent chosen
    
    if(!length(input$continentChoice) |  
       is.null(input$countryChoice) | !length(input$countryChoice)){
      db_plot <- ggplot(gapminder[0,], 
                        aes(y = country,
                            x = lifeExp)) +
        theme_minimal() + 
        labs(#title = str_glue("Change in Life Expectancy ({input$continentChoice})"),
          #subtitle = str_c(input$yr_range, collapse = " to "),
          x = "Life Expectancy (years)",
          y = "Country",
          caption = "Source: gapminder")
    }
    else{
      db_plot <- ggplot(plotdata_long, 
             aes(
                # sort countries in alphabetical order
                 y = factor(country, 
                            levels = sort(levels(country),
                                          decreasing = T)),
                 x = lifeExp)) +
        geom_line(aes(group = paired),
                  color = "grey") +
        geom_point(aes(
          color = year,
          
          # change tooltip text
          # SOURCE: https://plotly-r.com/controlling-tooltips
          text = paste("<b>Country</b>:", country,
                       "\n<b>Life Expectancy</b>:", round(lifeExp, 2), "years",
                      "\n<b>Year</b>:", year
                      )), size = 4) +
        theme_minimal() + 
          theme(legend.position = "top",
                axis.title.y = element_text(
                  margin = margin(t = 0, r = 20, b = 0, l = 0),
                  hjust = -0.8
                )) + 
        labs(#title = str_glue("Change in Life Expectancy ({input$continentChoice})"),
             #subtitle = str_c(input$yr_range, collapse = " to "),
             x = "Life Expectancy (years)",
             y = "Country",
             color = "Year",
             caption = "Source: gapminder") + 
        scale_y_discrete(guide = guide_axis(n.dodge=3)) 
    }
    ggplotly(db_plot, tooltip = c("text"))
  })
}