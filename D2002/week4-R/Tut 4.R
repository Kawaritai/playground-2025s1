library(ggplot2)

options(scipen = 5) # prevent scientific notation

getwd()

# LT stands for life table
LT <-  read.table("fltper_1x1.txt",
                  header=TRUE, # open
                  fill=TRUE, # fill uneven rows
                  skip=2 # skip first two rows
                  )

# Fix and make numeric the Age column
LT$Age[LT$Age == "110+"] <- 110
LT$Age <- as.numeric(LT$Age)


# Get a subset
LT_sub <- LT[LT$Year == "2020",]

# Get Mx, which indicates the mortality rate (capital is population, technically)
Mx <- data.frame(Age = 0:110, qx = LT_sub$qx)

ggplot(Mx, aes(x=Age,y=qx))+geom_line()

ggplot(Mx, aes(x=Age,y=qx))+geom_line()+
  scale_y_continuous(trans="log10")+
  theme_bw()

# Address the number of survivors (lx) and pr surviving (px)
lx <- 100000 # Initial population, at index lx[1]
length(lx) # 1 entry

px <- 1 - Mx$qx # Calculate various survival rates
length(px) # 111 entries

for (y in 1:110) {
  lx[y + 1] <- px[y] * lx[y]
}
length(lx) # 111 entries

# Return to add the survivors column to Mx
Mx$lx <- lx

ggplot(Mx, aes(x = Age, y=lx))+geom_line()

# Onto dx! dx is the number of people who died?
# Fix: dx is the deaths in an interval

dx <- Mx$qx * Mx$lx

Mx$dx <- dx

ggplot(Mx, aes(x=Age, y=dx))+geom_line()

# LifeTable function
LifeTable <- function(qx) {
  Age <- 0:110
  lx <- 100000
  px <- 1 - qx
  
  for (y in 1:110) {
    lx[y + 1] <- lx[y] * px[y]
  }
  dx <- qx * lx
  
  ALL <- data.frame(Age=Age, qx=qx,lx=lx,dx=dx)
  return(ALL)
}

# Compare qx on two thingies
LT1 <- LT[LT$Year=="1850",]
LT2 <- LT[LT$Year=="2020",]


ggplot()+
  geom_line(LT1,mapping = aes(x=Age,y=qx,color="1850"))+
  geom_line(LT2,mapping = aes(x=Age,y=qx,color="2020"))+
  scale_y_continuous(trans = "log10")+
  scale_color_manual(values=c("blue","red"))+
  labs(x = "Age",y="qx")+theme_bw()

###############

LT_A<-LifeTable(LT1$qx)
LT_B<-LifeTable(LT2$qx)

ggplot()+
  geom_line(LT_A, mapping = aes(x = Age, y = lx, color = "1850"))+
  geom_line(LT_B, mapping = aes(x = Age, y = lx, color = "2020"))+
  scale_color_manual(values = c("purple","tomato2"))+
  guides(color = guide_legend(title = "Year"))+
  labs(x = "Age (years)", y = "Number of survivors (lx)")+
  ggtitle("Number of people left alive at Age (1850 vs 2020), Netherlands (female 1x1)")


## and plotting them together, dx

ggplot()+
  geom_line(LT_A, mapping = aes(x = Age, y = dx, color = "1850"))+
  geom_line(LT_B, mapping = aes(x = Age, y = dx, color = "2020"))+
  scale_color_manual(values = c("navy","red"))+
  guides(color = guide_legend(title = "Year"))+
  labs(x = "Age", y = "dx")+theme_bw()

