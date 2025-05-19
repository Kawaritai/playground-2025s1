
## R tutorial  - Population projection
## DEMO
## 
rm(list = ls())

options(scipen=1000000)

library(ggplot2)

#### Parameters ####

Names<-c("USA")
Names2<-c("United States of America")

YEAR<-2018

#### Mortality ####
# setwd(    )

l<-read.table("fltper_1x1.txt",
              header=TRUE,fill=TRUE,skip=2)  # female life table
lm<-read.table("mltper_1x1.txt",
               header=TRUE,fill=TRUE,skip=2) # male life table

### Sx and Sxm: survival ratios for females and males respectively 
### you should calculate them from the corresponding life tables 
### from the Human Mortality Database 

l<-l[l$Year==YEAR,]
lm<-lm[lm$Year==YEAR,]

Sx<- ifelse(l$Lx[-111]>0,l$Lx[-1]/l$Lx[-111],0)   
Sxm<- ifelse(lm$Lx[-111]>0,lm$Lx[-1]/lm$Lx[-111],0)    

### L111 and L111m the survival for the last two age groups 
### (one number each)

L111<-  ifelse(l$Tx[110]>0, l$Tx[111]/l$Tx[110],0)      
L111m<- ifelse(lm$Tx[110]>0, lm$Tx[111]/lm$Tx[110],0)    

### (replace the last value in Sx and Sxm)
Sx[110]<-L111
Sxm[110]<-L111m


#### Population ####

Pop<-read.table("Population.txt",
                header=TRUE,fill=TRUE,skip=1) # population


#### Fertility, Births and Migration####
#### NEXT WEEK

l1<-read.table("line1.txt",header=TRUE)
l2<-read.table("line2.txt",header=TRUE)



k<-0.243368
km<-0.254229
  
#### Leslie matrix ####

Mf<-cbind(rbind(l2$Line1,diag(Sx)),
          c(rep(0,110),L111))

Mm<-cbind(rbind(rep(0, length(l2$Line1)),diag(Sxm)),
          c(rep(0,110),L111m))

### Ipop and Ipopm the base population of females and males 
### respectively (111 entries each)

Ipop<-as.numeric(Pop[Pop$Year==YEAR,]$Female  )
Ipopm<-as.numeric(Pop[Pop$Year==YEAR,]$Male  )


#### Projection ####

Proj<-50   			# let's look at a projection for 50 years

pop<-matrix(0,Proj,length(Ipop)) 	
# creates a matrix with each new line 
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
  
  pop[year,]<-t(Mf%*%pop[(year-1),])
  tot_birth <- pop[year,1]
  pop[year,1] <- tot_birth *k  
 
  
  popm[year,-1]<-t(Mm%*%popm[(year-1),])[-1]
  popm[year,1] <- tot_birth *km 
    
    
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
  
  PopF <- pyramid_temp[, c(1,2,6) ]
  PopF$Sex <- "Female"
  names(PopF)[3] <- "Percentage"
  
  PopM <- pyramid_temp[, c(1,2,7)]
  PopM$Sex <- "Male"
  names(PopM)[3] <- "Percentage"
  
  pyramid_temp <- rbind(PopF,PopM)
  
  Pop_pyramid <- rbind(Pop_pyramid,pyramid_temp)
}

########### selected the year of 2050
Year1<-2050

Pop1<-Pop_pyramid[Pop_pyramid$Year==Year1,]

p <- ggplot(data =Pop1, aes(x =  Age,  
                             y =  Percentage, 
                             fill =  Sex)) + 
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = function(x){paste0(abs(x),"%")}, 
                     limits = max(Pop1$Percentage) * c(-1.1,1.1)) +
  scale_x_continuous(n.breaks = 10)+
  labs(x = "Age", y = "Percentage of Population",
       title = paste("(l1) Population pyramid of",Names),
       subtitle = paste("Year:",Year1),
       caption = "Data source: Author's calculations based on HMD")+
  coord_flip()+                        # flip x and y axis
  scale_fill_brewer(palette= "Set1")+
  theme_minimal()
p


############# now in a movie

library(gganimate)
library(gifski)

p1 <- ggplot(Pop_pyramid, aes(x =  Age,  
                    y =  Percentage, 
                    fill =  Sex)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = function(x){paste0(abs(x),"%")}, 
                     limits = max(Pop_pyramid$Percentage) * c(-1.1,1.1)) +
  labs(x = "Age", y = "Percentage of Population",
       title = paste("Population pyramid of",Names),
       subtitle = "{closest_state}",
       caption = "Data source: HMD")+
  coord_flip()+
  scale_fill_brewer(palette= "Set1")+
  theme_minimal()

p2 <- p1 + transition_states(Year, transition_length = 2,wrap = FALSE) + 
  enter_fade() +
  exit_fade() + 
  ease_aes("cubic-in-out")

# Generate gif (this will take a few minutes to run)
animate(p2,width = 10, height = 10, units = "cm",res=150, 
        renderer = gifski_renderer(loop = F), 
        nframes= length(unique(Pop_pyramid$Year))*3)

# save the gif file 
anim_save(paste0("population pyramid_",Names,"_",
                 min(Pop_pyramid$Year),"_",max(Pop_pyramid$Year),
                 ".gif"))

