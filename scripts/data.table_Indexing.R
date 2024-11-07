# Load the data.table library
library(data.table)


# Create a sample data.table
dt <- data.table(
  name = c("John", "Sarah", "Michael", "Emily", "James", "Jessica", "David", "Samantha"),
  age = c(28, 35, 42, 29, 51, 27, 38, 33),
  salary = c(45000, 65000, 72000, 55000, 85000, 48000, 92000, 60000)
)

# Exercise 1
# Use .I to get the row indexes of entries where age is greater than 30 and salary is less than 50000
dt[dt[, .I[which(age < 30)]]]  


# Exercise 2
# Use .I to get the row indexes of the 3 entries with the highest salaries
dt[, .I[which(age < 30)][1:3]]  



# Exercise 3 
# Use .I to get the row indexes of entries where the name starts with 'J' or 'S'
dt[, .I[which(grepl("^J|^S",name))]]  


# Exercise 4
# Create a new column 'is_manager' in 'dt' that is TRUE if the salary is greater than 80000, else FALSE
# Use .I to get the row indexes of entries where is_manager is TRUE
dt[, is_manager := .(salary > 80000)][, .I[which(is_manager == TRUE)]]


# Exercise 5
# Use .I to get the row indexes of the top 20% of entries ordered by salary
dt[, .I[which(salary > quantile(dt$salary, probs = (0.80)))]]


# Old Exercises -----------------------------------------------------------

# Exercise 1: Create a data.table and identify row indices with a specific condition
# -----------------------------------------------------------------------------
# 1. Create a data.table `dt1` with columns `ID` (1 to 10) and `Score` (random values between 50 and 100).
# 2. Find the row indices where the `Score` is greater than 80.

# Create the data.table
dt1 <- data.table(ID = 1:10, Score = sample(50:100, 10, replace = TRUE))
print("Data table dt1:")
print(dt1)

# Use .I to find indices where Score is greater than 80
print("Row indices where Score > 80:")
indices1 <- dt1[Score > 80, .I]
print(indices1)


# Exercise 2: Filter rows based on indices
# -----------------------------------------------------------------------------
# 1. Using the `dt1` table created above, filter rows where `Score` is an even number.
# 2. Use the `.I` function to get the indices of these rows, then filter `dt1` using these indices.

# Find the indices of rows with even Scores
print("Indices with even Score values:")
even_indices <- dt1[Score %% 2 == 0, .I]
print(even_indices)

# Use the indices to filter rows in dt1
print("Rows where Score is even:")
even_rows <- dt1[even_indices]
print(even_rows)


# Exercise 3: Find the maximum value's row index and print the corresponding row
# -----------------------------------------------------------------------------
# 1. Identify the row index of the maximum `Score` in `dt1` using `.I`.
# 2. Print the row with the highest `Score`.

# Get the row index with the maximum Score
print("Row index with maximum Score:")
max_index <- dt1[Score == max(Score), .I]
print(max_index)

# Display the row with maximum Score
print("Row with maximum Score:")
max_row <- dt1[max_index]
print(max_row)


# Exercise 4: Using .I in combination with .N to get the last row(s) based on a condition
# -----------------------------------------------------------------------------
# 1. Using `dt1`, identify the last row index where `Score` is greater than 60.
# 2. Print this row.

# Get the last row index with Score > 60
print("Last row index where Score > 60:")
last_index <- dt1[Score > 60, .I[.N]]
print(last_index)

# Display the row
print("Last row where Score > 60:")
last_row <- dt1[last_index]
print(last_row)


# Exercise 5: Modify specific rows using .I
# -----------------------------------------------------------------------------
# 1. Set `Score` to 0 for rows in `dt1` where the `ID` is an odd number.
# 2. Use `.I` to get the row indices and update these rows in-place.

# Find row indices with odd ID
print("Indices with odd ID values:")
odd_id_indices <- dt1[ID %% 2 == 1, .I]
print(odd_id_indices)

# Update Score to 0 for these rows
dt1[odd_id_indices, Score := 0]
print("Updated dt1 with Score set to 0 for odd IDs:")
print(dt1)


# Exercise 6: Remove rows based on .I
# -----------------------------------------------------------------------------
# 1. Remove rows from `dt1` where `Score` is less than 60.
# 2. Use `.I` to get the indices of these rows and delete them.

# Find indices where Score is less than 60
print("Indices where Score < 60:")
low_score_indices <- dt1[Score < 60, .I]
print(low_score_indices)

# Remove these rows
dt1 <- dt1[!low_score_indices]
print("Data table dt1 after removing rows where Score < 60:")
print(dt1)
