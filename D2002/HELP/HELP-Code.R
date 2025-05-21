### PREFACE 
# If this information is not enough to Ctrl+F, try to open the .code-workspace
# and Ctrl+F there. 
#
#
# - Forecasting: The professor specifically mentioned that forecasting will be included since it incorporates elements of migration, mortality, and other demographic components
# - Life Tables: The professor emphasized life tables, saying "I like life tables a lot. So you can expect that probably I will be asking something in that direction"
# - Coverage: The exam will also include specific topics on fertility, introduction material, and population growth

#########--------------------------------------------------------------#########
# Using: ASFR from asfrRR.txt from HFD
# Get: TFR, MAC, plot them. 
# Source: mt-prac-Q1

data <- read.table("asfrRR.txt", header=TRUE)
data$Age[data$Age == "-12"] <- 12
data$Age[data$Age == "55+"] <- 55

data$Age <- as.numeric(data$Age)

usa <- data[data$Country == "USA", ,]
jpn <- data[data$Country == "JPN", ,]

# TFR = sum f(a) \times ASFR  / sum f(a)

TFR_usa <- sum(usa$ASFR)
TFR_jpn <- sum(jpn$ASFR)

# MAC = sum f(a) (a + 0.5) / sum f(a)

MAC_usa <- 0
MAC_jpn <- 0

# The solution:
MAC_usa <- sum((usa$Age + 0.5) * usa$ASFR) / sum(usa$ASFR)
MAC_jpn <- sum((jpn$Age + 0.5) * jpn$ASFR) / sum(jpn$ASFR)

MAC_usa <- MAC_usa / TFR_usa
MAC_jpn <- MAC_jpn / TFR_jpn

plot(usa$Age, usa$ASFR)

plot(jpn$Age, jpn$ASFR)

library(ggplot2)

ggplot()+
  geom_line(data = usa, mapping=aes(x = Age, y = ASFR, col="red")) +
  geom_line(data = jpn, mapping=aes(x = Age, y = ASFR, col="blue"))

#########--------------------------------------------------------------#########
# Using: period TFR (tfr.txt) and cohort TFR (ccf.txt)
# Show: Time trends of fertility
# Source: mt-prac-Q2
library(ggplot2)

tfr <- read.table("tfr.txt", header=TRUE, fill=TRUE, skip=2)

ccf <- read.table("ccf.txt", header=TRUE, fill=TRUE, skip=2)

# Sweden = SWE

swe_tfr <- tfr[tfr$Code == "SWE", c("Year", "TFR", "TFR40")]

swe_ccf <- ccf[ccf$Code == "SWE", c("Cohort", "CCF", "CCF40")]

ggplot()+
  geom_line(data=swe_tfr, mapping=aes(x=Year, y=TFR, col="blue"))+
  geom_line(data=swe_ccf, mapping=aes(x=Cohort, y=CCF40, col="red"))

#########--------------------------------------------------------------#########
# Using: deaths d, MYP p, life table "ax" in TWN.txt and JPN.txt
# Get: Life tables, mortality
# Source: mt-prac-Q3

# Sample:
# Life table: Age, lx, dx, qx, mx, ax, Lx, Tx, ex
# LifeTable <- function(pop, death, ax) {...}

#########--------------------------------------------------------------#########
# Using: data$Year, Population, Births, Deaths
# Get: Net migration counts
# Source: REAL Midterm, Q1

AUS<-read.table("AUS.txt",header=TRUE)

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


#########--------------------------------------------------------------#########
# Using: ASFR
# Get: Life table; other decrements
# Source: REAL Midterm, Q2

# Sample:
# Includes: LifeTableMx (i.e. function(mx){...})
Table<-cbind(c("USA",TFRUS,TFR1US,MACUS,MAC1US,PFRCUS,LEUS),
             c("KOR",TFRSK,TFR1SK,MACSK,MAC1SK,PFRCSK,LESK))
# PFRC: proportion of females remaining childless
# LE: Life expectancy b/w ages 12:55

#########--------------------------------------------------------------#########
# Using: Migration data from ABS
# Get: Chord diagram of migration flows
# Source: Tut_6

# Sample:
library(circlize)

## Load data
df0<-read.csv("InterMigra2016-10YAGE.csv",skip=10)
#         
# skip the first 9 rows and columns 1 and 5 in the csv file 

str(df0)
unique(df0$AGE10P...Age.in.Ten.Year.Groups) # 11 unique age bins
unique(df0$STATE..5YR.)
unique(df0$STATE..UR.)

# keep only the eight main states and territories
state=c("New South Wales","Victoria","Queensland","South Australia",
        "Western Australia","Tasmania","Northern Territory","Australian Capital Territory")


#########--------------------------------------------------------------#########
# Using: Population.txt
# Get: Population pyramids (three visualisations; single, side-by-side facets, overlap)
# Source: Tut8_Revise_(...).R

# Sample: Single Population Pyramid
ggplot(data = Pop1, mapping = aes(x=Age, y=Percentage, fill=Sex)) +
  geom_bar(stat = "identity") + 
  scale_y_continuous(
    labels = function(x) {x}, # 1
    limits = max(Pop1$Percentage)*c(-1.1, 1.1) # 2
  ) +
  scale_x_continuous(n.breaks=10) + # 3
  # See: labels, limits, breaks!
  coord_flip() + 
  labs(title="Single Population Pyramid",
       subtitle = paste("Year:", Year1)
  ) +
  scale_fill_brewer(palette="Set1")+
  theme_bw()

#########--------------------------------------------------------------#########
# Using: F/M LifeTables, Population.txt, line1.txt (k/km given)
# Get: Population Projection (6 Step Process in the file)
# Source; Tut9_Revise_(...).R

# Sample: 
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

#########--------------------------------------------------------------#########
# Using: F/M LifeTables, Population.txt, Births.txt, asfrRR.txt (period fertility)
# Get: FULL Population Projection (6 Step Process in the file), and migration estimates
# Source; Tut10_Full_(...).R
# Use the FULL file, not the "REVISE" File

# Sample:
# Migration_est <- function(Pop,mlt,flt,year){...}

  ## Making our own line1

f0 <- read.table(paste(Names,"asfrRR.txt",sep=""),
                 header=TRUE, fill=TRUE,skip=2) #period asfr by year and age (Lexis squares) for all countries

f <- f0[f0$Year == YEAR,]  # all on the year of selection 2018

Fe <- c(rep(0,12),f$ASFR,rep(0,(110-55)))

### line1: a combination of fertility and survival information
### for the first row of the matrix which returns the number 
### of babies when multiplied by the population it is also (110 long ### i.e. skip the last value)

SRB <- B$Male/B$Female

L1 <- l$Lx[1]/(2*l$lx[1])
L1m <- lm$Lx[1]/(2*lm$lx[1])

k <- L1/(1+SRB) # this is for female babies

km<-(L1m*SRB)/(1+SRB) # for estimating male babies

line1<-(Fe[-1] * Sx +Fe[-111]) # this is for female survivor and baby survivors