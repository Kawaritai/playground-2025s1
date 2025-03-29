# Regression Modelling Tutorial 3 - R Commands

# Question One

# Q1 (a)

anova(Lubricant.lm)
# From the ANOVA table, we know MSE = 1.881. The degrees of freedom is 51.
# F statistic in the ANOVA table is 119.64, p-value is quite less than 0.01. So we can conclude that beta1 is not zero.

# Mannually compute ANOVA table using commands below. The results are the same as those in the table.

n <- length(viscos)
SSE <- sum(Lubricant.lm$residuals^2)
MSE <- SSE/(n-2)
MSE

SSR <- sum((Lubricant.lm$fitted.values - mean (viscos))^2)
MSR <- SSR/1
MSR

Fstat <- MSR/MSE
Fstat

pvalue <- 1- pf(Fstat, 1, n-2)
pvalue

# summary() can also show the results of F statistic, corresponding degrees of freedom and p-value
summary()

# Q1 (b)

# Download the data file to the right directory and then read in and attach the data:

Lubricant <- read.csv("Lubricant.csv", header=T)
Lubricant
attach(Lubricant)

# Standard errors are just the standard deviations of the slope and the intercept.
# Now fit the requested model using lm() and then the easiest way to view the estimates
# and their standard errors is to use the default summary():

Lubricant.lm <- lm(viscos ~ pressure)
summary(Lubricant.lm)

# We can find the required sum of squares by mean correcting the x (pressure) values,
# squaring them and then adding them up:

Sxx <- sum((pressure - mean(pressure))^2)
Sxx

# A similar approach works to find the sum of squares of the residuals:

SSE <- sum(residuals(Lubricant.lm)^2)
SSE

# We can then find the MSE by dividing by n-2 (the df of MSE) or in general,
# we would use n-p, where p is the number of parameters in the model (it will be covered in MLR):

MSE<- SSE/(length(viscos)-length(Lubricant.lm$coefficients))
MSE

# Note we could have got this MSE from the anova() table. The standard error for the slope coefficient is then:

sqrt(MSE/Sxx)

# The standard error for the intercept is then:
sqrt(MSE*(1/length(viscos) + mean(pressure)^2/Sxx))

# Which is the same number we see in the summary() table:


# Q1 (c)

# Testing the significance of the slope coefficient is to test whether the slope coefficient 
# is zero or not. So the hypotheses we want to test are H0: beta1 = 0 vs HA: beta1 != (not equal) 0.
# Assuming the research question is "Is viscosity linearly related to pressure?", 
# we are still testing the same hypotheses. 

# This two-sided test of a zero null hypothesis is the default test shown in the 
# summary table, so we can use the p-value shown, which is 5.552e-15, which means
# 5.552 x (10 to the power of -15). The p-values is considerably smaller than our 
# default level of signifcance alpha = 0.05.

# So reject HO in favour of HA and conclude that the slope coefficient is not 0.
# Even though the slope is an apparently small number (0.001053), it is not 0,
# which implies that the mean of viscosity definitely increases as the pressure increases.

# The p-value for the F statistic in the ANOVA table is also the same
# as the p-value for the t test on the slope coefficient in the summary table:

summary(Lubricant.lm)
anova(Lubricant.lm)

# This is not a coincidence! In the special case of simple linear regression, the
# two tests are essentially testing the same hypotheses. We can also see that
# the t statistic squared is equal to the F statistic (with a little rounding
# error):

10.93818^2

# Q1 (d)

# Now the hypotheses we want to test are H0: beta1 = 0.001 vs HA: beta1 != (not equal) 0.001. 
# It is not a default test shown in summary table. We need to manually compute it.

b1 <- coef(Lubricant.lm)[2]
sd_b1 <- summary(Lubricant.lm)$coefficients[2,2]
tstat <- (b1-0.001)/sd_b1
pvalue <- 2*(1-pt(tstat,length(viscos)- 2))

# p value (0.5501) is quite large. Fail to reject H0 and conclude we do not have enough evidence 
# against H0: beta1 = 0.001.



# Q1 (e)

# The following R code should do the job - I don't really expect students to get 
# this question out on their first attempt (well done if you did). A good way to
# see what each line does is to run the code line by line - though you may need
# to have a good look at help(par) to see what is happening with all the 
# graphical options that I am setting here.

# Note that the Lubricant data is probably from a designed experiment, where the
# different levels of temperature were set (controlled) and then the pressure and
# resulting viscosity of the lubricant was observed. In a balanced experimental 
# design, we would normally observe the same number of replications at each level
# of tempature, but something may have gone wrong with some of these replications
# and we have some missing results:

table(tempC) # show the number of observations for each level of temperature.

tempCs <- unique(tempC)
tempCs

# First divide the data into 4 separate temperature groups (1,2,3,4), corresponding
# to the 4 levels of tempC:

press1 <- pressure[tempC==tempCs[1]]
viscos1 <- viscos[tempC==tempCs[1]]

press2 <- pressure[tempC==tempCs[2]]
viscos2 <- viscos[tempC==tempCs[2]]

press3 <- pressure[tempC==tempCs[3]]
viscos3 <- viscos[tempC==tempCs[3]]

press4 <- pressure[tempC==tempCs[4]]
viscos4 <- viscos[tempC==tempCs[4]]

# Now to create the plot, step by step for each of the four temperature groups:

