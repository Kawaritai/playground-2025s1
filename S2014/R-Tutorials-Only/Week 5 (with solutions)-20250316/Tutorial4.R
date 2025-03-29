# Regression Modelling Tutorial 4 - R Commands


# Question One

# Q1 (a)

Xh <- 1000
predict(Lubricant.lm, newdata = data.frame(pressure = Xh), 
        interval = 'confidence', level = .90)

# Q1 (b)
Xh <- 1000
predict(Lubricant.lm, newdata = data.frame(pressure = Xh), 
        interval = 'prediction', level = .90)

# Notice that the prediction interval is wider than the confidence interval.


# Question Two

# Q2 (a)

# Download the data file to the right directory and then read in and attach the data:

auscars <- read.csv("auscars.csv", header=T)
auscars
attach(auscars)


# Q2 (b)

# Now fit the requested model using lm():

auscars.lm <- lm(L.100k ~ Weight)

# The estimated coefficients and associated standard errors are then given in
# the summary:

summary(auscars.lm)


# The required plot:

plot(Weight, L.100k, ylim=c(5,20), xlab="Unladen weight (kgs)", ylab="Fuel efficiency (Litres/100Km)", main="NRMA Car Data 1991")
abline(coef(auscars.lm))


# Q2 (c)

# Fitted values v.s. Residuals

plot(auscars.lm, which = 1)

# Residauls are randomly spreaded around zero. Linearity assumption is mostly sastisified 
# as there is no systemtic pattern in the residuals. The variation stays most constant and
# most of residuals are within (-2,2) except for a few points, indicating a constant variance
# of the error term. Note the 20th observation has a relative larger residual than others.

# Q-Q plot
plot(auscars.lm, which = 2)

# Most points are close to the straight line on the Q-Q plot, except for the 20th residual.
# So normality assumption is valid for this model.

# Overall, we believe the assumptions of linear regression models are satisfied. 
# 20th obs is likely to be an outlier.


# Leverage
barplot(hatvalues(auscars.lm))
abline(h=4/length(Weight), col=2, lty=2)
# Find the indices of observations have large leverages.
which(hatvalues(auscars.lm) > 4/length(Weight))

# Six obsevations (index: 7,8,16,28,50,59) have relative high leverages. Whether they 
# have large impacts on the fitted regression, we need to look at Cook's distance.


## Cook's distance
plot(auscars.lm, which = 4)
# The 28th observation has relative large cook's distance so could be an infulential point.
# Meanwhile, the 28th observation has a high leverage and also has a large residual from early plots.


# Q2 (d)

# Plot looks like a reasonably strong association between Weight and L.100k. We can use the
# F test in the ANOVA table to confirm this:

anova(auscars.lm)

# The p-value is extremely small, indicating the we can reject H0 and conclude that there 
# is a significant relationship between the two variables. Since the estimate of the slope
# coefficient is positive, we can say that the heavier a car is, the more litres it will
# require to travel 100 kilometres, i.e. heavier cars are less fuel efficient.

# or we could just get t-test result from the summary output:
  
summary(auscars.lm)

# Q2 (e)

# We could calculate the R-squared value by dividing the SSR by the sum of the
# SSR and SSE in the ANOVA table = 180.031/(180.031 + 80.998) = 0.6897 or 68.97% 
# or we could just get the value from the summary output.


# We could check this value by finding the correlation between Weight and L.100k and 
# squaring it:

cor(Weight,L.100k)
cor(Weight,L.100k)^2

# So, approximately 69% of the variability in fuel efficiency is "explained" by the 
# weight differences in the cars.


# Q2 (f)

# We can store the estimated intercept coefficient and associated standard error by 
# extracting them from the lm object and the summary table:

coef(auscars.lm)
b0 <- coef(auscars.lm)[1]
b0

summary(auscars.lm)$coef
SEb0 <- summary(auscars.lm)$coef[1,2]
SEb0

# The degrees of freedom associated with MSerror is:

auscars.lm$df

# So the required confidence interval is:

c(b0 + qt(0.025,auscars.lm$df)*SEb0, b0 + qt(0.975,auscars.lm$df)*SEb0)

# However, we would have to extrapolate a long way "off the plot" (i.e. away from
# the data) to show the intercept and it doesn't really make sense to talk about 
# the fuel efficiency for a car with zero weight. So this interval is not useful.


