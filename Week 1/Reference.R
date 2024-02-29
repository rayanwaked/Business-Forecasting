# 1. Getting Help (R functions)
# Get help on a specific function: put question mark (?) in front of the function, and run the code.
?predict
?data.frame
# apropos() function will search all the local R functions by matching a keyword. Take 'prop' as example.
apropos('prop')
# RSiteSearch() will conduct an online search of all functions to match a keyword. Take 'rmse' as example.
RSiteSearch('rmse')

# 2. Packages- collections of R functions, data, and documentation that increase the power of R.
# install.packages() is used to download additional packages- those not exist in your current packages list, but needed for your project. e.g., "AppliedPredictiveModeling", "caret" 
install.packages("AppliedPredictiveModeling")
install.packages("caret")
# library() is used to load the packages that were installed, and make them ready for use. 
# IMPORTANT NOTE: You only need to download packages once, but make sure to library() relevant packages each time running an R script. 
library("AppliedPredictiveModeling")
library("caret")

# 3. Creating Objects in Rstudio
# anything created in R is called object, which can be assigned values using '<-' operator
# '=' can also be used for assigning values to R objects, but '<-' is recommended 
# For Windows user:  holding "Alt" key and press "-" key (to create "<-" operator). For Mac user: hold "Alt/Option" key and press "-" key.

# randomly select 5 people IDs from a total of 100 event participants
people <- sample(1:100, size = 5, replace = FALSE)

# To inspect the value of object in the Console window, simply type and run the object name.
people
# str() is used to understand the contents of an object.
str(people)

# 4. The three faces of "="
# 1) can be used to create object, e.g., qty = 22
qty = 22 # not recommended
qty <- 22 # strongly recommended
# 2) specifying values to function arguments, e.g., people <- sample(1:100,size=5,replace = FALSE)
# 3) testing for equivalence, e.g., 3 == 4
3 == 4
3 == 3

# 5. Core data types- numeric, integer, character, logical
# numeric example: 11.2, 3, 10.8
x <- 11.2
class(x) # returns numeric
y <- 3
class(y) # returns numeric
# integer example: 3L (the L tells R to store this as an integer)
z <- 3L
class(z) # returns integer
# character example: "color", "name", "Welcome to the class!"
message <- "Welcome to the class!"
# logical example: TRUE, FALSE
2 < 3 # returns TRUE
test <- 4 == 5
test # returns FALSE

# 6. Different types of R objects - atomic vector, factor, list, matrix, data frame
# atomic vector: the most basic data structure that can hold multiple value of the same type of data
# c() function ("c" for combine) is used to create vector object in R

# create weekHours as a vector that holds multiple numeric data 
weekHours <- c(45,40,35,40,45)
# vector operations are efficient: no need to loop over the elements of the vector 
weekHours + 5 # they work extra 5 hours a week in a busy time
mean(weekHours) # the avarage working hours is 41 hours

# create profession as a vector that holds character data
profession <- c('Consultant','ResearchAnalyst','Teacher','Teacher','ResearchAnalyst') 
profession

# factor: the R object that can be used to store character data. Factor stores character data by first determining all unique values in the data (called factor levels). as.factor() can be used to convert character data to factor (that enables us to see unique values).
profession1 <- as.factor(profession)
profession1

# To extract one or more values from vector object, write R object name followed by a pair of bracket
# subsetting vector[ ]: positive integer keeps/returns the elements at those positions
# subsetting vector[ ]: negative integer drops/excludes the elements at the specified positions 

# Subset weekHours to return the first element only
weekHours[1]
# Subset weekHours to return the first two elements
weekHours[c(1,2)]
# Subset weekHours to exclude the third element
weekHours[-3]
# Subset weekHours to exclude both the third and fourth elements
weekHours[-c(3,4)]
# Subset weekHours to exclude both the first and fourth elements
weekHours[-c(1,4)]

# Subset profession to drop the first element
profession[-1]
# Subset profession to keep the third element only
profession[3]
# Subset profession to keep the third and fifth elements only
profession[c(3,5)]

# missing values in R are encoded as NA ("not available")
# create probabilities as a vector which contains one missing element
probabilities <- c(.60,.30,NA,.25,.80)
# subset probabilities to return all non-missing values, e.g., vector[!is.na(vector)] 
probabilities[!is.na(probabilities)]
# most functions propagate missing values
mean(probabilities) # will still return NA
mean(probabilities, na.rm = TRUE) # return mean value after removing NA


# list: R object that can store many different types of elements inside it, including vectors, functions, etc.
# list() function can be used to create list object in R
# create record as a list that contains some profession (character) and weekHours (numeric) data
record <- list(c('Consultant','ResearchAnalyst','Teacher'), c(55,50,45))
record 


# matrix and data frame: two-dimensional rectangular data sets- they have rows and columns
# matrix can only contain data of the same type
  # matrix() function can be used to create matrix object
# data frame, as tabular data object, can contain data of different types. However,elements within one column MUST be of the same data type
  # data.frame() function can be used to create data frame object

# Create mat as a matrix with 3 rows and 4 columns
mat <- matrix(1:12,nrow = 3, ncol = 4)  
mat
# Assign names to the rows and columns to bring a matrix with full names
rownames(mat) <- c('row1','row2','row3')
colnames(mat) <- c('col1','col2','col3','col4')
mat
 
# Matrix can be subset using method similar to vectors, but rows and columns are subset separately
# matrix[row, column]: two indices separated by comma are required to subset matrix

# Subset mat to return the element sitting in the first row and second column
mat[1,2]
# Subset mat to return the elements sitting in the first row and 2nd, 3rd, and 4th columns
mat[1,2:4]
# Subset mat to return all of the elements in the first row
mat[1,]
# Subset mat to return all the elements in the second column
mat[,2]

# Create df as a data frames using data.frame() function 
df <- data.frame(ID = c(1,12,25,30,32),
                role = c('buyer', 'planner', 'manager', 'director','buyer'),
                posiFilled = c(TRUE,TRUE,FALSE,TRUE,FALSE),
                salary = c(85,92,113,130,80))
# inspect df in the console window
df 

# dataframe[row, column]: two indices separated by comma can also be used to subset data frame
# Subset df to return the element sitting in the first row and third column
df[1,3]
# Subset df to return the elements sitting in the first two rows
df[1:2,]
# Subset df to return the elements sitting in rows 1 to 3 and columns 2 to 4. 
df[1:3,2:4]
# In addition to [row, column] subset technique, the $ operator can also be used to return single column in the data frame. For example, subset df to return the salary column.
df[,4]
df$salary

# subset() function can be used to return subsets of vectors and data frames which meet condition.
# For data frame, use subset(x, subset_condition, select) where 'x' is the object name (changing depending on how you name your object); 'subset_condition' is the logical expression indicating rows to keep; 'select' is an expression indicating columns to select from a data frame (leave 'select' blank if you want to return all columns that meet the subset_condition)

# Return the subset with salary over 80k
subset(df,salary > 80)
# Return the subset with salary over 80k and posiFilled equals TRUE. Note that AND in R is the ampersand &.
subset(df,salary > 80 & posiFilled == TRUE)
# Return the subset with salary over 80k or posiFilled equals TRUE. Note that OR in R is the vertical bar |.
subset(df, salary > 80 | posiFilled == TRUE)
# Return employee IDs whose role is buyer in the company 
subset(df,role == "buyer", select = ID)


  