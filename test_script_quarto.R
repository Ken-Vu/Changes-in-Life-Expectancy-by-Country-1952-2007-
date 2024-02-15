library(pacman)
p_load(dplyr, quarto)

yr_range <- c(1962, 1972)
countryList <- c()

params <- list(yr_range = yr_range,
               countryList = countryList)

# render document
quarto::quarto_render("report_template.qmd",
                      output_format = "pdf",
                      execute_params = params)

