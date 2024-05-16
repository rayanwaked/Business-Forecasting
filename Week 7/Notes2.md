# Nonlinear Classification

## Overview

Nonlinear classification involves predicting the class of given data points where the relationship between the data points and the class boundary is not linear. It's crucial for complex datasets where linear classifiers fail to perform well.

## Nonlinear Classification Models in R

### K-Nearest Neighbors (KNN)

- **Definition**: KNN predicts the class of a sample based on the majority class among its k nearest neighbors.
- **Steps**:
    1. Identify k nearest neighbors using distance metrics (e.g., Euclidean distance).
    2. Calculate class probability estimates for the sample as the proportion of neighbors in each class.
    3. Assign the sample to the class with the highest probability.
- **Pre-processing**: It's recommended to pre-process predictors (e.g., center and scale) before performing KNN.

### Naïve Bayes (NB)

- **Definition**: NB classification uses Bayes’ theorem with the “naïve” assumption of independence between every pair of features.
- **Bayes' Theorem**: Used to calculate the probability of a class given a set of features.
- **Model Assumptions**:
    - Predictors are independent of each other.
    - Normality assumption for continuous predictors.
- **Advantages**:
    - Quick computation.
    - Competitively performs in many cases.

## RStudio Practice

- **Datasets**:
    - `CustomerBuy_M.xlsx` for practicing linear and nonlinear classification.
    - Optional: `hepatic` dataset for predicting hepatic injury.

- **R Script**: Follow the `Week 7_Linear and Nonlinear classification_(CustomerBuy_M)` R file for coding practice.

## Highlights

- KNN and NB are two popular methods for nonlinear classification in R.
- Pre-processing such as scaling and centering is crucial for KNN.
- Naïve Bayes operates under the assumption of feature independence and can quickly produce competitive models.

## Practice

- Required: Perform linear and nonlinear classification on the `CustomerBuy_M.xlsx` dataset.
- Optional: Apply both classification methods on the `hepatic` dataset to predict hepatic injury.

```
# Load necessary libraries
library(class) # For KNN
library(e1071) # For Naïve Bayes
library(caret) # For data splitting and pre-processing

# Assuming you have a dataset 'data' with predictors and a target variable 'Class'

# Splitting the dataset into training and test sets
set.seed(123) # For reproducibility
index <- createDataPartition(data$Class, p=0.75, list=FALSE)
trainData <- data[index, ]
testData <- data[-index, ]

# Pre-processing: scaling the data (important for KNN)
preProcValues <- preProcess(trainData, method = c("center", "scale"))
trainDataNorm <- predict(preProcValues, trainData)
testDataNorm <- predict(preProcValues, testData)

## K-Nearest Neighbors (KNN) ##

# Choosing the number of neighbors 'k'
k <- 5

# Training the model
knnModel <- knn(train = trainDataNorm[, -ncol(trainDataNorm)], 
                test = testDataNorm[, -ncol(testDataNorm)], 
                cl = trainDataNorm$Class, k = k)

# Evaluating the model
knnPredictions <- knnModel
confusionMatrix(knnPredictions, testDataNorm$Class)

## Naïve Bayes (NB) ##

# Training the model
nbModel <- naiveBayes(Class ~ ., data = trainDataNorm)

# Making predictions
nbPredictions <- predict(nbModel, testDataNorm)

# Evaluating the model
confusionMatrix(nbPredictions, testDataNorm$Class)
```