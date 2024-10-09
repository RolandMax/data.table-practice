# R data.table Exercises for Beginners
# Dataset: flight14.csv

# Load the required library and data
library(data.table)
dt <- fread("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv")

# Exercise 1: Basic data exploration
# Display the first 5 rows of the dataset
dt[1:5,]

# Exercise 2: Column selection
# Select only the "year", "month", "day", "carrier", and "distance" columns
head(dt[ ,
    .(
      year, month, day, carrier, distance
    )])

# Exercise 3: Filtering
# Find all flights with a distance greater than 1000 miles
dt[distance > 1000]

# Exercise 4: Sorting
# Sort the flights by distance in descending order
dt[order(-distance)]

# Exercise 5: Aggregation
# Calculate the average departure delay for each carrier
dt[, .(
  m_delay = mean(dep_delay)
), 
by = carrier]

# Exercise 6: Multiple operations
# Find the total number of flights and average arrival delay for each origin airport
str(dt)
dt[,
   .(
     total_flights = .N,
     mean_arr_delay = mean(arr_delay)
   ),
   by = origin]

# Exercise 7: Date manipulation
# Create a new column called "date" by combining year, month, and day
dt[, date := paste(year, month, day, sep = "_")]
dt

# Exercise 8: Advanced filtering
# Find all flights that departed between 6 AM and 10 AM (inclusive)
dt[hour > 6 & hour <= 10]

# Exercise 9: Window functions
# For each carrier, find the flight with the longest distance
dt[dt[, .I[which.max(distance)], by = carrier]$V1]   
  
>>>>>>> first_steps
# Exercise 10: Join operations
# Assuming you have another data.table called 'airports' with columns 'iata' and 'city',
# join it with the flights data to add the origin city name to each flight
# (Note: You'll need to create the airports data.table first)
<<<<<<< HEAD
=======
airports <- data.table(iata = c("JFK", "LGA", "EWR"),
                       city = c("New York", "New York", "New York"))

dt[airports, on = .(origin = iata)]
>>>>>>> first_steps

# Good luck with your exercises!