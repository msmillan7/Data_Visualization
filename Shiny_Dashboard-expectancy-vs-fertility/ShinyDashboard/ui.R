library(plotly)
library(shinydashboard)
library(shiny)



dashboardPage(
    
    dashboardHeader(title = "Life expectancy vs. Fertility Around The World"),
    
    dashboardSidebar(
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

