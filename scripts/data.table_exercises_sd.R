# R data.table Exercises Focusing on .SD
# Dataset: flight14.csv

# Load required library and data
library(data.table)
dt <- fread("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv")

# Exercise 1: Basic .SD usage
# For each origin, calculate the average of all numeric columns
dt[,
   lapply(.SD, mean), .SDcols = (is.numeric)]

# Exercise 2: .SD with custom function
# Create a function that calculates the coefficient of variation (CV = sd / mean)
# Use this function with .SD to calculate the CV of distance and air_time for each carrier
cv <- function(x){
  cv <- sd(x)/mean(x)
  return(cv)
}

dt[,
   lapply(.SD, cv), 
   .SDcols = c("air_time", "distance")]


# Exercise 3: .SD with conditional logic
# For each month, find the flight with the longest air_time, but only consider
# flights with a distance greater than 1000 miles

dt[distance > 1000, .SD[which.max(air_time)], by = month]


# Exercise 4: Using .SD.cols
# Calculate the sum of dep_delay and arr_delay for each origin-dest pair

dt[,
   lapply(.SD, sum),
   by = .(origin, dest),
   .SDcols = c("arr_delay", "dep_delay")]

# Exercise 5: Nested .SD operations
# For each origin, find the carrier with the highest average dep_delay

dt2 <- dt[,
   lapply(.SD, mean),
   by = .(origin, carrier),
   .SDcols = c("dep_delay")]

dt2[,
   lapply(.SD, max),
   by = .(origin, carrier),
   .SDcols = c("dep_delay")]

dt[, .SD[which.max(mean(dep_delay))], by = origin, .SDcols = c("carrier", "dep_delay")]

# Exercise 6: .SD with multiple operations
# For each day of the week (assuming you create this column first),
# calculate the minimum, maximum, and average of dep_delay and arr_delay

# 1: 1,8,15,22,29
# 2: 2,9,16,23,30
# 3: 3,10,17,24,31
# 4: 4,11,18,25
# 5: 5,12,19,26
# 6: 6,13,20,27
# 7: 7,14,21,28
dt[,
    ':='(weekday = 
           fcase(day %in% c(1,8,15,22,29), 1,
                 day %in% c(2,9,16,23,30), 2,
                 day %in% c(3,10,17,24,31), 3,
                 day %in% c(4,11,18,25), 4,
                 day %in% c(5,12,19,26), 5,
                 day %in% c(6,13,20,27), 6,
                 day %in% c(7,14,21,28), 7)
                 )]

multiple_func <- function(dt) {
  dt[, c("min_delay", "min_arr_delay") := lapply(.SD, min), by = weekday, .SDcols = c("dep_delay", "arr_delay")]
  dt[, c("max_delay", "max_arr_delay") := lapply(.SD, max), by = weekday, .SDcols = c("dep_delay", "arr_delay")]
  dt[, c("mean_delay", "mean_arr_delay") := lapply(.SD, mean), by = weekday, .SDcols = c("dep_delay", "arr_delay")]
}  

multiple_func(dt)

# or 

dt[, lapply(.SD, function(x) list(min = min(x), max = max(x), avg = mean(x))), 
   by = weekday, .SDcols = c("dep_delay", "arr_delay")]


# Exercise 7: Using .SD for data quality checks
# For each carrier, identify any flights where the air_time is greater than
# the time difference between dep_time and arr_time

# there are no variables dep_time and arr_time!


# Exercise 8: Advanced grouping with .SD
# For each origin-carrier combination, find the flight with the highest
# ratio of distance to air_time (i.e., the fastest flight)

max_air_time <- function(dt){
  dt[, flight_speed := .(distance/airtime)]
  dt[, max_speed := max(flight_speed)]
}

dt[,
   lapply(.SD, max_air_time),
   by = .(origin, carrier),
   .SDcols = c("distance", "air_time")]

dt[, .SD[which.max(distance/air_time)], by = .(origin, carrier)]

# Exercise 9: Time-based analysis with .SD
# Assuming you've added a date column, for each month, calculate a 7-day
# rolling average of dep_delay for each origin

dt[order(year, month, day), 
   .(rolling_avg = frollmean(dep_delay, 7)), 
   by = .(origin, month)]

# Exercise 10: Complex transformation with .SD
# For each carrier, calculate the percentage of flights that fall into
# these categories: early (arr_delay < 0), on-time (-15 <= arr_delay <= 15),
# slightly late (15 < arr_delay <= 60), very late (arr_delay > 60)

dt[, .(
  early = sum(arr_delay < 0) / .N * 100,
  on_time = sum(arr_delay >= -15 & arr_delay <= 15) / .N * 100,
  slightly_late = sum(arr_delay > 15 & arr_delay <= 60) / .N * 100,
  very_late = sum(arr_delay > 60) / .N * 100
), by = carrier]


# Good luck with your .SD exercises!