# Using: deaths d, MYP p, life table "ax" in TWN.txt and JPN.txt

twn <- read.table("TWN.txt", header=TRUE, skip=2, fill=TRUE)
jpn <- read.table("JPN.txt", header=TRUE, skip=2, fill=TRUE)

options(scipen = 5)

twn$Age[twn$Age == "110+"] <- "110"
twn$Age <- as.numeric(twn$Age)
jpn$Age[jpn$Age == "110+"] <- "110"
jpn$Age <- as.numeric(jpn$Age)

head(twn)
head(jpn)

twn_Female <- data.frame(Age = twn$Age, pop=twn$POP_Female, death=twn$DEATH_Female, ax=twn$ax_Female)
twn_Male <- data.frame(Age = twn$Age, pop=twn$POP_Male, death=twn$DEATH_Male, ax=twn$ax_Male)

jpn_Female <- data.frame(Age = jpn$Age, pop=jpn$POP_Female, death=jpn$DEATH_Female, ax=jpn$ax_Female)
jpn_Male <- data.frame(Age = jpn$Age, pop=jpn$POP_Male, death=jpn$DEATH_Male, ax=jpn$ax_Male)

# Life table: Age, lx, dx, qx, mx, ax, Lx, Tx, ex

LifeTable <- function(pop, death, ax) {
  N <- length(ax)
  Age <- 0:(N-1)

  mx <- death/pop
  
  qx <- mx / (1 + (1 - ax)*mx)
  # FIX: Make last qx = 1
  qx[N] <- 1
  
  # lx <- rep(100000, 111)
  # ^ Nope
  lx <- 100000
  for (x in 1:(N - 1)) {
    lx[x + 1] <- lx[x] * (1 - qx[x]) # Nice.
  }
  
  dx = lx * qx
  
  # Lx = lx + ax * dx
  # ^ Nope
  Lx<- (lx - dx) + ax * dx
  
  ## FIX
  ## and Lx for the last age-group
  Lx[N]<-ifelse(mx[N]>0,mx[N],0)      
  
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

LT.jpn_f <- LifeTable(jpn_Female$pop, jpn_Female$death, jpn_Female$ax)
head(LT.jpn_f)

LT.jpn_m <- LifeTable(jpn_Male$pop, jpn_Male$death, jpn_Male$ax)
head(LT.jpn_m)

LT.twn_f <- LifeTable(twn_Female$pop, twn_Female$death, twn_Female$ax)
head(LT.twn_f)

LT.twn_m <- LifeTable(twn_Male$pop, twn_Male$death, twn_Male$ax)
head(LT.twn_m)


library(ggplot2)

ggplot()+
  geom_line(data=LT.jpn_f, mapping=aes(x=Age, y=lx, col="Japan, female"))+
  geom_line(data=LT.twn_f, mapping=aes(x=Age, y=lx, col="Taiwan, female"))

ggplot()+
  geom_line(data=LT.jpn_m, mapping=aes(x=Age, y=lx, col="Japan, male"))+
  geom_line(data=LT.twn_m, mapping=aes(x=Age, y=lx, col="Taiwan, male"))

# CDR = deaths / population

with(twn_Female, sum(pop)/sum(death))
with(twn_Male, sum(pop)/sum(death))
with(jpn_Female, sum(pop)/sum(death))
with(jpn_Female, sum(pop)/sum(death))
