# Practice building and evaluating classification models on CustomerBuy_M dataset (both linear and nonlinear classification) Note: your modeling results may vary given the random data sampling nature.

# Required packages: AppliedPredictiveModeling,caret,pROC,klaR,Hmisc
# Note: "klaR" and "Hmisc" are two new packages for this week so make sure to install them first
install.packages(c("klaR","Hmisc"))

# Then library the required packages
lapply(c('AppliedPredictiveModeling','caret','pROC','klaR','Hmisc'),require,character.only = TRUE)

# use Import Dataset under the Environment tab to import CustomerBuy_M data

# convert customer data to data frame structure
CustomerBuy_M <- data.frame(CustomerBuy_M)
# check the internal structure of dataset
str(CustomerBuy_M)

# convert categorical variables to 'factor' prior to training classification models
# one way is to convert to 'factor' by excluding the non-categorical variables (using column positions)
CustomerBuy_M[,-c(2,7)] <- lapply(CustomerBuy_M[,-c(2,7)],factor)
# another way is by excluding the non-categorical variables (using variable names)
CustomerBuy_M[,!names(CustomerBuy_M) %in% c('income','residenceLen')] <- lapply(CustomerBuy_M[,!names(CustomerBuy_M) %in% c('income','residenceLen')],factor)

# recheck the internal structure of dataset
str(CustomerBuy_M) 

# check if there are any missing value in the dataset
colSums(is.na(CustomerBuy_M)) # there are three missing values
# return those customer records that contain missing data
miss <- CustomerBuy_M[!complete.cases(CustomerBuy_M),]
miss

# create the predictors and outcome subset respectively
predictors <- CustomerBuy_M[,-1]
buy <- CustomerBuy_M[,1]
# another way to create the buy object
buy <- CustomerBuy_M$buy

# perform data splitting (say assign 80% to training data)
# set.seed() is used to reproduce the results (from sampling)
set.seed(0)
training <- createDataPartition(buy,p=0.8,list=FALSE)
predictors_train <- predictors[training,]
buy_train <- buy[training]
predictors_test <- predictors[-training,]
buy_test <- buy[-training]

# find out how many missing values in the train and test respectively. Note: your results may vary given the random data sampling nature.
miss_train <- predictors_train[!complete.cases(predictors_train),]
miss_test <- predictors_test[!complete.cases(predictors_test),]

# use impute() function (from the "Hmisc" package) to impute missing values for the train and test set
# e.g., we replace the missing data with the median value of the feature column
predictors_train$residenceLen <- impute(predictors_train$residenceLen,median)
predictors_test$income <- impute(predictors_test$income,median)
predictors_test$residenceLen <- impute(predictors_test$residenceLen)

# recheck to confirm there are no missing values in the train and test set after imputing
colSums(is.na(rbind(predictors_train,predictors_test))) # return 0

# check how ResidenceLen affects customer buy decision in the train data
# note: we use boxplot() to view the relationship between continuous variable and categorical variable
boxplot(predictors_train$residenceLen ~ buy_train,col='chocolate',outline=FALSE)
# check how dualIncome affects customer buy decision in the train data
xtabs(~buy_train + predictors_train$dualIncome) # we can use xtabs() for two categorical variables

# check if there's any near-zero variance predictors in the training data
nzv <- nearZeroVar(predictors_train) # nzv returns empty; thus no need to remove anything
# check if any linear combinations existed in the predictors 
flc <- findLinearCombos(predictors_train)
str(flc) # $remove returns NULL; thus nothing to remove

# check outcome class proportion in the training data
table(buy_train) # N:Y = 414:431 (roughly balanced)
# thus there is no need to perform imbalance remedy here.
# however, when observing imbalanced dataset, one way is to use downSample() or upSample() (from "caret" package) to handle data imbalance. downSample() will randomly sample data so that all classes have the same frequency as the minority class, while upSample() is to sample the minority class with replacement until each class has appropriately the same number. For example:
# upTrain <- upSample(x = predictors_train, y = buy_train, yname = "buy")
# table(upTrain$buy) # N:Y = 431:431

### Next we'll build and compare three (linear & nonlinear) classification models- logistic regression, knn, nb

# We start with creating a control function using 10 fold cross validation resampling technique
set.seed(0)
ctrl <- trainControl(method = "cv",
                     summaryFunction = twoClassSummary, # calculates the area under the ROC curve
                     classProbs = TRUE, #calculates class probabilities
                     index = createFolds(buy_train, returnTrain = TRUE))

## Fit a logistic regression model
set.seed(0)
lrFit <- train(x = predictors_train, y = buy_train,
               method = "glm",
               metric = "ROC",
               trControl = ctrl)
lrFit # ROC value is 0.98
# check and interpret the parameter estimates of the fitted logistic regression model 
summary(lrFit)

## Tune a KNN model with "k" as the tuning parameter
set.seed(0)
knnTune <- train(x = predictors_train, y = buy_train,
                method = "knn",
                metric = "ROC",
                preProc = c("center", "scale"),
                tuneGrid = expand.grid(k = 1:25), # k=1:25 defines the range of #Neighbors
                trControl = ctrl)
knnTune # ROC value is 0.97

# check on the top N important predictor variables of the knnTune model and visualize them using a plot
knnImp <- varImp(knnTune)
plot(knnImp,top = 5) # top 5 important predictors for instance

## Fit a Naive Bayes model
set.seed(0)
nbFit <- train(x = predictors_train, y = buy_train,
               method = "nb",
               metric = "ROC",
               trControl = ctrl)
nbFit # ROC value is 0.98

# check on the top N important predictor variables of the nbFit model and visualize them using a plot
nbImp <- varImp(nbFit)
plot(nbImp, top = 5)

## we can also compare the predictive performance of these three models- lrFit, knnTune, and nbFit together
# start with making a list of the models
modellist <- list(lr=lrFit,knn=knnTune,nb=nbFit)
# then collect resamples from the cv folds using resamples function
resamps <- resamples(modellist)
# we can create a Box-and-whisker plot of the resamps to visualize model performance
bwplot(resamps, metric = "ROC")
# or create a dot plot that is in a visually simpler manner
dotplot(resamps,metric = "ROC")

## Based on above evaluation and comparison, which model to choose? We could choose nbFit given the slightly higher ROC value! However the lrFit is also a good option considering it is a linear model and has high model interpretability and also produce a very high ROC value!

# use the chosen model to predict the test set, and report the model performance on the test data
# if choosing nbFit:
pred_nb <- predict(nbFit,predictors_test)
confusionMatrix(pred_nb,buy_test,positive = "Y")
# if choosing lrFit:
pred_lr <- predict(lrFit,predictors_test)
confusionMatrix(pred_lr,buy_test,positive = "Y")