rm(list = ls())

options(scipen=999)

library(ggplot2)


I_YEAR <- 2018

### Part (1) Mortality
l <- read.table("fltper_1x1.txt", header=TRUE, skip=2, fill=TRUE)
lm <- read.table("mltper_1x1.txt", header=TRUE, skip=2, fill=TRUE)

l <- l[l$Year == I_YEAR,]
lm <- lm[lm$Year == I_YEAR,]

# Processing Step (1)
  # Explanation:
  # IF we have non-zero positive entries in any place that isn't index -111
  # THEN we will compute the survival ratio, where the numerator is effectively left-shifted
Sx<- ifelse(l$Lx[-111]>0,l$Lx[-1]/l$Lx[-111],0)
Sxm<- ifelse(lm$Lx[-111]>0,lm$Lx[-1]/lm$Lx[-111],0)

# Processing Step (2)
  # Explanation; note we're working in Tx, not Lx
  # IF we have non-zero positive entry in idx=111
  # THEN we continue using Tx to get the "survival ratio"
L111<-  ifelse(l$Tx[110]>0, l$Tx[111]/l$Tx[110],0)      
L111m<- ifelse(lm$Tx[110]>0, lm$Tx[111]/lm$Tx[110],0)

# (2b) And, special last row, has two occupied cells
Sx[110]<-L111
Sxm[110]<-L111m

### Part (2) Population
Pop <- read.table("Population.txt", header=TRUE, skip=2, fill=TRUE)

# Get initial populations
Ipop<-as.numeric(Pop[Pop$Year==I_YEAR,]$Female)
Ipopm<-as.numeric(Pop[Pop$Year==I_YEAR,]$Male)

### Part (3) Fertility
l1<-read.table("line1.txt",header=TRUE)

k<-0.243368 # contains sex ratio at birth and survivorship
km<-0.254229

# Since we are given the "line" and "k/km" values, 
# the final Leslie matrix is pretty much a "one-liner"
  # Note, we don't actually use "k/km" at this stage. 
Mf <- 
  cbind(
    rbind(l1$Line1, diag(Sx)),
    c(rep(0,110), L111)
  )

Mm <- 
  cbind(
    rbind(l1$Line1, diag(Sxm)), # Change Sx to Sxm
    c(rep(0,110), L111m) # Change L111 to L111m
  )

### (4) Yay, Projection!
Proj_time <- 50 # Project 50 years into the future

pop_mtx <- matrix(0, Proj_time, length(Ipop))

popm_mtx <- matrix(0, Proj_time, length(Ipopm)) # bit weird. why would the lengths be diffnt lol. 

pop_mtx[1, ] <- Ipop # Females
colnames(pop_mtx) <- 0:110
rownames(pop_mtx)<- 1:Proj_time

popm_mtx[1, ] <- Ipopm # Males
colnames(popm_mtx) <- 0:110
rownames(popm_mtx)<- 1:Proj_time

Proj_Pop <- c()

for (year in 2:Proj_time) {
  # Go to that year-row, do MATRIX mult, adjust using "k"!
    # (Remember? %*% is the proper matrix multiplier.)
  pop_mtx[year,]<-t(Mf%*%pop_mtx[(year-1),])
  tot_birth <- pop_mtx[year,1]
  pop_mtx[year,1] <- tot_birth *k # adjustment for female (SRB + survivorship)
  
  
  popm_mtx[year,-1]<-t(Mm%*%popm_mtx[(year-1),])[-1]
  popm_mtx[year,1] <- tot_birth *km # adjustment for male (SRB + survivorship)
    # (^ Funnily enough, we can use the same one.)
  
  
  Total<-pop_mtx[year,]+popm_mtx[year,]
  
  # "temp" is just a single row...
  Proj_Pop_temp <- data.frame(Year=(year+I_YEAR-1),
                              Age=0:110,
                              Female=pop_mtx[year,],
                              Male=popm_mtx[year,],
                              Total=Total)
  # ...For which we accumulate a final df. 
  Proj_Pop <- rbind(Proj_Pop, Proj_Pop_temp) # Accumulate
}

### (5) Pyramid Conversion (Tut8)
Pop_pyramid <- c()

for (year in unique(Proj_Pop$Year)){
  
  pyramid_temp <- Proj_Pop[Proj_Pop$Year==year,]
  
  pyramid_temp$pctf <- pyramid_temp$Female/sum(pyramid_temp$Total)*100
  pyramid_temp$pctm <- pyramid_temp$Male/sum(pyramid_temp$Total)*100*-1
  
  PopF <- pyramid_temp[, c(1,2,6) ]
  PopF$Sex <- "Female"
  names(PopF)[3] <- "Percentage"
  
  PopM <- pyramid_temp[, c(1,2,7)]
  PopM$Sex <- "Male"
  names(PopM)[3] <- "Percentage"
  
  pyramid_temp <- rbind(PopF,PopM)
  
  Pop_pyramid <- rbind(Pop_pyramid,pyramid_temp)
}


### (6) Visualisation (Tut8)
Year1 <- 2050

ggplot(data=Pop_pyramid[Pop_pyramid$Year == Year1,], mapping=aes(x=Age, y=Percentage, fill=Sex))+
  geom_bar(stat = "identity") +
  scale_y_continuous(
    labels=function(x){paste(abs(x), "%")},
    limits=max(Pop_pyramid$Percentage)*c(-1.1, 1.1)
  ) +
  scale_x_continuous(n.breaks=10) +
  coord_flip()+
  labs(title="Single Population Pyramid",
       subtitle = paste("Year:", Year1)
  ) +
  scale_fill_brewer(palette="Set1")+
  theme_bw()
