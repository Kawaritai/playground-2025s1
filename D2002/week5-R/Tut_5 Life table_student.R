# DEMO R session

## In this program we will be creating a full life table

## we download the HMD data for French females life tables 
## read the first three columns for year, age and mx 

# the value is either "f" or "m"
sex <-"m"
options(scipen = 5) # prevent scientific notation

# setwd("C:/Users/u1019088/OneDrive - Australian National University/Courses/DEMO8008/2025/Day 5")

## Period data
Mx <- read.table("den_mltper_1x1.txt", header=TRUE, fill=TRUE, skip=2)[,1:3]

data <- read.table("den_mltper_1x1.txt", header=TRUE, fill=TRUE, skip=2)

Mx$Age[Mx$Age=="110+"] <- 110
Mx$Age <- as.numeric(Mx$Age)

## Cohort data
# Mx2 <- read.table("fltcoh_1x1.txt", header=TRUE, fill=TRUE, skip=2)[,1:3]
# 
# Mx2$Age[Mx2$Age=="110+"] <- 110
# Mx2$Age <- as.numeric(Mx2$Age)
# 
# Mx2$mx <- as.numeric(Mx2$mx)



#### Putting it into a function ####

LifeTableMx<-function(mx,sex){
  
  ### N is the number of ages that we have or length(mx)
  N<-length(mx)
  
  # person years lived by those dying in the interval
  # If x > 0, then ax = 0.5
  ax<-rep(0.5, N) 
  
  ## for the first age ax  depends on infant mortality and sex
  if(sex=="m"){
    ax[1]<-ifelse(mx[1]<0.107,0.045+mx[1]*2.684,0.330)}
  if(sex=="f"){
    ax[1]<-ifelse(mx[1]<0.107,0.053+2.800*mx[1],0.350)
  }
  
  ## transform from death rates to probabilities of dying
  qx<- mx / (1 + (1 - ax) * mx)
    
    ### with the last value of qx = 1
    qx[N] <- 1
    
    ## Probability of surviving
    px<- 1 - qx
    
    ## calculating the survival function
    lx<-100000
  
  for(y in 1:(N-1)){          
    lx[y+1]<-lx[y]*px[y]
  }
  
  ## the distribution of deaths
  dx<- qx * lx
    
    ## the life tables person-years depends on lx, dx and ax
    Lx<- (lx - dx) + ax * dx
    
    ## and Lx for the last age-group
    Lx[N]<-ifelse(mx[N]>0,mx[N],0)                  
  
  ## person-years from a given age upwards
  Tx<-c() 
  for(y in 1:N){
    Tx[y]<- sum(Lx[y:N])
  }
  
  ## finally life expectancy
  
  ex<- Tx / lx
    
  
  Age<-0:110              
  
  # ALL<-data.frame(Age,mx,lx,dx,Lx,Tx,ex)
  ALL<-data.frame(Age, mx, qx, ax, lx, dx, Lx, Tx, ex)
  return(ALL)
}

#### loop for period life expectancy ####

LT_p <- c()

for (x in unique(Mx$Year)){
  mx <- Mx[Mx$Year==x,]$mx
  lt_x <- LifeTableMx(mx, sex)
  lt_x$Year <- x
  LT_p <- rbind(LT_p,lt_x)
}

#### loop for cohort life expectancy ####

# LT_c <- c()
# 
# for (y in unique(Mx2$Year)){
#   mx2 <- Mx2[Mx2$Year==y,]$mx
#   lt_y <- LifeTableMx(mx2, sex)
#   lt_y$Year <- y
#   LT_c <- rbind(LT_c,lt_y)
# }

#### Visualization ####

library(ggplot2)


## plot life expectancy at age 0, 30 and 80
ggplot()+
  geom_line(data[data$Age==0,],
            mapping=aes(x=Year, y=ex, color="e(0) at age 0"))+
  geom_line(data[data$Age==30,],
            mapping=aes(x=Year, y=ex, color="e(30) at age 30"))+
  geom_line(data[data$Age==80,],
            mapping=aes(x=Year, y=ex, color="e(80) at age 80"))+
  scale_x_continuous(n.breaks = 10)+
  scale_y_continuous(breaks = seq(0,110,10),limits = c(0,100))+
  scale_color_brewer(type = "qual",palette = 2)+
  guides(color = guide_legend(title="Measures"))+
  theme_bw()+
  labs(x="Year",y="Life expectancy", title="Life expectancy of Males in Denmark (1835-2023)")



## plot period vs cohort life expectancy
ggplot()+
  geom_line(LT_p[LT_p$Age==0,],
            mapping=aes(x=Year,y=ex,color="Period"))+
  geom_line(LT_c[LT_c$Age==0,], 
            mapping=aes(x=Year,y=ex,color="Cohort"))+
  scale_x_continuous(n.breaks = 10)+
  scale_y_continuous(breaks = seq(0,110,10),limits = c(0,100))+
  scale_color_brewer(type = "qual",palette = 2)+
  guides(color = guide_legend(title="Measures"))+
  theme_bw()+
  labs(x="Year",y="Life expectancy")

