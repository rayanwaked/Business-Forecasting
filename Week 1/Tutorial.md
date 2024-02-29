I. Basics

* **Comments:**  # This is a comment
* **Variables:** `my_variable <- 10` (Use the assignment operator `<-`)
* **Data Types:**
    *  Numeric: `10, 5.7`
    *  Character: `"Hello"`
    *  Logical: `TRUE, FALSE`
* **Vectors:** `numbers <- c(1, 5, 8, 2)`  (Use `c()` to combine)

II. Data Structures

* **Lists:** `my_list <- list("Apple", 2, TRUE)` (Can store mixed data types)
* **Data Frames:**
    ```R
    data <- data.frame(name = c("Emily", "John"),
                       age = c(25, 30))
    ```

III. Data Manipulation

* **dplyr package** (install with `install.packages("dplyr")`)
    * **Loading:** `library(dplyr)`
    * **Selecting Columns:** `data %>% select(name)`
    * **Filtering Rows:** `data %>% filter(age > 25)`
    * **Creating New Variables:** `data %>% mutate(is_adult = age >= 18)`
    * **Grouping and Summarizing:**
       ```R 
       data %>% 
          group_by(name) %>% 
          summarize(avg_age = mean(age)) 
       ```
    * **Chaining Operations:** Use the pipe operator (`%>%`)

IV. Control Flow

* **If/Else:**
    ```R
    if (x > 10) {
       print("x is greater than 10")
    } else {
       print("x is less than or equal to 10")
    }
    ```
* **For Loops:**
    ```R
    for (i in 1:5) {
       print(i) 
    }
    ```   
* **While Loops:**
    ```R
    count <- 1
    while (count <= 5) {
       print(count)
       count <- count + 1
    }
    ```

V. Functions

* **Example**
    ```R
    # Define a function
    my_function <- function(x) {
    x * 2
    }
  
    my_function(5)  # Returns 10
    ```

VI. Basic Scatterplot

* **Example**
    ```R
    ggplot(data, aes(x = age, y = height)) +
    geom_point() 
    ```
