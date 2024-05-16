# Time Series Forecasting in R Language

## Overview
Welcome to the summary of our session on time series forecasting using R. We delved into the importance of understanding data that includes a time dimension and explored various R functions and methods to forecast future data points based on historical data.

## Highlights
- **Introduction to Time Series Forecasting**: Started with the `tslm()` function to capture trend and seasonal patterns.
- **Advanced Methods**: Utilized the `auto.arima()` function for capturing autocorrelations beyond trend and seasonality.
- **Practical Applications**: Conducted forecasting exercises with shampoo sales, coffee mug profit, and plant pot sales data.

## Time Series Forecasting Workflow in RStudio
1. **Setup**: Install and load necessary R packages.
2. **Data Preparation**: Load the dataset and convert it into a time series object using `ts()`.
3. **Data Visualization**: Identify patterns, including autocorrelations.
4. **Model Fitting**: Partition data into training and validation periods. Fit models using the training data.
5. **Model Evaluation**: Compare forecast accuracy using the validation data. Select the best-performing model.
6. **Forecasting**: Refit the selected model to the combined dataset and forecast future periods.

## Next Steps for Continuing Studies
### Predictive Models
- **Beyond Basics**: Explore penalized models, support vector machines, random forest, and neural networks.
- **Resource**: Free online e-book for a comprehensive study on these models.

### Time Series Forecasting
- **Exponential Smoothing Methods**: Including simple and trend-adjusted exponential smoothing.
- **Dynamic Regression Models**: Incorporate external information such as holidays and promotions.
- **Multivariate Time Series Analysis**: Advanced analysis involving more than one time-dependent variable.

## Resources for R Coding Practice
- **R for Data Science**: A freely accessible e-book to enhance data science skills.
- **R Markdown**: A framework for authoring documents and generating reports with R.
- **Shiny Applications**: Build interactive web apps directly from R.
- **Blockchain with R**: Learn how to read and create blockchain data structures in R.

```
# Install necessary packages
install.packages(c("forecast", "tseries", "ggplot2"))
library(forecast)
library(tseries)
library(ggplot2)

# Assuming sales_data is your dataset with columns 'date' and 'sales'

# Convert the dataset to a time series object
sales_ts <- ts(sales_data$sales, start=c(2012,1), frequency=12) # Adjust 'start' and 'frequency' as per your data

# Visualize the time series data
plot(sales_ts, main="Sales Data Time Series", ylab="Sales", xlab="Time")

# Split data into training and validation (test) sets
training_set <- window(sales_ts, start=c(2012,1), end=c(2020,12)) # Adjust dates as necessary
test_set <- window(sales_ts, start=c(2021,1)) # Adjust dates as necessary

# Time Series Linear Model (TSLM)
tslm_model <- tslm(training_set ~ trend + season)
summary(tslm_model)

# Forecast using the TSLM model
tslm_forecast <- forecast(tslm_model, h=24) # Forecasting next 2 years (24 months)
plot(tslm_forecast)

# Auto ARIMA model
auto_arima_model <- auto.arima(training_set)
summary(auto_arima_model)

# Forecast using the Auto ARIMA model
auto_arima_forecast <- forecast(auto_arima_model, h=24) # Forecasting next 2 years (24 months)
plot(auto_arima_forecast)

# Compare models - Here we just plot them, but you should also consider statistical accuracy metrics
plot(forecast(tslm_model, h=12), main="TSLM vs Auto ARIMA Forecast Comparison")
lines(forecast(auto_arima_model, h=12)$mean, col='red')
legend("topleft", legend=c("TSLM", "Auto ARIMA"), col=c("black", "red"), lty=1)

# This is a simplified example. When implementing, make sure to perform diagnostic checks,
# and adjust model parameters as necessary based on your specific dataset and requirements.
```