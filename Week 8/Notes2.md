# Partitioning Time Series Data, Model Fitting, and Evaluating Forecast Accuracy in R

## Overview
This section covers techniques for partitioning time series data into training and validation sets, fitting models to the training data, and evaluating model accuracy on the validation data. These steps are crucial for providing an unbiased evaluation of model performance and ensuring that the model performs well on new data, thus avoiding overfitting.

## Highlights
- Partitioning time series data involves splitting the data into a training set and a validation set, with the training set used to develop the forecasting model and the validation set used to evaluate model accuracy.
- The `window()` function is used to partition time series data into training and validation periods.
- The `tslm()` function from the forecast package is used for fitting linear models to time series data.
- Forecast accuracy is measured using the `accuracy()` function, with forecast errors calculated for the validation period.

## Partitioning Time Series Data
- Time series data must be partitioned into training and validation sets to provide an unbiased evaluation of model performance.
- The validation set size typically represents about 20% of the total sample but depends on the data frequency and forecast horizon. It should be at least as large as the forecast horizon.
- In the example given, the most recent 24 months of data are allocated to the validation period, with the remaining data forming the training period.
- The `window()` function is utilized to create `train_data` and `validation_data`, specifying the start and end periods of the training and validation periods.

## Model Fitting
- The `tslm()` function is used for fitting time series linear models, including trend and seasonal components.
- Models are developed using `train_data`. For models with observed trend and seasonal patterns, both components are included in the model fitting.
- The inclusion of a quadratic trend (`trend^2`) is considered for capturing non-linear trends, with significant relationships indicated by asterisks in model summary outputs.

## Evaluating Forecast Accuracy
- Model accuracy is evaluated on the validation set to avoid bias.
- Forecast accuracy is assessed using the `accuracy()` function, calculating various error measures such as ME, RMSE, MAE, MPE, MAPE, MASE, ACF1, and Theil's U.
- Error measures on the same scale as the data (e.g., ME, RMSE, MAE) are useful for comparing forecasting methods for the same units, while unit-free measures (e.g., MPE, MAPE, MASE) are used for comparisons across different datasets.
- The RMSE and MAPE are highlighted as popular measures in forecasting competitions.

## Forecasting Future Series
- After comparing models, the chosen model (with better performance based on error measures) is refitted using both training and validation data to generate forecasts for future periods.
- The `tslm()` function is again used to refit the model to the combined dataset, and forecasts are made for the desired future periods.
- The forecasting process includes generating point forecasts and prediction intervals for each future time period, visualized using the `autoplot` function.

## Conclusion
- The session concludes with a reminder that all codes discussed are available in the uploaded R script "(coding done!) Week 8_Time Series Forecasting I", found in the Week 8 content folder.
- It's emphasized to review the comments within the R script for further explanation of the codes used.

```
# Load necessary library
library(forecast)

# Assuming salesTS is the time series object containing 10 years of monthly shampoo sales data
salesTS <- ts(data, start=c(2008,1), frequency=12)

# Partitioning the data into training and validation sets
validation_size <- 24 # Last 24 months for validation
train_size <- length(salesTS) - validation_size
train_data <- window(salesTS, end=c(2017, -validation_size/12))
validation_data <- window(salesTS, start=c(2017, -validation_size/12 + 1))

# Model fitting with linear trend and seasonal components
fit_lm <- tslm(train_data ~ trend + season)

# For a model with quadratic trend
fit_poly <- tslm(train_data ~ trend + I(trend^2) + season)

# Model summary (example for the linear model)
summary(fit_lm)

# Evaluating forecast accuracy using the validation data
lm_pred <- forecast(fit_lm, h=validation_size)
poly_pred <- forecast(fit_poly, h=validation_size)

# Accuracy of the models
accuracy(lm_pred, validation_data)
accuracy(poly_pred, validation_data)

# Refitting the chosen model using the entire dataset
# Assuming fit_lm is chosen based on better accuracy metrics
fit_lm_all <- tslm(salesTS ~ trend + season)

# Forecasting future series for the next 24 months
newPred <- forecast(fit_lm_all, h=24)

# Plotting the forecast with 95% confidence intervals
autoplot(newPred)

# The forecasted values and intervals can be viewed directly from newPred object
print(newPred)
```