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
        df <- df() %>% drop_na() #Clean NAs
        sliderInput("year", "Select year ", min=min(df$Year), max=max(df$Year), value=2000, sep="")
    })
    
    #Regions names to be displayed in UI drop down menu
    output$regions = renderUI({
        df <- df() %>% drop_na() #Clean NAs
        selectInput('region', 'Region', c( "All Regions", unique(df$Region)))
    })
    
    #Country names to be displayed in UI drop down menu according to the selected Region
    output$countries = renderUI({
        df <- df() %>% drop_na() #Clean NAs
        
        if (input$region!="All Regions")
        {
            df <- df %>% filter(Region == input$region)
        }

        selectInput('country', 'Country', c( "All Countries", unique(df$Country)))
    })
    

    observeEvent(input$reset_input, {
        updateSliderInput(session, "year", value = 2000)
        updateSelectInput(session, "region", selected = "All Regions")
        updateSelectInput(session, "country", selected = "All Countries")
    })
    
    #Plot to be displayed in UI
    output$myplot <- renderPlotly({

        df <- df()
        region_filter = input$region
        country_filter = input$country
        
        #Initial filter df according to user's input (year)
        df_filt <- df %>% drop_na() %>% filter(Year == input$year)
        
        #Filter, when applies, df according to user's input (Region and Country)
        if(region_filter!= "All Regions")
        {
            df_filt <- df_filt %>% 
                filter(Region == region_filter)
            
            if(country_filter!= "All Countries")
            {
                df_filt <- df_filt %>% 
                    filter(Country == country_filter)
            }
        }
        else
        {
            if(country_filter!= "All Countries")
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
                     text = ~paste('<b> Country:</b>', Country, 
                                   '<br><b> Life Expectancy:</b>', round(LifeExpectancy, digits=0),
                                   '<br><b> Fertility:</b>', round(Fertility, digits=1), 
                                   '<br><b> Population:</b>', Population)) %>%
            #add_text(textfont = t, textposition = "top right") %>%
            config(displayModeBar = FALSE) %>% #Remove plotly toobar
            layout(title = paste(text='<b>Life Expectancy vs. Fertility</b>', '<br>Year', input$year),
                   #subtitle = paste('Year', input$year),
                   plot_bgcolor='#ecf0f5',
                   paper_bgcolor='#ecf0f5',
                   xaxis = list(title = '<b> Life Expectancy (years)</b>'),
                   yaxis = list(title = '<b> Fertility (number of children)</b>'),
                   legend = list(title=list(text='<b> Regions </b>')),
                   margin = list(l = 50, r = 60,
                                 b = 60, t = 60,
                                 pad = 15))
        
        return(p)
    })

})
