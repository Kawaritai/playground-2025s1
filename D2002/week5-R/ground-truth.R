# Life Table Calculation
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
  
  ## 1. GET qx
  qx<- mx / (1 + (1 - ax) * mx)
  
  ### with the last value of qx = 1
  qx[N] <- 1
  
  ## 2. GET px
  px<- 1 - qx
  
  ## 3. CALCULATE lx
  lx<-100000
  
  for(y in 1:(N-1)){          
    lx[y+1]<-lx[y]*px[y]
  }
  
  ## 4. GET dx
  dx<- qx * lx
  
  ## 5. CALCULATE Lx
  Lx<- (lx - dx) + ax * dx
  
  ## and Lx for the last age-group
  Lx[N]<-ifelse(mx[N]>0,mx[N],0)                  
  
  ## 5. CALCULATE Tx
  Tx<-c() 
  for(y in 1:N){
    Tx[y]<- sum(Lx[y:N])
  }
  
  ## 6. EASY, LIFE EXPECTANCY!
  
  ex<- Tx / lx
  
  ## Hmm, Age last. 
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

LT_c <- c()

for (y in unique(Mx2$Year)){
  mx2 <- Mx2[Mx2$Year==y,]$mx
  lt_y <- LifeTableMx(mx2, sex)
  lt_y$Year <- y
  LT_c <- rbind(LT_c,lt_y)
}

## plot life expectancy at age 0, 30 and 80
ggplot()+
  geom_line(LT_p[LT_p$Age==0,],
            mapping=aes(x=Year, y=ex, color="e(0) at age 0"))+
  geom_line(LT_p[LT_p$Age==30,],
            mapping=aes(x=Year, y=ex, color="e(30) at age 30"))+
  geom_line(LT_p[LT_p$Age==80,],
            mapping=aes(x=Year, y=ex, color="e(80) at age 80"))+
  scale_x_continuous(n.breaks = 10)+
  scale_y_continuous(breaks = seq(0,110,10),limits = c(0,100))+
  scale_color_brewer(type = "qual",palette = 2)+
  guides(color = guide_legend(title="Measures"))+
  theme_bw()+
  labs(x="Year",y="Life expectancy", title="Life expectancy of Males in Denmark (1835-2023)")
