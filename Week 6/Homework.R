# Load necessary libraries
library(caret)
library(readxl)
library(dplyr)  # Add for data manipulation
library(tibble) # For rownames_to_column()

# Import data
data <- readxl::read_excel("Week 6/Database.xlsx", 1)

# Convert categorical variables to factor
factor_vars <- c("gender", "education", "marriage", paste0("status_", 1:6), "default")
data[factor_vars] <- lapply(data[factor_vars], factor)

# Create predictors and outcome subset
predictors <- data[, -ncol(data)] # Exclude the outcome column
outcome <- data$default

# Perform data splitting
set.seed(123) # For reproducibility
train_index <- createDataPartition(outcome, p = 0.8, list = FALSE)
train_data <- predictors[train_index, ]
test_data <- predictors[-train_index, ]
train_outcome <- outcome[train_index]
test_outcome <- outcome[-train_index]

# Impute missing data, center, and scale
preproc_params <- preProcess(train_data, method = c("medianImpute", "center", "scale"))
train_data <- predict(preproc_params, newdata = train_data)
test_data <- predict(preproc_params, newdata = test_data)

# Logistic Regression
set.seed(0)
model_log <- train(x = train_data, y = train_outcome,
                   method = "glm",
                   metric = "ROC",
                   trControl = trainControl(method = "cv", classProbs = TRUE))

# Naïve Bayes
set.seed(0)
model_nb <- train(x = train_data, y = train_outcome,
                  method = "nb",
                  metric = "ROC",
                  trControl = trainControl(method = "cv", classProbs = TRUE))

# KNN
set.seed(0)
model_knn <- train(x = train_data, y = train_outcome,
                   method = "knn",
                   tuneGrid = expand.grid(k = 1:25),
                   metric = "Accuracy",
                   trControl = trainControl(method = "cv", classProbs = TRUE))

# Evaluate models
resamples <- resamples(list(LogisticRegression = model_log, NaiveBayes = model_nb, KNN = model_knn))

# Convert resamples to data frame (no need to change row names)
resamples_df <- as.data.frame(resamples)

# Print summary
print(resamples_df)

# Print out observations causing numerical 0 probability warnings
problematic_observations <- c(929, 931)
print(predictors[problematic_observations, ])

# The results represent performance metrics (likely ROC-AUC for Logistic Regression/Naive Bayes and Accuracy for KNN)
# from a 10-fold cross-validation of three machine learning models: Logistic Regression, Naive Bayes, and KNN.

# Overall performance across the folds:
# * Logistic Regression seems to consistently yield the highest performance scores.
# * KNN appears to perform moderately well, generally outperforming Naive Bayes.
# * Naive Bayes generally has the lowest scores across the folds.
