# R code for Sample Assignment 1

# Assuming you have already run followed the assignment instructions
# and run install.packages() to install the faraway library:

library(faraway)

# Or you could download the data from Wattle and then read it in:

# prostate <- read.csv("prostate.csv", header=T)
# teengamb <- read.csv("teengamb.csv", header=T)

prostate
help(prostate)
attach(prostate)

teengamb
help(teengamb)
attach(teengamb)

# Q1 (a)

plot(lcavol,lpsa, main="Relationship between prostate specific antigen test\n and cancer tumour volume", xlab="log(Cancer Volume)", ylab="log(PSA)")
cor.test(lcavol, lpsa)

# Q1 (b)

prostate.lm <- lm(lcavol ~ lpsa)
prostate.lm

plot(prostate.lm, which=1)
plot(prostate.lm, which=2)

barplot(hatvalues(prostate.lm), main="Leverage plot of the hat values")
abline(h=4/length(lpsa))

# Q1 (c)

anova(prostate.lm)

# Q1 (d)

summary(prostate.lm)
exp(prostate.lm$coef)

# Q1 (e)

range(lpsa)
lpsa.values <- -20:120/20
lpsa.values

cintervals <- predict(prostate.lm, newdata=data.frame(lpsa=lpsa.values), interval="confidence")
cintervals

plot(lpsa, lcavol, main="Relationship between cancer tumour volume\n and prostate specific antigen test", xlab="log(PSA)", ylab="log(Cancer Volume)")
abline(prostate.lm$coef)
lines(lpsa.values, cintervals[,"lwr"], lty=2)
lines(lpsa.values, cintervals[,"upr"], lty=2)
legend(-0.63, 4, c("SLR Model", "95% Confidence Intervals"), lty=1:2)

# This is the bit you were told NOT to do in the question:
pintervals <- predict(prostate.lm, newdata=data.frame(lpsa=lpsa.values), interval="prediction")
pintervals
# lines(lpsa.values, pintervals[,"lwr"], lty=3)
# lines(lpsa.values, pintervals[,"upr"], lty=3)

# Also not a required part of the assignment, but here is the 
# above plot back-transformed to the original (non-log) scale:

plot(exp(lpsa), exp(lcavol), main="Relationship between cancer tumour volume\n and prostate specific antigen test", xlab="PSA (ng/ml)", ylab="Cancer Volume (ml)")
lines(exp(lpsa.values), exp(cintervals[,"fit"]))
lines(exp(lpsa.values), exp(cintervals[,"lwr"]), lty=2)
lines(exp(lpsa.values), exp(cintervals[,"upr"]), lty=2)
lines(exp(lpsa.values), exp(pintervals[,"lwr"]), lty=3)
lines(exp(lpsa.values), exp(pintervals[,"upr"]), lty=3)
legend(164, 4, c("SLR Model on log-log scale", "95% Confidence Intervals", "95% Prediction Intervals"), lty=1:3)

# Q2 (a)

plot(income, gamble, main="Teenage gambling in Britain", xlab="Income (pounds/week)", ylab="Expenditure on gambling (pounds/year)")

# Q2 (b)

gamble.lm <- lm(gamble ~ income)
gamble.lm
abline(gamble.lm$coef)

plot(gamble.lm, which=1)
plot(gamble.lm, which=2)
plot(gamble.lm, which=4)
barplot(hatvalues(gamble.lm), main="Leverage plot of the hat values")
abline(h=4/length(income))

# Q2 (c)

range(income)
range(gamble)

log(gamble)

gambleGE1 <- gamble[gamble>=1]
income_gGE1 <- income[gamble>=1]

length(gambleGE1)
range(gambleGE1)
length(income_gGE1)
range(income_gGE1)

log_gambleGE1 <- log(gamble[gamble>=1])
log_income_gGE1 <- log(income[gamble>=1])
gambleGE1.lm <- lm(log_gambleGE1 ~ log_income_gGE1)

plot(log_income_gGE1, log_gambleGE1)
abline(gambleGE1.lm$coef)

plot(gambleGE1.lm, which=1)
plot(gambleGE1.lm, which=2)
plot(gambleGE1.lm, which=4)

# Q2 (d)

anova(gambleGE1.lm)
summary(gambleGE1.lm)
exp(gambleGE1.lm$coef)

#Q2 (e)

incomes <- c(1,5,20)
log_incomes <- log(incomes)
log_incomes

predictions <- predict(gambleGE1.lm, newdata=data.frame(log_income_gGE1=log_incomes), interval="prediction")
predictions
exp(predictions)

# Not a required part of the assignment, but here is a plot of the
# data, the model and the above predictions on the original scale:

loginc <- log(1:210/10)
p_int <- predict(gambleGE1.lm, newdata=data.frame(log_income_gGE1=loginc), interval="prediction")
p_int

plot(c(1,max(incomes)), c(1,200), type="n", main="Teenage gambling in Britain", xlab="Income (pounds/week)", ylab="Expenditure on gambling (pounds/year)")
points(income, gamble)
points(income_gGE1, gambleGE1, pch=19)
lines(1:210/10, exp(p_int[,"fit"]))
lines(1:210/10, exp(p_int[,"lwr"]), lty=2)
lines(1:210/10, exp(p_int[,"upr"]), lty=2)
lines(c(incomes[1],incomes[1]),c(exp(predictions)[1,"lwr"],exp(predictions)[1,"upr"]), lty=2)
lines(c(incomes[2],incomes[2]),c(exp(predictions)[2,"lwr"],exp(predictions)[2,"upr"]), lty=2)
lines(c(incomes[3],incomes[3]),c(exp(predictions)[3,"lwr"],exp(predictions)[3,"upr"]), lty=2)
legend(10,205,c("SLR model on log-log scale","Selected 95% prediction intervals","Observations not used in model"),lty=c(1,2,NA), pch=c(NA,NA,"O"))
