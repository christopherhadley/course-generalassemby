# General Assembly Data Science (London, Fall 2015)
# Lesson 2: Machine Learning
# Wednesday 7th October 2015

# R Session: Multiple Regression + Backwards Elimination

### EXAMPLE 1 - supervisor performance
#   This dataset shows a set of six numeric survey responses Xi (survey responses)
#   (e.g. how do they handle employee complaints, how critical, opportunities to learn
#   new things), and a dependent variable Y denoting the perceived supervisor quality.
#
#   We would like to predict Y (the overall rating) from the X's.
#
#   Source: http://www.ats.ucla.edu/stat/examples/chp/p054.txt

# Read in the data (tab-separated)
x <- read.table('data-lesson2/supervisor.txt', sep='\t', header=TRUE)

# Let's have a look
head(x)
View(x)

# Calling plot on this type of data is equivalent to the more specific plotting function pairs().
# This set of scatterplots gives us an idea of the pairwise relationships present in the dataset.
plot(x)  # same as pairs(x)

# This linear fit represents the "full model"; eg, the fit with all of the independent variables included.
fit <- lm(Y ~ ., data=x)
summary(fit)

# Let's remove the feature w/ lowest (absolute) t-score.
# Note R-sq decreases slightly (we took a feature away), adj R-sq increases slightly (decreased variance).
fit2 <- update(fit, .~. -X5)
summary(fit2)

# Ditto, remove X4.
fit3 <- update(fit2, .~. -X4)
summary(fit3)

# Ditto, remove X2.
# Stopping criteria met, all features have |t| > 1a
# i.e. an optimal bias-variance point reached, and residual standard error (RSE) is minimised.
fit4 <- update(fit3, .~. -X2)
summary(fit4)			     

# Let's keep going, see what happens.
# Note this model is weaker (lower R-sq, higher RSE).
fit5 <- update(fit4, .~. -X6)
summary(fit5)

# Weaker still.
fit6 <- update(fit5, .~. -X3)
summary(fit6)

# Ideally, a plot of the residuals will look random, i.e. we want absence of structure here ("gaussian white noise").
# This plot looks pretty good.
plot(resid(fit4))  # Could also do plot(summary(fit4)$residuals).
hist(resid(fit4))  # Want this to look like a Normal distribution, equally weighted around zero.

# Another way of judging normality is if we see a straight diagonal line in the residuals' qqplot.
# See ?qqplot for more on this, this looks OK here, not too biased.
qqnorm(resid(fit4))
qqline(resid(fit4), col=2)



### EXAMPLE 2 - cigarette consumption
#   In 1970, a national insurance organisation wanted to study the consumption pattern of cigarettes in all
#   50 states. Variables in this data are:
#       - Age       Median age of a person living in a state.
#       - HS        Percentage of people over 25 years of age in a state who had completed high school.
#       - Income    Per capita personal income for a state (in USD).
#       - Black     Percentage of black people living in a state.
#       - Female    Percentage of females living in a state.
#       - Price     Weighted average price (in cents) of a pack of cigarettes in a state.
#       - Sales     Number of packs of cigarettes sold in a state on a per capita basis.
#
#   Source: http://www.ats.ucla.edu/stat/examples/chp/p081.txt

# Read the data, have a look, remove the state label as this isn't helpful to our model.
x <- read.table('cigarettes.txt', sep='\t', header=T)
head(x)
x$State <- NULL

# Full model.
fit <- lm(Sales ~ ., data=x)
summary(fit)

# Remove the intercept.
# Note some weird stats (high R-sq, low t-scores), potentially the linear regression
# assumptions are not valid, possibly not enough data for prediction.
fit <- lm(Sales ~ 0 + ., data=x)  # Same as fit <- lm(Sales ~ . - 1, data=x)
summary(fit)

# Remove HS
fit2 <- update(fit, .~. -HS)
summary(fit2)

# Remove Female. Note t-score of Age jumps (Age becomes much more significant).
# Because this can happen, make sure you remove only one feature at a time with backwards elimination!
fit3 <- update(fit2, .~. -Female)
summary(fit3)

# Examine our residuals...
plot(resid(fit3))  # Obvious outlier present here.
qqnorm(resid(fit3))
qqline(resid(fit3), col=2)
# The qqplot here isn't looking good, and the residual quartiles are looking biased.
# Conclusion: this dataset doesn't support multiple linear regression very well! Difficult to know
# if we have outliers that need to be removed, or if we need more data.

