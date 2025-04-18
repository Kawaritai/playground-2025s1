install.packages("neuralnet")
install.packages("sigmoid")
library(neuralnet)
library(sigmoid)

weather <- read.csv("weather.csv")


data <- subset(weather, select=c("WindSpeed9am", "Humidity9am", "Pressure9am", "Cloud9am", "Temp9am", "Temp3pm"))

head(data)

## STEP 1: Objective: predict `Temp3pm`

# Neural net can't handle missing information
# Note the meaningfulness of doing such an action
data[is.na(data)] <- 0

# Divide data set into training and test data sets
index <- sample(1:nrow(data),round(0.75*nrow(data))) # 75%
train <- data[index,] # 75%
test <- data[-index,] # 25%

# (Neural nets) Normalise attributes
maxs <- apply(data, 2, max) 
mins <- apply(data, 2, min)
scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))

# Split data into scaled sets
train_ <- scaled[index,]
test_ <- scaled[-index,]

## OBJ:  predict Temp3pm using WindSpeed9am, Humidity9am, Pressure9am, Cloud9am, and Temp9am attributes.
f <- "Temp3pm ~ WindSpeed9am + Humidity9am + Pressure9am + Cloud9am + Temp9am"
nn <- neuralnet(f,data=train_,hidden=c(4,3), act.fct = relu, linear.output=T)
# 2 hidden layers with 5 units then 3 units; logistic activation function; train_ as training set

plot(nn)

# EX: Predict Temp3pm - but, this is scaled!
pr.nn <- compute(nn,test_[,1:5])

# Re-scale to original
pr.nn_ <- pr.nn$net.result*(max(data$Temp3pm)-min(data$Temp3pm))+min(data$Temp3pm)
test.r <- (test_$Temp3pm)*(max(data$Temp3pm)-min(data$Temp3pm))+min(data$Temp3pm)

# Compare predicted to true values in test dataset
plot(test$Temp3pm,pr.nn_,col='red',main='Real vs predicted NN',pch=18,cex=0.7)


# Average Absolute Difference, MAE
MAE.nn <- sum(abs(test.r - pr.nn_))/nrow(test_)
print(MAE.nn)


## STEP 2: NOW train a linear model rather than a neural net
lm.fit <- glm(f, data=train) # Huh, a glm
# No need for a scaling step
pr.lm <- predict(lm.fit, test)

summary(lm.fit)

# But we do still have MAE for lms
MAE.lm <- sum(abs(pr.lm - test$Temp3pm))/nrow(test)
print(MAE.lm)

# The lm seems to be lower. 

## STEP 3: COMPARE
par(mfrow=c(1,2))

plot(test$Temp3pm,pr.nn_,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='NN',pch=18,col='red', bty='n')

plot(test$Temp3pm,pr.lm,col='blue',main='Real vs predicted lm',pch=18, cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='LM',pch=18,col='blue', bty='n', cex=.95)



