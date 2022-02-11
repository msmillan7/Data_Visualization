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
        sliderInput("year", "Select year ", min=min(df$Year), max=max(df$Year-1), value=2000, sep="")
    })
    
    #Regions names to be displayed in UI drop down menu
    output$regions = renderUI({
        df <- df()
        selectInput('region', 'Region', c( "All Regions", unique(df$Region)))
    })
    
    #Country names to be displayed in UI drop down menu according to the selected Region
    output$countries = renderUI({
        df <- df()
        
        if (input$region!="All Regions")
        {
            df <- df %>% filter(Region == input$region)
        }

        selectInput('country', 'Country', c( "Select Country (All)", unique(df$Country)))
    })
    
    #Plot to be displayed in UI
    output$myplot <- renderPlotly({

        df <- df()
        region_filter = input$region
        country_filter = input$country
        
        #Initial filter df according to user's input (year)
        df_filt <- df %>% 
            drop_na() %>% 
            filter(Year == 2017)
        
        #Filter, when applies, df according to user's input (Region and Country)
        if(region_filter!= "All Regions")
        {
            df_filt <- df_filt %>% 
                filter(Region == region_filter)
            
            if(country_filter!= "Select Country (All)")
            {
                df_filt <- df_filt %>% 
                    filter(Country == country_filter)
            }
        }
        else
        {
            if(country_filter!= "Select Country (All)")
            {
                df_filt <- df_filt %>% 
                    filter(Country == country_filter)
            }
        }
        
        p <- plot_ly(data=df_filt, x=~LifeExpectancy, y=~Fertility, color=df_filt$Region, fill=df_filt$Region,
                     type = 'scatter', 
                     mode = 'markers',
                     size = ~Population,
                     marker = list(opacity = 0.7, sizemode = 'diameter', sizeref = 1.3),
                     text = ~paste('Country:', Country, 
                                   '<br>Life Expectancy:', LifeExpectancy,
                                   '<br>Fertility:', Fertility, 
                                   '<br>Population:', Population)) %>%
            layout(title = paste('Fertility vs. Life Expectancy in year', input$year),
                   plot_bgcolor='#ecf0f5',
                   paper_bgcolor='#ecf0f5',
                   xaxis = list(title = 'Life Expectancy (years)'),
                   yaxis = list(title = 'Fertility (number of children)'))
        
        return(p)
    })

})
