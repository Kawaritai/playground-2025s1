## R tutorial 1 - Getting started with R
## DEMOGRAPHY
## Feb-2025

## Welcome to the magical world of R
## It's a calculator, a spreadsheet, a painter, and many more.

#### vectors ####

## Objects

# a <- 
##   Vectors (are made of elements that are all 
##   of the same type, for example characters, 
##   numbers,...)


# vec1 <-  

## must of the same type
## notice the indicator ("num","int","chr")

## what if we don't do numbers, it's called strings

# vec2 <- 


## Sequence function: create a vector from 0 to 25 
## with a distance of 5 between each element

# vec3 <- 

## Repeat function: repeat the number 5 for 7 times

# vec4 <- 

## also works for characters

# vec5 <- 


#### Data Frames ####

##  We cannot put numbers and characters together in vectors.
##  But we can with data.frame
# setwd("      ")

## You can also set the working directory by going to: session > 
## set working directory > choose working directory

## import data
data <- read.table("Population.csv", header = TRUE, sep=",") 
data <- NULL
data <- read.csv("Population.csv")

## For importing text files
## header is to incorporate column names,
## skip is to avoid title,
## sep is to separate value.

data

##  This is a data.frame, it contains a vector for each column
##  Think of it intuitively as a table.

## extract vectors from data frame

Country <-  data$Country
Pt1 <-  data$Pt1

#### Calculations ####

##  Balance equation

##  Compute Pt2

B <-   data$B
D <-   data$D
M <-   data$M

Pt2 <-  Pt1 + B - D + M

data$Pt2 <-  Pt2

## Move on to rates

## Person years = Exposure
PY <-  (Pt2 + Pt1)/2

## Crude growth rates (CGR)
CGR <-  (Pt2 - Pt1)/PY * 1000

## Crude birth rates (CBR)
CBR <-  B/PY * 1000

## Crude death rates (CDR)
CDR <-  D/PY * 1000

## Crude rate of natural increase (CRNI)
CRNI <-  (B-D)/PY * 1000

## Crude net migration rate (CRNM)
CRNM <-  M/PY * 1000

 #### data presentation ####

mtx <- matrix(
  c(CBR, CRNM), 3, 2,
  dimnames = list(Country, c("CBR", "CRNM"))
)

mtx <- t(mtx)
par(mar=c(6,6,6,6), xpd=TRUE)
barplot(
  mtx,
  beside = TRUE,
  main = "Principal Period Rates of Countries",
  xlab = "Country",
  ylab = "Rate per 1000",
  col = c("chocolate", "turquoise"),
  names.arg = colnames(mtx),
  legend.text = rownames(mtx),
  args.legend = list(x="topright", inset=c(-1,0))
)

legend("topright", inset=c(-0.22,0), legend=rownames(mtx), fill=c("chocolate", "turquoise"), density=NA)

#### recap! ####

## 1. What is a data.frame?
## 2. How to read data?
## 3. How to do calculations with vectors?
## 4. barplot!