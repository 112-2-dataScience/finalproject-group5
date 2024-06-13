library(quantmod)
library(randomForest)
library(lubridate)
# 獲取今日日期
today <- Sys.Date()
today
one_year_ago <- today %m-% years(3)

# 設定要分析的股票代碼
stock_code <- "5608.TW" 

# 下載歷史股價資料
getSymbols(stock_code, src = "yahoo", 
           from = one_year_ago, 
           to = today)
data <- Cl(get(stock_code))
data
tail(data)

# 計算技術指標，以RSI為例
rsi <- RSI(data)
new_rsi<-rsi[length(rsi)]
new_rsi<-as.numeric(new_rsi)
print(paste("最新RSI:",new_rsi))

plot(rsi)

#RSI的一般理解是，當RSI超過70時，資產可能被過度買入，可能會發生回調；
#當RSI低於30時，資產可能被過度賣出，可能會發生反彈。
##RSI比較準#

macd <- MACD(data)
macd
#plot(macd)

# 計算 CCI
cci <- CCI(data)
print(head(cci,30))

# 計算布林通道
bbands <- BBands(data)
print(head(bbands,30))
# 在布林通道中，'dn'、'mavg'、'up' 和 'pctB' 是四個關鍵的組成部分：
# 'dn'：這是布林通道的下線，計算方式是中線減去兩倍的標準差。下線可以被視為股價的支撐線。
# 'mavg'：這是布林通道的中線，通常是股價的20日移動平均線。中線代表了股價的平均成本。
# 'up'：這是布林通道的上線，計算方式是中線加上兩倍的標準差。上線可以被視為股價的阻力線。
# 'pctB'：這是一個指標，用來表示收盤價在布林通道中的相對位置。
#計算公式是 `(收盤價 - 下線) / (上線 - 下線)`。
#當'pctB'值大於1時，表示收盤價超過了上線；當'pctB'值小於0時，表示收盤價低於下線。



last_day_macd <- tail(macd$macd, 1)
last_day_signal <- tail(macd$signal, 1)
second_last_day_macd <- tail(macd$macd, 2)[1]
second_last_day_signal <- tail(macd$signal, 2)[1]

r1<-last_day_macd > last_day_signal 
r2<-second_last_day_macd <= second_last_day_signal
result<-if(as.character(r1) == "TRUE" & as.character(r2) =="TRUE"){
  print("UPWARD")}else{print("DOWNWARD")}
print(paste("最新MACD狀態:",result))
#MACD（移動平均匯聚/分歧指標），用來識別資產的動能。
#當MACD線上穿信號線時，可能表示資產即將上漲，反之下穿可能表示下跌。



trade_decision <- function(new_rsi, result) {
  decision <- "N/A"
  
  if (new_rsi > 70) {
    if (result == "UPWARD") {
      decision <- "建議持有或繼續買入"
    } else if (result == "DOWNWARD") {
      decision <- "建議賣出"
    }
  } else if (new_rsi >= 50) {
    if (result == "UPWARD") {
      decision <- "建議持有或繼續買入"
    } else if (result == "DOWNWARD") {
      decision <- "建議賣出"
    }
  } else if (new_rsi >= 30) {
    if (result == "UPWARD") {
      decision <- "建議買入"
    } else if (result == "DOWNWARD") {
      decision <- "建議賣出"
    }
  } else {
    if (result == "UPWARD") {
      decision <- "建議買入"
    } else if (result == "DOWNWARD") {
      decision <- "建議賣出"
    }
  }
  
  return(decision)
}

decision <- trade_decision(new_rsi, result)
print(paste("交易決策：", decision))




# Set the stock code
stock_code <- "2641.TWO"

# Get today's date and the date from one year ago
today <- Sys.Date()
one_year_ago <- today - years(3)

# Download historical stock price data
getSymbols(stock_code, src = "yahoo", from = one_year_ago, to = today)
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
tail(df)


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








# View the resulting data frame
head(df,10)




#x1<-df#3481
#x2<-df#5608
#x3<-df#2329
#x4<-df#5432
#X5<-df#6488
#x6<-df#00919

x7<-df#2641#

xx<-rbind(x1,x2,x3,x4,X5,x6)
xx<-na.omit(xx)
xx$up5<-xx$up5/xx$close
table(xx$up5>0)

xx<-read.csv(file.choose())
head(xx)
xx


mm<-randomForest(up5~rsi+macd+signal,data=xx)

xx$up_or_down<-as.factor(ifelse(xx$up5>=0,1,0))
m2<-randomForest(up_or_down~rsi+macd+signal+close,data=xx)
m2$confusion
x7<-na.omit(x7)
x7$pd<-predict(m2,type = "prob",newdata = x7)
x7$pd[,2]
save(m2, file = "stock_random_forest_model2.rdata")


x7$pd<-predict(mm,newdata = x7)
x7$right<-ifelse(x7$up5<0 & x7$pd<0, 1,0)
x7$right<-ifelse(x7$up5>=0 & x7$pd>=0, 1,x7$right)
table(x7$right)
x7<-na.omit(x7)
mean(abs(x7$up5-x7$pd))

save(mm, file = "stock_random_forest_model.rdata")

m1<-lm(xx$up5~xx$rsi+xx$macd+xx$signal+xx$close)
summary(m1)
m2<-lm(xx$up~xx$rsi+xx$macd+xx$signal+xx$close)
summary(m2)
m3<-lm(xx$avg5~xx$rsi+xx$macd+xx$signal+xx$close)
summary(m3)
AIC(m1,m2,m3)









library(rio)
setwd("D:/")
export(df_train,"股票train.csv")




library(zoo)


# 設定股票代碼列表
stock_codes <- c("3481.TW", "6488.TWO", "5608.TW", "2329.TW", "00919.TW",
                 "3050.TW", "1102.TW", "0056.TW", "00885.TW", "2603.TW",
                 "2609.TW")

# 初始化 df_train
df_train <- data.frame()

# 遍歷股票代碼列表
for (stock_code in stock_codes) {
  # 下載歷史股價數據
  getSymbols(stock_code, src = "yahoo", from = one_year_ago, to = today)
  data <- Cl(get(stock_code))
  
  # 計算技術指標
  rsi <- RSI(data)
  macd <- MACD(data)
  cci <- CCI(data)
  bbands <- BBands(data)
  
  # 創建數據框
  df <- data.frame(rsi = rsi, macd = macd$macd, signal = macd$signal,
                   close = data, cci = cci, bb = bbands$pctB)
  
  # 差補包含缺失值的行
  df <- na.approx(df)
  df<-as.data.frame(df)
  
  # 添加價格相關的特徵
  df$close<-df[,4]
  df[,4]<-NULL
  df$id<-stock_code
  
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
  
  # 將 df 添加到 df_train
  df_train <- rbind(df_train, df)
}

# 查看結果
df_train<-na.omit(df_train)
head(df_train, 30)
nrow(df_train)
table(df_train$id)
