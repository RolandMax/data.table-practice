library(data.table)

# Sample data
dt <- data.table(
  group = rep(c("A", "B"), each = 5),
  date = rep(seq(as.Date("2024-01-01"), by = "day", length.out = 5), 2),
  value = c(10, 15, 12, 18, 20, 8, 13, 16, 14, 19)
)

# Basic window functions
# 1. Running sum within groups
dt[, running_sum := cumsum(value), by = group]

# 2. Rolling mean with a 3-day window
dt[, rolling_mean := frollmean(value, n = 3), by = group]

# 3. Lag and lead values
dt[, `:=`(
  prev_value = shift(value, n = 1),
  next_value = shift(value, n = -1)
), by = group]

# 4. Ranking within groups
dt[, `:=`(
  rank_simple = frank(value),                    # Simple ranking
  rank_dense = frank(value, ties.method = "dense"),  # Dense ranking
  rank_percent = frank(value, ties.method = "random") / .N  # Percentile ranking
), by = group]

# 5. Running calculations with offset
dt[, `:=`(
  running_max = cummax(value),
  running_min = cummin(value)
), by = group]

# 6. Window calculations relative to first/last value
dt[, `:=`(
  pct_of_first = value / first(value),
  pct_of_max = value / max(value)
), by = group]

# 7. Rolling window with custom function
dt[, rolling_median := frollapply(value, n = 3, FUN = median), by = group]

# 8. Moving average with varying window
dt[, `:=`(
  ma_2day = frollmean(value, n = 2),
  ma_3day = frollmean(value, n = 3),
  ma_4day = frollmean(value, n = 4)
), by = group]

# 9. Row numbers within groups
dt[, row_num := seq_len(.N), by = group]

# 10. Differences from group statistics
dt[, `:=`(
  diff_from_mean = value - mean(value),
  diff_from_median = value - median(value)
), by = group]

# Print first few rows to show results
print(dt)

# Example usage with filtering based on window calculations
# Get rows where value is above the 3-day moving average
high_performers <- dt[value > rolling_mean]

# Get top 2 values per group
top_by_group <- dt[, .SD[frank(-value, ties.method = "first") <= 2], by = group]


# Window Exercises --------------------------------------------------------

library(data.table)

# Create sample datasets
# Sales dataset
sales_dt <- data.table(
  date = rep(seq(as.Date("2024-01-01"), by = "day", length.out = 10), 2),
  store = rep(c("Store A", "Store B"), each = 10),
  sales = c(100, 150, 120, 180, 200, 160, 140, 190, 210, 170,
            90, 140, 160, 150, 180, 200, 170, 155, 185, 195)
)

# Employee dataset
employee_dt <- data.table(
  emp_id = 1:8,
  department = rep(c("Sales", "IT", "HR", "Marketing"), each = 2),
  salary = c(50000, 55000, 65000, 70000, 45000, 48000, 52000, 54000),
  join_date = as.Date(c("2023-01-15", "2023-03-01", "2023-02-01", 
                        "2023-04-15", "2023-01-01", "2023-05-01",
                        "2023-03-15", "2023-06-01"))
)

# Print the first few rows of each dataset to understand the structure
print("Sales Dataset:")
print(head(sales_dt))
print("\nEmployee Dataset:")
print(head(employee_dt))

# ============ EXERCISES ============

# Exercise 1: Department Salary Analysis
# Task: For each employee, add columns showing:
# - Their department's average salary
# - How much their salary differs from their department's average
# - Their salary as a percentage of their department's average
# Hint: Use mean() within by and keep original rows

employee_dt[,
            ':='(
              avg_dep_salary = mean(salary)
            ), 
            by = department][,
            ':='(
              diff_salary = salary - avg_dep_salary,
              perc_dep_salary = salary/avg_dep_salary * 100
            )
            ]


# Exercise 2: Running Sales Analysis
# Task: For each store's daily sales, add columns showing:
# - Running total of sales (cumulative sum)
# - Running average of sales
# - Running maximum sales achieved
# Hint: Use cumsum(), cumean(), and cummax() with by and order()


sales_dt[order(date),
         ':='(cumsum_dep = cumsum(sales),
              mean_dep =  cumsum(sales)/seq_len(.N),
              cummax_dep = cummax(sales)),
         by = store,
         ]

# Exercise 3: Sales Rankings Over Time
# Task: For each day's sales record, add columns showing:
# - Daily rank among all stores (1 = highest sales that day)
# - Store's rank among its own historical sales
# - Percentile rank of sales within store
# Hint: Use frank() with different by groups

copy(
  sales_dt[,
           ':='(daily_rank_store = frank(-sales)),  # Added minus for highest=1
           by = .(date)
  ][,
    ':='(
      histo_rank_store = frank(-sales),    # Added minus for highest=1
      percentile_rank = frank(sales, ties.method = "random") / .N
    ),
    by = .(store)
  ]
)


# Exercise 4: Previous and Next Day Comparisons
# Task: For each store's daily sales, add columns showing:
# - Previous day's sales
# - Next day's sales
# - Percentage change from previous day
# Hint: Use shift() with different n values
copy(
  sales_dt[order(date),  # Important to order by date first
           ':='(prev_sales = shift(sales, 1),
                next_sales = shift(sales, -1),
                perc_change = ((sales - shift(sales, 1)) / shift(sales, 1)) * 100),
           by = store]  # Added by = store
)


# Exercise 5: Moving Window Calculations
# Task: For each store's sales, add columns showing:
# - 3-day moving average
# - 3-day moving sum
# - 3-day moving maximum
# Hint: Use frollmean(), frollsum(), and frollmax()

copy(
  sales_dt[order(date),
           ':='(
             move_mean = frollmean(sales, 3),
             move_sum = frollsum(sales, 3)
             # move_max = frollmax(sales, 1)
           ),
           by = store]
)

# ============ BONUS CHALLENGES ============

# Challenge 1: Employee Timeline Analysis
# For each employee, add columns showing:
# - Number of people who joined their department before them
# - Average salary of people who joined before them in their department
# - Their salary compared to the department average at their join date
# Hint: Combine order(), shift(), and cumulative calculations

employee_dt[order(join_date),
            ':='()
            ]


# Challenge 2: Sales Performance Windows
# For each store's daily sales, add columns showing:
# - Best sales in the next 3 days
# - Average sales in the previous 3 days
# - Whether current sales are above both these values
# Hint: Combine frollapply() with different alignments

# Challenge 3: Relative Position Analysis
# For each store's daily sales, add columns showing:
# - Relative position between the minimum and maximum sales for that store
# - Whether sales are in the top quartile of all time sales for that store
# - Number of days since last time sales were higher
# Hint: Combine ranking functions with cumulative calculations

# Challenge 4: Moving Statistics
# For each store's daily sales, calculate:
# - Z-score based on previous 5 days' mean and standard deviation
# - Whether current sale is an outlier (> 2 standard deviations from mean)
# - Exponentially weighted moving average (more weight to recent days)
# Hint: Use multiple rolling calculations together

# Challenge 5: Comparative Performance
# For each day and store, add columns showing:
# - Sales ranking among all stores that day
# - Whether store performed above their own historical average
# - Whether store performed above the overall average for all stores that day
# Hint: Combine window functions with different grouping levels







