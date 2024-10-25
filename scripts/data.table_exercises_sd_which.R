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


# Data.table Advanced Exercises and Solutions
# Note: Assuming 'dt' is your flights data.table

#-----------------------------------------------------------------------------
# Exercise 1: Finding carrier with highest average departure delay by month
#-----------------------------------------------------------------------------
# Task: For each month, find the carrier with the highest average dep_delay

# Solution:
dt[, .(avg_delay = mean(dep_delay)), by = .(month, carrier)
][, .SD[which.max(avg_delay)], by = month]

#-----------------------------------------------------------------------------
# Exercise 2: Data quality check for flight times
#-----------------------------------------------------------------------------
# Task: For each carrier, find flights where the air_time is greater than 
# the time difference between arr_time and dep_time

# Solution:
dt[, {
  # Calculate actual time difference accounting for midnight crossing
  time_diff = ifelse(arr_time < dep_time,
                     arr_time + 2400 - dep_time,
                     arr_time - dep_time)
  .SD[which(air_time > time_diff)]
}, by = carrier]

#-----------------------------------------------------------------------------
# Exercise 3: Finding flights closest to median delay
#-----------------------------------------------------------------------------
# Task: For each origin-carrier combination, find the flight with dep_delay 
# closest to the median dep_delay for that group

# Solution:
dt[, {
  med = median(dep_delay)
  .SD[which.min(abs(dep_delay - med))]
}, by = .(origin, carrier)]

#-----------------------------------------------------------------------------
# Exercise 4: Complex flight time ratio analysis
#-----------------------------------------------------------------------------
# Task: For each month, find the flight that had:
# - The highest ratio of actual flight time to scheduled flight time 
# - Only consider flights where distance > 500 miles
# - And arr_delay was less than 30 minutes

# Solution:
dt[distance > 500 & arr_delay < 30, {
  # Calculate scheduled flight time from actual and delays
  sched_time = air_time - arr_delay + dep_delay
  .SD[which.max(air_time/sched_time)]
}, by = month]

#-----------------------------------------------------------------------------
# Exercise 5: Rolling maximum delays
#-----------------------------------------------------------------------------
# Task: For each carrier-origin combination, find flights where:
# - The dep_delay was higher than all previous flights that day
# - Return only flights that set a new "record" for delays

# Solution:
dt[order(carrier, origin, dep_time),
   .SD[which(dep_delay == cummax(dep_delay))],
   by = .(carrier, 
          origin, 
          date = as.Date(paste(year, month, day, sep = "-")))]

#-----------------------------------------------------------------------------
# Exercise 6: Route performance analysis
#-----------------------------------------------------------------------------
# Task: For each origin-destination pair with at least 20 flights:
# - Find flights that exceeded the route's average air_time by more than 30 minutes
# - Calculate what percentile this flight's air_time was for the route

# Solution:
dt[, .SD[{
  # Only process routes with sufficient flights
  if (.N >= 20) {
    avg_time = mean(air_time)
    exceeded = which(air_time > (avg_time + 30))
    if (length(exceeded) > 0) {
      # Calculate percentile for these flights
      .SD[exceeded][, percentile := rank(air_time)/.N * 100]
    }
  }
}], by = .(origin, dest)]

#-----------------------------------------------------------------------------
# Exercise 7: Efficiency score calculation
#-----------------------------------------------------------------------------
# Task: For each carrier-month combination:
# - Calculate an efficiency score: (distance/air_time) * (1 - dep_delay/100)
# - Find the top 3 most efficient flights
# - Only consider flights with positive delays less than 60 minutes

# Solution:
dt[dep_delay > 0 & dep_delay < 60, {
  eff_score = (distance/air_time) * (1 - dep_delay/100)
  .SD[order(-eff_score)[1:3]]
}, by = .(carrier, month)]

# Note: All solutions assume appropriate data types and no missing values.
# In practice, you might need additional data validation and error handling.


# Exercise 10: Comparative Analysis
# For each origin-destination pair:
# - Find the flight with the highest positive difference between its air_time 
# - and the mean air_time for that route
# - Only consider routes with at least 10 flights
# Write your solution here:

# Calculate group sizes
dt[, ':='(n = .N), by = .(origin, dest)]

# Filter and calculate mean for groups with n >= 10
dt[n >= 10, ':='(mean_air_time = mean(air_time)), by = .(origin, dest)]

# Calculate difference from mean
dt[n >= 10, ':='(diff_air_time = air_time - mean_air_time), by = .(origin, dest)]

dt[, .SD[which.max(diff_air_time)], by = .(origin, dest)]


# Exercise 11: Time-based Analysis with Multiple Conditions
# For each carrier in summer months (6,7,8):
# - Find the flight that had the highest combined score
# - Score = (100 - dep_delay) + (distance/100)
# - Only consider flights that departed before noon
# Write your solution here:

dt[month %in% c(6,7,8) & hour < 12]

dt[, ':='(score = (100 - dep_delay) + (distance/100)), by = carrier]

dt[, .SD[which.max(score)], by = carrier]


# Exercise 12: Relative Performance
# For each origin:
# - Find the flight with the largest positive difference between its speed
# - and the median speed of all flights from that origin that day
# - Speed = distance/air_time
# Write your solution here:

str(dt)

dt[, {speed = distance/air_time
      median_speed = median(speed)
      .SD[which.max(speed - median_speed)]},
   by = .(origin, date = as.Date(paste(year, month, day, sep = "-")))]



# Exercise 13: Complex Grouping with Conditions
# For each carrier-month combination:
# - Find the flight with the highest "efficiency score"
# - Efficiency = (distance/air_time) * (1 - dep_delay/100)
# - Only consider flights where:
#   * distance > 300
#   * dep_delay between 0 and 30
#   * arr_delay < 45
# Write your solution here:

str(dt)

efficiency <- function(distance, air_time, dep_delay){
  x <- (distance/air_time) * (1 - dep_delay/100)
  return(x)
}

dt[distance > 300 & between(dep_delay, 0, 30) & arr_delay < 45,
   .SD[which.max(efficiency(distance, air_time, dep_delay))],
   by = .(carrier, month)]

# Exercise 14: Multi-metric Optimization
# For each origin-destination pair:
# - Find the flight with the best overall performance score
# - Performance = (100 - dep_delay) * 0.4 + 
#                 (100 - arr_delay) * 0.4 + 
#                 (distance/air_time) * 0.2
# - Only consider flights that operated on weekends
# Write your solution here:
unique(dt$day)
str(dt)

performance_score <- function(dep_delay, arr_delay, distance, air_time){
  x <- (100 - dep_delay) * 0.4 + 
       (100 - arr_delay) * 0.4 +
       (distance/air_time) * 0.2
  return(x)
}


dt[, c("date") := .(as.Date(paste(year, month, day, sep = "-")))
   ][,
     "weekdays" := .(weekdays(date, abbr = TRUE))]

dt[weekdays %in% c("Sa", "Sun"),
   .SD[which.max(performance_score(dep_delay, arr_delay, distance, air_time))],
   by = .(origin, dest)]

# Exercise 15: Sequential Analysis
# For each carrier:
# - Find flights that had better performance in all metrics
# - compared to their previous flight that day
# - Metrics: dep_delay, arr_delay, and air_time
# Write your solution here:

dt[order(carrier, date),
   .SD[which(
     dep_delay < shift(dep_delay, 1) &
     arr_delay < shift(arr_delay, 1) &
     air_time < shift(air_time, 1))],
   by = .(carrier, date)
   ]
