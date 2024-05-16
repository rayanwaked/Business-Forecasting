install.packages("forecast")
install.packages("ggplot2")
library(forecast)
library(ggplot2)
library(readxl)

# Import data
plantpot <- read_excel("Week 8/plantpot.xlsx")

# Convert data to data frame and create time series object
plantpot_df <- as.data.frame(plantpot)
quantityTS <- ts(plantpot_df$quantity, start = c(2018,11), end = c(2023,10), frequency = 12)

# Time Series Visualization
autoplot(quantityTS, main = "Monthly Sales of Plant Pots")

# Autocorrelation Visualization
ggAcf(quantityTS)

# Data Partitioning
train_data <- window(quantityTS, start = c(2018,11), end = c(2022,10))
validation_data <- window(quantityTS, start = c(2022,11), end = c(2023,10))

# Linear Regression Model
linear_model <- tslm(train_data ~ trend + season)

# ARIMA Model and Residuals Check
arima_model <- auto.arima(train_data)
checkresiduals(arima_model)

# Forecast Accuracy Measurement
linear_forecast <- forecast(linear_model, h = 12)
arima_forecast <- forecast(arima_model, h = 12)
accuracy(linear_forecast, validation_data)
accuracy(arima_forecast, validation_data)

# Model Selection and Forecasting
# The p-value of the Ljung-Box test for the ARIMA model residuals is 0.3208, which is greater than the typical significance level of 0.05, indicating that the residuals are not significantly autocorrelated. This suggests that the ARIMA model adequately captures the dependencies in the data.

# Additionally, comparing the forecast accuracy metrics between the linear regression and ARIMA models, the ARIMA model generally has lower RMSE (Root Mean Squared Error) and MAE (Mean Absolute Error) values for both the training and test sets, indicating better performance in terms of forecast accuracy.

# Therefore, based on both the Ljung-Box test results and forecast accuracy metrics, the ARIMA model is preferred over the linear regression model.
final_forecast <- forecast(arima_model, h = 12)
autoplot(final_forecast, main = "Forecast for Next 12 Months")
