#Load R's built in car data set
data(cars)

# Create the scatter plot
plot(cars$speed, 
     cars$dist, 
     main = "Effect of Car Speed on Stopping Distances",
     xlab = "Speed (mph)", 
     ylab = "Stopping Distance (ft)")

# Fit the linear model
linear_model <- lm(dist ~ speed, data = cars)

# Overlay line of best fit
abline(linear_model, col = "red", lwd = 2)

# Fit the LOESS model and predict values
loess_model <- loess(dist ~ speed, data = cars)
loess_predictions <- predict(loess_model)

# LOESS model regression line
lines(cars$speed, loess_predictions, col = "blue2", lwd = 3)

# Calculates both the fitted values and standard errors of the fitted values
loess_ci <- predict(loess_model, se = TRUE)

# Calculate the upper and lower bounds of the 95% confidence interval
upper <- loess_ci$fit + 1.96 * loess_ci$se.fit
lower <- loess_ci$fit - 1.96 * loess_ci$se.fit

# Overlay for upper and lower bounds of confidence intervals
lines(cars$speed, upper, col = "blue2", lwd = 1, lty = 2)
lines(cars$speed, lower, col = "blue2", lwd = 1, lty = 2)
