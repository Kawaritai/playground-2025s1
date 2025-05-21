## Midterm exam
options(scipen=6)
setwd("C:/Users/u1019088/OneDrive - Australian National University/Courses/DEMO2002/2025/midterm")



########################################################

## now question 2

AUS<-read.table("AUS.txt",header=TRUE)

######## Answer question 2

P<-AUS$Population
B<-AUS$Births
D<-AUS$Deaths
  
N<-length(P)
Year<-AUS$Year[-N]

NM<-P[-1]-P[-N]-B[-N]+D[-N]

Y1<-Year[which(NM==max(NM))]
Y2<-Year[which(NM==min(NM))]
Migra<-cbind(Year,NM)
Migra[Migra[,1]==Y2,]
Migra[Migra[,1]==Y1,]


plot(Year,NM,type="l",col="red")
abline(v=Y1,lty=2,col="blue")
abline(v=Y2,lty=2,col="blue")
abline(h=0)



PY<-(P[-1]+P[-N])/2

CBR<-B[-N]/PY*1000
CDR<-D[-N]/PY*1000
CNMR<-NM/PY*1000
CGR<-(P[-1]-P[-N])/PY*1000

AUSR<-data.frame(Year,CBR,CDR,CNMR,CGR)


library(ggplot2)

## plot Population Rates
ggplot()+
  geom_line(AUSR,mapping=aes(x=Year,y=CBR,color="CBR"))+
  geom_line(AUSR,mapping=aes(x=Year,y=CDR,color="CDR"))+
  geom_line(AUSR,mapping=aes(x=Year,y=CNMR,color="CNMR"))+
  geom_line(AUSR,mapping=aes(x=Year,y=CGR,color="CGR"))+
  scale_color_brewer(type = "qual",palette = 2)+
  guides(color = guide_legend(title="Rates"))+
  theme_bw()+
  labs(x="Year",y="Rates (per 1000)")+
  ggtitle("Australian population trends,1921-2021.")


########################################################

## now question 3

ASFR1<-read.table("ASFR1.txt",header=TRUE)

######## Answer question 3

### we are going to use our life table function from lecture 5
### changing a couple of things

LifeTableMx<-function(mx){ ## do not need sex
   
  N<-length(mx)
  
  ## that was the hint no need to worry about the ax as in mortality 
  ax<-rep(0.5,N) 
   
  qx<-mx/(1+(1-ax)*mx) 
  
  ### For mortality with the last value of qx = 1... here NOT
  ## qx[N] <- 1
   
  px<-1-qx
   
  lx<-100000
  
  for(y in 1:(N-1)){          
    lx[y+1]<-lx[y]*px[y]
  }
   
  dx<-lx*qx
   
  Lx<-lx[-1]+ax[-N]*dx[-N] 
   
  Lx[N]<-lx[N] ### this reduces to lx in the last age-group since nobody is having children at ages 55+                
   
  Tx<-c() 
  for(y in 1:N){
    Tx[y]<-sum(Lx[y:N]) 
  }
  
  Tx<-Tx-Tx[N] ### since our interest is of life expectancy between ages 12 and 55, 
               ### we subtract the last value
  
  ex<-Tx/lx 
  
  Age<-12:55    ### we also change the age          
  
  ALL<-data.frame(Age,mx,lx,dx,Lx,Tx,ex)
  return(ALL)
}

US<-ASFR1[ASFR1$Pop=="USA",]
SK<-ASFR1[ASFR1$Pop=="KOR",]

LTUS<-LifeTableMx(US$ASFR1)
LTSK<-LifeTableMx(SK$ASFR1)

## plot 1

library(ggplot2)

ggplot()+
  geom_line(LTUS,mapping=aes(x=Age,y=lx,color="USA"))+
  geom_line(LTSK,mapping=aes(x=Age,y=lx,color="KOR"))+
  scale_color_brewer(type = "qual",palette = 2)+
  guides(color = guide_legend(title="Survivors"))+
  theme_bw()+
  labs(x="Age",y="Survivors")+
  ggtitle("South Korea vs USA ASFR1 Life Table Survivors.")


## plot 2

ggplot()+
  geom_line(LTUS,mapping=aes(x=Age,y=dx,color="USA"))+
  geom_line(LTSK,mapping=aes(x=Age,y=dx,color="KOR"))+
  scale_color_brewer(type = "qual",palette = 2)+
  guides(color = guide_legend(title="Decrements"))+
  theme_bw()+
  labs(x="Age",y="Decrements")+
  ggtitle("South Korea vs USA ASFR1 Life Table Decrements.")



## Table

TFRUS<-round(sum(US$ASFR),2)
TFR1US<-round(sum(US$ASFR1),2)
MACUS<-round(sum(((12:55)+0.5)*US$ASFR)/TFRUS,2)
MAC1US<-round(sum(((12:55)+0.5)*US$ASFR1)/TFR1US,2)
PFRCUS<-round(LTUS$lx[44]/1000,2)
LEUS<-round(LTUS$ex[1],2)


TFRSK<-round(sum(SK$ASFR),2)
TFR1SK<-round(sum(SK$ASFR1),2)
MACSK<-round(sum(((12:55)+0.5)*SK$ASFR)/TFRSK,2)
MAC1SK<-round(sum(((12:55)+0.5)*SK$ASFR1)/TFR1SK,2)
PFRCSK<-round(LTSK$lx[44]/1000,2)
LESK<-round(LTSK$ex[1],2)

Table<-cbind(c("USA",TFRUS,TFR1US,MACUS,MAC1US,PFRCUS,LEUS),
             c("KOR",TFRSK,TFR1SK,MACSK,MAC1SK,PFRCSK,LESK))

rownames(Table)<-c("Population","TFR","TFR1","MAC","MAC1","PFRC","LE")

Table
