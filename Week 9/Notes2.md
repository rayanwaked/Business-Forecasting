# Week 9 - Time Series Forecasting II (Continued)

## Two Forms of ARIMA Models

### Non-Seasonal ARIMA
- **Order**: (p,d,q)
    - **p**: Order of autoregressive part.
    - **d**: Order of differencing.
    - **q**: Order of moving average.
- Handles trend but not seasonality.

### Seasonal ARIMA
- Supports seasonal components.
- **Order**: (P,D,Q)m
    - **P**: Seasonal autoregressive order.
    - **D**: Seasonal differencing order.
    - **Q**: Seasonal moving average order.
    - **m**: Number of observations per season.
- Includes additional seasonal terms, similar to non-seasonal part but with backshifts of the seasonal period.

## Forecasting with ARIMA

### Finding Optimal ARIMA Model
- Use `auto.arima()` function from the forecast package.
- Can automatically determine (p,d,q) and (P,D,Q)m.
- Default arguments: `approximation = TRUE`, `stepwise = TRUE`, `lambda = NULL`.
    - For thorough model estimation, use `approximation = FALSE`, `stepwise = FALSE`.

### Forecasting Practice: Coffeemugprofit Data
1. Import data and create time series object using `ts()` function.
2. Visualize time series with `autoplot()`.
3. Fit ARIMA model using `auto.arima()`.
4. Perform model residuals check with `checkresiduals()`.
5. If necessary, tweak `auto.arima()` parameters for improved fitting.

### Fitted ARIMA Model: Non-Seasonal ARIMA (2,1,1)
- Two past observations (autoregressive).
- Differenced once.
- One past forecast error (moving average).

## Forecasting Process
1. Summary of fitted model (`summary(fit)`).
2. Forecast future series (`forecast(fit, h=10, level=0.95)`).
3. Visualize forecast with `autoplot()`.

### Insights from Forecast
- The forecast suggests potential periods of thin profit.
- Business strategies may need to be re-examined.

## Conclusion
- Completed forecasting with a non-seasonal ARIMA model using Coffeemugprofit data.
- Introduced the concept of seasonal ARIMA models for data with seasonal patterns.

### Next Steps
- Explore fitting a seasonal ARIMA model using the sales.xlsx dataset to compare with non-seasonal ARIMA and other models from previous weeks.

### References
- R scripts and datasets available in the Week 9 content folder for further practice and reference.

## Next Video
- Fitting a seasonal ARIMA model and comparing it to other models using the sales.xlsx dataset.

```
# Load necessary libraries
library(forecast)
library(ggplot2)
library(readxl) # for reading Excel files

# Two Forms of ARIMA Models
# Non-Seasonal ARIMA is specified as ARIMA(p,d,q)
# Seasonal ARIMA is specified as ARIMA(P,D,Q)[m]

# Forecasting with ARIMA

## Finding Optimal ARIMA Model
# auto.arima() can help find both non-seasonal and seasonal components

# Example with Coffeemugprofit Data
# Note: Replace this with the actual path to your data file
coffeemugprofit_data_path <- "path/to/coffeemugprofit/data.xlsx"
coffeemugprofit_data <- read_excel(coffeemugprofit_data_path)

# Assuming the data is in the first column and time starts from 2021, monthly frequency
coffeemugprofit_ts <- ts(coffeemugprofit_data[[1]], start=c(2021,1), frequency=12)

# Visualize the time series
autoplot(coffeemugprofit_ts)

# Fit an ARIMA model
fit_arima_coffeemugprofit <- auto.arima(coffeemugprofit_ts, stepwise=FALSE, approximation=FALSE)

# Check model residuals
checkresiduals(fit_arima_coffeemugprofit)

# Forecast future series
future_forecast_coffeemugprofit <- forecast(fit_arima_coffeemugprofit, h=10)
autoplot(future_forecast_coffeemugprofit)

# Insights from Forecast
# This section would involve analyzing the forecast output and plotting it
# The code above generates the forecast and visualizes it, providing the basis for further analysis

# Conclusion and Next Steps
# This script has implemented forecasting using a non-seasonal ARIMA model on the Coffeemugprofit dataset
# Next steps involve exploring a seasonal ARIMA model for a dataset with clear seasonal patterns
```
