# data.table first steps
# check: 
# https://github.com/Rdatatable/data.table
# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html


library(data.table)


# Basics ------------------------------------------------------------------

# read data w/ fread
dt <- fread("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv")

# check data
str(dt)
dt

# convert to data.table
# w/ setDT for baseR data.frames or lists 
# others w/ as.data.table(df)
df <- read.csv("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv")
dt <- setDT(df)
str(dt)

# Subset rows in i
# Get all the flights with “JFK” as the origin airport in the month of June.
dt[origin == 'JFK' & month == 6L]

# Get the first two rows from flights.
dt[1:2,]

# Sort flights first by column origin in ascending order, 
# and then by dest in descending order:
dt[order(origin, -dest)]

# d) Select column(s) in j
# – Select arr_delay column, but return it as a vector.
dt[, arr_delay]
str(dt)
# – Select arr_delay column, but return as a data.table instead.
dt[, list(arr_delay)]
# or .()
head(dt[, .(arr_delay)])

# – Select both arr_delay and dep_delay columns.
cols <- dt[ , .(arr_delay, dep_delay)]
head(cols)

# – Select both arr_delay and dep_delay columns 
# and rename them to delay_arr and delay_dep.
cols <- dt[ , .(delay_arr = arr_delay, delay_dep = dep_delay)]
head(cols)

# e) Compute or do in j
# – How many trips have had total delay < 0?
ans <- dt[, sum( (arr_delay + dep_delay) < 0 )]
head(ans)

# f) Subset in i and do in j
# – Calculate the average arrival and departure delay for all flights 
# with “JFK” as the origin airport in the month of June.

dt[origin == 'JFK' & month == 6L,
   .(
     avg_arr_delay = mean(arr_delay),
     avg_dep_delay = mean(dep_delay)
   )]

# – How many trips have been made in 2014 from “JFK” airport in the month of June?
dt[origin == 'JFK' & month == 6L & year == 2014L,
   length(dest)]


# g) Handle non-existing elements in i
# – What happens when querying for non-existing elements?

# Key-based subsetting: dt["d"]
# This performs a right join on the key column x, resulting in a row with d and NA for columns not found. 
# When using setkeyv, the table is sorted by the specified keys 
# and an internal index is created, enabling binary search for efficient subsetting.
setkeyv(dt, "origin")
dt["XYZ"] 

# Logical subsetting: dt[x == "d"]
dt[origin == 'XYZ']

# Exact match using nomatch=NULL
# For exact matches without NA for non-existing elements, use nomatch=NULL:
# can help prevent confusion when dealing with non-existing elements in your data.
dt["XYZ", nomatch = NULL]


# Special symbol .N:
# .N is a special built-in variable that holds the number of observations in the current group. 
# It is particularly useful when combined with by
dt[origin == 'JFK' & month == 6L, .(freq_flights  = .N)] # .N = number of observations

# refer to columns by names in j (like in a data.frame)?
# – Select both arr_delay and dep_delay columns the data.frame way.
df[, c("arr_delay", "dep_delay")]

# Select columns named in a variable using the .. prefix
selected_cols = c("arr_delay", "dep_delay")
dt[, ..selected_cols]
# – Select columns named in a variable using with = FALSE
dt[, selected_cols, with = FALSE]

# We can also deselect columns using - or !
# returns all columns except arr_delay and dep_delay
dt[, !c("arr_delay", "dep_delay")]

# select by specifying start and end column names, e.g., year:day
dt[, year:day]


# Aggregations ------------------------------------------------------------


# a) Grouping using by

# – How can we get the number of trips corresponding to each origin airport?
dt[, .(.N), by = .(origin)]
# or
dt[, .(.N), by = "origin"]
# When there’s only one column or expression to refer to in j and by, we can drop the .() notation. 
# This is purely for convenience. We could instead do:
dt[, .N, by = origin]


# How can we calculate the number of trips
# for each origin airport for carrier code "AA"?
dt[carrier == "AA",
   .N,
   by = origin]

