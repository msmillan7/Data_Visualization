library(plotly)
library(shinydashboard)
library(shiny)
library(shinythemes)



dashboardPage(
    
    skin = "blue",
    dashboardHeader(title = "Life expectancy vs. Fertility Around The World",
                    titleWidth = 470),
    
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

