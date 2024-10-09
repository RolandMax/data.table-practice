# R data.table Exercises for Beginners
# Dataset: flight14.csv

# Load the required library and data
library(data.table)
flights <- fread("flight14.csv")

# Exercise 1: Basic data exploration
# Display the first 5 rows of the dataset


# Exercise 2: Column selection
# Select only the "year", "month", "day", "carrier", and "distance" columns


# Exercise 3: Filtering
# Find all flights with a distance greater than 1000 miles


# Exercise 4: Sorting
# Sort the flights by distance in descending order


# Exercise 5: Aggregation
# Calculate the average departure delay for each carrier


# Exercise 6: Multiple operations
# Find the total number of flights and average arrival delay for each origin airport


# Exercise 7: Date manipulation
# Create a new column called "date" by combining year, month, and day


# Exercise 8: Advanced filtering
# Find all flights that departed between 6 AM and 10 AM (inclusive)


# Exercise 9: Window functions
# For each carrier, find the flight with the longest distance


# Exercise 10: Join operations
# Assuming you have another data.table called 'airports' with columns 'iata' and 'city',
# join it with the flights data to add the origin city name to each flight
# (Note: You'll need to create the airports data.table first)

# Good luck with your exercises!