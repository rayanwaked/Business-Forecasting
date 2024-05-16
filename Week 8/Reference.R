# Practice building and evaluating time series forecasting models that capture trend and seasonal trend.

# Required packages: forecast, ggplot2
# Check and make sure you have the required packages installed.You can use below code to install them if needed.
install.packages(c("forecast","ggplot2"))
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

# Partition the time series object- salesTS into training and validation period
# we assign the most recent 24 months (i.e., year 2016 & 2017) as the validation period
validation <- 24
# the training period would be the rest of the months in the series
train <- length(salesTS) - validation
# window() is then used to partition the series into the train/validation data
train_data <- window(salesTS, start = c(2008,1), end = c(2008,train))
validation_data <- window(salesTS, start = c(2008, train+1), end = c(2008, train+validation))

# Fit time series forecasting model using the training data and evaluate model performance using the validation data

# tslm() function in the "forecast" package is used to fit linear models to time series including trend and seasonality components, where the variable "trend" is a simple time trend and "season" is a factor indicating the season (e.g., month or quarter depending on the frequency of the data).

# (Model 1) use the train_data to fit a time series forecasting model including linear trend and season components
fit_lm <- tslm(train_data ~ trend + season)
# (Model 2) use the train_data to fit another time forecasting model of quadratic trend and season components
fit_poly <- tslm(train_data ~ trend + I(trend^2) + season)

# generate model summary output for the above two fitted models
summary(fit_lm)
summary(fit_poly)

# Evaluate and compare forecast accuracy of the two fitted models using the validation data

# Measure the forecast accuracy of Model 1 (fit_lm) 
# use the fit_lm model to make forecasts in the validation period with 95% confidence level (level = 0.95)
lm_pred <- forecast(fit_lm, h=validation, level=0.95) 
accuracy(lm_pred,validation_data)
# Measuring the forecast accuracy of Model 2 (fit_poly)
# use the fit_poly model to make forecasts in the validation period with 95% confidence level (level = 0.95)
poly_pred <- forecast(fit_poly, h=validation, level=0.95)
accuracy(poly_pred,validation_data)

# after comparing model performance, fit_lm performs a more accurate forecast onto this shampoo sales data! 

# Next, refit the chosen model structure to the combined training and validation periods data, i.e., salesTS 
fit_lm_all <- tslm(salesTS ~ trend + season)
# then use the fit_lm_all model to generate forecasts for the future, say next 24 months (i.e., 2018 & 2019)
newPred <- forecast(fit_lm_all, h=24, level=0.95)
# check the forecasted values
newPred
# visualize the forecasts 
autoplot(newPred) +  xlab("Year") + ylab("Sales_IN 000s") +
  ggtitle("Time Series Data, with Two Years of Forecast")
