
## R tutorial 3 - Fertility Period vs Cohort 
## DEMO2002 - Population dynamics
## Mar-2025

#### good practice is to load the package first ####

library(ggplot2)

#### data preparation ####
# setwd("   ")

fx<-read.table("CANasfrRR.txt",
                header=TRUE, fill=TRUE, skip=2)

fx$Age[fx$Age=="12-"] <- "12"
fx$Age[fx$Age=="55+"] <- "55"
fx$Age <- as.numeric(fx$Age)

#### calculate TFR for any given year ####

i <-  2019

fx2019 <- fx[fx$Year == i, ]
 

TFR2019 <-  sum(fx2019$ASFR)
MAC2019 <-  sum((fx2019$Age+0.5) * fx2019$ASFR)/ TFR2019
  
#### loop to calculate TFR ####

Year <- unique(fx$Year) 

TFR <- c()

for(i in Year){
  Fx <- fx[fx$Year == i,] 
  tfr_y <-   sum(Fx$ASFR)
  TFR <- c(TFR,  tfr_y)
}

TFR <- data.frame(Year, TFR)

# For the TFR we just created

ggplot(TFR, aes(x=Year,y=TFR))+geom_line()

#### Period & Cohort Comparison ####

fx2<-read.table("CANasfrVV.txt"  ,
                 header=TRUE, fill=TRUE, skip=2)

fx2$ARDY[fx2$ARDY == "12-"] <- "12"
fx2$ARDY[fx2$ARDY == "55+"] <- "55"
fx2$ARDY <- as.numeric( fx2$ARDY)

fx2$Cohort <- gsub("[+]","", fx2$Cohort)
fx2$Cohort <- gsub("[-]","", fx2$Cohort)

fx2$Cohort <- as.numeric( fx2$Cohort)

#### We are gonna look at the Cohort TFR ####

Year2 <- 1921:1965

CTFR <- c()

for (i in Year2) {
  Fx <- fx2[fx2$Cohort == i,]
  ctfr_c<- sum(Fx$ASFR)
  CTFR <- c(CTFR, ctfr_c)
}

CTFR <- data.frame(Year=1921:1965, CTFR)

#### Plotting time! ####

ggplot(TFR,aes(x=Year ,y=TFR,color="Period"))+
  geom_line()+
  theme(aspect.ratio=1)+
  geom_line(CTFR,mapping=aes(x=Year ,y=CTFR,color="Cohort"))+
  scale_color_manual(values = c("navy","red"))+
  labs(title="TFR: Period vs Cohort, Canada (1921-2019)")

ggplot(TFR,aes(x=Year ,y=TFR,color="Period"))+
  geom_line()+
  theme(aspect.ratio=1)+
  geom_line(CTFR,mapping=aes(x=Year+26 ,y=CTFR,color="Cohort"))+
  scale_color_manual(values = c("navy","red"))+
  labs(title="TFR: Period vs Cohort, Canada (1921-2019)")



