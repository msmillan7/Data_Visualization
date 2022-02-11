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
        uiOutput("countries"),
        actionButton("reset_input", "Reset filters", 
                     style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
    ),
    
    dashboardBody(
        tabPanel(title="Life expectancy vs. Fertility",
                 plotlyOutput("myplot")
        )
    )

)

