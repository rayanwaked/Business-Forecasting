# Practice building and evaluating Non-seasonal ARIMA model using the coffeemugprofit.xlsx dataset.

# Required packages: forecast, ggplot2 
# Check and make sure you have the required packages installed.
# Library the required packages
lapply(c('forecast','ggplot2'),require,character.only = TRUE)

# coffeemugprofit.xlsx dataset contains weekly coffee mugs profit data for the past 150 weeks

# use Import Dataset under the Environment tab to import the data and convert to data frame
coffeemugprofit <- data.frame(coffeemugprofit)

# Create time series object of the "profit_usd" column from the coffeemugprofit data frame
profitTS <- ts(coffeemugprofit$profit_usd)

# Visualize the created time series object- profitTS
autoplot(profitTS) +  xlab("Week") + ylab("Profit_USD") + 
  ggtitle("Coffee mug profit in the past 150 weeks")

# Visualize the autocorrelation of weekly coffee mug profit series data 
ggAcf(profitTS)

# Note: if you intend to compare ARIMA models with other time series forecasting models, you can proceed to partition the time series data into training and validation period (as what we did in Week 8). Here in this practice with the coffeemugprofit data, we focus on using all the collected profit data to find an appropriate ARIMA model. We then check whether the fitted model has adequately captured the data information using the residuals check - R function: checkresiduals()

# auto.arima() function in the "forecast" package is used to find a proper ARIMA model for the series data
fit <- auto.arima(profitTS)
# perform residuals check of the fitted model
checkresiduals(fit) # the check suggests that the model left information in the residuals

# let's have the auto.arima() function work harder by having a couple of parameters tweaked, adding arguments approximation = FALSE,stepwise = FALSE inside the function
fit <- auto.arima(profitTS,approximation = FALSE,stepwise = FALSE)
# re-check the residuals of the fitted model
checkresiduals(fit) # this time, the model passes the required checks
# generate model summary output
summary(fit)

# Next, use the fitted model to generate forecasts for the future, say next 10 weeks.
newPred <- forecast(fit, h=10, level=0.95)
# check the forecasted values with 95% prediction intervals
newPred
# visualize the forecasts 
autoplot(newPred) +  xlab("Week") + ylab("Profit_USD") + 
  ggtitle("Coffee mug profit, with forecasts into next 10 weeks")
