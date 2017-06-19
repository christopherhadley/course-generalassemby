# useful functions

# assignment of arrays
x <- c(1,2,3); x
x <- 1:3; x # assign 
length(x) # length of array x


x <- replicate(10, rnorm(20))

# slicing and dicing arrays - syntax
x[,1] # prints first column as array
x[1,] # prints first row
x[1,2:7] # print first row, from elements 2 to 7

x$Y <- x[,1]; x$Y

head(x)


# another way:if there are column names
x$Y # prints column Y (same as x[,1] above)
x$X1 # print column X1
# Best to use this syntax in case structure of data is changed (equivalent to hard coding in Excel)

# size of array
nrow(x) # rows
length(x) # cols
ncol(x) # cols


# defining a simple function
myfunction <- function(arg1, arg2, ... ) {
  statements
  return(object)
}