
## R tutorial  - Population projection
## DEMO
## 

Names<-c("DNK")
Names2<-c("Denmark")


options(scipen=1000000)

library(ggplot2)

#### Parameters ####


YEAR<-2023

#### Mortality ####
# setwd(Folder1)

l<-read.table("fltper_1x1.txt",
              header=TRUE,fill=TRUE,skip=2)  # female life table
lm<-read.table("mltper_1x1.txt",
               header=TRUE,fill=TRUE,skip=2) # male life table

### Sx and Sxm: survival ratios for females and males respectively 
### to run the program they should have a length of (110 not 111)!!! 
### you should get them from the corresponding life tables from the 
### Human Mortality Database 

l<-l[l$Year==YEAR,]
lm<-lm[lm$Year==YEAR,]

Sx<-ifelse(l$Lx[-111]>0,l$Lx[-1]/l$Lx[-111],0)
Sxm<-ifelse(lm$Lx[-111]>0,lm$Lx[-1]/lm$Lx[-111],0)

### L111 and L111m the survival for the last two age groups 
### (one number each)

L111<-ifelse(l$Tx[110]>0,l$Tx[111]/l$Tx[110],0)      
L111m<-ifelse(lm$Tx[110]>0,lm$Tx[111]/lm$Tx[110],0)

### (replace the last value in Sx and Sxm)
Sx[110]<-L111
Sxm[110]<-L111m


#### Population ####

Pop<-read.table("Population.txt",
                header=TRUE,fill=TRUE,skip=1) # population


#### Births ####

B<-read.table("Births.txt",
              header=TRUE,fill=TRUE,skip=1, as.is=TRUE) # birth
B<-B[B$Year==YEAR,] # birth in YEAR of 2018

#### Migration ####

Migration_est <- function(Pop,mlt,flt,year){
  
  Sx_m <- mlt[mlt$Year==year,]
  Sx_m <- ifelse(Sx_m$Lx[-111]>0, Sx_m$Lx[-1]/Sx_m$Lx[-111],0)
  
  Sx_f <- flt[flt$Year==year,]
  Sx_f <- ifelse(Sx_f$Lx[-111]>0, Sx_f$Lx[-1]/Sx_f$Lx[-111], 0)
  
  Pop_diff_f <- Pop[Pop$Year==year+1,]$Female[-1] - 
                Pop[Pop$Year==year,]$Female[-111] * Sx_f
  
  Pop_diff_f <- c(Pop_diff_f,0)
  Pop_diff_f <- (Pop_diff_f[-1]+Pop_diff_f[-111])/2
  Pop_diff_f <- c(Pop_diff_f,0)
  
  Pop_diff_m <-
    Pop [Pop$Year == year+1,]$Male[-1] -
    Pop [Pop$Year == year, ]$Male[-111]*Sx_m
    
  Pop_diff_m <- c(Pop_diff_m,0)
  Pop_diff_m <- (Pop_diff_m[-1]+Pop_diff_m[-111])/2
  Pop_diff_m <- c(Pop_diff_m,0)
  
  MAX <- max(Pop_diff_m,Pop_diff_f)
  MIN <- min(Pop_diff_m,Pop_diff_f)
  plot(c(0,110),c(MIN,MAX),type="l",col=0)
  lines(Pop_diff_f,col="red")
  lines(Pop_diff_m,col="blue")
  abline(h=0)
  legend("topright",legend=c("male","female"),
         col=c("blue","red"),pch=15)
  
  Mig <- data.frame(
    age = 0:110,
    Female = Pop_diff_f,
    Male = Pop_diff_m
  )
  
  return(Mig)
}

dev.off()

Mig <- Migration_est(Pop,mlt=lm,flt=l,YEAR)

Mig <- Migration_est(Proj_Pop,mlt=lm,flt=l,2025)

#### Fertility and Births ####


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

#### Leslie matrix ####

Mf<-cbind(rbind(line1,diag(Sx)),
          c(rep(0,110),L111))

Mm<-cbind(rbind(rep(0,length(line1)),diag(Sxm)),
          c(rep(0,110),L111m))

### Ipop and Ipopm the base population of females and males 
### respectively (111 entries each)

Ipop<-as.numeric(Pop[Pop$Year==YEAR,]$Female)
Ipopm<-as.numeric(Pop[Pop$Year==YEAR,]$Male)


#### Projection ####

Proj<-83			# let's look at a projection for 50 years

pop<-matrix(0,Proj,length(Ipop)) 	
# creates a matrix whit each new line 
# for each new year of the female population

popm<-matrix(0,Proj,length(Ipopm))   # same for males

pop[1,]<- Ipop  	 #initialize the first row of female population
colnames(pop)=0:110
rownames(pop)=1:Proj

popm[1,]<- Ipopm   #initialize the first row of male population
colnames(popm)=0:110
rownames(popm)=1:Proj

Proj_Pop <- c()

