## DEMO R session

## In this program we will be creating a life table

## we download the HMD data for Australian males life tables 
## read qx and try to reproduce the original lx and dx 

library(ggplot2)

options(scipen=5)

#### data from HMD

setwd("   ")

LT<-read.table( )

LT$Age[LT$Age==" "] <-  
LT$Age <- as.numeric( )

LT_sub<-LT[LT$Year==  ,]

## first select the probability of dying qx and plot both
Mx <- data.frame(Age =  ,qx =  )

ggplot( ,aes(x= ,y= ))+geom_line()


ggplot( ,aes(x= ,y= ))+geom_line()+
  scale_y_continuous(trans = "log10")+
  theme_bw()


## now the number of survivors
## first probability of surviving

lx <- 

px<-

for(y in 1:110){
  lx[ ]<-      
}

Mx$lx <-  

ggplot( ,aes(x= ,y= ))+geom_line()

## finally we calculate the distribution of deaths

dx <-  

Mx$dx <-  

ggplot( ,aes(x= ,y= ))+geom_line()

## reading the two end years
## Australia in 1921 and 2020

#### or everything as a function

LifeTable<-function(   ){
  
  Age<-0:110
  
  ALL<-data.frame(Age = Age, qx = qx,
                  lx = lx,dx = dx)
  
  return(ALL)
}



## reading the two end years
## Australia in 1921 and 2020


LT1<-LT[LT$Year=="1921",]
LT2<-LT[LT$Year=="2020",]

ggplot()+
  geom_line(,mapping = aes(x=,y=,color=""))+
  geom_line(,mapping = aes(x=,y=,color=""))+
  scale_y_continuous(trans = "log10")+
  scale_color_manual(values=c("blue","red"))+
  labs(x = "Age",y="qx")+theme_bw()

###############

LT_A<-LifeTable()
LT_B<-LifeTable()

ggplot()+
  geom_line(, mapping = aes(x = , y = , color = ""))+
  geom_line(, mapping = aes(x = , y = , color = ""))+
  scale_color_manual(values = c("navy","red"))+
  guides(color = guide_legend(title = "Year"))+
  labs(x = "Age", y = "lx")+theme_bw()

## and plotting them together, dx

ggplot()+
  geom_line(, mapping = aes(x = , y = , color = ""))+
  geom_line(, mapping = aes(x = , y = , color = ""))+
  scale_color_manual(values = c("navy","red"))+
  guides(color = guide_legend(title = "Year"))+
  labs(x = "Age", y = "dx")+theme_bw()

