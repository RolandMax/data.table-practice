# Data.table copy() Function Practice Exercises
# These exercises help understand when and why to use copy() 
# to avoid unintended data modifications

# Load required package
library(data.table)

# Create sample data.table for exercises
dt <- data.table(
  id = 1:5,
  name = c("Alice", "Bob", "Charlie", "David", "Eve"),
  score = c(85, 92, 78, 95, 88),
  grade = c("B", "A", "C", "A", "B")
)

#################################################
# Exercise 1: Understanding Reference Semantics
#################################################
# Task: Create a new variable dt2 that references dt
# Then modify the score of the first student in dt2
# Check both dt and dt2 - what do you observe?

# Your code here:
dt2 <- dt
dt2[1, score := 70]
print(dt)     # Will show score = 70 for first row
print(dt2)    # Will also show score = 70 for first row
# Both changed because they reference same data


#################################################
# Exercise 2: Using copy()
#################################################
# Task: Repeat Exercise 1, but this time create dt2 using 
# the copy() function. Modify the score in dt2 and compare
# both data.tables

# Your code here:
dt2 <- copy(dt)
dt2[1, score := 70]
print(dt)     # Will show score = 70 for first row
print(dt2)    # Will also show score = 70 for first row




#################################################
# Exercise 3: Working with Subsets
#################################################
# Task: Create a new data.table high_scorers that contains
# only students with scores above 90
# Try it both with and without copy()
# What happens when you modify the grades in high_scorers?

# Your code here:
high_scorers <- 
  dt[score > 90]

high_scorers[id ==2, grade := "C"] 
print(high_scorers)
print(dt)

high_scorers <- 
  copy(dt[score > 90])
high_scorers[id ==2, grade := "C"] 
print(high_scorers)
print(dt)




#################################################
# Exercise 4: Chains of References
#################################################
# Task: Create the following chain:
# 1. Create dt2 as a reference to dt
# 2. Create dt3 as a copy of dt2
# 3. Create dt4 as a reference to dt3
# Modify values in each data.table and track the changes

# Your code here:
dt2 <- dt
dt3 <- copy(dt2)
dt4 <- dt3

dt[name == "Charlie", grade := "A"]
print(dt)
print(dt2)
dt2[name == "Eve", grade := "DD"]
print(dt2)
print(dt3)
dt3[name == "David", grade := "FAIL"]
print(dt4)

#################################################
# Exercise 5: Column Operations
#################################################
# Task: Create a new data.table dt_new by copying dt
# Add a new column 'status' based on the score:
# - If score ≥ 90: "Excellent"
# - If score ≥ 80: "Good"
# - Otherwise: "Need Improvement"
# Do this with and without copy()

# Your code here:




#################################################
# Exercise 6: Conditional Copy
#################################################
# Task: Write code that copies the data.table only if 
# certain conditions are met:
# - Copy if there are any 'A' grades
# - Don't copy if all scores are below 90

# Your code here:




#################################################
# Exercise 7: Memory Impact
#################################################
# Task: Create a larger data.table with 100,000 rows
# Experiment with copying versus referencing this data.table

# Create large data.table
n <- 100000
large_dt <- data.table(
  id = 1:n,
  value1 = rnorm(n),
  value2 = sample(letters, n, replace = TRUE),
  value3 = sample(1:100, n, replace = TRUE)
)

# Your code here:




#################################################
# Exercise 8: Function Arguments
#################################################
# Task: Create a function that takes a data.table as input
# and modifies some values. Test the function:
# 1. First without using copy()
# 2. Then with copy()

# Your code here:




#################################################
# Bonus Challenge
#################################################
# Task: Create a scenario where:
# 1. You have multiple data.tables referencing each other
# 2. Some need to be copied and others don't
# 3. You need to make specific modifications to each
# 4. The changes should only affect certain data.tables

# Your code here:




# End of exercises
# Remember to check your data.tables after each modification!