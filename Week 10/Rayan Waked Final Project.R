# ----------------------------------------------------------------------------------------------------------------------
# ||||||||||||||||                      Section One: Regression Analysis                                ||||||||||||||||
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------- Packages & Data Section ----------------------------------------
# ----------------------------------------------------------------------------------------------------------

# Apply packages
lapply(c("readxl", "AppliedPredictiveModeling", "caret", "corrplot", "earth", "dplyr"), require,character.only = TRUE)

# Create dataframe
carEconomy <- read_excel("Week 10/CarEconomy.xlsx")
carEconomy_df <- as.data.frame(carEconomy)

# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------- Preproccessing Section -----------------------------------------
# ----------------------------------------------------------------------------------------------------------

# Examine structure
str(carEconomy_df)

# Find missing values
print("Missing Values ----------------------------")
cat("Missing values: ", sum(is.na(carEconomy_df)), "\n")

# Create predictors and outcome subsets
predictors <- carEconomy_df[, -1] # -mpg
outcome <- carEconomy_df[, 1] # mpg

# Partition dataset
set.seed(100)
indexes <- createDataPartition(y = outcome, p = 0.75, list = FALSE)
training <- carEconomy_df[indexes, ]
test <- carEconomy_df[-indexes, ]

# Near-zero variance
nzv <- nearZeroVar(training)

# Highly correlation
cor_matrix <- cor(training[, -1]) # -mpg
highlyCor <- findCorrelation(cor_matrix, cutoff = 0.9)

# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------- Model Creation Section -----------------------------------------
# ----------------------------------------------------------------------------------------------------------

# Linear model
print("Linear Model ----------------------------")
lm_model <- lm(mpg ~ ., data = training)
summary(lm_model)

# MARS model
print("MARS Model ----------------------------")
set.seed(100)
tuneGrid <- expand.grid(.degree = 1, .nprune = seq(2, 38, by = 2)) # ChatGPT
ctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3) # ChatGPT
marsModel <- train(mpg ~ ., data = training, method = "earth", tuneGrid = tuneGrid, trControl = ctrl)
print(marsModel)

# KNN model
print("KNN Model ----------------------------")
set.seed(100)
ctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
knn_model <- train(mpg ~ ., data = training, method = "knn", tuneLength = 10, trControl = ctrl)
print(knn_model)

# Linear model exhibits an r-squared of 0.3048 or 30.48% accuracy
# MARS model exhibits an RMSE of 5.4306, about average
# KNN model exhibits an RMSE of 5.5379, slightly worse than MARS

# ------------------------------------------------------------------------------------------------------------
# ----------------------------------------- Model Deployment Section -----------------------------------------
# ------------------------------------------------------------------------------------------------------------

# Deploy best model
print("Selection ----------------------------")
predictions <- predict(marsModel, newdata = test)
performance <- postResample(predictions, test$mpg)
print(performance)

# MARS model exhibits an RMSE of 5.9400, r-square of 0.1892, and MAE of 4.5859
# Results indiciate that the model requires further tuning and perhaps more feature engineering on the dataset
# Specifically, more work needs to be done to help it capture variability, non-linear trends, and outliers















# ----------------------------------------------------------------------------------------------------------------------
# ||||||||||||||||                   Section Two: Classification Forecasting                            ||||||||||||||||
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------- Packages & Data Section ----------------------------------------
# ----------------------------------------------------------------------------------------------------------

# Apply packages
lapply(c("readxl", "AppliedPredictiveModeling", "caret", "corrplot", "earth", "dplyr", "pROC", "klaR"), require,character.only = TRUE)

# Import the dataset
FoodSample <- read_excel("Week 10/FoodSample.xlsx")

# Create dataframe
FoodSample <- as.data.frame(FoodSample)

# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------- Preproccessing Section -----------------------------------------
# ----------------------------------------------------------------------------------------------------------

# Factor type
FoodSample$popular <- as.factor(FoodSample$popular)

# Find missing values
print("Missing Values ----------------------------")
cat("Missing values: ", sum(is.na(FoodSample)), "\n")

# Create subsets
predictors <- FoodSample[, -1] #-popular
outcome <- FoodSample[, 1] #popular

# Set seed value
seed <- 100

# Split data
set.seed(seed)
index <- createDataPartition(outcome, p = 0.75, list = FALSE)
train_data <- FoodSample[index, ]
test_data <- FoodSample[-index, ]

# Check near-zero variance
nzv <- nearZeroVar(train_data[, -1]) #-popular
# Check linear combinations
flc <- findLinearCombos(train_data[, -1]) #-popular

# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------- Model Creation Section -----------------------------------------
# ----------------------------------------------------------------------------------------------------------

# Set the control
control <- trainControl(method = "cv", number = 10, classProbs = TRUE, summaryFunction = twoClassSummary) # ChatGPT

# Create logisitic regression model
print("LR ----------------------------")
set.seed(seed)
logistic_model <- train(popular ~ ., data = train_data, method = "glm", trControl = control, metric = "Accuracy")

# Create niave bayes model
print("NB ----------------------------")
set.seed(seed)
nb_model <- train(popular ~ ., data = train_data, method = "nb", trControl = control, metric = "Accuracy")

# Create k-nearest neighbors model
print("KNN ----------------------------")
set.seed(seed)
knn_model <- train(popular ~ ., data = train_data, method = "knn", tuneLength = 25, trControl = control, metric = "Accuracy")

# Model comparison (refactored from week 7)
results <- resamples(list(logistic = logistic_model, nb = nb_model, knn = knn_model))
summary(results)
bwplot(results)

# The logisic regression model exhibits an ROC from 0.69 to 0.99 with a mean of 0.84
# The niave bayes model exhibits an ROC from 0.67 to 0.94 with a mean of 0.81
# The k-nearest neighbor model exhibits an ROC from 0.76 to 0.99 with a mean of 0.90
# Of the three, the k-nearest neighbor model performs the best

# ------------------------------------------------------------------------------------------------------------
# ----------------------------------------- Model Deployment Section -----------------------------------------
# ------------------------------------------------------------------------------------------------------------

# Deploying best model
print("Deploying best model ----------------------------")
predictions <- predict(knn_model, newdata = test_data)
confusionMatrix(predictions, test_data$popular)

# Accuracy                     : 0.7167
# 95% CI                       : (0.5856, 0.8255)
# No Information Rate          : 0.5167
# P-Value [Acc > NIR]          : 0.001275

# Kappa : 0.4333

# Mcnemar's Test P-Value       : 1.000000

#         Sensitivity          : 0.7241
#         Specificity          : 0.7097
#         Pos Pred Value       : 0.7000
#         Neg Pred Value       : 0.7333
#         Prevalence           : 0.4833
#         Detection Rate       : 0.3500
#         Detection Prevalence : 0.5000
#         Balanced Accuracy    : 0.7169
