library(shinydashboard)
library(shiny)



dashboardPage(
    
    dashboardHeader(title = "Life expectancy vs. Fertility Around The World"),
    
    dashboardSidebar(
        #sliderInput("year", "Select year ", min=1990, max=2018, value=2000),
        #selectInput("region", "Select a Region", c(1960:2020), selected=2014),
        #selectInput("country", "Select a Country", c(1960:2020), selected=2014),
        uiOutput("years"),
        uiOutput("regions"),
        uiOutput("countries")
         ),
    
    dashboardBody(
        tabPanel(title="My Plot",
                 plotlyOutput("myplot")
        )
    )

)

