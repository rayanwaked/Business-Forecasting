# Week 2: Data Pre-processing

## Introduction
- **Importance of Data Pre-processing**: Ensures data quality, which significantly impacts model performance.
- **Agenda**: Introduction to data pre-processing, data transformation for individual predictors, and removing extra predictors.

## Data Pre-processing Concept
- **Data Cleaning**: Handling missing values, removing noise, and correcting inconsistencies.
- **Data Integration**: Merging data from multiple sources into a coherent dataset.
- **Data Transformation**: Rescaling, resolving skewness, and reducing outlier impact.
- **Data Reduction**: Aggregating or eliminating redundant predictors.

## Data Transformation for Individual Predictors
- **Centering and Scaling**: Adjusting predictors to have a mean of 0 and standard deviation of 1.
- **Skewness**: Identifying and resolving skewness in data.
    - *Skewness Visualization*: Left-skewed, right-skewed, and symmetric distributions.
    - *Diagnosing Skewness*: Using skewness values and graphical plots.
    - *Resolving Skewness*: Employing mathematical transformation methods like Box-Cox.

## Box-Cox Transformation
- **Method Overview**: Proposed by Box and Cox (1964) to handle skewness.
- **Transformation Function**: Varies based on lambda parameter.
    - *Lambda Values*: 0 (natural logarithm), 1/2 (square root), 1/3 (cube root), -1 (inverse), and others.
- **Estimation**: Lambda value estimated from training data.
- **Effect Visualization**: Histogram comparison before and after Box-Cox transformation.

## Conclusion
- **Next Steps**: Practice checking and resolving skewness using the "product" Excel file in the upcoming video.