# – How can we get the total number
# of trips for each origin, dest pair for carrier code "AA"?
dt[carrier == "AA",
   .N,
   by = .(origin, dest)]


# – How can we get the average arrival and departure delay 
# for each orig,dest pair for each month for carrier code "AA"?
dt[carrier == "AA",
   .(
     m_arr = mean(arr_delay),
     m_dep = mean(dep_delay)
   ),
   by = .(
     origin,
     dest,
     month
   )]


# b) Sorted by: keyby
# – So how can we directly order by all the grouping variables? 
# w/ keyby:
# automatically orders the result by the grouping variables in increasing order.

dt[carrier == "AA",
   .(
     m_arr = mean(arr_delay),
     m_dep = mean(dep_delay)
   ),
   keyby = .(
     origin,
     dest,
     month
   )]


# c) Chaining
# – How can we order dt using the columns origin in ascending order, 
# and dest in descending order?
dt[carrier == "AA", .N, by = .(origin, dest)][order(origin, -dest)]
head(dt, 10)

# d) Expressions in by
# – Can by accept expressions as well or does it just take columns?
# how many flights started late but arrived early (or on time), started and arrived late etc…
dt[ ,
    .N,
    .(arr_delay > 0, dep_delay >0)]

# e) Multiple columns in j - .SD
# To compute on (multiple) columns, we can then simply use the base R function lapply().
dt[ , 
    lapply(.SD, mean), # with this you list apply (lapply) the mean to all the subset data (.SD)
    .(origin, dest, month),
    .SDcols = c("arr_delay", "dep_delay")]  # for just those specified in .SDcols

# f) Subset .SD for each group:
# – How can we return the first two rows for each month?
dt[ ,
    lapply(.SD, head, 2),
    by = month]


# add, update, delete columns ---------------------------------------------

# using the := operator

# a) Add columns by reference

dt[ ,
    `:=` (speed = distance/ (air_time) * 60,
          delay = arr_delay + dep_delay)
    ]

# or 

dt[, c("speed", "delay") := .((distance/ air_time * 60),
                              (arr_delay + dep_delay)
                              )]

head(dt)

# b) Update some rows of columns by reference - sub-assign by reference

# – Replace those rows where hour == 24 with the value 0
# subassign by reference

dt[hour == 24L, hour := 0L]

# c) Delete column by reference
# – Remove delay column

dt[ ,
    c("delay") := NULL]

## or using the functional form
dt[, `:=`(delay = NULL)]

head(dt)

# d) := along with grouping using by

# e.g. – How can we add a new column which contains 
# for each orig,dest pair the maximum speed?
dt[,
    `:=` (max_speed = max(speed)),
          by = .(origin, dest)]

head(dt)

# e) Multiple columns and :=
#   – How can we add two more columns computing max() 
# of dep_delay and arr_delay for each month, using .SD?

in_cols  = c("dep_delay", "arr_delay")
out_cols = c("max_dep_delay", "max_arr_delay")
dt[, c(out_cols) := lapply(.SD, max), by = month, .SDcols = in_cols]

dt[ ,
    c("speed", "max_speed", "max_dep_delay", "max_arr_delay") := NULL] 


# – How can we update multiple existing columns in place using .SD?

# change to factor
dt[, 
   names(.SD) := lapply(.SD, as.factor), .SDcols = is.character]
# change it back
cols <- sapply(dt, is.factor)
dt[,
   names(.SD) := lapply(.SD, as.character), .SDcols = cols]

str(dt)

# a) := for its side effect

str(dt)

foo_funct <- function(DT){    # this function updates the original dt
  DT[, speed := distance/(air_time * 60)]
  DT[, .(max_speed = max(speed)), by = month]
  return(DT)
  }

foo_funct(dt)

# b) The copy() function

foo_funct_2 <- function(DT){
  DT <- copy(DT)   # the copy function creates a copy, which doesn´t update the orginal data.table
  DT[, speed := distance/ (air_time *60)]
  DT[, .(max_speed = max(speed)), by = month]
  return(DT)
}

copy_dt <- foo_funct_2(dt)
str(dt)
str(copy_dt)
