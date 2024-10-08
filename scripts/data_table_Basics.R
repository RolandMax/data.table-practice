# data.table first steps
# check: 
# https://github.com/Rdatatable/data.table
# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html


library(data.table)

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
setkeyv(dt, "origin")
dt["XYZ"]
