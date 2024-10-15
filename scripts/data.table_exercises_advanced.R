# Advanced R data.table Exercises
# Dataset: flight14.csv

# Load required library and data
library(data.table)
flights <- fread("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv")

# Exercise 1: Using :=
# Add a new column 'is_delayed' that is TRUE if dep_delay > 15, FALSE otherwise


# Exercise 2: Multiple := operations
# In a single operation, add two new columns:
# 'total_delay': sum of dep_delay and arr_delay
# 'speed_mph': distance / air_time * 60


# Exercise 3: :=  with by
# For each origin, calculate and add a new column 'avg_delay_at_origin'
# containing the average departure delay for that origin


# Exercise 4: Setting a key
# Set 'origin' and 'dest' as the key for the flights data.table


# Exercise 5: Using a key for fast subsets
# Using the key set in Exercise 4, quickly subset all flights from JFK to LAX


# Exercise 6: Sorting with key
# Sort the flights first by origin, then by destination, using the key


# Exercise 7: Adding a secondary index
# Add a secondary index on the 'carrier' column


# Exercise 8: Using a secondary index
# Use the secondary index to quickly subset all flights by carrier "AA"


# Exercise 9: Combining operations
# For each carrier, find the flight with the longest air time,
# and return the carrier, origin, dest, and air_time columns


# Exercise 10: Advanced join and update
# Assume you have a data.table 'carrier_delays' with average delays per carrier
# Join this with flights and add a column 'delay_diff' showing how each flight's
# delay compares to the carrier's average
# (You'll need to create carrier_delays first)

# Good luck with your advanced exercises!