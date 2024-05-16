# Week 10: Course Review and Next Steps in Predictive Modeling

## Overview
- **Objective:** Course review and guidance for continuing the learning journey in predictive modeling beyond the term.
- **Key Focus:** Relationship between predictive modeling covered in the course and broader machine learning categories.

## Predictive Modeling and Machine Learning
- **Predictive Modeling:** Core of the course, involves using historical data to predict future outcomes.
- **Machine Learning:** Encompasses several algorithm categories, including supervised, unsupervised, and reinforcement learning.

### Machine Learning Categories
1. **Supervised Learning:** Training data includes both predictors and outcomes (labeled data). Most of the course content is under this category.
    - **Applications:** Regression (continuous outcomes) and Classification (categorical outcomes).
2. **Unsupervised Learning:** Uses unlabeled data to uncover underlying structures and patterns.
    - **Applications:** Customer segmentation, recommender systems.
3. **Reinforcement Learning:** Dynamic learning involving a sequence of decisions based on errors and rewards.
    - **Applications:** Self-driving cars, robotics, online gaming.

### Review of Specific Models
- **Linear and Nonlinear Models** for both regression and classification were covered, with R functions for implementation.
- **Model Performance Metrics:** RMSE and R-squared for regression; AUC ROC, Accuracy, and F1-Score for classification.

### Application Areas
- **Regression:** Predicting house values, drug solubility and permeability.
- **Classification:** Customer purchase decisions, predicting hepatic injury, credit card payment default.

## Predictive Modeling Process Flowchart
- **Steps Include:**
    - Collecting and understanding datasets.
    - Preprocessing data (handling missing data, encoding categorical variables, etc.).
    - Splitting data into training and test sets.
    - Developing models, assessing their effectiveness, and selecting the best model.
    - Applying the model to new data for predictions.

### Important R Functions
- **`createDataPartition()`:** For splitting data into training and test sets.
- **`createFolds()`:** Setting up cross-validation.
- **`train()`:** Model training, where "x" is the predictors and "y" is the outcome of the training set.

## Conclusion
- The video concludes with a recap of the predictive modeling process, highlighting key R functions essential for smooth model development and implementation.
- **Next Video:** A deeper dive into time series forecasting and further steps for advancing studies in predictive modeling.

## Loading and Visualizing Time Series Data
```
# Install necessary packages
install.packages("forecast")
install.packages("ggplot2")

# Load the packages
library(forecast)
library(ggplot2)

# Load the dataset
sales_data <- read.csv("path_to_sales.xlsx")

# Convert to time series object
salesTS <- ts(sales_data$sales, start=c(2008,1), end=c(2017,12), frequency=12)

# Visualize the time series data
autoplot(salesTS) +
  xlab("Time") + ylab("Sales in Thousands") +
  ggtitle("Monthly Shampoo Sales Over Time")

```

## Supervised Learning: Regression Example with Linear Model
```
# Load necessary package for linear modeling
install.packages("caret")
library(caret)

# Assuming HousePrice dataset is loaded into R as housePrice_df
# Predicting house value based on predictors like number of rooms, age, etc.

# Splitting data into training and test sets
set.seed(123) # for reproducibility
trainingIndex <- createDataPartition(housePrice_df$value, p = .8, list = FALSE)
trainingData <- housePrice_df[trainingIndex,]
testData <- housePrice_df[-trainingIndex,]

# Fitting a simple linear regression model
model_lm <- lm(value ~ ., data=trainingData)

# Predicting values for the test set
predictions <- predict(model_lm, testData)

# Evaluating model performance
model_performance <- postResample(pred = predictions, obs = testData$value)
print(model_performance)
```

## Supervised Learning: Classification Example with Logistic Regression
```
# Assuming a dataset 'clientData' for predicting credit card default (Yes/No)

# Splitting the dataset
trainingIndex <- createDataPartition(clientData$default, p = .8, list = FALSE)
trainingData <- clientData[trainingIndex,]
testData <- clientData[-trainingIndex,]

# Fitting a logistic regression model
model_glm <- glm(default ~ ., family="binomial", data=trainingData)

# Predicting and evaluating model performance
predictions <- predict(model_glm, testData, type="response")
predictedClass <- ifelse(predictions > 0.5, "Yes", "No")

# Compute model performance metrics
confusionMatrix <- confusionMatrix(data = predictedClass, reference = testData$default)
print(confusionMatrix)
```