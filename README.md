# [Group5] your project title
我們設計了一款產品，包含兩種預測模型。<br>第一種模型預測未來三日或五日的收盤價。第二種模型預測未來三日或五日的上漲機率。<br>這些模型旨在幫助投資者，在股市波動時提供一個預測工具，以便更好地進行股票買賣決策

## Contributors
|組員|系級|學號|工作分配|
|-|-|-|-|
|陳宥任|資科碩一|112753218|建立模型(Random Forest、 xgboost)，Github| 
|謝皓雲|資科碩一|112753120|資料收集，整理數據，統整模型，建立股票預測架構|
|郭承諺|資科四|109703032|建立模型(Random Forest、 xgboost)，海報製作|
|吳秉叡|社會四|109204039|資料收集，建立模型(Random Forest、 xgboost)，海報製作|
|鄭丞皓|資科三|110703067|建立模型(Random Forest、 xgboost)，海報製作|
|陳聰堯|阿文四|108502006|資料收集，整理數據，建立模型(Random Forest、 xgboost)|
## Quick start
Please provide an example command or a few commands to reproduce your analysis, such as the following R script:
```R
Rscript code/your_script.R --input data/training --output results/performance.tsv
```

## Folder organization and its related description
idea by Noble WS (2009) [A Quick Guide to Organizing Computational Biology Projects.](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1000424) PLoS Comput Biol 5(7): e1000424.

### docs
* Your presentation, 1122_DS-FP_groupID.ppt/pptx/pdf (i.e.,1122_DS-FP_group1.ppt), by **06.13**
* Any related document for the project, i.e.,
  * discussion log
  * software user guide

### data
* Input
  * Source:<br>
     * stock_train_data.csv

  * Format:  csv檔案
  * Size<br>
     * 數量 : 54989<br>
     * 特徵: Rsi , macd , signal , cci , pctB , close , up , avg5 , up5 , avg3 , up3 , macd_way <br>
* 股票市場Feature介紹:
     * up：代表隔天股票價格的上漲。
     * close : 代表股票在交易日結束時的收盤價格。
     * avg5 : 五日移動平均線，表示過去五個交易日的平均收盤價。
     * avg3 : 三日移動平均線，表示過去三個交易日的平均收盤價。
     * up3 ： 未來三日漲跌幅，1表示上漲，0表示下降。
     * up5 :  未來五日漲跌幅，1表示上漲，0表示下降。
     * macd_way：是一種技術分析指標，當MACD線從上向下穿過訊號線時，這是一個賣出信號；當MACD線從下向上穿過訊號線時，這是一個買入信號
 
### code
* Analysis steps
  *  set seed
  *  Feature Selection
  *  grid search
  *  glmnet
  *  Data Preprocessing
  *  model build
  *  prediction
  *  compare F1_score, R_squared, accuarcy

 
* Which method or package do you use?
  * Random Forest(library(randomForest))
  * hyper_parameter_select(library(glmnet))
  * confusion matrix(library(caret))
  * Auc(library(pROC))
  * F1_score(library(MLmetrices))
  * Feature Selection(library(dplyr))<br>
 
* What is a null model for comparison?
* How do your perform evaluation?
  *  F1_score , R_squared 

### results
* What is your performance?
  * Two types of models for prediction:
  * predicting the closing price for the next three or five days, evaluated using R-squared.
  * Predicting the probability of an increase in the next three or five days, evaluated using F1_score.

 

* Is the improvement significant?

## References
* Packages you use
  * xgboost
  * ggbiplot
  * pROC
  * caret
  * ggplot2
  * glmnet
  * randomForest
  * MLmetrics
  * shiny
  * ggbiplot
 

* Related publications
