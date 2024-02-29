# Given data frame
df <- data.frame(names=c('Queen','Cleo','Rose','Bill','Flora'), scores=c(23,32,27,40,45))

# (a) Continue running below R code to practice subset data frame.
# What are the returns?
# List the return values in the comment starting with “#”.
df$names
# Returns: 'Queen' 'Cleo' 'Rose' 'Bill' 'Flora'

# (b) After practice in (a), write R code to subset the data frame df that returns the column of scores.
df$scores
# Returns: 23 32 27 40 45

# (c) Use the subset() function to return the player names with scores over 30.
subset_df <- subset(df, scores > 30, select = names)
# Returns: 'Cleo' 'Bill' 'Flora'

# Install packages if not installed
install.packages(c("AppliedPredictiveModeling", "caret", "e1071", "corrplot", "FactoMineR"))

# Load the packages
library(AppliedPredictiveModeling)
library(caret)
library(e1071)
library(corrplot)
library(FactoMineR)

# Install the "readxl" package if not installed
install.packages("readxl")

# Load the package
library(readxl)

# Import the data from cereal.xlsx
cereal <- read_excel("/Users/rayanwaked/Downloads/cereal.xlsx")

# Convert cereal into a dataframe
cereal <- data.frame(cereal)

# Display the structure of the data frame
str(cereal)

# Load the package
library(e1071)

# Check the skewness of the predictor "protein"
protein_skewness <- skewness(cereal$protein)

# Display the skewness value of protein in the comment
# Skewness value of protein: 1.973224
print(protein_skewness)

# Apply natural logarithm transformation to all predictors in the data set
cereal[, 2:10] <- apply(cereal[, 2:10], 2, log1p)

# Load the required packages
library(e1071)

# Check the skewness of the predictor "protein"
protein_skewness <- skewness(cereal$protein)

# Display the skewness value of protein
print(protein_skewness)

# Create a histogram of the original "protein" values
hist(cereal$protein, main = "Distribution of Protein (Before Transformation)", xlab = "Protein")

# Apply natural logarithm transformation to "protein"
cereal$protein_transformed <- log1p(cereal$protein)

# Create a histogram of the transformed "protein" values
hist(cereal$protein_transformed, main = "Distribution of Protein (After Transformation)", xlab = "Transformed Protein")

# Load the package
library(corrplot)

# Calculate the correlation matrix
cor_matrix <- cor(cereal[, 2:10])

# Visualize the correlation matrix using corrplot with numbers displayed
corrplot(cor_matrix, method = "number", type = "full", order = "hclust")

# Observations:
# Positive Correlations:
#   There is a 0.79 correlation between Protein and Polyunsaturated Fat
#   There is a 0.46 correlation between Monounstaturated Fat and Sugar, as well as Sodium and Sugar
#   There is a 0.36 correlation between Dietary Fiber and Saturated Fat
# Negative Correlations:
#   There is a -0.54 correlation between Total Carbohydrates and Polyunsaturated Fat
#   There is a -0.50 correlation between Saturated Fat and Sodium, as well as Protein and Sodium
#   There is a -0.46 correlation between Sugar and Dietary Fiber

# Apply Principal Component Analysis (PCA) to all predictors
pca_result <- prcomp(cereal[, 2:10], scale. = TRUE)

# Scree plot to visualize the proportion of variance explained by each PC
plot(pca_result)

# Cumulative proportion of variance explained
cumulative_variance <- cumsum(pca_result$sdev^2) / sum(pca_result$sdev^2)

# Print the cumulative proportion of variance explained
print(cumulative_variance)
# Cumulative variance is
# [1] 0.2819111 0.5107992 0.6677453 0.8019401 0.9006168 0.9501355 0.9896968
# [8] 0.9974112 1.0000000

# Determine the number of components to retain based on the scree plot or a threshold

# What is the % of variance captured by those retained PCs respectively?

# Display the summary of the PCA result
summary(pca_result)

# Extract the percentage of variance captured by each PC
variance_explained <- pca_result$sdev^2 / sum(pca_result$sdev^2) * 100

# Print the percentage of variance captured by each PC
print(variance_explained)
# Variance is
# [1] 28.1911072 22.8888141 15.6946058 13.4194812  9.8676750  4.9518702  3.9561231
# [8]  0.7714417  0.2588818

