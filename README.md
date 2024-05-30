# [Group5] your project title
The goals of this project.

## Contributors
|組員|系級|學號|工作分配|
|-|-|-|-|
|陳宥任|資科碩一|112753218|建立模型(Random Forest、 xgboost)，Github| 
|謝皓雲|資科碩一|112753120|資料收集，統整模型，建立股票預測架構|
|郭承諺|資科四|109703032|建立模型(Random Forest、 xgboost)，海報製作|
|吳秉叡|社會四|109204039|資料收集，建立模型(Random Forest、 xgboost)|
|鄭丞皓|資科三|110703067|建立模型(Random Forest、 xgboost)，海報製作|
|陳聰堯|阿文四|108502006|資料收集，建立模型(Random Forest、 xgboost)|
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
 
### code
* Analysis steps
  *  set seed
  *  Feature Selection
  *  grid search
  *  glmnet
  *  Data Preprocessing
  *  model build
  *  prediction
  *  compare F1_score, R_square, accuarcy
 
* Which method or package do you use?
  * Random Forest(library(randomForest))
  * hyper_parameter_select(library(glmnet))
  * confusion matrix(library(caret))
  * Auc(library(pROC))
  * F1_score(library(MLmetrices))
  * Feature Selection(library(dplyr))<br>
 
* What is a null model for comparison?

### results
* What is your performance?
* How do your perform evaluation? 
* Is the improvement significant?

## References
* Packages you use
* Related publications
