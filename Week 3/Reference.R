# Practice objective: verify the sample differences resulting from Simple Random Sampling (R function:sample()) and Stratified Random Sampling (R function:createDataPartition())

# Required packages: AppliedPredictiveModeling, caret
# Dataset: suppliersRank.xlsx
# Check and make sure you have the required packages installed. Then library them.
# Besides library packages by checking the packages box, here is another way to library multiple packages
lapply(c('AppliedPredictiveModeling','caret'), require, character.only = TRUE)


# use Import Dataset under Environment to import suppliersRank data

# convert suppliersRank dataset to data frame
suppliersRank <- data.frame(suppliersRank)

# display the internal structure of suppliersRank dataset
str(suppliersRank)

# check the population frequencies of suppliers rank
rank <- suppliersRank$rank
table(rank)

# check the population proportion of suppliers rank
populationProp <- table(rank)/length(rank)
populationProp
# round to two decimals
populationProp <- round(populationProp,digits = 2)
populationProp


### (a) Use the sample() function to create a simple random sample of 60 suppliers rank (simple_sample)
simple_sample <- sample(rank,60)
simple_sample
# check the simple_sample proportions of suppliers rank
simpleProp <- table(simple_sample)/length(simple_sample)
simpleProp <- round(simpleProp, digits = 2)
simpleProp

### (b) Use the createDataPartition() function to create a stratified random sample of 60 suppliers (stra_sample)
stra_sample <- createDataPartition(rank,0.625)
stra_sample
# check the stra_sample proportions of suppliers rank  
straProp <- table(rank[stra_sample$Resample1])/length(stra_sample$Resample1)
straProp <- round(straProp,digits = 2)
straProp

### Question: compare between simple_sample and stra_sample, which one is closer to the population proportion of suppliers rank? Let's compare simpleProp, populationProp and straProp!
simpleProp
populationProp
straProp
