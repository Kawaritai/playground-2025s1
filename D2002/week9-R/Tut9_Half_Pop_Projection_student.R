
## R tutorial  - Population projection
## DEMO
## 

options(scipen=1000000)

library(ggplot2)

#### Parameters ####

Names<-c("USA")
Names2<-c("United States of America")

YEAR<-2018

#### Mortality ####
setwd(    )

l<-read.table(     )  # female life table
lm<-read.table(    ) # male life table

### Sx and Sxm: survival ratios for females and males respectively 
### you should calculate them from the corresponding life tables 
### from the Human Mortality Database 

l<-l[  ==  ,]
lm<-lm[ ,]

Sx<-  /   
Sxm<-  /  

### L111 and L111m the survival for the last two age groups 
### (one number each)

L111<-  /      
L111m<-  / 

### (replace the last value in Sx and Sxm)
Sx[110]<-L111
Sxm[110]<-L111m


#### Population ####

Pop<-read.table(     ) # population


#### Fertility, Births and Migration####
#### NEXT WEEK

l1<-read.table("line1.txt",header=TRUE)
k<-0.243368
km<-0.254229
  
#### Leslie matrix ####

Mf<-cbind(rbind(,diag()),
          c(rep(0,110),))

Mm<-cbind(rbind(,diag()),
          c(rep(0,110),))

### Ipop and Ipopm the base population of females and males 
### respectively (111 entries each)

Ipop<-as.numeric(Pop[Pop$Year==   ,]$  )
Ipopm<-as.numeric(Pop[Pop$Year==  ,]$  )


#### Projection ####

Proj<-   			# let's look at a projection for 50 years

pop<-matrix(0,Proj,length(   )) 	
# creates a matrix with each new line 
# for each new year of the female population

popm<-matrix(0,Proj,length(   ))   # same for males

pop[  ]<- Ipop  	 #initialize the first row of female population
colnames(pop)=0:110
rownames(pop)=1:Proj

popm[  ]<- Ipopm   #initialize the first row of male population
colnames(popm)=0:110
rownames(popm)=1:Proj

Proj_Pop <- c()

for (year in 2:Proj){
  
  pop[year,]<-t(    pop[(year-1),])
  tot_birth <- pop[   ]
  pop[year,1] <- tot_birth *  
 
  
  popm[year,-1]<-t(  popm[(year-1),])[-1]
  popm[year,1] <- tot_birth * 
    
    
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
  
  PopF <- pyramid_temp[ ]
  PopF$Sex <- " "
  names(PopF)[3] <- " "
  
  PopM <- pyramid_temp[ ]
  PopM$Sex <- " "
  names(PopM)[3] <- " "
  
  pyramid_temp <- rbind(PopF,PopM)
  
  Pop_pyramid <- rbind(Pop_pyramid,pyramid_temp)
}

########### selected the year of 2050
Year1<-2050

Pop1<-Pop_pyramid[Pop_pyramid$Year==  ,]

p <- ggplot(data =  , aes(x =  ,  
                             y =  , 
                             fill =  )) + 
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = function(x){paste0(abs(x),"%")}, 
                     limits = max(Pop1$Percentage) * c(-1.1,1.1)) +
  scale_x_continuous(n.breaks = 10)+
  labs(x = "Age", y = "Percentage of Population",
       title = paste("Population pyramid of",Names),
       subtitle = paste("Year:",Year1),
       caption = "Data source: Author's calculations based on HMD")+
  coord_flip()+                        # flip x and y axis
  scale_fill_brewer(palette= "Set1")+
  theme_minimal()
p


############# now in a movie

library(gganimate)
library(gifski)

p1 <- ggplot( , aes(x =  ,  y =  , fill =  )) +
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
# anim_save(paste0("population pyramid_",Names,"_",
#                  min(Pop_pyramid$Year),"_",max(Pop_pyramid$Year),
#                  ".gif"))
