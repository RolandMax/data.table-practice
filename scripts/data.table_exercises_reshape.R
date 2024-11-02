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
complex_dt <- 
  dcast(complex_dt, 
      region+year+sales+profit~product)

melt(complex_dt,
     id.vars = c("region", "year", "sales", "profit", "A", "B"),
     measure.vars = c("B", "C"),
     variable.name = "product",
     value.name = "product_value")


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
dates_dt <- 
melt(dates_dt, 
     id.vars = c("date"),
     measure.vars = patterns("value."),
     variable.name = "A_B",
     value.name = "value")

dates_dt[,  ':='(month = format(date, "%b"))]
dcast(dates_dt, date+A_B+value~month)



# Intermediate  data.table reshape exercises ------------------------------


library(data.table)

#################################################
# Setup: Create sample datasets for exercises
#################################################

# Dataset 1: Customer transactions with nested categories
transactions_dt <- data.table(
  customer_id = rep(1:3, each = 4),
  date = rep(as.Date("2024-01-01") + 0:3, 3),
  category_main = rep(c("Electronics", "Food", "Electronics", "Food"), 3),
  category_sub = rep(c("Phones", "Groceries", "Laptops", "Restaurant"), 3),
  amount = round(rnorm(12, mean = 500, sd = 200), 2),
  payment_method = rep(c("Credit", "Debit", "Cash", "Credit"), 3)
)

# Dataset 2: Employee performance metrics over time
performance_dt <- data.table(
  employee_id = rep(1:4, each = 12),
  year = rep(rep(2022:2023, each = 6), 4),
  month = rep(month.abb[1:6], 8),
  productivity = round(rnorm(48, mean = 85, sd = 10), 1),
  quality = round(rnorm(48, mean = 90, sd = 5), 1),
  attendance = round(rnorm(48, mean = 95, sd = 3), 1)
)

# Dataset 3: Product inventory across locations
inventory_dt <- data.table(
  location = rep(c("North", "South", "East", "West"), each = 3),
  product = rep(c("Widget", "Gadget", "Tool"), 4),
  stock_2022_Q1 = round(rnorm(12, 100, 20)),
  stock_2022_Q2 = round(rnorm(12, 110, 20)),
  stock_2023_Q1 = round(rnorm(12, 105, 20)),
  stock_2023_Q2 = round(rnorm(12, 115, 20))
)

#################################################
# Exercise 1: Hierarchical Reshaping
#################################################
# Task: Using transactions_dt:
# 1. Create a wide format showing total amount spent by each customer
#    for each combination of main and sub category
# 2. Column names should be in format: main_sub
# 
# Expected output columns: customer_id, Electronics_Phones, Electronics_Laptops, 
#                         Food_Groceries, Food_Restaurant
# 
# Hint: Use paste0() within dcast formula

# Your code here:
dcast(transactions_dt,
      customer_id ~ paste0(category_main, "_", category_sub),
      value.var = "amount",
      fun.aggregate = sum)

#################################################
# Exercise 2: Time Series Reshaping with Multiple Metrics
#################################################
# Task: Using performance_dt:
# 1. Create a quarter column based on months
# 2. Calculate average metrics per employee per quarter-year
# 3. Reshape to show each metric as columns with quarter-year suffix
#
# Expected output format: employee_id, productivity_Q1_2022, quality_Q1_2022, 
#                        attendance_Q1_2022, productivity_Q2_2022, etc.
#
# Hint: You may need multiple steps and multiple reshaping operations

# Your code here:
# Step 1: Create quarter column more comprehensively
performance_dt[,
               ':='(quarter = fcase(
                 month %in% c("Jan", "Feb", "Mar"), "Q1",
                 month %in% c("Apr", "May", "Jun"), "Q2",
                 month %in% c("Jul", "Aug", "Sep"), "Q3",
                 month %in% c("Oct", "Nov", "Dec"), "Q4"
               ))]

# Step 2: Melt the metrics
melted_dt <- melt(performance_dt, 
                  id.vars = c("employee_id", "year", "quarter", "month"),
                  measure.vars = c("productivity", "quality", "attendance"))

# Step 3: Calculate quarterly averages and reshape
dcast(melted_dt,
      employee_id ~ paste0(variable, "_", quarter, "_", year),
      fun.aggregate = mean,
      value.var = "value")
#################################################
# Exercise 3: Complex Pattern-Based Reshaping
#################################################
# Task: Using inventory_dt:
# 1. Melt the stock columns into year, quarter, and value columns
# 2. Calculate year-over-year growth for each location-product combination
# 3. Reshape final result to show growth by quarters as columns
#
# Expected output: location, product, Q1_growth, Q2_growth
#
# Hint: Use patterns in melt and handle the split of year/quarter carefully

# Your code here:
# Step 1: Melt the stock columns to long format
inventory_long <- melt(
  inventory_dt,
  id.vars = c("location", "product"),
  measure.vars = patterns("stock_"),
  variable.name = "period",
  value.name = "stock"
)

# Step 2: Split period into year and quarter
inventory_long[, c("year", "quarter") := tstrsplit(gsub("stock_", "", period), "_")]

# Step 3: Calculate year-over-year growth
growth_dt <- inventory_long[order(location, product, quarter, year)
][, growth := ((stock / shift(stock) - 1) * 100),
  by = .(location, product, quarter)
][!is.na(growth)]

# Step 4: Reshape to show quarters as columns
dcast(growth_dt,
      location + product ~ quarter,
      value.var = "growth")

#################################################
# Exercise 4: Multi-Level Aggregation with Reshaping
#################################################
# Task: Using transactions_dt:
# 1. Create summary statistics (mean, median, count) for amounts
# 2. Calculate these stats at both main category and sub-category levels
# 3. Reshape the result to show statistics as columns
#
# Expected output should show statistics for both aggregation levels in a single table
#
# Hint: You might need multiple aggregation steps and careful reshaping

# Step 1: Your aggregations are good
agg_main <- transactions_dt[, .(mean = mean(amount), 
                                median = median(amount), 
                                count = .N), 
                            by = category_main]

agg_sub <- transactions_dt[, .(mean = mean(amount), 
                               median = median(amount), 
                               count = .N), 
                           by = .(category_main, category_sub)]

# Step 2: Adding level indicators is good
agg_main[, level := "main"]
agg_sub[, level := "sub"]

# Step 3: Combine tables first
combined_stats <- rbindlist(list(agg_main, agg_sub), fill = TRUE)

# Step 4: Now reshape if needed to get statistics as columns
# If you want to reshape, it would be something like:
result <- dcast(combined_stats, 
                category_main + category_sub + level ~ ., 
                value.var = c("mean", "median", "count"))

#################################################
# Exercise 5: Rolling Time Window with Reshaping
#################################################
# Task: Using performance_dt:
# 1. Calculate 3-month rolling averages for each metric
# 2. Reshape to show metrics as columns with both current and rolling values
# 3. Format the result to show percentage differences
#
# Expected output: Should show current values, rolling averages, and percentage differences
#                 for each metric in separate columns
#
# Hint: Use shift() and rolling calculations before reshaping

# Your code here:


#################################################
# Bonus Challenge: Combined Operations
#################################################
# Task: Create a comprehensive analysis using transactions_dt:
# 1. Calculate daily totals by payment method and main category
# 2. Create rolling 3-day averages
# 3. Reshape to show payment methods as columns
# 4. Calculate percentage of total daily sales for each payment method
#
# Hint: This will require combining several of the techniques from above exercises

# Your code here:












