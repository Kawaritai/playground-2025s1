
## R tutorial 2 
## DEMO2002 - Visualizing Population dynamics
## Feb-2025

## three tips to success in R

## 1. It's Okay if you have to Google it or AI it
## 2. Use the help() function, a life saver!
## 3. There are always more than one way to do things

## download HFD data from 
## https://www.humanfertility.org/ 
## Select country (USA) -> Age-specific data

# Set working directory and load the file
# Or you can create a project

#### data preparation ####

# setwd() 

fx<-read.table("USAasfrRR.txt",
               header=TRUE  ,fill=TRUE ,skip=2 )

fxukr <- read.table("UKRasfrRR.txt",
                    header = TRUE, fill=TRUE, skip=2)

# when reading this data, how do we take off the title?
# How do we handle the column names, and empty cell?

## Age is a factor variables that needs to be 
## transformed into numeric 
## Let's start by changing the "problematic values"

fx$Age <- as.character(fx$Age)
fx$Age[fx$Age == "12-"] <- "12"
fx$Age[fx$Age == "55+"] <- "55"
fx$Age <- as.numeric(fx$Age)

fxukr$Age <- as.character(fxukr$Age)
fxukr$Age[fxukr$Age == "12-"] <- "12"
fxukr$Age[fxukr$Age == "55+"] <- "55"
fxukr$Age <- as.numeric(fxukr$Age)

# Select the year of interest
fx2017 <- fx[ fx$Year== "2017",]


#### plotting the value using ggplot2 ####

# install.packages("ggplot2")

library(ggplot2)
# This is a package, it helps you do things faster
# without having to write a whole bunch of unnecessary codes

ggplot()

# we can plot age profile of fertility


ggplot(data = fx2017)+
  geom_line(aes(x=Age,y=ASFR))

## Now what if we need colors to tell the story across time?

help("scale_color_continuous")

ggplot(data = fx)+
  geom_line(aes(x=Age,y=ASFR,group=Year, color=Year))+
  scale_color_continuous(type = "viridis")

## color is for points and lines, fill is for areas!

ggplot(data= fx)+
  geom_raster(aes(x=Year, y=Age, fill=ASFR))+
  scale_fill_gradientn(colors=c("navy","blue","skyblue",
                                "beige","yellow",
                                "gold","orange","red"))+
  labs(x="Period",y="Age",
       title = "Lexis Surface for ASFR, USA 1933-2022")

ggplot()
ggplot(data= fxukr)+
  geom_raster(aes(x=Year, y=Age, fill=ASFR))+
  scale_fill_gradientn(colors=c("navy","blue","skyblue",
                                "beige","yellow",
                                "gold","orange","red"))+
  geom_vline(xintercept=1970, linetype=2, col="tan", lwd=1.5)+
  theme(aspect.ratio=1)+
  scale_x_continuous(breaks = seq(min(fxukr$Year), max(fxukr$Year), 2))+
  scale_y_continuous(breaks=seq(min(fxukr$Age), max(fxukr$Age), 2))+
  labs(x="Period",y="Age",
       title = "Lexis Surface for ASFR, Ukraine 1959-2013")



#### Recap! ####

## 1. What is a package?
## 2. What do you have to specify in ggplot every time?
## Answer: ggplot(), x and y, and your plotting function
## 3. How to control axis and  colors in ggplot2?
