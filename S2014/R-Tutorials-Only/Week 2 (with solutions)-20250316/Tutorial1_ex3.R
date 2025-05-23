# Exercise 3 of Tutorial 1

# Part (a)

x <- seq(-3,3,0.01)
y <- exp(-abs(x))
plot(x,y,type="l",ylab="f(x)")
title("Plot of the double exponential function in the range [-3, 3]")


# Part (b)

help(read.csv)

# When you download the data to your working directory, open  the file
# to examine the contents. Note that the file has a header row containing
# the variable names, and "header = TRUE" when using read.csv(), so 
# all that we have to do to read in the data with the correct names is:

mussels <- read.csv("worksheet4_mussels.csv",header = T)
attributes(mussels)
attach(mussels)

# Use logical expressions to subset out the two locations:
age1 <- age[location==1]
weight1 <- weight[location==1]
age2 <- age[location==2]
weight2 <- weight[location==2]

# now for the plot:
plot(age2, weight2, type="b", pch="2", xlab="Age", ylab="Weight")
lines(age1, weight1, type="b", pch="1", lty=2)
title("Growth Characteristics of Mussels\nSouthwestern Virginia, USA")
text(c(17,14),c(3.5,11), c("Location 1", "Location 2"))

# This above code plots the two sets of points and "joins the dots", which
# is a sensible approach in this instance, as the data is sorted by age
# within each location:

location1.lm <- lm(weight1 ~ age1)
location2.lm <- lm(weight2 ~ age2)

plot(age2, weight2, pch="2", xlab="Age", ylab="Weight")
points(age1, weight1, pch="1")
abline(location1.lm$coef)
abline(location2.lm$coef,lty=2)
title("Growth Characteristics of Mussels\nSouthwestern Virginia, USA")

help(legend)

legend(4, 13, c("Location 1", "Location 2"), lty=c(1,2), pch=c("1","2"))

# Both locations show an increasing relationship between weight and age,
# ie. mussels increase in weight as they get older. The mussels at
# location 2 generally increase in weight faster than at location 1.


# Part (c)

normals <- rnorm(1000,3,4)
hist(normals)
min(normals)
max(normals)

# The answers should change each time you use the above code 

hist(normals, breaks=seq(floor(min(normals)),floor(max(normals)+1),1))
hist(normals, breaks=seq(floor(min(normals)),floor(max(normals)+1),0.5))
hist(normals, breaks=seq(floor(min(normals)),floor(max(normals)+1),0.25))
hist(normals, breaks=seq(floor(min(normals)),floor(max(normals)+1),0.1))

# Now going the "other way":

hist(normals, breaks=seq(floor(min(normals)),floor(max(normals)+1),1.5))

# This may not work, as the breaks may no longer span the range of values in
# normals. In that case, expand the base of the histogram slightly:

hist(normals, breaks=seq(floor(min(normals)-2),floor(max(normals)+2),1.5))
hist(normals, breaks=seq(floor(min(normals)-4),floor(max(normals)+4),2))

# Now adding a normal "curve":

grid <- seq(floor(min(normals)),floor(max(normals)+1),1)
really.normal <- dnorm(grid,3,4)
hist(normals, breaks=seq(floor(min(normals)),floor(max(normals)+1),1))
lines(grid,really.normal)
lines(grid,1000*1*really.normal)

# Now you can try this out yourself on the other histograms.

help(hist)

# Note that the default bin-width is based on Sturges' rule, but the
# help file also suggests Scott's rule and the Freedman-Diaconis rule
# as alternatives - you might like to "google" these terms to read 
# about the pros and cons of these alternatives.

qqnorm(normals)

# Looks reasonably linear!

expo <- rexp(15,1)
mean(expo)
var(expo)
qqnorm(expo)

# Very right (postively) skewed. You could confirm this with a histogram:

hist(expo)


# Part (d)

x <- rnorm(50)
median(x)
mean(x)

x[1] <-x[1] + 100
median(x)
mean(x)

# The median is only slightly affected by the addition of such a distinct
# outlier, however the mean is definitely affected.
# Note the above are only typical results, the results will change slightly
# each time you repeat this simulation exercise!

means.normal <- rep(0, 100)
medians.normal <- rep(0, 100)
means.cauchy <- rep(0, 100)
medians.cauchy <- rep(0, 100)
for(i in 1:100) {
  x <- rnorm(50)
  y <- rcauchy(50)
  means.normal[i] <- mean(x)
  medians.normal[i] <- median(x)
  means.cauchy[i] <- mean(y)
  medians.cauchy[i] <- median(y)}

