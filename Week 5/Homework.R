# Apply packages
lapply(c("AppliedPredictiveModeling", "caret", "corrplot", "earth", "readxl"), require,character.only = TRUE)

# Import data and convert to a dataframe
# The title of the second page in the excel file is named "Data"
pricing_dataframe <- data.frame(read_excel("Week 5/Database.xlsx", sheet = "Data"))

# Check data structure
print("Checking data structure")
str(pricing_dataframe)

# Check for NA values
print("Checking NA values")
sum(is.na(pricing_dataframe))

# Create predictors and outcome subset
predictors <- pricing_dataframe[,-12]
price <- pricing_dataframe[,12]

# Split data into Train (75%) and Test (25%)
set.seed(0)
training <- createDataPartition(price, p=0.75, list=FALSE)
predictors_train <- predictors[training,]
price_train <- price[training]
predictors_test <- predictors[-training,]
price_test <- price[-training]

# View summary statistics of the predictors in the training set
summary(predictors_train)
# View histogram of price_train data
hist(price_train)

# Check for near-zero variance predictors
nzv <- nearZeroVar(predictors_train)
print(nzv) ## No NZV found

# Find and remove highly correlated variables
high_correlation <- findCorrelation(cor(predictors_train), 0.90)
predictors_train_filtered <- predictors_train[,-high_correlation]
predictors_test_filtered <- predictors_test[,-high_correlation]

# Fit the Linear Regression Model
lm_model <- lm(price_train ~ ., data = predictors_train_filtered)

# Summary of the Linear Regression Model
summary(lm_model)

# Make predictions on the test set
predictions <- predict(lm_model, newdata = predictors_test_filtered)

# Evaluate the model
# Calculate Root Mean Squared Error
rmse <- sqrt(mean((predictions - price_test)^2))
print(paste("Root Mean Squared Error (RMSE):", rmse))

# Calculate R-squared
rsquared <- cor(predictions, price_test)^2
print(paste("R-squared:", rsquared))
