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
#    - It can be more efficient than other methods, especially for large datasets.
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
#   - Be careful when using `which.max()` or `which.min()` if there might be NA values. 
#     These functions don't handle NA values by default.
#   - If you need to handle NA values, you might use `which(x == max(x, na.rm = TRUE))` instead of `which.max(x)`.
# 
# Understanding the use of `which()` with `.SD` allows you to perform powerful row selections within groups in data.table operations. It's particularly useful when you need to select rows based on certain conditions while still retaining all the columns in your result.




# R data.table Exercises Focusing on which() with .SD
# Dataset: flight14.csv

# Load required library and data
library(data.table)
dt <- fread("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv")


# Exercise 8: Combining which() and aggregation
# For each month, find the carrier with the highest average dep_delay
dt[,
   .SD[which.max(mean(dep_delay))],
       by = .(month)]

# Exercise 9: Using which() for data quality checks
# For each carrier, find any flights where the air_time is greater than the time difference
# between arr_time and dep_time (you may need to calculate this difference first)

dt[, diff := arr_time - dep_delay]
dt[,
   .SD[which(air_time < diff)],
   by = carrier]

# Exercise 10: Advanced which() usage
# For each origin-carrier combination, find the flight with dep_delay closest to 
# the median dep_delay for that groupq


# Exercise 8: Conditional Selection with Multiple Criteria
# For each month, find the flight that had:
# - The highest ratio of actual flight time to scheduled flight time 
# - But only consider flights where distance > 500 miles
# - And arr_delay was less than 30 minutes
# Write your solution here:


# Exercise 9: Rolling Maximum with Groups
# For each carrier-origin combination, find flights where:
# - The dep_delay was higher than all previous flights that day
# - Return only flights that set a new "record" for delays
# Write your solution here:


# Exercise 10: Comparative Analysis
# For each origin-destination pair:
# - Find the flight with the highest positive difference between its air_time 
# - and the mean air_time for that route
# - Only consider routes with at least 10 flights
# Write your solution here:


# Exercise 11: Time-based Analysis with Multiple Conditions
# For each carrier in summer months (6,7,8):
# - Find the flight that had the highest combined score
# - Score = (100 - dep_delay) + (distance/100)
# - Only consider flights that departed before noon
# Write your solution here:


# Exercise 12: Relative Performance
# For each origin:
# - Find the flight with the largest positive difference between its speed
# - and the median speed of all flights from that origin that day
# - Speed = distance/air_time
# Write your solution here:


# Exercise 13: Complex Grouping with Conditions
# For each carrier-month combination:
# - Find the flight with the highest "efficiency score"
# - Efficiency = (distance/air_time) * (1 - dep_delay/100)
# - Only consider flights where:
#   * distance > 300
#   * dep_delay between 0 and 30
#   * arr_delay < 45
# Write your solution here:


# Exercise 14: Multi-metric Optimization
# For each origin-destination pair:
# - Find the flight with the best overall performance score
# - Performance = (100 - dep_delay) * 0.4 + 
#                 (100 - arr_delay) * 0.4 + 
#                 (distance/air_time) * 0.2
# - Only consider flights that operated on weekends
# Write your solution here:


# Exercise 15: Sequential Analysis
# For each carrier:
# - Find flights that had better performance in all metrics
# - compared to their previous flight that day
# - Metrics: dep_delay, arr_delay, and air_time
# Write your solution here:

