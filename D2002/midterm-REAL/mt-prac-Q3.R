# Using: ASFR1.txt: Year Age ASFR ASFR1 Pop
rm(list = ls())
options(scipen = 5)


## Read ASFR1.txt
asfr1 <- read.table("ASFR1.txt", header=TRUE, fill=TRUE)
# Need to clean up
asfr1$Age[asfr1$Age == "12-"] <- 12
asfr1$Age[asfr1$Age == "55+"] <- 55
asfr1$Age <- as.numeric(asfr1$Age)

# Only one year: 2022

# Korea only
asfr_kor <- asfr1[asfr1$Pop == "KOR", c("Age", "ASFR", "ASFR1")]
str(asfr_kor) # lowest BR

# USA only 
asfr_usa <- asfr1[asfr1$Pop == "USA", c("Age", "ASFR", "ASFR1")]
str(asfr_usa)


# Note that ASFR = all births, but ASFR1 = first births

# TFR = sum asfr
tfr_usa <- sum(asfr_usa$ASFR)
tfr1_usa <- sum(asfr_usa$ASFR1)

# TFR1 = sum asfr1
tfr_kor <- sum(asfr_kor$ASFR)
tfr1_kor <- sum(asfr_kor$ASFR1)

# MAC = sum f(a) (a + 0.5) / sum f(a)
mac_usa <- sum((asfr_usa$Age + 0.5) * asfr_usa$ASFR) / sum(asfr_usa$ASFR)
mac1_usa <- sum((asfr_usa$Age + 0.5) * asfr_usa$ASFR1) / sum(asfr_usa$ASFR1)

mac_kor <- sum((asfr_kor$Age + 0.5) * asfr_kor$ASFR) / sum(asfr_kor$ASFR)
mac1_kor <- sum((asfr_kor$Age + 0.5) * asfr_kor$ASFR1) / sum(asfr_kor$ASFR1)


# Life table: Age, lx, dx, qx, mx, ax, Lx, Tx, ex
LifeTable <- function(mx) {
  START <- 12
  END <- 55
  N <- END - START + 1
  Age <- START:END
   
  # ASSUME ax = 0.5 every age
  ax <- rep(0.5, N)

  # Actually, the life table is a mother table
  # mx <- death/pop
  
  qx <- mx / (1 + (1 - ax)*mx)
  
  # lx <- rep(100000, 111)
  # ^ Nope
  lx <- 100000
  for (x in 1:(N - 1)) {
    lx[x + 1] <- lx[x] * (1 - qx[x])
  }
  
  dx = lx * qx
  
  # Lx = lx + ax * dx
  # ^ Nope
  Lx<- (lx - dx) + ax * dx
  
  ## FIX
  ## and Lx for the last age-group
  # Lx[N]<-ifelse(mx[N]>0,mx[N],0)      
  
  # Make Tx the empty vector
  Tx <- c()
  for (y in 1:N) {
    Tx[y] <- sum(Lx[y:N])
  }
  
  ex = Tx / lx
  
  ALL <- data.frame(Age, lx, dx, qx, mx, ax, Lx, Tx, ex)
  # ALL <- data.frame(Age, mx)
  return(ALL)
}

LT_usa <- LifeTable(asfr_usa$ASFR1)
LT_kor <- LifeTable(asfr_kor$ASFR1)

# 44 is the 
# LT_usa[44, 1:9]
pfrc_usa <- LT_usa[44, "lx"] / 100000
pfrc_kor <- LT_kor[44, "lx"] / 100000


library(ggplot2)

ggplot()+
  geom_line(data=LT_usa, mapping=aes(x=Age, y=lx, col="USA"))+
  geom_line(data=LT_kor, mapping=aes(x=Age, y=lx, col="Korea"))+
  labs(title="Life Table of childless to first-time mothers — survivors (lx)")

ggplot()+
  geom_line(data=LT_usa, mapping=aes(x=Age, y=dx, col="USA"))+
  geom_line(data=LT_kor, mapping=aes(x=Age, y=dx, col="Korea"))+
  labs(title="Life Table of childless to first-time mothers — decrements (dx)")

ggplot()+
  geom_line(data=LT_usa, mapping=aes(x=Age, y=ex, col="USA"))+
  geom_line(data=LT_kor, mapping=aes(x=Age, y=ex, col="Korea"))+
  labs(title="Life Table of childless to first-time mothers — expectation (ex)")

