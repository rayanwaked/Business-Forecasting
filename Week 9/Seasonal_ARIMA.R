# Practice building and evaluating Seasonal ARIMA model using the sales.xlsx dataset (the one used in Week 8)

# Note: this R script is built upon Week 8. What's new is that, the seasonal ARIMA model is added (in the model fitting part), the performance of which is then compared with the previous two models created in Week 8.

# Required packages: forecast, ggplot2
# Check and make sure you have the required packages installed.
# Library the required packages
lapply(c('forecast','ggplot2'),require,character.only = TRUE)

# sales.xlsx dataset contains monthly shampoo sales data from Jan.2008 to Dec.2017 (no missing data)
# use Import Dataset under the Environment tab to import sales data and convert to data frame
sales <- data.frame(sales)

# Create time series object of the "sales_IN000s" column from the sales data frame
salesTS <- ts(sales$sales_IN000s,start = c(2008,1),end = c(2017,12), frequency = 12)

# Visualize the created time series object- salesTS
autoplot(salesTS) +  xlab("Time") + ylab("Sales_IN 000s") + 
  ggtitle("Monthly Sales: Year 2008-2017")

# Visualize the autocorrelation of monthly shampoo sales time series data 
ggAcf(salesTS)

# Partition the time series object- salesTS into training and validation period
# we assign the most recent 24 months (i.e., year 2016 & 2017) as the validation period
validation <- 24
# the training period would be the rest of the months in the series
train <- length(salesTS) - validation
# window() is then used to partition the series into the train/validation data
train_data <- window(salesTS, start = c(2008,1), end = c(2008,train))
validation_data <- window(salesTS, start = c(2008, train+1), end = c(2008, train+validation))

# Fit time series forecasting model using the training data and evaluate model accuracy on the validation data

# (Model 1) use the tslm() function to fit a model of linear trend and season components using the train_data
fit_lm <- tslm(train_data ~ trend + season)
# (Model 2) use the tslm() function to fit a model of quadratic trend and season components using the train_data
fit_poly <- tslm(train_data ~ trend + I(trend^2) + season)
# (Model 3) use the auto.arima() function to fit a seasonal ARIMA model using the train_data
fit_arima <- auto.arima(train_data)

# generate model summary output for the three fitted models
summary(fit_lm)
summary(fit_poly)
summary(fit_arima)

# Evaluate and compare forecast accuracy of the three fitted models using the validation data with 95% confidence level

# Measure the forecast accuracy of Model 1 (fit_lm) 
lm_pred <- forecast(fit_lm, h=validation, level=0.95) 
accuracy(lm_pred,validation_data)
# Measuring the forecast accuracy of Model 2 (fit_poly)
poly_pred <- forecast(fit_poly, h=validation, level=0.95)
accuracy(poly_pred,validation_data)
# Measuring the forecast accuracy of Model 3 (fit_arima)
arima_pred <- forecast(fit_arima, h=validation, level=0.95)
accuracy(arima_pred,validation_data)

# After comparing model performance, fit_lm performs the most accurate forecast (i.e., smallest validation RMSE), followed by fit_arima, then fit_poly.

# Next, refit the chosen model structure to the combined training and validation periods data, i.e., salesTS 
fit_lm_all <- tslm(salesTS ~ trend + season)
# then use the fit_lm_all model to generate forecasts for the future, say next 24 months (i.e., 2018 & 2019)
newPred <- forecast(fit_lm_all, h=24, level=0.95)
# check the forecasted values
newPred
# visualize the forecasts 
autoplot(newPred) +  xlab("Year") + ylab("Sales_IN 000s") +
  ggtitle("Time Series Data, with Two Years of Forecast")
