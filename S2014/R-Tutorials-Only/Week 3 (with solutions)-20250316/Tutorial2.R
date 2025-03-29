# Regression Modelling Tutorial 2 - R Commands

# Question One

# Q1 (a)

# Download the data file to the right directory and then read in and attach the data:

Lubricant <- read.csv("Lubricant.csv", header=T)
Lubricant
attach(Lubricant)

# Now fit the requested model using lm() and then the easiest way to view the estimates
# is to use summary():

Lubricant.lm <- lm(viscos ~ pressure)
summary(Lubricant.lm)


# Q1 (b)

# It is always good practice to properly label a plot - though it would have been
# better if the description of the data had included information about the units
# used in the sample measurements, so we could have included that info in the 
# axis labels:

plot(pressure, viscos, xlab="Pressure", ylab="Viscosity", main="Lubricant data")

# Add the estimated regression line - the coefficients of the model are stored as
# a pair, the intercept a, followed by the slope b, so they are already in the
# appropriate format for using abline():

Lubricant.lm$coefficients
help(abline)
abline(Lubricant.lm) # or abline(Lubricant.lm$coefficients)

# To use the coefficients in a vector multiplication, we need to also have 
# vectors of new values that specify what is to be multiplied by the intercept 
# and what is to be multiplied by the slope, i.e. we want a vector of 1 and the
# the new x value:

c(1, 1000) %*% Lubricant.lm$coefficients

# For the second prediction, we could do the multiplication the other way round.
# Strictly speaking, vector/matrix multiplication is not transitive, so we may
# need to transpose one of our matrices, but in the simple case of two vectors
# R will produce the right results, even if we omit this simple detail:

Lubricant.lm$coefficients %*% c(1, 10000)
t(Lubricant.lm$coefficients) %*% c(1, 10000)

# Note that the first prediction (x,y) = (1000, 5.857091) is well within the 
# range of our data and appears to be a sensible prediction (it is on the 
# estimated regression line in the midst of a lot of the observed sample values),
# however, (10000, 15.33369) is off the far end of the graph - the plot suggests
# definite problems with the fit of the model for values in the upper range of
# the data and it would be very unwise to extrapolate the model to include 
# even larger values - at best, simple linear regression is a good local 
# approximation within the range of the observed data.


# Q1 (c)

# Calculate the means:

xbar <- mean(pressure)
ybar <- mean(viscos)
c(xbar, ybar)

# By inspection of the plot in part (b), this point is on the estimated regression
# line, but we can check this by predicting the value of Y when X = xbar:

c(1, xbar) %*% Lubricant.lm$coefficients