# Generating histograms, means and standard deviations. R makes it easy to combine 
# multiple plots into one overall graph, using either the par() or layout() function. 
# With the par() function, you can include the option mfrow=c(nrows, ncols) to 
# create a matrix of nrows x ncols plots that are filled in row by row:

par(mfrow=c(2,2))
hist(means.normal)
hist(medians.normal)
hist(means.cauchy)
hist(medians.cauchy)

mean(means.normal)
mean(medians.normal)

mean(means.cauchy)
mean(medians.cauchy)

median(means.normal)
median(medians.normal)

median(means.cauchy)
median(medians.cauchy)

sqrt(var(means.normal))
sqrt(var(medians.normal))

sqrt(var(means.cauchy))
sqrt(var(medians.cauchy))

# These simulations of the sampling distributions of the mean and the
# median show that only the means of the samples from the Cauchy distribution 
# are affected by the presence of outliers. Even in the Cauchy distribution,
# the median is robust against the presence of outliers.

# Don't forget to reset the plot window:

par(mfrow=c(1,1))


# Part (e)

beta.change <- function (y, x, exclude){
  excl <- unique(exclude) # check there are no repeated values in exclude
  if(min(excl)<1) {print("invalid exclusion - index too small")}
  else if(max(excl)>length(y)) {print("invalid exclusion - index too large")}
  else {
    beta <- lm(y ~ x)$coef
    beta.excl <- lm(y[-excl]~x[-excl])$coef
    beta - beta.excl
    }
}

# If you not are using the same workspace as you did for exercise 2, 
# you will need to make sure the file "worksheet2_women.csv" is in your
# current working directory and execute the following code, which is 
# currently shown commented out:

# ws2.women <- read.csv("worksheet2_women.csv", header=F)
# names(ws2.women) <- c("Height", "Weight")

# If you are using the same workspace, then all you need to do is:

attach(ws2.women)

lm(Weight ~ Height)$coef

beta.change(Weight, Height, 0)
beta.change(Weight, Height, 1)
beta.change(Weight, Height, 2)
beta.change(Weight, Height, 3)
beta.change(Weight, Height, 4)
beta.change(Weight, Height, 5)
beta.change(Weight, Height, 6)
beta.change(Weight, Height, 7)
beta.change(Weight, Height, 8)
beta.change(Weight, Height, 9)
beta.change(Weight, Height, 10)
beta.change(Weight, Height, 11)

# Excluding observation 4 would make a big change in both coefficients.

# In percentage terms the coefficients would change by:

100 * beta.change(Weight, Height, 4)/lm(Weight ~ Height)$coef


# Part (f)

# Using the above beta.change() function:

jackknife.slope <- function(y, x) {
  n <- length(y)
  change <- rep(0, n)
  for(i in 1:n) {change[i] <- beta.change(y,x,i)[2]}
  (n-1)*mean(change)
}

# for the ws2.women dataset, we get:

jackknife.slope(Weight, Height)

# To generalise this function, we would have to allow the user to pass in
# their estimator, "theta()", as an argument to the function.

# beta.change() returns a vector showing the change in the regression coefficients
# rather than just the slope. To keep things simple, let's use a slightly simpler
# function and assume that we are always dealing with the sort of data described
# in the question, i.e. a data.frame with two columns, the first being x and the
# second y:

slope <- function(data){
  x <- data[,1]
  y <- data[,2]
  lm(y ~ x)$coef[2]
}
  
# So, a general jackknife function would look like:

jackknife <- function(data, theta){
  n <- nrow(data)
  change <- rep(0, n)
  for(i in 1:n) {change[i] <- theta(data) - theta(data[-i,])}
  (n-1)*mean(change)
}

# So, now with the ws2.women dataset and using the slope() function:

jackknife(ws2.women, slope)

# I will leave it as an exercise for you to think how you might modify this
# even further to allow for more general data input and more complex functions,
# but here are a couple more examples of using our existing jackknife function:

mean.x <- function(data) {
  x <- data[,1]
  mean (x)
}

mean.x(ws2.women)
mean(Height)

mean.y <- function(data) {
  y <- data[,2]
  mean (y)
} 

mean.y(ws2.women)
mean(Weight)

jackknife(ws2.women, mean.x)
jackknife(ws2.women, mean.y)

# Both very close to 0, which should not be big surprise as the sample mean 
# is an unbiased estimator.
