library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(bslib)
library(rsconnect)
# Calculated Summary Values:
data <- data.frame(read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv"))

# 1) WHAT YEAR DID THE US HAVE IT'S HIGHEST AMOUNT OF CO2 EMMISSIONS(millions of tons)?
Value_1 <- data %>% filter(country == "United States") %>% arrange(co2) %>% pull(year) %>% last()
# 2) WHAT YEAR HAD THE LARGEST CHANGE IN POPULATION FOR THE US?
data <- mutate(data, change_in_pop = population - lag(population, default = 0))
Value_2 <- data %>% filter(country == "United States") %>% arrange(change_in_pop) %>%
  pull(year) %>% last()
# 3) WHAT COUNTRY PRODUCED THE MOST CARBON EMISIONS IN 2005?
# Remove NA values
Value_3 <- data %>% group_by(country) %>% filter(year == 2005 & co2 == max(co2)) %>%
  arrange(co2) %>% pull(country) %>% last()

# 4) WHAT COUNTRY HAS THE HIGHEST RATIO OF CARBON EMMISIONS TO GDP OVER ALL TIME?
Value_4 <- data %>% filter(!is.na(co2_per_gdp)) %>% group_by(country) %>% arrange(mean(co2_per_gdp)) %>%
  pull(country) %>% unique() %>% last()

# 5) WHAT YEAR HAD THE SMALLEST CHANGE IN POPULATION FOR THE US?
Value_5 <- data %>% filter(country == "United States" & change_in_pop != 0 & !is.na(change_in_pop)) %>% arrange(desc(change_in_pop)) %>%
  pull(year) %>% last()



server <- function(input, output) {
  # make a plot where you can change the country, and the variable/s youre looking at

  # DONT FORGET TO MAKE THIS PART INTERACTIVE WITH PLOTLY
  output$CO2_Plot <- renderPlotly({

    filtered_df <- data %>%
      # Filter for user's country selection
      filter(country %in% input$country_selection) %>%
      # Select rows wanted
      select("year", input$Variables) %>%
      # Makes sure rows have values
      # filter(!is.na(input$Variables) | input$Variables != 0)
      na.omit()

      # statements to add new lines based on user input of # of variables
    if("co2" == input$Variables) {
      plot_to_print <- ggplot(data = filtered_df, aes(x = year)) +
        geom_line(aes(y = co2, color = "co2")) +
        labs(title = "Emmision of CO2",
             x = ("Year"),
             y = ("Volume(Million Tonnes)"),
             color = "Variable"
        ) + scale_color_manual(values = c("co2" = "Blue"))
    }
    # ADD IN LABS THE NUMBER OF A CERTAIN VARIABLE, SO ITS NOT JUST 10E-10 OR SOMETHING
    if("gdp" == input$Variables) {
      plot_to_print <- ggplot(data = filtered_df, aes(x = year)) +
        geom_line(aes(y = gdp, color = "gdp")) +
        labs(title = "GDP of Country",
             x = ("Year"),
             y = ("Volume"),
             color = "Variable"
        ) + scale_color_manual(values = c("gdp" = "Red"))
    }
    if("population" == input$Variables) {
      plot_to_print <- ggplot(data = filtered_df, aes(x = year)) +
        geom_line(aes(y = population, color = "population")) +
        labs(title = "Population Growth",
             x = ("Year"),
             y = ("Volume"),
             color = "Variable"
        ) + scale_color_manual(values = c("population" = "Green"))
    }
    return(plot_to_print)

  })

}