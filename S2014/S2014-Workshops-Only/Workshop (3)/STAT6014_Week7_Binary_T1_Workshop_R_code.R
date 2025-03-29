
## ========STAT6014_Week7_Binary_T1_Workshop_R_code ==============

## Example 1: Calculus Data (Non-aggregate data)
calculus <-read.table("calculus.csv", header = TRUE, sep = ",")
attach(calculus)
# n=30, X=Time, Y = 1/0 = Answer the question correctly/not
length(calculus$Time)
head(calculus,n=14)

# For Issue 1 => Create plot between Xi and Yi - points
plot(Time,Response,ylim=c(-0.5,1),
     
# If use LR: mu_Y = B0+B1*Xi - dashed line
fit<-lm(Response~Time); lines(Time,fit$fitted,lty=2)

# Issue 2: if use LR: mu_Y = B0+B1*Xi to fit the data:
# LHS proxy: sample mean of Y under each Xi level 
# Since all Y=0/1 -> its sample mean belongs to [0,1]
tapply(Response,Time,mean)
# RHS proxy: yi hat = bo+b1*Xi => can be >0 or <0
summary(fit)$coefficients
Time1<-c(0.4,0.625,0.714285714,0.833333333,1,1.25)
+
  summary(fit)$coefficients[2,1]*Time1
# Not fit!May need LHS transformation: from mu_Y to g(mu_Y)



## Example 1 - Calculus (Non-aggregate data) - Prediction:
# n=30, X=Time, Y = 1/0 = Answer the question correctly/not
length(calculus$Time)
head(calculus,n=10)

# [1] fitted: logit(pi_hat) =ln(pi_hat/(1-pi_hat))= b0+b1*X1
# [2] fitted: pi_hat = exp([1] fitted)/(1+exp([1] fitted))
calculus.glmt1<-glm(Response ~ Time, family = binomial)
calculus.glmt1$coefficients
calculus.glmt1<-glm(Response ~ Time, family = binomial(link='logit'))
calculus.glmt1$coefficients
# [2] fitted = exp([1] fitted)/(1+exp([1] fitted))
fitted(calculus.glmt1)[1]
calculus.glmt1$fitted.values[1]

# Create plot between Xi and Yi
plot(Time,Response,ylim=c(-0.5,1))
# Plot T1 (Binary model) => much better than T0 (LR model)
lines(Time,calculus.glmt1$fitted.values,lty=2)

# Odds
# [1] logit(pi_hat) =ln(pi_hat/(1-pi_hat))=ln(odds_hat)= b0+b1*X1
predict(calculus.glmt1)[1]
-6.125247+6.811302*Time[1]
# odds = exp([1])
exp(predict(calculus.glmt1))[1]
# B1 interpretation: 
# With the other variables constant, increase X1 by 1 (from x to x+1) 
# => odds of Y=1 will change by a multiplicative factor of exp(B1)
# exp(b1)
exp(summary(calculus.glmt1)$coefficients[2,1])

# Prediction
# Let Xi=1.5 hours
# [2] fitted = exp([1])/(1+exp([1]))
Xnew<-data.frame(Time=1.5)
Xnew
predict(calculus.glmt1,Xnew,type='response')
exp(-6.125247+6.811302*Xnew)/(1+exp(-6.125247+6.811302*Xnew))
# mu_Y hat = pi hat = 0.98 >1 => Yi hat = 1 =>
# for Xi =1.5 (student who studies 1.5 hours' calculus)
# => will have Yi fitted = 1 (answer the quiz question correctly)

# ---------------------------------------------------------------------

## Example 4: Calculus Data with Gender (Non-aggregate data)

# n=100,X1=Time,X2=gender(0~F,1~M),X3=X1*X2,Y=0/1(answer correctly)
# non-aggregate data
calculus <-read.table("calculus,gender.csv", header = TRUE, sep = ",")
length(calculus$Time)
# X2 = Gender (2 levels - M/F => M=1, F=0 (baseline level))
contrasts(factor(calculus$Gender))
# Convert notations to nonaggregate data form
x1_nonagg<-calculus$Time
x2_nonagg<-calculus$Gender
x3_nonagg<-x1_nonagg * x2_nonagg
y_nonagg<-calculus$Response

# Non-aggregate data (X1,X2,X3,Y)
# n=100,X1=Time,X2=gender(0~F,1~M),X3=X1*X2,Y=0/1(answer correctly)
nonagg<-data.frame(x1_nonagg,x2_nonagg,x3_nonagg,y_nonagg)
head(nonagg,n=17)
attach(nonagg)

# [1] logit(pi) =ln(pi/(1-pi))= B0+B1*X1+B2*X2+B3*X3
# [2] pi = exp([1])/(1+exp([1]))
calculus.glmt1<-glm(y_nonagg ~ x1_nonagg + x2_nonagg + x3_nonagg, 
                    family = binomial)
calculus.glmt1$coefficients
# Dispersion (assumed) = 1
summary(calculus.glmt1)$dispersion
# (Unscaled) Deviance = D
summary(calculus.glmt1)$deviance



## Hypothesis 1 - Individual hypothesis - Wald test (1 single beta)
# Ho: Bi=0; H1:Bi != 0
summary(calculus.glmt1)$coefficients
# vs N(0,1)'s critical value
c(qnorm(0.025), qnorm(0.975))
# If p-value < 5% => Reject Ho
# Assume the sample size is relatively large.



## Hypothesis 2 - Drop in deviance test - 1 single beta
# F:[1] logit(pi) =ln(pi/(1-pi))= B0+B1*X1+B2*X2+B3*X3
calculus.glmt1<-glm(y_nonagg ~ x1_nonagg + x2_nonagg + x3_nonagg, 
                    family = binomial)
# R:[1] logit(pi) =ln(pi/(1-pi))= B0+B1*X1+B2*X2
calculus.glmt12<-glm(y_nonagg ~ x1_nonagg + x2_nonagg, 
                     family = binomial)
# Ho: B3=0 ; H1: >=1 B3 !=0
# Shows unscaled change in deviance and scaled change
# in deviance (by dispersion assumed) p-value from Chisquare
anova(calculus.glmt12,calculus.glmt1,test="Chisq")
# TS = Change in deviance/dispersion(assumed) of full
anova(calculus.glmt12,calculus.glmt1,test="Chisq")$Deviance[2]/
  summary(calculus.glmt1)$dispersion
ts2<-(summary(calculus.glmt12)$deviance-summary(calculus.glmt1)$deviance)/
  summary(calculus.glmt1)$dispersion
ts2
# Vs Chisq,one side,df=# in Ho = 1
# cv (RHS RR=5%)
qchisq(0.95, 1)
# p-values = values from ANOVA table (scaled by dispersion assumed)
1 - pchisq(ts2, 1)




## Hypothesis 3 - Drop in deviance test - All the Bs
# F:[1] logit(pi) =ln(pi/(1-pi))= B0+B1*X1+B2*X2+B3*X3
calculus.glmt1<-glm(y_nonagg ~ x1_nonagg + x2_nonagg + x3_nonagg, 
                    family = binomial)
# R:[1] logit(pi) =ln(pi/(1-pi))= B0
calculus.glmt13<-glm(y_nonagg ~ 1, family = binomial)
# Ho: B1=B2=B3=0; H1: >=1 Bi !=0
# Shows unscaled change in deviance and scaled change
# in deviance (by dispersion assumed) p-value from Chisquare
anova(calculus.glmt13,calculus.glmt1,test="Chisq")
# TS = Change in deviance/dispersion(assumed) of full
anova(calculus.glmt13,calculus.glmt1,test="Chisq")$Deviance[2]/
  summary(calculus.glmt1)$dispersion
ts3<-(summary(calculus.glmt13)$deviance-summary(calculus.glmt1)$deviance)/
  summary(calculus.glmt1)$dispersion
ts3
# Vs Chisq,one side,df=# in Ho = 3
# cv (RHS RR=5%)
qchisq(0.95, 3)
# p-values = values from ANOVA table (scaled by dispersion assumed)
1 - pchisq(ts3, 3)




## Hypothesis 4 - Drop in deviance test - any combination of Bs
# F:[1] logit(pi) =ln(pi/(1-pi))= B0+B1*X1+B2*X2+B3*X3
calculus.glmt1<-glm(y_nonagg ~ x1_nonagg + x2_nonagg + x3_nonagg, 
                    family = binomial)
# R:[1] logit(pi) =ln(pi/(1-pi))= B0+B2*X2
calculus.glmt14<-glm(y_nonagg ~ x2_nonagg, family = binomial)
# Ho: B1=B3=0 ; H1: >=1 Bi !=0
# Shows unscaled change in deviance and scaled change
# in deviance (by dispersion assumed) p-value from Chisquare
anova(calculus.glmt14,calculus.glmt1,test="Chisq")
# TS = Change in deviance/dispersion(assumed) of full
anova(calculus.glmt14,calculus.glmt1,test="Chisq")$Deviance[2]/
  summary(calculus.glmt1)$dispersion
ts4<-(summary(calculus.glmt14)$deviance-summary(calculus.glmt1)$deviance)/
  summary(calculus.glmt1)$dispersion
ts4
# Vs Chisq,one side,df=# in Ho = 2
# cv (RHS RR=5%)
qchisq(0.95, 2)
# p-values = values from ANOVA table (scaled by dispersion assumed)
1 - pchisq(ts4, 2)


