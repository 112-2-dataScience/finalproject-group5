library(shiny)
library(shinydashboard)
library(quantmod)
library(randomForest)
library(caret)
library(lubridate)
library(dplyr)

#setwd("/Users/xiehaoyun/Desktop/StockPrediction/")

# Set the stock code
stock_code <- "6488.TWO"

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Stock Forecast"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("App", tabName = "app", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      # Home tab content
      tabItem(tabName = "home",
              fluidRow(
                box(title = "歡迎使用AI股價預測", width = 15,
                    HTML("<p>
       <p>資料來源為Yahoo Finance，請由左側選單列進入使用</p>
       
                         ")
                    
                    )
              )
      ),
      
      # App tab content
      tabItem(tabName = "app",
              fluidRow(
                box(width = 6,
                    textInput("stock_code", "輸入股票代碼(限台股)【注意是.TW還是.TWO結尾】", value = "6488.TWO"),
                    dateInput("date", "從此日期開始往後預測三日", value = Sys.Date()),
                    actionButton("submit_btn", "開始分析")
                ),
                box(width = 6,
                    verbatimTextOutput("rsi_output"),
                    verbatimTextOutput("growth_output"),
                    verbatimTextOutput("predicted_close_output"),
                    verbatimTextOutput("exam"),
                    plotOutput("stock_plot")
                    
                )
              )
      )
    ),
    tags$footer(style = "position: fixed; bottom: 0; width: 100%; text-align: center;", "Author: Group 5 Data Science 2024 NCCU ,版權所有")
  )
)

# Define server
server <- function(input, output) {
  observeEvent(input$submit_btn, {
    stock_code <- toupper(input$stock_code)
    date <- input$date
    
    # Download historical stock price data
    getSymbols(stock_code, src = "yahoo", from = date - years(1), to = date)
    data <- Cl(get(stock_code))
    
    # Calculate technical indicators: RSI and MACD
    rsi <- RSI(data)
    macd <- MACD(data)
    cci <- CCI(data)
    bbands <- BBands(data)
    
    
    # Create a data frame with RSI, MACD, MACD signal, and closing prices
    df <- data.frame(rsi = rsi, macd = macd$macd, signal = macd$signal,
                     close = data,cci=cci,pctB=bbands$pctB)
    
    # Remove rows with missing values
    df <- na.omit(df)
    df$close<-df[,4]
    
    df[,4]<-NULL
    
    # Add new columns for price movements
    df[, c("up", "avg5", "up5","avg3","up3")] <- NA
    
    # Calculate price-related features
    for (i in 1:(nrow(df) - 5)) {
      df[i, "up"] <- df[i + 1, "close"] - df[i, "close"]
      df[i, "avg5"] <- mean(df[(i + 1):(i + 5), "close"])
      df[i, "up5"] <- df[i, "avg5"] - df[i, "close"]
      df[i,"avg3"]<- mean(df[(i + 1):(i + 3), "close"])
      df[i,"up3"]<-df[i, "avg3"] - df[i, "close"]
    }
    
    # Add a new column for MACD direction
    df$macd_way <- ifelse(df$macd > df$signal, "up", "down")
    df$macd_way<-as.factor(df$macd_way)
    
    # Load the pre-trained random forest model
    load("stock_random_forest_model.rdata")
    df$pd <- predict(m2, newdata = df)
    
    
    load("rf_model2.rdata")
    m1<-rf
    df$pd2<-predict(m1,newdata = df,type="prob")
    
    # Predict future closing price
    df$predicted_close <- df$close * (1 + df$pd)
    
    # Convert df$close to xts object
    df$close <- xts(df$close, order.by=as.Date(rownames(df)))
    
    plot1<-df$close
    
    mes<-ifelse(100*df[nrow(df), "pd2"][,2]>50 & df[nrow(df), "pd"]>0,1,0)
    mes<-ifelse(100*df[nrow(df), "pd2"][,2]<50 & df[nrow(df), "pd"]<=0,1,mes)
    mes<-ifelse(mes==1,"雙模型檢核通過","雙模型檢核未通過，模型看法分歧，建議再觀望")
    
    # Plot stock price
    output$stock_plot <- renderPlot({
      chartSeries(plot1, theme = chartTheme("white"), 
                  TA = "addVo();addBBands();addCCI();addMACD();addRSI()")
    },width = 600, height = 400,res=96)
    
    # Display latest RSI
    output$rsi_output <- renderText({
      paste0("預測三日內走向:","【上漲機率:",100*df[nrow(df), "pd2"][,2],"%】",
             "【下跌機率:",100*df[nrow(df), "pd2"][,1],"%】")
    })
    
    # Display predicted growth rate
    output$growth_output <- renderText({
      paste0("預測未來三日平均漲幅:","【",round(100*df[nrow(df), "pd"],2),"%】")
    })
    
    output$exam <- renderText({
      paste0("雙模型檢核結果:","【",mes,"】")
    })
    
    # Display predicted closing price
    output$predicted_close_output <- renderText({
      paste("預測未來三日平均收盤價:",round(df[nrow(df), "predicted_close"],2))
    })
  })
}

# Run the application
shinyApp(ui, server)

