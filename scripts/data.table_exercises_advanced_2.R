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
dt[order(year, month, day), 
   rolling_avg := frollmean(dep_delay, 7), 
   by = .(origin)]


# Exercise 4: Reshaping data
# Create a summary table with carriers as columns and origins as rows, 
# showing the average departure delay for each combination
dcast(dt, origin ~ carrier, value.var = "dep_delay", fun.aggregate = mean)

# Exercise 5: Advanced grouping
# For each origin-destination pair, calculate the percentage of delayed flights
# (considering a flight delayed if arr_delay > 15)
dt[, 
   .(
     perc_delayed = round(sum(ifelse(arr_delay > 15, 1, 0))/.N * 100, 2)
     ),
   by = .(origin, dest)]
#
# Exercise 6: Cumulative statistics
# For each carrier, calculate the cumulative sum of flight distances over the year,
# ordered by date
dt[order(year, month, day), 
   .(cum_sum = cumsum(distance)), 
   by = .(carrier)]

# Exercise 7: Conditional aggregation
# Calculate the number of flights and average delay for each carrier,
# but only consider flights with positive delays (both departure and arrival)
dt[
  arr_delay > 0 | dep_delay > 0,
   .(
     num_flights = .N,
     m_total_del = mean(dep_delay) + mean(arr_delay)
   ),
   by = .(carrier)]


# Exercise 8: Time-based operations
# Assuming the 'date' column exists (if not, create it first),
# find the busiest day (most flights) for each month
dt[,
   .(total_flights_day = .N),
   by = .(day, month)
   ][,
     .(
       day,
       total_flights_day,
       max_flights_day_month = max(total_flights_day)
       ),
     by = .(month)
   ][
     total_flights_day == max_flights_day_month,
     .(day, month, total_flights_day)
   ]

dt[, .SD[which.max(.N), .(month, day, flights = .N)], by = month]


# Exercise 9: Advanced sorting
# Sort the flights first by origin, then by descending total delay (dep_delay + arr_delay),
# and finally by ascending flight number
dt[order(origin), 
   "total_delay" := dep_delay + arr_delay][
     order(total_delay, carrier)
   ]

# better
dt[order(origin, -total_delay, flight)]


# Exercise 10: Complex transformation
# Create a 'delay_category' column based on total delay (dep_delay + arr_delay):
# 'Early' if < 0, 'On Time' if 0-15, 'Slight Delay' if 16-60, 'Long Delay' if > 60
# Then, calculate the percentage of flights in each category for each carrier

dt[,
   "delay_category" := ifelse(total_delay < 0, "Early",
                              ifelse(total_delay > 0 & total_delay < 15, "Slight Delay",
                                     ifelse(total_delay > 16 & total_delay < 60, "Slight Delay",
                                            ifelse(total_delay > 60, "Long Delay", NA
                                                   ))))
][,
  .(n_carrier_delay_category = .N),
  by = .(carrier, delay_category)
][,
  .(delay_category,
    n_carrier_delay_category,
    n_flights_carrier = sum(n_carrier_delay_category)),
  by = .(carrier)
][,
  .(carrier,
    delay_category,
    n_carrier_delay_category,
    perc_carrier_delay_category = round(n_carrier_delay_category/n_flights_carrier * 100, 2)
    )]


# better

dt[, delay_category := fcase(
  total_delay < 0, "Early",
  total_delay <= 15, "On Time",
  total_delay <= 60, "Slight Delay",
  total_delay > 60, "Long Delay"
)]

dt[, .(
  percentage = .N / nrow(.SD) * 100
), by = .(carrier, delay_category)]


# Good luck with your adNULL# Good luck with your advanced exercises!