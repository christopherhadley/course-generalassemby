
# set working dir
setwd('~/Dropbox (Qubit)/Hadley/GA/')

# read in data, separated by tabs, header = True (F = False)
x <- read.table('supervisor.txt', sep='\t', h = T)

# dataset rates supervisors - rows are people, columns are responses (X1-6 are questions, Y is aggregate)

# slicing and dicing arrays - syntax
x[,1] # prints first column as array
x[1,] # prints first row
x[1,2:7] # print first row, from elements 2 to 7

# another way:
x$Y # prints column Y (same as x[,1] above)
x$X1 # print column X1
# Best to use this syntax in case structure of data is changed (equivalent to hard coding in Excel)

# size of array
nrow(x) # rows
length(x) # cols
ncol(x) # cols


# PLOTS
plot(x) # plots everything against everything (symmetric)
pairs(x)
plot(x$Y ~ x$X1)

# let's model
# mutli-regssion of Y against everything (~)
fit <- lm(Y ~ ., data=x)

# This lines does exactly the same: 
fit <- lm(Y ~ X1 + X2 + X3 + X4 + X5 + X6, data = x)
summary(fit)

# Let's look at fit of residuals
fit$residuals
plot(fit$residuals) # should be a "white noise" pattern around 0 if good model
hist(fit$residuals)

# remove X5
# Syntax: .~.-X5 means keep the same on the left of the ~, remove X5 on the RHS
fit2 <- update(fit, .~. -X5)
summary(fit2)
# as you take things away, multi R squared will go down (more predictors means more accuracy, but beware over-fitting)



# remove X4
fit3 <- update(fit2, .~. -X4)
summary(fit3)
fit4 <- update(fit3, .~. -X2)
summary(fit4)

# previously over-fitting, so fix that
fit5 <- update(fit4, .~. -X6)
summary(fit5)
# This cuases adjR2 to start going down, RSE started going up, so fit5 is weaker than fit4

fit6 <- update(fit5, .~. -X3)
summary(fit6)

fit7 <- update(fit6, .~. -1)
fit7 <- lm(Y ~ X1 -1, data = x)
summary(fit7)

# This is called backwards elimination

# Another example: cigarette sales by US states
f <- read.table('fagsales.txt', sep='\t', h = T)
