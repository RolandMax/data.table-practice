# Data.table reshape exercises: dcast and melt
# Load required package
library(data.table)

#################################################
# Setup: Create sample datasets for exercises
#################################################

# Dataset 1: Student scores
students_dt <- data.table(
  student_id = rep(1:3, each = 4),
  subject = rep(c("Math", "English", "Science", "History"), 3),
  score = c(85, 92, 78, 95, 88, 72, 90, 85, 79, 88, 94, 82)
)

# Dataset 2: Sales data
sales_dt <- data.table(
  store = c("Store_A", "Store_A", "Store_B", "Store_B"),
  year = c(2022, 2023, 2022, 2023),
  q1_sales = c(100, 110, 90, 95),
  q2_sales = c(120, 125, 85, 100),
  q3_sales = c(95, 115, 88, 92),
  q4_sales = c(130, 140, 95, 105)
)

# Dataset 3: Employee skills
skills_dt <- data.table(
  employee_id = 1:4,
  name = c("Alice", "Bob", "Charlie", "David"),
  python = c(4, 3, 5, 2),
  sql = c(3, 4, 4, 5),
  r = c(5, 2, 3, 4)
)

#################################################
# Exercise 1: Basic Melting
#################################################
# Task: Using students_dt, create a wide format where:
# - Each student should be a row
# - Subjects should become columns
# - Scores should be the values
# Hint: Use dcast with formula: student_id ~ subject

# Your code here:
students_dt

dcast(students_dt, student_id ~ subject, value.var = "score")
  

#################################################
# Exercise 2: Basic Casting
#################################################
# Task: Take sales_dt and melt it to create a long format where:
# - Only quarter sales columns are melted
# - The new columns should be named "quarter" and "sales"
# Hint: Use measure.vars for quarter columns

# Your code here:
melt(sales_dt, id.vars = c("store", "year"),
     measure.vars = c("q1_sales", "q2_sales", "q3_sales"))


#################################################
# Exercise 3: Multiple Value Columns
#################################################
# Task: Create a new data.table:
students_grades_dt <- data.table(
  student_id = rep(1:3, each = 4),
  subject = rep(c("Math", "English", "Science", "History"), 3),
  score = c(85, 92, 78, 95, 88, 72, 90, 85, 79, 88, 94, 82),
  grade = c("B", "A", "C", "A", "B", "C", "A", "B", "C", "B", "A", "B")
)




# Then cast it to wide format keeping both score and grade
# Hint: Use dcast with value.var = c("score", "grade")

# Your code here:
students_grades_dt

dcast(students_grades_dt,  student_id ~ subject,
      value.var = c("score", "grade"))  

#################################################
# Exercise 4: Aggregation in Casting
#################################################
# Task: Using the students_dt:
# 1. Calculate the average score per subject
# 2. Cast it to wide format showing min and max scores per subject
# Hint: Use dcast with fun.agg

# Your code here:
result <- dcast(students_dt, 
                subject ~ ., 
                value.var = "score",
                fun.agg = list(
                  Min = min,
                  Max = max,
                  Average = mean
                ))

print("Subject Statistics:")
print(result)


#################################################
# Exercise 5: Selective Melting
#################################################
# Task: Using skills_dt:
# 1. Melt only the skill columns (python, sql, r)
# 2. Keep employee name in the result
# 3. Give appropriate names to the new columns
# Hint: Use measure.vars and variable.name/value.name

# Your code here:
skills_dt
melt(skills_dt, 
     id.vars = c("employee_id", "name"), 
     measure.vars = c("python", "sql", "r"),
     variable.name = "skills",
     value.name = "number")



#################################################
# Exercise 6: Pattern Matching in Melt
#################################################
# Task: Using sales_dt:
# 1. Melt only the quarterly sales columns using pattern matching
# 2. Extract the quarter number from the variable names
# Hint: Use patterns in measure.vars

# Your code here:
sales_dt

sales_dt <- 
melt(sales_dt, 
     id.vars = c("store", "year"),
     measure.vars = patterns("q."),
     variable.name = "quarter",
     value.name = "sales")

sales_dt[,
         ':='(quarter = gsub(pattern = "_sales", replacement = "", quarter))]


#################################################
# Exercise 7: Complex Reshaping
#################################################
# Create this sample data:
complex_dt <- data.table(
  region = rep(c("North", "South"), each = 6),
  year = rep(c(2022, 2023), each = 3, times = 2),
  product = rep(c("A", "B", "C"), times = 4),
  sales = sample(1000:5000, 12),
  profit = sample(100:500, 12)
)

# Task:
# 1. First cast it to show products as columns
# 2. Then melt it back but only for specific products
# Hint: This is a two-step process

# Your code here:



#################################################
# Exercise 8: Working with Dates
#################################################
# Create this sample data:
dates_dt <- data.table(
  date = seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "month"),
  value_A = rnorm(12, 100, 10),
  value_B = rnorm(12, 200, 20)
)

# Task:
# 1. Melt the value columns
# 2. Extract month from date
# 3. Cast to show months as columns
# Hint: Use format(date, "%b") for month abbreviations

# Your code here:



print("End of exercises")