data <- data.frame(read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv"))
library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(bslib)
library(rsconnect)
# All Text
Title <- h1("CO2 Data Work", align = "center")

# Text for intoTab
intro_Title <- h2("Impacts of CO2", align = "center")
intro_Paragraph_1 <- p("The human race has dramatically progressed technologically over the centuries,
as these changes continue to speed up, the Earth starts to feel the negative effects related to this progression.
One praticular effect of this progression is the rising CO2 levels and climate change. But how much have humans had an impact on
this over the decades? That is the question I hope to answer through my data gathering and visualizations.
I want to be able to show how much of an impact an increase in human population/and advancment can effect our enviornment",
                       align = "center")
intro_Paragraph_2 <- p("In order to best display these impacts I plan to calulate and work with data related to
 population size, adv. Global Temps, CO2 emmisions, etc.", align = "center")
Summary_Values_title <- h2("Summary Values", align = "center")
Summary_Values_P1 <- p("WHAT YEAR DID THE US HAVE IT'S HIGHEST AMOUNT OF CO2 EMMISSIONS(millions of tons)?", align = "center")
Summary_Values_P1.2 <- p("The year the US produced the highest amount of CO2 was in 2005", align = "center")
Summary_Values_P2 <- p("WHAT YEAR HAD THE LARGEST CHANGE IN POPULATION FOR THE US?", align = "center")
Summary_Values_P2.2 <- p("The year with the largest change in population in the US was in 1992", align = "center")
Summary_Values_P3 <- p("WHAT COUNTRY PRODUCED THE MOST CARBON EMISIONS IN 2005?", align = "center")
Summary_Values_P3.2 <- p("The country that produced the most carbon emmisions in 2005 was the US", align = "center")
Summary_Values_P4 <- p("WHAT COUNTRY HAS THE HIGHEST RATIO OF CARBON EMMISIONS TO GDP OVER ALL TIME?", align = "center")
Summary_Values_P4.2 <- p("The country with the highest CO2 emmisions to GDP over all time is Zimbabwe", align = "center")
Summary_Values_P5 <- p("WHAT YEAR HAD THE SMALLEST CHANGE IN POPULATION FOR THE US?", align = "center")
Summary_Values_P5.2 <- p("The smallest change in population in the US was 1800", align = "center")

Dataset_Summary <- h2("Who collected the data? How was the data collected or generated?
Why was the data collected? What are possible limitations or problems with this data?", align = "center")

Dataset_Summary_P2 <- p("The data was collected by Hannah Ritchie, Max Roser and Pablo Rosado. The data was collected by a team of
data analyists at the non-profit Our world in Data. Most data came from the reports and data analitics of countries that are reported yearly
as well as simulated data from people at the non-profit Our world in Data. The data was collected in order to help people
understand how Co2 levels effect the wolrd around us and our total impact. Possible limitations involved with this data if the
 lack of for certain countries over the years, with this kind of data it is very hard to get accurate data that is also consitently shared
 or recorded, so for that reason the data requires filtration and overview in order to make good use of it. Another limitation that might
 occur is if countries lie about level of Co2 being emitted or certain data being overlooked, this data has alot of moving variables and
 because of that, there is always a chance that the data doesn't accurately show the true totals", align = "center")

Conclusion <- h2("Conculsion", align = "center")

Conclusion_P2 <- p("From the data visualizations and summary values calculated, I am able to get a better understanding
of how population plays a role in Co2 emmisions as well as if countries are improving in their Co2 emmision reductions or not
 over the years. Being able to visualize data like the ones displayed in the grpahs of this project allow for people to get a better
 understanding of trends over time and how their respective countries are performing in a time that requires a more concious
 approach to fuel use and clean energy. I am able to see from most of these graphs the steep increase in use of fossil fuels as well as how
 some countries have made inprovments over time.", align = "center")


summary_Tab <- tabPanel("Data Summary",
                        intro_Title,
                        intro_Paragraph_1,
                        intro_Paragraph_2,
                        Summary_Values_title,
                        Summary_Values_P1,
                        Summary_Values_P1.2,
                        Summary_Values_P2,
                        Summary_Values_P2.2,
                        Summary_Values_P3,
                        Summary_Values_P3.2,
                        Summary_Values_P4,
                        Summary_Values_P4.2,
                        Summary_Values_P5,
                        Summary_Values_P5.2,
                        Dataset_Summary,
                        Dataset_Summary_P2,
                        Conclusion,
                        Conclusion_P2
)

Viz_theme <- bs_theme(
  bg = "#0b3d91", # background color
  fg = "white", # foreground color
  primary = "#FCC780", # primary color
)
# Update BootSwatch Theme
Viz_theme <- bs_theme_update(Viz_theme, bootswatch = "journal")

country_widget <- selectizeInput(inputId = "country_selection",
                                 label= "Region",
                                 # MIGHT NEED TO MAKE UNIQUE?
                                 choices = unique(data$country),
                                 selected = "United States"
)

variables_widget <- radioButtons(inputId = "Variables",
                                       label = h3("Variables"),
                                       choices = list("CO2" = "co2", "GDP" = "gdp", "POPULATION" = "population"),
                                       selected = "co2")


main_Plot <- mainPanel(
  # Make plot interactive
  plotlyOutput(outputId = "CO2_Plot")
)
main_Plot_Description <- p("This graphs allows you to choose which country you want to see the trends over time with. You
are able to choose one of three different variables of the database used for all the information collected")


viz_tab <- tabPanel("Data Viz",
                    sidebarLayout(
                      sidebarPanel(
                        country_widget,
                        variables_widget,
                        main_Plot_Description
                        # can add more
                      ),
                      main_Plot
                    )
  )


ui <- navbarPage(
  theme = Viz_theme,
  titlePanel(Title),
  summary_Tab,
  viz_tab
)

