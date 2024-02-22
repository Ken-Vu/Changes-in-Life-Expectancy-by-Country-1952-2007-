library(pacman)
library(shiny)
p_load(ggplot2, gapminder, dplyr, plotly, tidyr, tibble)


# Define server logic required to draw a dumbbell plot
server <- function(input, output, session) {
  
  
  # have temporary place to store previous
  # country selections and year selections
  rv <- reactiveValues(prev_CountrySelect = NULL,
                       prev_YearSelect = NULL)
  
  #...........................................
  # SEC 1: Getting List of Countries ----
  #...........................................
  
  ## a. Preserve Country Choices ----
  # preserve country choices when adding more continents
  observeEvent(input$countryChoice, {
    if(length(input$continentChoice) >= 1 &
       length(input$countryChoice) >= 1){
      rv$prev_CountrySelect <- c(rv$prev_CountrySelect,
                               input$countryChoice)
    }
    else if(!is.null(input$continentChoice) | 
            length(input$continentChoice) < 1){
      rv$prev_CountrySelect <- c()
    }
    
    else{
      rv$prev_CountrySelect <- c()
    }
  })
  
  ## b. Update Country List ----
  # update list of countries based on selection
  observeEvent(input$continentChoice,
               ignoreNULL = F, {
    
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
    
    # if deselecting countries, don't add back the 
    # deselected country
    if(length(input$countryChoice) < length(rv$prev_CountrySelect)){
      # update selection
      #Update the actual input depending on continent choice
      updateSelectInput(session, "countryChoice",
                        choices = countrySelection, 
                        selected = input$countryChoice
                        )
    }
    # a check to make sure it retains countries
    # selected when adding more countries to plot
    else{
      updateSelectInput(session, "countryChoice",
                        choices = countrySelection, 
                        selected = c(input$countryChoice,
                                     rv$prev_CountrySelect)
      )
    }
  }) 
  
  #...........................................
  # SEC 2: Getting Summary Tables ----
  #...........................................
  # Contains summary statistics for chosen
  # countries
  
  # save summary table as reactive to reuse later
  sumTable <- reactive({
    # function to get summary table
    get_sumTable1 <- function(yr_range, countryChoice){
      
      tempTable <- gapminder |> 
        filter(year %in% yr_range & country %in% countryChoice) |> 
        group_by(year) |> 
        summarise(`Minimum` = min(lifeExp),
                  `1st Quantile` = quantile(lifeExp, 0.25),
                  `Median` = median(lifeExp),
                  `Mean` = mean(lifeExp),
                  `3rd Quantile` = quantile(lifeExp, 0.75),
                  `Maximum` = max(lifeExp),
                  `Standard Deviation` = sd(lifeExp)
        ) |>
        
        # round each column to two places
        mutate_at(vars(-year), list(~round(., 2))) |> 
        # transpose table
        t() |>
        as.data.frame(stringsAsFactors = F, header=T) |>
        rownames_to_column("Metric Name")

      # rename columns
      # depends on how many years picked
      if(input$yr_range[1] == input$yr_range[2]){
        colnames(tempTable) <- c("Metric", input$yr_range[1])
      }
      else{
        colnames(tempTable) <- c("Metric", input$yr_range)
      }

      # return formatted tibble
      tempTable[-1,] |>
        as_tibble()
      
    }
    
    
    # check if got no countries or continents chosen
    if(!length(input$continentChoice) | 
       is.null(input$countryChoice) | !length(input$countryChoice)){
      # create a dummy table
      summaryTable <- get_sumTable1(input$yr_range, 
                                    c("Japan")) |> 
        slice(0)
    }
    
    else{
      summaryTable <- get_sumTable1(input$yr_range, 
                                    input$countryChoice)
    }
    summaryTable
  })
  
  # render summary table
  output$summaryTable <- renderTable({
    
    # create summary table
    sumTable()
    
  }) 


  #...........................................
  # SEC 3: Getting Data ----
  #...........................................
  # Shows all the data for life expectancy for each
  # country chosen and the years picked
  dataSubset <- reactive({
    # subset data
    # check if only looking at data for one year
    if(input$yr_range[1] == input$yr_range[2]){
      plotdata_table <- 
        gapminder |>
        filter(continent %in% input$continentChoice &
                 year %in% c(input$yr_range[1]))
    }
    # otherwise, grab data for the two years 
    else{
      plotdata_table <- 
        gapminder |> 
        filter(continent %in% input$continentChoice &
                 year %in% input$yr_range)
    }
    
    # check if got no countries or continents chosen
    if(!length(input$continentChoice) | 
       is.null(input$countryChoice) | !length(input$countryChoice)){
      # get dummy table with nothing in it
      plotdata_table <- gapminder |> 
        filter(country == "Japan" & year %in% input$yr_range) |>
        select(continent, country, year, lifeExp) |> 
        arrange(continent, country) |>
        rename(Continent = continent,
               Country = country) |> 
        pivot_wider(names_from = year,
                    names_glue = "Life Expectancy in {year} (years)",
                    values_from = lifeExp) |> 
        slice(0)
    }
    else{
      plotdata_table <- plotdata_table |> 
        filter(country %in% input$countryChoice) |> 
        mutate(year = factor(year)) |> 
        select(continent, country, year, lifeExp) |> 
        arrange(continent, country) |> 
        
        # pivot wider to compare data between years
        rename(Continent = continent,
               Country = country) |> 
        pivot_wider(names_from = year,
                    names_glue = "Life Expectancy in {year} (years)",
                    values_from = lifeExp)
    }
    
    plotdata_table
  })
  
  # output data to plotly
  output$dataLifeExp <- renderTable({
    
    dataSubset()
    # SOURCE: https://plotly.com/ggplot2/dumbbell-plots/
    
    
  })
  
  #...........................................
  # SEC 4: Outputting up dumbbell plot ----
  #...........................................
  # Outputting plot
  
  # function for dumbbell plot to reuse plot later
  db_plot <- reactive({
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
    if(is.null(input$continentChoice) | !length(input$continentChoice) | 
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
    
    if(is.null(input$continentChoice) | !length(input$continentChoice) | 
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
    
    db_plot
  })
  
  # outputting the ggplot as a plotly object
  output$dbPlot <- renderPlotly({
    ggplotly(db_plot(), tooltip = c("text"))
  })
  
  # SEC 5: Downloading dashbaord elements ----
  ## a. Downloading report ---- 
  # The code to trigger the download of a custom report
  # made in Quarto
  
  # read https://shiny.posit.co/r/articles/build/generating-reports/
  output$downloadReport <- downloadHandler(
    filename = "report.pdf",
    content = function(file){
      
      
      # save table 
      
      # get parameters
      params <- list(
        "yr_range" = input$yr_range,
        "countryList" = input$countryChoice)
      
      id <- showNotification(
        "Rendering report...", 
        duration = NULL, 
        closeButton = FALSE
      )
      on.exit(removeNotification(id), add = TRUE)
      
      # render document
      quarto::quarto_render("report_template.qmd",
                            output_format = "pdf",
                            execute_params = params)
      
      # save it to download location
      file.copy("report_template.pdf", file)
    }
      
  )
  
  ## b. Downloading dumbbell plot ----
  output$downloadPlot <- downloadHandler(
    filename = "db_plot.jpg",
    content = function(file){
      
      ggsave(file, plot = db_plot(),
             width = 8, height = 5,
             device = "jpg")
    }
  )
  
  ## c. Download summary table ----
  output$downloadSumTable <- downloadHandler(
    filename = "summary_table.csv",
    content = function(file){
      
      write.csv(sumTable(), file)
    }
  )
  
  ## d. Download data ----
  output$downloadData <- downloadHandler(
    filename = "lifeExp_data_subset.csv",
    content = function(file){
      
      write.csv(dataSubset(), file)
    }
  )
}