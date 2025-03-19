## DEMO R session

## In this program we will be creating a life table

## we download the HMD data for Australian males life tables 
## read qx and try to reproduce the original lx and dx 

library(ggplot2)

options(scipen=5)

#### data from HMD

# setwd("   ")

LT<-read.table("fltper_1x1", header=TRUE, skip=2, fill=TRUE)

LT$Age[LT$Age=="110+"] <- 110
LT$Age <- as.numeric(LT$Age)

LT_sub<-LT[LT$Year=="2020",]

## first select the probability of dying qx and plot both
Mx <- data.frame(Age = 0:110 ,qx =  LT_sub$qx)

ggplot(Mx,aes(x=Age,y= qx))+geom_line()


ggplot(Mx,aes(x=Age ,y= qx))+geom_line()+
  scale_y_continuous(trans = "log10")+
  theme_bw()


## now the number of survivorså
## first probability of surviving

lx <- 100000

px<- 1-Mx$qx

for(y in 1:110){
  lx[y+1]<- lx[y] * px[y]      
}

Mx$lx <-  lx

ggplot(Mx,aes(x=Age,y= lx))+geom_line()

## finally we calculate the distribution of deaths

dx <-  Mx$lx * Mx$qx

Mx$dx <-  dx

ggplot(Mx,aes(x= Age,y= dx))+geom_line()

## reading the two end years
## Australia in 1921 and 2020

#### or everything as a function

LifeTable<-function(qx){
  lx <- 100000
  px <- 1-qx
  
  for(y in 1:110){
    lx[y+1]<- lx[y] * px[y]
  }
  dx <- lx*qx
  
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
  geom_line(LT1,mapping = aes(x=Age,y=qx,color="1921"))+
  geom_line(LT2,mapping = aes(x=Age,y=qx,color="2020"))+
  scale_y_continuous(trans = "log10")+
  scale_color_manual(values=c("blue","red"))+
  labs(x = "Age",y="qx")+theme_bw()

###############

LT_A<-LifeTable(LT1$qx)
LT_B<-LifeTable(LT2$qx)

ggplot()+
  geom_line(LT_A, mapping = aes(x = Age, y = lx, color = "1921"))+
  geom_line(LT_B, mapping = aes(x = Age, y = lx, color = "2020"))+
  scale_color_manual(values = c("navy","red"))+
  guides(color = guide_legend(title = "Year"))+
  labs(x = "Age", y = "lx")+theme_bw()

## and plotting them together, dx

ggplot()+
  geom_line(LT_A, mapping = aes(x = Age, y = dx, color = "1921"))+
  geom_line(LT_B, mapping = aes(x = Age, y = dx, color = "2020"))+
  scale_color_manual(values = c("navy","red"))+
  guides(color = guide_legend(title = "Year"))+
  labs(x = "Age", y = "dx")+theme_bw()

