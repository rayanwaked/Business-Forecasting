# Classification Model Performance Measures

## Confusion Matrix
- A **confusion matrix** is a table showing correct and incorrect classifications.
    - Correct classifications: **True Positives (TP)** and **True Negatives (TN)** on the diagonal.
    - Incorrect classifications: **False Positives (FP)** and **False Negatives (FN)** off-diagonal.
- Positive: Indicates membership in the reference group.
- Negative: Not in the reference group.

### Highlights
- **Positive** does not imply a desirable outcome but indicates membership in the reference group.
- **True Positive (TP):** Correctly forecasted as a member of the reference group.
- **True Negative (TN):** Correctly forecasted as not a member of the reference group.
- **False Positive (FP):** Incorrectly forecasted as a member of the reference group.
- **False Negative (FN):** Incorrectly forecasted as not a member of the reference group.

## Derived Measures from Confusion Matrix
1. **Classification Accuracy:**
    - Number of correct predictions (TP + TN) divided by the total number of predictions.
    - Useful when the dataset is balanced.

2. **Precision:**
    - Percentage of correctly predicted positive cases (TP / (TP + FP)).

3. **Sensitivity (Recall or True Positive Rate):**
    - Percentage of actual positives correctly predicted (TP / (TP + FN)).

4. **Specificity (True Negative Rate):**
    - Percentage of actual negatives correctly predicted (TN / (FP + TN)).

5. **F1-Score:**
    - Balances precision and recall. Useful for evaluating imbalanced datasets.

## Example Calculation
- **Scenario:** Predicting customer buy decisions (yes or no).
- **Confusion Matrix Outcome:**
    - TP = 101 (correctly predicts buying)
    - TN = 100 (correctly predicts not buying)
    - FP = 3 (incorrectly predicts buying)
    - FN = 6 (incorrectly predicts not buying)
- **Derived Metrics:**
    - Accuracy = 95%
    - F1-Score = 95%

## Accuracy and Classification Thresholds
- Accuracy can be misleading due to changes in classification thresholds.
- Different thresholds can significantly alter the confusion matrix and accuracy.

## ROC Curve
- **ROC (Receiver Operating Characteristic) Curve:**
    - Plots the True Positive Rate against the False Positive Rate at various thresholds.
    - The closer to the top left corner, the better (high TP rate and low FP rate).

### AUC (Area Under the Curve)
- Measures the degree of separability between classes.
- A higher AUC indicates a better model at distinguishing true positives and negatives.

## Conclusion
- We explored the confusion matrix, derived metrics, and the importance of the ROC curve and AUC in evaluating classification model performance. In the next video, we'll apply logistic regression modeling with the CustomerBuy dataset.

## Confusion Matrix

A **confusion matrix** is a table used to describe the performance of a classification model on a set of test data for which the true values are known.

- **True Positives (TP)**: Correctly predicted positive observations
- **True Negatives (TN)**: Correctly predicted negative observations
- **False Positives (FP)**: Incorrectly predicted positive observations (Type I error)
- **False Negatives (FN)**: Incorrectly predicted negative observations (Type II error)

## Derived Metrics

1. **Accuracy**: `(TP + TN) / (TP + TN + FP + FN)`
2. **Precision**: `TP / (TP + FP)`
3. **Recall (Sensitivity)**: `TP / (TP + FN)`
4. **Specificity**: `TN / (TN + FP)`
5. **F1 Score**: `2 * (Precision * Recall) / (Precision + Recall)`

## R Code Examples

### Calculating Metrics from Confusion Matrix

```r
# Assuming values for TP, TN, FP, FN
TP <- 101
TN <- 100
FP <- 3
FN <- 6

# Accuracy
accuracy <- (TP + TN) / (TP + TN + FP + FN)
# Precision
precision <- TP / (TP + FP)
# Recall
recall <- TP / (TP + FN)
# Specificity
specificity <- TN / (TN + FP)
# F1 Score
f1_score <- 2 * (precision * recall) / (precision + recall)

# Print metrics
print(paste("Accuracy:", accuracy))
print(paste("Precision:", precision))
print(paste("Recall:", recall))
print(paste("Specificity:", specificity))
print(paste("F1 Score:", f1_score))

# For ROC curve, we need an actual binary outcome and predicted probabilities.
# Assuming 'actual' as the true binary outcome and 'predicted_prob' as the predicted probability for the positive class.

# Install and load the pROC package
install.packages("pROC")
library(pROC)

# Create a ROC curve
roc_obj <- roc(actual, predicted_prob)

# Plot ROC curve
plot(roc_obj, main="ROC Curve", col="#1c61b6")
# Add color to the area under the curve
auc(roc_obj)
lines(roc_obj, col="#1c61b6")
```