# Week 6: Introduction to Classification Modeling

## Overview

- **Previous Topics**: Building and evaluating regression models for continuous variables.
- **Current Focus**: Building and evaluating models for categorical outcomes, i.e., classification models.
- **Applications**: From predicting shipment arrival times to loan default likelihood, classification models have a wide range of applications.

## Highlights

- **Transition from Regression to Classification**: While regression predicts numerical outcomes, classification predicts categorical outcomes.
- **Binary vs. Multi-Class Classification**: Binary involves two outcomes (e.g., yes/no), while multi-class involves more than two (e.g., types of music genres).
- **Logistic Regression**: A popular linear classification model used to predict event probabilities.

## Classification Modeling

- **Definition**: Predictive modeling for a categorical outcome.
- **Applications**:
    - Shipment arrival predictions (on time/late).
    - Grant application approvals.
    - Student academic success (pass/fail).
    - Loan default likelihood.
    - Credit evaluation (good/bad credit).
    - Fraud detection in transactions.

## Types of Classification Problems

1. **Two-Class or Binary Classification**: Outcomes are binary (e.g., yes/no, success/failure).
2. **Multi-Class Classification**: Outcomes involve more than two categories (e.g., music genres).

## Logistic Regression

- **Overview**: A linear classification model predicting class probabilities.
- **Mechanism**: Utilizes a logistic function to relate categorical outcomes to predictor variables.
- **Logit Model**: Models the log odds of the event as a linear function of predictor variables.

### Mathematical Expression of Logistic Regression

- **Log Odds Ratio**: `ln(p/(1-p))` where `p` is the probability of the event of interest.
- **Linear Relationship**: The right-hand side of the equation is linear with predictor variables and parameters.

### Parameter Interpretation

- **Odds Ratio**: Affected by the change in predictor variables. The sign of parameter estimates (`beta`) indicates the direction of the effect on the odds ratio.

## R Code Examples

### Logistic Regression Example

```r
# Load the necessary library
library(ggplot2)

# Load data (Example: Using iris dataset)
data(iris)

# Binary classification example: Versicolor vs. Not Versicolor
iris$Species_binary <- ifelse(iris$Species == 'versicolor', 1, 0)

# Fitting a logistic regression model
model <- glm(Species_binary ~ Petal.Length + Petal.Width, family = binomial, data = iris)

# Summary of the model
summary(model)

----
  
# Predicting probabilities
probabilities <- predict(model, type = "response")

# Adding predicted probabilities to the dataset
iris$PredictedProb <- probabilities

# Viewing the modified dataset
head(iris)
```