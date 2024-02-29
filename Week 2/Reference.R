# Required packages: AppliedPredictiveModeling, caret, corrplot, e1071, and FactoMineR
# Dataset: product.xlsx

# Install and library the required packages. Note: For the packages that are already in your Packages list, you do NOT need to re-install them. But must library them.
# AppliedPredictiveModeling
# caret
# e1071; note: e1071 contains skewness()
# corrplot
# FactoMineR; note: FactoMineR contains PCA() function

# use Import Dataset under Environment tab to import product data

# convert product dataset to data frame
product <- data.frame(product)
# display the internal structure of product dataset
str(product)
# Retain all of the predictors (Note: in the product dataset, you can retain all predictors by excluding the identifier (ID) and outcome columns)
predictors <- product[,-(1:2)]

### Check and transform/resolve skewness of the predictors

# Use skewness() to check the skewness of the predictor- Area1 (surface area)
skewness(predictors$Area1)

# Use preProcess() & predict() function to apply skewness transformation to all of the predictors in the product dataset
predictorsPP <- preProcess(predictors,method = "BoxCox")
predictorsTrans <- predict(predictorsPP,predictors)

# Recheck the skewness of the predictor- Area1 after the transformation
skewness(predictorsTrans$Area1)

# Compare the distributional plots of the predictor- Area1 before and after the Box-Cox transformation is applied
hist(predictors$Area1,xlab = "Original Data",col = "skyblue")
hist(predictorsTrans$Area1, xlab = "Transformed Data", col = "skyblue")

### Practice data reduction using the PCA technique and apply to the entire set of predictors

# Identify and remove those predictors that are with only a single value since PCA uses variances
isZV <- apply(predictors, 2, function(x) length(unique(x)) == 1) # returns logical value- TRUE or FALSE
predictors <- predictors[, !isZV] # 2 predictors are of zero variance thus removed

# Apply PCA to the entire set of predictors  
# First, preProcess(); Then, predict(); Finally, PCA()
predictorsPP <- preProcess(predictors,c('BoxCox','center','scale'))
predictorsTrans <- predict(predictorsPP,predictors)
predictorsPCA <- PCA(predictorsTrans, ncp = ncol(predictors), graph = FALSE)

# Check the eigenvalue and % of variance captured by each generated principal component (PC) 
# How many PCs to keep? Keep the PCs with an eigenvalue greater than 1
# What is the % of variance captured by those retained PCs respectively?
predictorsPCA$eig # retain 25 PCs

# Run below codes if you're interested in the loadings (or coefficients) of the initial variables from which the PCs are constructed
predictorsCoef <- data.frame(prcomp(predictorsTrans)$rotation[, 1:25])
predictorsCoef


### Practice removing highly correlated predictors 

# Use corrplot() to visualize the correlation matrix of the predictors created by cor() function
predictorsCorr <- cor(predictorsTrans)
corrplot(predictorsCorr, order = "hclust",tl.cex = .35)

# findCorrelation() from the caret package is used to identify highly correlated predictors to remove
highCorr <- findCorrelation(predictorsCorr, 0.75)
predictorsTrans <- predictorsTrans[,-highCorr]