for (year in 2:Proj){
  
  pop[(year-1),] <- pop[(year-1),] 
  pop[year,]<-t(Mf%*%pop[(year-1),])
  tot_birth <- pop[year,1]
  pop[year,1] <- tot_birth*k
  pop[year,] <- pop[year,] 
  
  popm[(year-1),] <- popm[(year-1),] 
  popm[year,]<-c(tot_birth*km,t(Mm%*%popm[(year-1),])[-1])
  popm[year,] <- popm[year,] 
  
  To<-pop[year,]+popm[year,]
  
  Proj_Pop_temp <- data.frame(Year=(year+YEAR-1),
                              Age=0:110,
                              Female=pop[year,],
                              Male=popm[year,],
                              Total=To)
  
  Proj_Pop <- rbind(Proj_Pop, Proj_Pop_temp)
}

#### Plot the results as a pop pyramid ####

Pop_pyramid <- c()

for (year in unique(Proj_Pop$Year)){
  
  pyramid_temp <- Proj_Pop[Proj_Pop$Year==year,]
  
  pyramid_temp$pctf <- pyramid_temp$Female/sum(pyramid_temp$Total)*100
  pyramid_temp$pctm <- pyramid_temp$Male/sum(pyramid_temp$Total)*100*-1
  
  PopF <- pyramid_temp[,c(1,2,6)]
  PopF$Sex <- "Female"
  names(PopF)[3] <- "Percentage"
  
  PopM <- pyramid_temp[,c(1,2,7)]
  PopM$Sex <- "Male"
  names(PopM)[3] <- "Percentage"
  
  pyramid_temp <- rbind(PopF,PopM)
  
  Pop_pyramid <- rbind(Pop_pyramid,pyramid_temp)
}

Pop_pyramid_initial <- c()
Pop_Initial <- as.data.frame(cbind(Year=YEAR, Age = 0:110, Female = Ipop, Male = Ipopm, Total = Ipop + Ipopm))

for (year in unique(Pop_Initial$Year)){
  
  pyramid_temp <- Pop_Initial[Pop_Initial$Year==year,]
  
  pyramid_temp$pctf <- pyramid_temp$Female/sum(pyramid_temp$Total)*100
  pyramid_temp$pctm <- pyramid_temp$Male/sum(pyramid_temp$Total)*100*-1
  
  PopF <- pyramid_temp[,c(1,2,6)]
  PopF$Sex <- "Female"
  names(PopF)[3] <- "Percentage"
  
  PopM <- pyramid_temp[,c(1,2,7)]
  PopM$Sex <- "Male"
  names(PopM)[3] <- "Percentage"
  
  pyramid_temp <- rbind(PopF,PopM)
  
  Pop_pyramid_initial <- rbind(Pop_pyramid_initial,pyramid_temp)
}


########### selected the year of 2100
Year1<-2070

Pop1<-Pop_pyramid[Pop_pyramid$Year==Year1,]

p <- ggplot(data = Pop1, aes(x = Age,  
                             y = Percentage, 
                             fill = Sex)) + 
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = function(x){paste0(abs(x),"%")}, 
                     limits = max(abs(Pop1$Percentage)) * c(-1.1,1.1)) +
  scale_x_continuous(n.breaks = 10)+
  labs(x = "Age", y = "Percentage of Population",
       title = paste("Population pyramid of",Names2),
       subtitle = paste("Year:",Year1),
       caption = "Data source: Author's calculations based on HMD")+
  coord_flip()+                        # flip x and y axis
  scale_fill_brewer(palette= "Set1")+
  theme_minimal()
p

p_initial <- ggplot(data = Pop_pyramid_initial, aes(x = Age,  
                             y = Percentage, 
                             fill = Sex)) + 
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = function(x){paste0(abs(x),"%")}, 
                     limits = max(abs(Pop_pyramid_initial$Percentage)) * c(-1.1,1.1)) +
  scale_x_continuous(n.breaks = 10)+
  labs(x = "Age", y = "Percentage of Population",
       title = paste("Population pyramid of",Names2),
       subtitle = paste("Year:",YEAR),
       caption = "Data source: Author's calculations based on HMD")+
  coord_flip()+                        # flip x and y axis
  scale_fill_brewer(palette= "Set1")+
  theme_minimal()
p_initial


############# now in a movie
library(gganimate)
library(gifski)

p1 <- ggplot(Pop_pyramid, aes(x = Age,  y = Percentage, fill = Sex)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = function(x){paste0(abs(x),"%")},
                     limits = max(abs(Pop_pyramid$Percentage)) * c(-1.1,1.1)) +
  labs(x = "Age", y = "Percentage of Population",
       title = paste("Population pyramid of",Names),
       subtitle = "{closest_state}",
       caption = "Data source: HMD")+
  coord_flip()+
  scale_fill_brewer(palette= "Set1")+
  theme_minimal()

p2 <- p1 + transition_states(Year, transition_length = 2) +
  enter_fade() +
  exit_fade() +
  ease_aes("cubic-in-out")

# Generate gif (this will take a few minutes to run)
animate(p2,width = 10, height = 10, units = "cm",res=150,
        renderer = gifski_renderer(loop = T),
        nframes= length(unique(Pop_pyramid$Year))*3)
# save the gif file
anim_save(paste0("population pyramid_",Names,"_",
                 min(Pop_pyramid$Year),"_",max(Pop_pyramid$Year),
                 ".gif"))

