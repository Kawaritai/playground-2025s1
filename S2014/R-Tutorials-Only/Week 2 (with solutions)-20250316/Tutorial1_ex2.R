# Exercise 2 of Tutorial 1

# Part (a)

c
t
vector
matrix
number
constant
scalar

help(c)
help(t)
help(vector)
help(matrix)


# Part (b)

search()
ls()
ls(pos=1)
ls(pos="package:datasets")

help(search)
help(ls)
help(Formaldehyde)

# Part (c)

constant1 <- 1
constant1
class(constant1)
help(class)
str(constant1)
help(str)

vector1 <- rep(constant1, 7)
vector1
class(vector1)
str(vector1)
help(rep)

constant2 <- length(vector1)
constant2
class(constant2)
str(constant2)
help(length)

vector2 <- 1:constant2
vector2
class(vector2)
str(vector2)

vector3 <- c(0, 2^(1/3), sqrt(2), 2, 2*2, 2^3, 2^4)
vector3
class(vector3)
str(vector3)
help(sqrt)

tm3 <- mean(vector3, trim=0.25)
tm3
class(tm3)
str(tm3)
help(mean)

vector4 <- seq(28, 1, -3.5)
vector4
class(vector4)
str(vector4)
help(seq)

vector4 <- vector4[1:7]
vector4
class(vector4)
str(vector4)
# vector4 was longer than the others - this command subsets out the first 7 elements

matrix1 <-cbind(vector1, vector2, vector3, vector4)
matrix1
class(matrix1)
str(matrix1)
help(cbind)

constant3 <- ncol(matrix1)
constant3
class(constant3)
str(constant3)
help(ncol)
# similarly, nrow() will give the number of rows in a matrix

matrix2 <- rbind(vector1, vector2, vector3, vector4)
matrix2
class(matrix2)
str(matrix2)

matrix3 <- matrix1 - t(matrix2)
matrix3
class(matrix3)
str(matrix3)

matrix4 <- matrix1 %*% matrix2
matrix4 
class(matrix4)
str(matrix4)

vector4d <- dim(matrix4)
vector4d
class(vector4d)
str(vector4d)
help(dim)

matrix5 <- matrix2 %*% matrix1
matrix5 
class(matrix5)
str(matrix5)

vector5d <- dim(matrix5)
vector5d
class(vector5d)
str(vector5d)
# Matrix multiplication is not transitive; A %*% B does not equal B %*% A

vector6 <- apply(matrix1, 2, mean)
vector6
class(vector6)
str(vector6)
help(apply)
# apply() has been used to calculate the column means of matrix1

matrix6 <- sweep(matrix1, 2, apply(matrix1, 2, mean))
matrix6
class(matrix6)
str(matrix6)
help(sweep)
# sweep() and apply() have been used to "mean-correct" the columns of matrix1

matrix6[3:5,3] <- 0
matrix6
class(matrix6)
str(matrix6)
# this sets the 3rd, 4th and 5th rows of the 3rd column of matrix6 to 0

vector3
median(vector3)
help(median)

sum(vector3)
help(sum)

prod(vector3)
help(prod)

vector4
order(vector4)
help(order)

sort(vector4)
help(sort)

rm(hello)


# Part (d)

square <- function(x) {x*x}
class(square)
square(2)

square <- function(x) {
  y <- x^2
  y
}
square(2)


# Part (e)

help(read.csv)

ws2.women <- read.csv("worksheet2_women.csv", header=F)
ws2.women
str(ws2.women)
attributes(ws2.women)

women
help(women)

names(ws2.women) <- c("Height", "Weight")
ws2.women
attach(ws2.women)
search()
ls(pos=2)

Height
Weight


# Part (f)

summary(ws2.women)
hist(Height)
hist(Weight)
boxplot(Height, Weight)
plot(ws2.women)

help(par)
help(plot)
help(hist)
help(barplot)

women.lm <- lm(Weight ~ Height)
attributes(women.lm)

plot(women.lm)
anova(women.lm)
summary(women.lm)

plot(Height, Weight, xlab="Height (in cm)", ylab="Weight (in kg)")
title("Sample of 10 women")
abline(women.lm$coef)

help(abline)

# We need to develop criteria for what makes a "good" model and learn how
# to correctly assess the R output before we can really address the questions
# asked at the end of this exercise. This is exactly what we will be doing
# for most of the rest of this course.

