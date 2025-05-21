
## R tutorial  - Population projection
## DEMO
## 

Names<-c("DNK")
Names2<-c("Denmark")


options(scipen=1000000)

library(ggplot2)

#### Births ####

B<-read.table("Births.txt",
              header=TRUE,fill=TRUE,skip=1, as.is=TRUE) # birth
B<-B[B$Year==YEAR,] # birth in YEAR of 2018

#### Migration ####

Migration_est <- function(Pop,mlt,flt,year){
  
  Sx_m <- mlt[mlt$Year==year,]
  Sx_m <- ifelse(Sx_m$Lx[-111]>0, Sx_m$Lx[-1]/Sx_m$Lx[-111],0)
  
  Sx_f <- flt[flt$Year==year,]
  Sx_f <- ifelse(Sx_f$Lx[-111]>0, Sx_f$Lx[-1]/Sx_f$Lx[-111], 0)
  
  Pop_diff_f <- Pop[Pop$Year==year+1,]$Female[-1] - 
                Pop[Pop$Year==year,]$Female[-111] * Sx_f
  
  Pop_diff_f <- c(Pop_diff_f,0)
  Pop_diff_f <- (Pop_diff_f[-1]+Pop_diff_f[-111])/2
  Pop_diff_f <- c(Pop_diff_f,0)
  
  Pop_diff_m <-
    Pop [Pop$Year == year+1,]$Male[-1] -
    Pop [Pop$Year == year, ]$Male[-111]*Sx_m
    
  Pop_diff_m <- c(Pop_diff_m,0)
  Pop_diff_m <- (Pop_diff_m[-1]+Pop_diff_m[-111])/2
  Pop_diff_m <- c(Pop_diff_m,0)
  
  MAX <- max(Pop_diff_m,Pop_diff_f)
  MIN <- min(Pop_diff_m,Pop_diff_f)
  plot(c(0,110),c(MIN,MAX),type="l",col=0)
  lines(Pop_diff_f,col="red")
  lines(Pop_diff_m,col="blue")
  abline(h=0)
  legend("topright",legend=c("male","female"),
         col=c("blue","red"),pch=15)
  
  Mig <- data.frame(
    age = 0:110,
    Female = Pop_diff_f,
    Male = Pop_diff_m
  )
  
  return(Mig)
}

Mig <- Migration_est(Pop,mlt=lm,flt=l,YEAR)

#### Fertility and Births ####


f0 <- read.table(paste(Names,"asfrRR.txt",sep=""),
                 header=TRUE, fill=TRUE,skip=2) #period asfr by year and age (Lexis squares) for all countries

f <- f0[f0$Year == YEAR,]  # all on the year of selection 2018

Fe <- c(rep(0,12),f$ASFR,rep(0,(110-55)))

### line1: a combination of fertility and survival information
### for the first row of the matrix which returns the number 
### of babies when multiplied by the population it is also (110 long ### i.e. skip the last value)


SRB <- B$Male/B$Female

L1 <- l$Lx[1]/(2*l$lx[1])
L1m <- lm$Lx[1]/(2*lm$lx[1])

k <- L1/(1+SRB) # this is for female babies

km<-(L1m*SRB)/(1+SRB) # for estimating male babies

line1<-(Fe[-1] * Sx +Fe[-111]) # this is for female survivor and baby survivors
