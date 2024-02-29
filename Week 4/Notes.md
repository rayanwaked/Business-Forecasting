# Week 4: Linear Regression and its Cousins

## Introduction
- This week: Linear regression and its cousins.
- Next weeks: Non-linear regression, linear classification, non-linear classification, etc.

## Linear vs Non-linear
- **Linear**: Only linear functions, predictors appear in separate terms, raised to the first power.
- **Example Models**: Y = 5x1 + 10x2 (linear), Y = 5x1 + 10x1x2 (non-linear), Y = 5x1^2 + 10x2 (non-linear).
- Linear models are simple and interpretable.

## Linear Regression Models
- **Simple Linear Regression**: Basic linear model.
- **Principal Component Regression (PCR)**: Uses PCA for dimensionality reduction.
- **Partial Least Squares (PLS)**: Considers outcome variable in component creation.

## Simple Linear Regression
- **Mathematical Expression**: 
  - \( y_i = b_0 + b_1x_{i1} + b_2x_{i2} + ... + b_px_{ip} + e_i \)
  - \( SSE = \sum_{i=1}^{n} (y_i - \hat{y_i})^2 \)
- **Function in RStudio**: `lm()`

## Principal Component Regression (PCR)
- **Steps**:
  1. Pre-process predictors using PCA.
  2. Build regression models using principal components.
- **Function in RStudio**: `pcr()`

## Partial Least Squares (PLS)
- **Objective**: Find components summarizing predictor variation and correlated with outcome.
- **Function in RStudio**: `pls()`

## Regression Performance Measures
- **RMSE**: Root Mean Square Error, measures forecast error.
- **R squared**: Proportion of information in data explained by the model.
- **Example Application**: Predicting compound solubility for pharmaceutical use.

## Conclusion
- Linear regression and its cousins are powerful predictive modeling techniques.
- Performance measures like RMSE and R squared help evaluate model effectiveness.