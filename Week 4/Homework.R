install.packages(c("AppliedPredictiveModeling", "caret", "corrplot", "pls"))

library(AppliedPredictiveModeling)
library(caret)
library(corrplot)
library(pls)

data(permeability)

# Check for missing values in the 'fingerprints' subset
missing_values <- sum(is.na(fingerprints))
cat("Number of missing values in 'fingerprints':", missing_values)

set.seed(0)
training <- createDataPartition(permeability, p = 0.8, list = FALSE)
predictors_train <- fingerprints[training, ]
permeability_train <- permeability[training]
predictors_test <- fingerprints[-training, ]
permeability_test <- permeability[-training]

# Identify and remove near-zero variance predictors in the training set
nzv_predictors <- nearZeroVar(predictors_train)
predictors_train <- predictors_train[, -nzv_predictors]
predictors_test <- predictors_test[, -nzv_predictors]

# Linear Model (LM)
lm_model <- lm(permeability_train ~ ., data = data.frame(predictors_train, permeability_train))
print("lm_model evaluation")
summary(lm_model)

# Principal Component Regression (PCR)
pcr_model <- pcr(permeability_train ~ ., data = data.frame(predictors_train, permeability_train), validation = "CV")
print("pcr_model evaluation")
summary(pcr_model)

# Partial Least Squares (PLS)
pls_model <- plsr(permeability_train ~ ., data = data.frame(predictors_train, permeability_train), validation = "CV")
print("pls_model evaluation")
summary(pls_model)

# Between the three models, the PCR model performs the worst due to indication of potential overfitting
# (cross-validation error begins increasing at the latter half).

# The linear model multiple R-squared stands at 93.81% and adjusted R-squared at 81.42%, which indicates
# that the model is performing very well and finding meaningful information as it continues.
# Additionally, its high F-statistic of 7.579 and low p-value of 2.308e-11 indicates that the model is statistically
# significant.

# In comparision to the linear model, the PSL model provides a higher prediction accuracy of 93.81%
# However, it seems that the RMSEP is increasing as the number of comps increases, which indicates that
# the model's performance is weakening as the data becomes more intricate.
# In general, the PLS model appears to be presenting more favorable statistics, but more in-depth analysis
# between the two models would be practical.

# Predict with the chosen model on the test set
print("employing chosen model, Partial Least Squares")
predictions <- predict(pls_model, newdata = predictors_test)