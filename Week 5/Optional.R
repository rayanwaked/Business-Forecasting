# Practice nonlinear regression models on MedicalValue.xlsx (the same dataset used for practicing linear regression in Week 4)

# Required packages: AppliedPredictiveModeling,caret,corrplot,earth
# Check and make sure you have the required packages installed. Then library them.
# Library the required packages
lapply(c('AppliedPredictiveModeling','caret','corrplot','earth'),require,character.only = TRUE)

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

# view the summary statistics of those non-binary predictors in the training set, where the non-binary predictors sit in columns 1-20 of the predictors_train subset
nbpredictors <- predictors_train[,1:20]
summary(nbpredictors)

# check if there's any near-zero variance predictors 
nzv <- nearZeroVar(predictors_train)
# if there is none observed, then there is nothing to remove. However, since we observed four near-zero variance predictors from "nzv", we then proceed to remove them from the predictors in both the training and test set by running codes below.
predictors_train <- predictors_train[,-nzv]
predictors_test <- predictors_test[,-nzv]

# use findCorrelation() to check predictors that have high correlations (using threshold value 0.9). If there are any found, then remove them from both the training and test set.
tooHigh <- findCorrelation(cor(predictors_train),.9)
predictors_trainfiltered <- predictors_train[,-tooHigh]
predictors_testfiltered <- predictors_test[,-tooHigh]

### Next we'll build and evaluate nonlinear regression models- mars and knn

# We start with creating a control function using 10 fold cross validation resampling technique
# the random number seed is set so that the results can be reproduced
set.seed(0)
ctrl <- trainControl(method = "cv", index = createFolds(med_train, returnTrain = TRUE))

## Build Multivariate Adaptive Regression Splines (MARS) regression model, where "degree" and "nprune" are the tuning parameters- "degree" determines degrees of variable interactions, "nprune" determine the number of terms to retain
set.seed(0)
marsTune <- train(x = predictors_train, y = med_train,
                  method = "earth",
                  tuneGrid = expand.grid(degree = 1:2, nprune = 2:38),
                  trControl = ctrl)
marsTune # note: It takes a while to finish running this nonlinear model. cross-validated RMSE = 0.69 (nprune = 19, degree = 2) Your results may vary given the random data sampling nature!

# visualize the model performance resulting from different parameter values
plot(marsTune) 
# varImp() is used to estimate the predictors importance in the fitted model
marsImp <- varImp(marsTune)
plot(marsImp, top = 15)

## Build K-Nearest Neighbors (KNN) regression model, where "k" is the turning parameter.
set.seed(0)
knnTune <- train(x = predictors_train, y = med_train,
                 method = "knn",
                 preProc = c("center", "scale"),
                 tuneGrid = data.frame(k = 1:20),
                 trControl = ctrl)
knnTune # cross-validated RMSE = 1.05 (k=7). Note: your results may vary given the random data sampling nature.

# plot knnTune model, and see how RMSE change with different number of neighbors (k)
plot(knnTune)

## Compare MARS and KNN model, and choose the one returns the smallest prediction error (i.e., cross-validated RMSE).

# If marsTune is chosen, then use it to predict test data              
pred <- predict(marsTune,predictors_test)
# Use postResample() to report the model performance on the test data. note: you can also use defaultSummary() to report the model performance similar to what we did in the previous week.
postResample(pred,med_test)