# Q2 (g)

newWeight <- 1800

# 95% confidence interval for the expected value of L.100k when Weight = 1800:

predict(auscars.lm, newdata=data.frame(Weight=newWeight), interval="confidence")

# 95% prediction interval for a single value of L.100k when Weight = 1800:

predict(auscars.lm, newdata=data.frame(Weight=newWeight), interval="prediction")


# Q2 (h)

newWeight <- seq(min(Weight),max(Weight),10)
newWeight

auscars.cis <- predict(auscars.lm, newdata=data.frame(Weight=newWeight), interval="confidence")
auscars.cis

auscars.pis <- predict(auscars.lm, newdata=data.frame(Weight=newWeight), interval="prediction")
auscars.pis

plot(Weight, L.100k, ylim=c(5,20), xlab="Unladen weight (kgs)", ylab="Fuel efficiency (Litres/100Km)", main="NRMA Car Data 1991")
abline(coef(auscars.lm))

lines(newWeight, auscars.cis[,"lwr"], lty=2)
lines(newWeight, auscars.cis[,"upr"], lty=2)

lines(newWeight, auscars.pis[,"lwr"], lty=3)
lines(newWeight, auscars.pis[,"upr"], lty=3)

legend(720,20,c("Estimated SLR model", "95% Confidence Intervals", "95% Prediction Intervals"), lty=1:3)

# We can see that the prediction intervals are much wider than the confidence intervals,
# as would be expected, since they incorporate the extra variability of a single random
# error, along with the uncertainty of the expected value. Also, we note that both the
# bands have a quadratic shape to them (the confidence interval bands are more obvious),
# which indicates that even if we firmly believethat our linear model holds, 
# it is more and more difficult to accurately predict as we move away from the centre of 
# the data.



# Question Three

# Q3 (a)

# Download the data file to the right directory and then read in the data:

vote <- read.csv("vote.csv",header=T,sep=",")
bush <- vote$bush2000
buchanan <- vote$buchanan2000

plot(bush, buchanan, xlab="Bush vote", ylab="Buchanan vote")

# Two outliers make it difficult to detect the pattern of scatter plot. We now closely look at
# the majority points by changing the scales of x-axis and y-axis.  
plot(bush, buchanan, xlab="Bush vote", ylab="Buchanan vote", xlim=c(0,200000), ylim=c(0,2000) )

# Let Y be the Buchanan vote and X be the Bush vote.
# It is clear to see that the variation of Y is increasing when X is increasing, showing 
# Y does not have constant variance.

plot(log(bush), log(buchanan), xlab="log(Bush vote)", ylab="log(Buchanan vote)")

# After taking log transformation on both X and Y, the relationship of X and Y seems more linear.
# And variation of Y seems stay constant. So the log-log transformation looks better for use in a SLR.

# Q3 (b)

# By view the data, we know Palm Beach county is the last observation (67th observation).

vote.reg=lm(log(buchanan[-67])~log(bush[-67]))
summary(vote.reg)

# The fitted regression line is: hat log(Y) =  -2.3415 + 0.7310 log(X)
# where Y is the Buchanan vote and X is the Bush vote.

# Then, we can use the following equation to predict Buchanan votes from Bush votes (Xnew):
# log(hat Y) = exp(-2.3415 + 0.7310 log(Xnew)) so that
# hat Y = exp(-2.3415 + 0.7310 log(Xnew))

# Q3 (c)

# Fitted values v.s. Residuals

plot(fitted(vote.reg), residuals(vote.reg))

# It shows the lineariy of the mdoel is appropriate and the residauls have constant variance and 

# Q-Q plot
plot(vote.reg, which = 2)

# QQ-plot shows that the residuals have a little heavy tail on lower tail side, indicating slight 
# nonnormality. Due to the large sample size, the nonnormality is less of concern.  


# Q3 (d)

# We use the fitted model to get the 95% prediction interval of log(Y) and then take 
# exp() transformation to obtain prediction interval of Y given Xnew = bush[67].

vote.pred = predict(vote.reg,data.frame(bush=bush[67]),interval="prediction")
exp(vote.pred)

# Q3 (e)

buchanan[67]

# The observed number of votes for Buchanan is 3407, way outside the upper limit of the 95% prediction
# interval. This would make us suspect that something was different in Palm Beach county.
