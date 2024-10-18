# Advanced R data.table Exercises (No Joins)
# Dataset: flight14.csv

# Load required library and data
library(data.table)
dt <- fread("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv")

# Exercise 1: Complex filtering
# Find all flights that departed between 6 AM and 10 AM, had a distance greater than 1000 miles,
# and arrived less than 30 minutes late
str(dt)
dt[(hour > 6 & hour < 10) & distance > 1000 & arr_delay < 30
   , ]


# Exercise 2: Conditional update
# For all flights with a distance greater than 1000 miles, 
# add a 'long_flight_bonus' column with a value of 10 if the flight was on time (arr_delay <= 0),
# and 5 otherwise
dt[distance > 1000, 
   c("long_flight_bonus") := .(ifelse(arr_delay <= 0, 10, 5))]


# Exercise 3: Rolling statistics
# Calculate a 7-day rolling average of departure delays for each origin
dt[,
   ':=' (week = as.integer(day/7))][, ':=' (mean_week_dep_delay = mean(dep_delay)), by = week]



# Exercise 4: Reshaping data
# Create a summary table with carriers as columns and origins as rows, 
# showing the average departure delay for each combination



# Exercise 5: Advanced grouping
# For each origin-destination pair, calculate the percentage of delayed flights
# (considering a flight delayed if arr_delay > 15)


# Exercise 6: Cumulative statistics
# For each carrier, calculate the cumulative sum of flight distances over the year,
# ordered by date


# Exercise 7: Conditional aggregation
# Calculate the number of flights and average delay for each carrier,
# but only consider flights with positive delays (both departure and arrival)


# Exercise 8: Time-based operations
# Assuming the 'date' column exists (if not, create it first),
# find the busiest day (most flights) for each month


# Exercise 9: Advanced sorting
# Sort the flights first by origin, then by descending total delay (dep_delay + arr_delay),
# and finally by ascending flight number


# Exercise 10: Complex transformation
# Create a 'delay_category' column based on total delay (dep_delay + arr_delay):
# 'Early' if < 0, 'On Time' if 0-15, 'Slight Delay' if 16-60, 'Long Delay' if > 60
# Then, calculate the percentage of flights in each category for each carrier

# Good luck with your advanced exercises!