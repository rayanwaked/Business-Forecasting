# Week 8: Introduction to Time Series Forecasting

## Overview
- **Duration:** Weeks 8 and 9
- **Focus:** Time series forecasting, a distinct predictive modeling technique due to the time dimension, requiring specific analysis and R functions.

## Agenda
1. **Introduction to Time Series Data**
2. **Time Series Forecasting**
3. **Time Series Components**
4. **Visualization of Time Series Data in RStudio**
5. **Data Partitioning into Training and Validation Periods**
6. **Model Fitting and Forecast Accuracy Measurement**
7. **Forecasting Future Periods**

### Highlights
- Time series forecasting adds a **time dimension**, imposing an ordering of observations.
- Focus on **regularly spaced data** (daily, weekly, monthly, quarterly) for this course.
- Examples: daily stock prices, monthly store sales, quarterly freight spending, annual profits, consumer price index (CPI), annual birth and mortality rates.
- **Dataset for class:** Monthly shampoo sales from January 2008 to December 2017.

## Defining Time Series
- **Time Series:** Sequential data points recorded over time.
- **Types:**
    - Regularly spaced data: Observed at regular intervals.
    - Irregularly spaced data: Not the focus of this course.

## Time Series Forecasting
- Determines time series components (trend, seasonal patterns) and estimates future data sequence.
- Uses **sales.xlsx** dataset for illustration.

## Time Series Components
- **Trend:** Long-term increase or decrease (linear, polynomial, exponential).
- **Seasonal:** Occurs at specific times of the year, fixed frequency.
- **Cyclical:** Rises and downs without a fixed frequency, caused by difficult-to-determine factors.

## Additive vs. Multiplicative Components
- **Additive:** Constant variation across different periods.
- **Multiplicative:** Percentage variation across different periods.
- **Transformation:** Log transform multiplicative components into additive format for modeling convenience.

## Visualizing Time Series Data
- **Dataset:** sales.xlsx (Week 8 content folder).
- **Objective:** Identify initial patterns and components.
- **Tools:** `ts()` function for creating time series object, `autoplot()` for plotting (requires "ggplot2" and "forecast" packages).

### Steps for Visualization
1. Import data into RStudio.
2. Convert to time series object with `ts()` function.
3. Use `autoplot()` for plotting, incorporating axis labels and title for clarity.

## Conclusion
- The session ended with insights on identifying and visualizing time series components, laying the groundwork for future forecasting models.
- **Next steps:** Partitioning time series data, model fitting, and evaluating forecast accuracy in the upcoming video.

---

## Additional Notes
- Remember to install necessary R packages (`ggplot2`, `forecast`) before attempting to visualize time series data.
- Pay attention to the types of time series data and their components to choose the appropriate forecasting methods.

```
# Load necessary libraries
library(readxl) # For reading Excel files
library(ggplot2) # For data visualization
library(forecast) # For forecasting functions

# Assuming the 'sales.xlsx' file is in your working directory
# Load the dataset
sales_data <- read_excel("sales.xlsx")

# Convert the sales data into a time series object
# The dataset is assumed to have monthly data from January 2008 to December 2017
salesTS <- ts(sales_data$sales, start=c(2008, 1), end=c(2017, 12), frequency=12)

# Visualize the time series data
autoplot(salesTS) +
  xlab("Time") + ylab("Sales in Thousands of Dollars") +
  ggtitle("Monthly Shampoo Sales Time Series") +
  theme_minimal()

# Basic time series decomposition to visualize components
components <- decompose(salesTS)
autoplot(components)

# Note: The 'decompose' function can help visualize the trend, seasonal, and random components
# of the time series data, assuming an additive model. For multiplicative models, you may consider
# using 'stl()' function instead.
```