twn <- read.table("TWN.txt", header=TRUE, skip=2, fill=TRUE)
jpn <- read.table("JPN.txt", header=TRUE, skip=2, fill=TRUE)

twn$Age[twn$Age == "110+"] <- "110"
jpn$Age[jpn$Age == "110+"] <- "110"

twn$Age <- as.numeric(twn$Age)
jpn$Age <- as.numeric(jpn$Age)

str(twn)

# Life table: x, lx, dx, qx, mx, ax, Lx, Tx, ex

# Age: 0:110
lifetable <- function(age, pop, death, ax) {
  N <- length(ax)
  x <- 0:(N-1)
  
  mx <- death/pop
  
  qx <- mx/(1 + (1 - ax) * mx)
  qx[N] = 1
  
  lx <- 100000
  
  for (y in 1:(N-1)) {
    # Fix. You fucked this up
    # Fix 2:You fucked this up twice
    lx[y + 1] <- lx[y] * (1 - qx[y])
  }
  # lx = 0 at the end?
  
  dx = lx*qx
  
  # Lx <- lx + ax * dx
  # ^ Nope, AGAIN!
  Lx<- (lx - dx) + ax * dx
  
  ## FIX
  ## and Lx for the last age-group
  Lx[N]<-ifelse(mx[N]>0,mx[N],0)      
  
  Tx <- c()
  for (y in 1:N) {
    Tx[y] <- sum(Lx[y:110])
  }
  
  ex = Tx/lx # Fix: lx not Lx
  
  ALL <- data.frame(x, lx, dx, qx, mx, ax, Lx, Tx, ex)
  return(ALL)
  
}

lt1 <- lifetable(jpn$Age, jpn$POP_Female, jpn$DEATH_Female, jpn$ax_Female)
