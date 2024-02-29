# Practice building and evaluating regression models on HousePrice dataset (both linear and nonlinear regression)
# Note: your modeling results may vary given the random data sampling nature.

# crimRate: per capita crime rate by town
# age: Proportion of owner-occupied units built prior to 1940
# nitricoxide: Nitric oxides concentration (parts per 10 million)
# numRoom: Average number of rooms per dwelling
# resilandProp: Proportion of residential land zoned for lots over 25,000 sqft
# indusProp: Proportion of non-retail business acres per town
# disToEmpo: Weighted distances to employment centers
# radHighway: Index of accessibility to radial highways
# propertyTax: Full-value property tax rate per $10,000
# ptRatio: Pupil-teacher ratio by town
# lowstat: Percentage of lower status of the population
# medValue: Median value of owner-occupied homes in $1000s (the outcome variable)

# Required packages: AppliedPredictiveModeling,caret,corrplot,earth
# Check and make sure you have the required packages installed. Then library them.
# Library the required packages
lapply(c('AppliedPredictiveModeling','caret','corrplot','earth', 'readxl'),require,character.only = TRUE)

# use Import Dataset under the Environment tab to import HousePrice data

# convert HousePrice to data.frame
HousePrice <- data.frame(read_excel("Week 5/Database.xlsx", sheet = "Data"))
# check the internal structure of the dataset
str(HousePrice)

# use colSums() to check if there are any missing value in the dataset
colSums(is.na(HousePrice)) # returns 0

# create the predictors and outcome subset respectively
predictors <- HousePrice[,-12]
price <- HousePrice[,12]

# perform data splitting (say assign 75% to training data while 25% to test data)
# set.seed() is used to reproduce the results (from sampling)
set.seed(0)
training <- createDataPartition(price,p=0.75,list=FALSE)
predictors_train <- predictors[training,]
price_train <- price[training]
predictors_test <- predictors[-training,]
price_test <- price[-training]

# view the summary statistics of the predictors in the training set
summary(predictors_train)
# view how the house price generally looks like in the training set
hist(price_train)

# check if there's any near-zero variance predictors 
nzv <- nearZeroVar(predictors_train) # nzv returns empty; thus no need to remove anything

# use findCorrelation() to check predictors that have high correlations (using threshold value 0.9). If there are any found, then remove them from both the training and test set.
tooHigh <- findCorrelation(cor(predictors_train),.9)
predictors_trainfiltered <- predictors_train[,-tooHigh]
predictors_testfiltered <- predictors_test[,-tooHigh]

### Next we'll build and compare three (linear & nonlinear) regression models- lm, mars, and knn

# We start with creating a control function using 10 fold cross validation resampling technique
set.seed(0)
ctrl <- trainControl(method = "cv", index = createFolds(price_train, returnTrain = TRUE))

## Build a linear regression model (lm)
set.seed(0)
lmFit <- train(x = predictors_trainfiltered, y = price_train,
            method = "lm",
            trControl = ctrl)

lmFit # cross-validated RMSE = 47.43

# check and interpret the coefficients for the fitted linear regression model 
summary(lmFit) 

## Build Multivariate Adaptive Regression Splines (MARS) regression model, where "degree" and "nprune" are the tuning parameters- "degree" determines degrees of variable interactions, "nprune" determine the number of terms to retain.
set.seed(0)
marsTune <- train(x = predictors_train, y = price_train,
                  method = "earth",
                  tuneGrid = expand.grid(degree = 1:2, nprune = 2:38),
                  trControl = ctrl)
marsTune # cross-validated RMSE = 34.80 (nprune = 13,degree = 2)

# visualize the model performance resulting from different parameter values
plot(marsTune)

# varImp() is used to estimate the predictors importance in the fitted model
marsImp <- varImp(marsTune)
plot(marsImp, top = 6) # "top = N" means we're interested in the top N important predictors

## Build K-Nearest Neighbors (KNN) regression model, where "k" is the turning parameter.
set.seed(0)
knnTune <- train(x = predictors_train, y = price_train,
                 method = "knn",
                 preProc = c("center", "scale"),
                 tuneGrid = data.frame(k = 1:20),
                 trControl = ctrl)
knnTune # cross-validated RMSE = 36.14 (k=2)
# plot knnTune model, and see how RMSE change with different number of neighbors (k)
plot(knnTune)

## Comparing among these three models- lmFit, marsTune, and knnTune 
# start with making a list
modellist <- list(lm=lmFit,mars=marsTune,knn=knnTune)
# then collect resamples from the cv folds
resamps <- resamples(modellist)
# we can create a dot plot of the resamps
dotplot(resamps,metric = "RMSE")
# we can also create a Box-and-whisker plot of the resamps
bwplot(resamps, metric = "RMSE")

# Based on above evaluation and comparison, which model to choose? we would choose the model returns the smallest prediction error (i.e.,cross-validated RMSE). Choose marsTune!

# Use the chosen model to predict new data (i.e, test set)
pred <- predict(marsTune,predictors_test)
# Use postResample() to report the model performance on the test data. Note: you can also use defaultSummary() to report the model performance as what we did in the previous week.
postResample(pred,price_test) # test RMSE = 36.29
