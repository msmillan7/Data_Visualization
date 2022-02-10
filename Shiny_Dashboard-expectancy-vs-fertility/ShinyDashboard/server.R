library(shiny)
library(plotly)
library(ggplot2)
library(readr)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    df <- reactiveFileReader(
        intervalMillis = 20000,
        session = session,
        filePath = './WorldBankData.csv',
        readFunc = read_csv) 
    
    #Years to be displayed in UI slider input
    output$years = renderUI({
        df <- df()
        sliderInput("year", "Select year ", min=min(df$Year), max=max(df$Year), value=2000, sep="")
    })
    
    #Regions names to be displayed in UI drop down menu
    output$regions = renderUI({
        df <- df()
        selectInput('region', 'Region', unique(df$Region))
    })
    
    #Country names to be displayed in UI drop down menu
    output$countries = renderUI({
        df <- df()
        selectInput('country', 'Country', unique(df$Country))
    })
    
    #Plot to be displayed in UI
    output$myplot <- renderPlotly({

        df <- df()
        
        #To-Do Filter df according to user's input (year, region and country, when applies)
        df_filt <- df %>% 
            drop_na() %>% 
            filter(Year == input$year, 
                   Region == input$region)
        
        # p <- ggplot(df_filt, aes(x=LifeExpectancy, 
        #                 y=Fertility, 
        #                 size=Population, 
        #                 color=Region, 
        #                 fill=Region)) +
        #     geom_point(shape=21, alpha=0.5) + 
        #     theme_minimal() +
        #     labs(title="Life expectancy vs. Fertility",
        #          subtitle = input$year,
        #          x = "Life Expectancy (years)",
        #          y = "Fertility (number of children)") +
        #     geom_text_repel(aes(label=Country), size=2.5)
        # 
        
        p <- plot_ly(data=df_filt, x=~LifeExpectancy, y=~Fertility, color=df_filt$Region, fill=df_filt$Region,
                     type = 'scatter', mode = 'markers',size = ~Population,
                     marker = list(opacity = 0.7, sizemode = 'diameter', sizeref = 1.3),
                     text = ~paste('Country:', Country, 
                                   '<br>Life Expectancy:', LifeExpectancy,
                                   '<br>Fertility:', Fertility, 
                                   '<br>Population:', Population)) %>%
            layout(title = paste('Fertility vs. Life Expectancy in', input$year),
                   plot_bgcolor='#ecf0f5',
                   paper_bgcolor='#ecf0f5',
                   xaxis = list(title = 'Life Expectancy (years)'),
                   yaxis = list(title = 'Fertility (number of children)'))
        
        return(p)
    })

})