plot(pressure, viscos, type="n", xlab="Pressure", ylab="Viscosity", main="Lubricant data")
points(press1, viscos1, pch="1")
points(press2, viscos2, pch="2")
points(press3, viscos3, pch="3")
points(press4, viscos4, pch="4")

# Now fit 4 separate simple linear regression models:

tempC_l.lm <- lm(viscos1 ~ press1)
summary(tempC_l.lm)

tempC_2.lm <- lm(viscos2 ~ press2)
summary(tempC_2.lm)

tempC_3.lm <- lm(viscos3 ~ press3)
summary(tempC_3.lm)

tempC_4.lm <- lm(viscos4 ~ press4)
summary(tempC_4.lm)

# And add these estimated regression lines to the plot with a suitable legend:

abline(tempC_l.lm$coef, lty=1)
abline(tempC_2.lm$coef, lty=2)
abline(tempC_3.lm$coef, lty=3)
abline(tempC_4.lm$coef, lty=4)
legend(5500, 7, paste(tempCs,"deg C"), pch=c("1","2","3","4"), lty=1:4,
       title="Temperature")

# From the plot, it is obvious that viscosity depends on both pressure and temperature
# with distinctly different slopes for the four different levels of temperature.



# Question Two

# The data file for this question is not provided. We need to enter data into R manually. 
# One simple way is to type the data into vectors (it is a good thing the data are all whole numbers):

Day <- 0:11
Score <- c(0, 195, 351, 503, 683, 847, 1011, 1193, 1378, 1561, 1743, 1925)
LACE <- data.frame(Day, Score)
LACE

# We don't need to attach(LACE), as we already have the columns of this data frame 
# available as separate vectors, which we can simply feed into a simple linear regression
# model and produce some plots to check the assumptions underlying this model:

LACE.lm <- lm(Score ~ Day)
plot(LACE.lm) 

# These diagnostic plots are used to check whether the model assumptions are satisified. 
# We will talk about it in Week 4's lectures. Please review this question after week 4.

# There is a definite pattern in the residuals. The linearity assumption might be violated. 
# You can try models including X^2. Or the error terms might have time dependence as X is day 
# (time series dataset). This is probably because Ian did the first few days of the course 
# at the rate of about once a week, but then had almost a 6 month gap before he completed the later days,
# at the rate of almost one session a day! It would have been good if the LACE system 
# had recorded this addition info (the date on which he did each session), so we could 
# include it in the model.

# This curvature isn't as apparent in a plot of the data and the model, it is quite clear in the residuals.

plot(Day, Score)
abline(LACE.lm)
title("Ian's LACE training results")

# Even though it is not necessarily a "good" model (model assumptions are not satisfied),
# the SLR model is probably still in George Box's class of "useful models", so we will still 
# see what it has to say on the question of whether or not Ian have done better than the 
# typical range. The upper end of this range is 120 points per day, i.e., the question is 
# my slope coefficient greater than 120? This is an alternative hypothesis and the equivalent null 
# hypothesis is beta1 <= 120.
# This is one-sided test.

# We can calculate a standard error for beta1 - this time we will use info stored 
# with the model summary:

summary(LACE.lm)
names(LACE.lm) # to show what elements are stored in LACE.lm
names(summary(LACE.lm)) # to show what elements are stored in summary(LACE.lm)

# Note that we can't use the t statistic and p-value for the slope coefficient 
# from the summary, as this is for a test of H0: beta1 = 0 sv H1: beta1 != 0. 

# We next manually calculate the standard error of the slope coefficient.
# sigma (the square root of the error variance) and the residual degrees of freedom are 
# stored with LACE.lm object:

RMSE <- summary(LACE.lm)$sigma
RMSE

df.resid <- LACE.lm$df.residual # or length(Score)-2
df.resid

# RMSE stands for "root mean square error" and we check this is correct by squaring
# and comparing with the MS for the residuals shown in ANOVA table"

anova(LACE.lm)
RMSE^2

# We still need Sxx to calculate the standard error of the slope coefficient:

Sxx <- sum((Day- mean(Day))^2)
Sxx

SEb1 <- RMSE/sqrt(Sxx)
SEb1

# Which is the correct standard error shown in the summary table. 
# Or we can use the following to get estimated sd of b1 directly
SEb1 <- summary(LACE.lm)$coefficients[2,2]
SEb1

# We can then use this to calculate a standardised test statistic for a test of 
# H0: beta1 <= 120 v.s. HA: beta1 > 120

b1 <- LACE.lm$coef[2]
b1

test.stat <- (b1-120)/SEb1
test.stat


# Using a significance level of alpha=0.05, the one-tailed critical value from 
# a t distribution with 10 degrees of freedom is (recall that HA: beta1 > 120,
# so we want all the rejection region to be in the upper tail):

qt(0.95, df.resid)

# Note with only 10 degrees of freedom, we are NOT guaranteeed any real help 
# from the Central Limit Theorem, so the use of Student's t distribution is making 
# a fairly strong assumption about the error distribution being normal, but that
# assumption (at least) looked OK on the Normal Q-Q plot.

# The observed test statistic 38.20506 >> the critical value 1.812461 or we could 
# calculate a one-tailed p-value for this test statistic:

1 - pt(test.stat, df.resid)

# This p-value is a lot less than alpha = 0.05, so we would reject H0 in favour 
# of HA and conclude that Ian's daily scores were significantly above the typical
# range. 

# We should be cautious with this test result as the residuals plot show the model
# assumptions are satisfied.

