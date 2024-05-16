# Week 7: Nonlinear Classification Models

## Introduction
- Focus on **nonlinear classification models** to classify instances into the right group, especially when they are not linearly separable.
- Examples include models like K-Nearest Neighbors (KNN) and Naive Bayes.

### Nonlinear vs. Linear Classification Models
- Nonlinear models can handle cases where instances cannot be separated linearly.

## Agenda for the Week
1. **Introduction to Nonlinear Classification Models:**
    - Focus on K-Nearest Neighbors (KNN) and Naive Bayes.
    - Other models like neural networks and support vector machines are mentioned but not the focus for undergraduate studies.

2. **Practical Application:**
    - Predicting customer purchase likelihood with the **CustomerBuy_M dataset** (where "M" indicates missing values).

3. **Coding Practice:**
    - Imputing missing data.
    - Handling data imbalance.

4. **Optional Practice:**
    - Modeling with the hepatic dataset available in RStudio.

## K-Nearest Neighbors (KNN)
- **Introduction:**
    - First introduced in week 5 as a nonlinear regression model.
    - Can be applied to classification problems.

- **Application:**
    - Predicts the classification of a new sample based on the majority class among its K nearest neighbors.
    - K is a tuning parameter.
    - Pre-processing (e.g., center and scale predictors) is recommended.

## Naive Bayes (NB)
- **Foundation:**
    - Based on Bayes' theorem, which uses conditional probabilities.

- **Application:**
    - Predicts the probability that an outcome belongs to a specific class based on prior knowledge.

- **Assumptions:**
    - Predictors are independent.
    - Normality for continuous predictors.

- **Advantages:**
    - Quick computation.
    - Competitive performance, especially in multi-class predictions.

## Practical Exercises
- Focus on the **CustomerBuy_M dataset**.
- Optional practice with the hepatic injury dataset using RStudio.

## Conclusion
- The week will culminate in applying KNN and Naive Bayes to the CustomerBuy_M dataset.
- Optional exercises provided for further exploration in real-world applications.

