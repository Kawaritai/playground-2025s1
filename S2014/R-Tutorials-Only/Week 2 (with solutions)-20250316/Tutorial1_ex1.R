# Exercise 1 of Tutorial 1

# Part (a)

2 + 2
2 * 2
sqrt(4)
abs(4)
abs(-4)
log(4)
log(4, base=2)
4 > 2
4 < 2
4 < 2 || 4 > 2
qnorm(0.025)
qnorm(0.975)


# Part (b)

help(log)

# The default for the log() function is to compute logarithms to the base e, 
# i.e. natural logarithms, which are using referred to as ln in mathematics.
# If you want common logarithms (logs to the base 10), you can use log10(number) or
# log(number, base=10) and if you want binary logarithms use log(number, base=2).


# Also try the help files for the other new commands:

help(sqrt)
help(qnorm)


# Part (c)

getwd()

# Reset the working directory to whatever new file space you decide to create:

setwd("H:/My Documents/STAT2008-6038 RM/Tutorials/Tutorial 0")


# Part (d)

hello<-function() cat("Hello, world!\n")

hello()

# Part (e)

q()