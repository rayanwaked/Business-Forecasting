# Practice building and evaluating linear Regression models

# Required packages: AppliedPredictiveModeling,caret,corrplot,FactoMineR,pls
# Check and make sure you have the required packages installed. Then library them.
# Library the required packages
lapply(c('AppliedPredictiveModeling','caret','corrplot','FactoMineR','pls'),require,character.only = TRUE)

# required dataset: MedicalValue.xlsx

# use Import Dataset under the Environment tab to import MedicalValue data

# convert MedicalValue to data frame
MedicalValue <- data.frame(MedicalValue)
# check the internal structure of the dataset
str(MedicalValue)

# use colSums() to check if there are any missing values
sum(colSums(is.na(MedicalValue)))

# create the predictors and outcome subset respectively
med <- MedicalValue[,1]
predictors <- MedicalValue[,-1]

# perform data splitting (say assign 75% to training data while 25% to test data)
# set.seed() is used to reproduce the results (from sampling)
set.seed(0) 
training <- createDataPartition(med,p=0.75,list=FALSE)
predictors_train <- predictors[training,]
med_train <- med[training]
predictors_test <- predictors[-training,]
med_test <- med[-training]

# visualize the training data to check the relationship between the outcome and randomly selected predictors- linear or not?
par(mfrow = c(2,2)) # Create a 2 x 2 plotting matrix
plot(predictors_train[,1],med_train,col="red")
plot(predictors_train[,3],med_train,col="green")
plot(predictors_train[,5],med_train,col="purple")
plot(predictors_train[,10],med_train,col="orange")

# view the summary statistics of those non-binary predictors in the training set, where the non-binary predictors sit in columns 1-20 of the predictors_train subset
nbpredictors <- predictors_train[,1:20]
summary(nbpredictors)

# check if there's any near-zero variance predictors 
nzv <- nearZeroVar(predictors_train)
# if there is none observed, then there is nothing to remove. However, since we observed four near-zero variance predictors from "nzv", we then proceed to remove them from the predictors in both the training and test set by running codes below.
predictors_train <- predictors_train[,-nzv]
predictors_test <- predictors_test[,-nzv]

# Is the between-predictor correlation significant in the training data?
# Is the structure of the data contained in a smaller number of dimensions than the original predictor space? Let's find out using PCA.
prePP <- preProcess(predictors_train, c("BoxCox", "center", "scale"))
preTrans <- predict(prePP, predictors_train)
prePCA <- PCA(preTrans,ncp = ncol(predictors_train),graph = FALSE)
prePCA$eig # it shows 38 components are of eigenvalue greater than 1

# let's also visualize the correlation among predictors (e.g, non-binary predictors) in the training set
medcorr <- cor(nbpredictors)
corrplot::corrplot(medcorr) # we used the full namespace to call this function because the pls package has a function with the same name.

# since we observed high correlations exist between predictors, let's then remove predictors that have high correlations greater than a threshold value (e.g., 0.9) from both the training and test set.
tooHigh <- findCorrelation(cor(predictors_train),.9)
predictors_trainfiltered <- predictors_train[,-tooHigh]
predictors_testfiltered <- predictors_test[,-tooHigh]

### Next we'll build and compare three linear regression models based on the performance metric RMSE
# The first model is simple linear regression Model (LM)
# The second model is Principal Component Regression (PCR)
# The third model is Partial Least Squares (PLS)

# We start with creating a control function using 10 fold cross validation resampling technique
# the random number seed is set so that the results can be reproduced
set.seed(0)
ctrl <- trainControl(method = "cv", index = createFolds(med_train, returnTrain = TRUE))

## Let's use train() to fit the simple linear regression model with the filtered predictors, where high correlated predictors are removed
set.seed(0)
lmFit <- train(x = predictors_trainfiltered, y = med_train,
               method = "lm",
               trControl = ctrl)
lmFit # cross-validation RMSE = 0.72

## Let's use train() to tune the Principal Component Regression (PCR) model, where tuneGrid = expand.grid(ncomp=1:40) is used for tuning the model parameter- the number of components
set.seed(0)
pcrTune <- train(x = predictors_train, y = med_train,
                 method = "pcr",
                 tuneGrid = expand.grid(ncomp = 1:40),
                 trControl = ctrl)
pcrTune #cross-validation RMSE = 0.73 (ncomp = 38)

## Let's continue using train() to tune the Partial Least Squares Regression (PLS) model, where tuneGrid = expand.grid(ncomp=1:40) is used for tuning the model parameter- the number of components
set.seed(0)
plsTune <- train(x = predictors_train,y = med_train,
                 method = "pls",
                 tuneGrid = expand.grid(ncomp = 1:40),
                 trControl = ctrl)
plsTune # cross-validation RMSE = 0.69 (ncomp = 13)


## By this point, we have the cross-validation RMSE values for all three models. Which model will you recommend for this predictive problem? choose plsTune!

## Practice using the chosen regression model for predicting new data (e.g.,test data)
newPredict <- predict(plsTune,predictors_test)
newPredict
summary(newPredict)

## Let's report the performance of the chosen model on the test data
testResults <- data.frame(obs = med_test,pred = newPredict)
defaultSummary(testResults) # test RMSE = 0.68
