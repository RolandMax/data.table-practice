# 
# 1. Basic concept:
#    - `which()` returns the indices of TRUE elements in a logical vector.
#    - When used with `.SD`, it helps select specific rows within each group.
# 
# 2. Common pattern:
#    `.SD[which.max(...)]` or `.SD[which.min(...)]`
# 
# 3. Examples:
# 
# Example 1: Finding the row with the maximum value in a column for each group
# ```r
# dt[, .SD[which.max(air_time)], by = carrier]
# ```
# This returns the entire row (all columns in .SD) for the flight with the longest air_time for each carrier.
# 
# Example 2: Finding the row with the minimum value in a column for each group
# ```r
# dt[, .SD[which.min(dep_delay)], by = origin]
# ```
# This returns the entire row for the flight with the shortest departure delay for each origin.
# 
# Example 3: Using which() with a condition
# ```r
# dt[, .SD[which(distance > 1000)], by = carrier]
# ```
# This returns all rows where the distance is greater than 1000 for each carrier.
# 
# 4. Why use `which()` with `.SD`?
#    - It allows you to select entire rows based on column conditions.
#    - It's particularly useful when you want to return multiple columns for the selected row(s).
# - It can be more efficient than other methods, especially for large datasets.
# 
# 5. Advanced usage:
#   You can combine `which()` with other functions for more complex selections:
#   
#   ```r
# # Select the top 3 longest flights for each carrier
# dt[, .SD[order(-air_time)][1:3], by = carrier]
# 
# # Select flights with above-average distance for each origin
# dt[, .SD[which(distance > mean(distance))], by = origin]
# ```
# 
# 6. Caution:
#   - Be careful when using `which.max()` or `which.min()` if there might be NA values. These functions don't handle NA values by default.
#    - If you need to handle NA values, you might use `which(x == max(x, na.rm = TRUE))` instead of `which.max(x)`.
# 
# Understanding the use of `which()` with `.SD` allows you to perform powerful row selections within groups in data.table operations. It's particularly useful when you need to select rows based on certain conditions while still retaining all the columns in your result.




# R data.table Exercises Focusing on which() with .SD
# Dataset: flight14.csv

# Load required library and data
library(data.table)
flights <- fread("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv")

# Exercise 1: Basic which.max()
# For each origin, find the flight with the longest air_time


# Exercise 2: Basic which.min()
# For each carrier, find the flight with the shortest dep_delay


# Exercise 3: which() with a condition
# For each day in January, find the flight with the highest speed (distance / air_time) 
# among flights with distance > 1000 miles


# Exercise 4: Multiple column selection
# For each origin-dest pair, find the flight with the highest total delay (dep_delay + arr_delay)
# Return only the date, flight, carrier, and total delay columns


# Exercise 5: Top N selection
# For each carrier, find the top 3 flights with the longest air_time
# Hint: You'll need to combine which() with order()


# Exercise 6: Conditional which()
# For each origin, find the flight with the highest dep_delay, but only consider flights 
# where dep_delay is less than 60 minutes


# Exercise 7: which() with calculated fields
# For each carrier, find the flight with the highest ratio of arr_delay to dep_delay
# (Only consider flights where both delays are positive)


# Exercise 8: Combining which() and aggregation
# For each month, find the carrier with the highest average dep_delay


# Exercise 9: Using which() for data quality checks
# For each carrier, find any flights where the air_time is greater than the time difference
# between arr_time and dep_time (you may need to calculate this difference first)


# Exercise 10: Advanced which() usage
# For each origin-carrier combination, find the flight with dep_delay closest to 
# the median dep_delay for that group

# Good luck with your which() and .SD exercises!