# Practice building and evaluating classification models using "hepatic" dataset from the pharmaceutical industry. The dataset is imbeded inside RStudio, which can be loaded using data() function.

# "hepatic" dataset contains 281 unique compounds, each of which has been classified as causing no liver damage, mild damage, or severe damage.
# these compounds were analyzed with 184 biological screens to assess each compound's effect on a particular biologically relevant target in the body. Additionally, 192 chemical fingerprint predictors were determined for these compounds.Each of these predictors represent a substructure and are either counts of the number of substructures or an indicator of presence or absence of the particular substructure.

# The objective is to predict the compounds’ probability of causing hepatic injury (i.e., liver damage)

# Required packages: AppliedPredictiveModeling,caret,pROC,klaR
# Library the required packages
lapply(c('AppliedPredictiveModeling','caret','pROC','klaR'),require,character.only = TRUE)

# load the hepatic dataset
data(hepatic) # there are three subsets- bio, chem, injury shown in the gloabl environment
# check the dataset outcome classes
table(injury) # None(106) Mild(145) Severe(30)

# lump all compounds that cause injury (no matter mild or severe) into a "Yes" category
any_damage = as.character(injury)
any_damage[any_damage=="Mild"] = "Yes"
any_damage[any_damage=="Severe"] = "Yes"
any_damage[any_damage=="None"] = "No"
# convert the outcome variable any_damage to a factor
any_damage <- factor(any_damage)
table(any_damage) # Now the outcome class are: No(106) Yes(175) 

# combine two predictor subset into one complete predictor body
predictors <- cbind(bio, chem) # the combined predictors has 281 rows 376 columns

# perform data splitting (say assign 80% to training data)
# set.seed() is used to reproduce the results (from sampling)
set.seed(0)
training <- createDataPartition(any_damage,p=0.8,list=FALSE)
predictors_train <- predictors[training,]
damage_train <- any_damage[training]
predictors_test <- predictors[-training,]
damage_test <- any_damage[-training]

# check if there are any near-zero variance predictors. If any found, then proceed to remove.
nzv <- nearZeroVar(predictors_train) # nzv found 138 predictors to be removed
predictors_train <- predictors_train[,-nzv] # remove 138 predictors_train (238 predictors left)
predictors_test <- predictors_test[,-nzv] # remove 138 predictors_test (238 predictors left)
# check if any linear combinations existed in the predictors 
flc <- findLinearCombos(predictors_train)
str(flc) # "$remove" found 17 linear combination predictors to be removed
predictors_train <- predictors_train[,-flc$remove] # predictors_train are left with 221 columns now
predictors_test <- predictors_test[,-flc$remove] # predictors_test are left with 221 columns now

# check the class balance condition in the train data
table(damage_train) # No:Yes = 85:140 
# up-sampling is one of the methods to remedy the imbalance issue, where cases from the minority classes are sampled with replacement until each class has approximately the same number. 
upTrain <- upSample(x = predictors_train, y = damage_train, yname = "any_damage")
table(upTrain$any_damage) # No:Yes = 140:140 
# update the predictors_train and damage_train with the balanced train data
predictors_train <- upTrain[,-222]
damage_train <- upTrain[,222]

### Next we'll build and compare three (linear & nonlinear) classification models- logistic regression, knn, nb

# We start with creating a control function using 10 fold cross validation resampling technique
set.seed(0)
ctrl <- trainControl(method = "repeatedcv",
                     summaryFunction = twoClassSummary, # calculates the area under the ROC curve
                     classProbs = TRUE, #calculates class probabilities
                     index = createFolds(damage_train, returnTrain = TRUE))

# Fit a logistic regression model
set.seed(0)
lrFit <- train(x = predictors_train, y = damage_train,
                method = "glm",
                metric = "ROC",
                trControl = ctrl)

# Tune a KNN model with "k" as the tuning parameter
set.seed(0)
knnTune <- train(x = predictors_train, y = damage_train,
                method = "knn",
                metric = "ROC",
                preProc = c("center","scale"),
                tuneGrid = expand.grid(k = 1:15),
                trControl = ctrl)

# Fit a Naive Bayes model
set.seed(0)
nbFit <- train(x = predictors_train, y = damage_train,
               method = "nb",
               metric = "ROC",
               trControl = ctrl)

## Comparing the predictive performance of these three models- lrFit, knnFit, and nbFit
# start with making a list of the models
modellist <- list(lr=lrFit,knn=knnTune,nb=nbFit)
# then collect resamples from the cv folds using resamples function
resamps <- resamples(modellist)
# we can create a Box-and-whisker plot of the resamps to visualize model performance
bwplot(resamps, metric = "ROC")
# or create a dot plot that is in a visually simpler manner
dotplot(resamps,metric = "ROC")

# Which model to choose among the three trained models above? Relatively, knnTune model yield a better ROC value.

# use the chosen model to predict the test set and report the model performance on the test data
pred <- predict(knnTune,predictors_test)
confusionMatrix(pred,damage_test,positive = "Yes")

