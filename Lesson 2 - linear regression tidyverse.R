# Building on what we did in lesson 2 and mucking about with tidyverse packages 
library(tidyverse)
library(modelr)
library(broom)

supervisor <- read_tsv('data-lesson2/supervisor.txt')

supervisor
ggplot(supervisor, aes(X1, Y)) + geom_point()
# Let's get a general look (using base R)
plot(supervisor)

# This is a tiny dataset!

model_supervisor <- lm(Y ~ ., data = supervisor)
model_supervisor

grid <- supervisor %>%
  data_grid(.model = model_supervisor) %>%
  add_predictions(model_supervisor) %>%
grid
ggplot(grid, aes(X1, pred)) + geom_point()


supervisor <- supervisor %>%
  add_predictions(model_supervisor) %>%
  add_residuals(model_supervisor)
supervisor

# Difference between summary() and glance()

df <- tribble(
  ~x,~y,
  7,276,
  3,43,
  4,82,
  6,136,
  10,417,
  9,269
)
# plot - base R
plot(df)
# plot - ggplot
df %>%
  ggplot(aes(x, y)) + geom_point()

model <- lm(y ~ x, data = df)
model
summary(model)
glance(model)

# These two summaries have different names for the same things: 
# summary name - glance name
# RSE = sigma
# F-statistic = statistic
# Pr(>|t|) for x = p.value

glance(model_supervisor)
summary(model_supervisor)

# Backward elimination: remove the lowest t statistic - ie. X5
mod2 <- update(model_supervisor, .~. -X5)
summary(mod2)
# Remove X4
mod3 <- update(mod2, .~. -X4)
summary(mod3)
# Remove X2
mod4 <- update(mod3, .~. -X2)
summary(mod4)


supervisor <- supervisor %>%
  add_residuals(mod4)
supervisor

