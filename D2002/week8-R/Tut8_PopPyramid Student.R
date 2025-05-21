## R tutorial - Population Pyramid
## DEMO



## We need to install and use the following packages

library(ggplot2) # for data visualization


## 1. DOWNLOAD DATA ####

## Download single-age group population size data for a selected population from HMD https://www.mortality.org/ 
## Select country (Australia) -> Complete Data Series -> Period data -> Population size -> 1-year
## Save the "Population.txt" file in your working directory

## Specify which country you choose to plot
Names<-c("Greece")

## 2. PREPARE DATA ####
# setwd(  )

# Or, if you read data from the txt file
Pop <-read.table("Deaths_1x1.txt", header=TRUE, skip=2, fill=TRUE) 

str(Pop)
unique(Pop$Age)

Pop$Age[Pop$Age=="110+"] <- "110"
Pop$Age <- as.numeric(Pop$Age)


## 3. PLOT SINGLE YEAR POPULATION PYRAMID ####

## With one year
range(Pop$Year)
Year1<-max(Pop$Year)

Pop1 <- Pop[Pop$Year==Year1,]

Pop1$pctf <-  Pop1$Female/sum(Pop1$Total) *100
Pop1$pctm <-  Pop1$Male/sum(Pop1$Total) *100*-1

PopF <- Pop1[,c(1,2,6)] # Year, Age, pctf
PopF$Sex <- "Female"
names(PopF)[3] <- "Percentage"

PopM <- Pop1[,c(1,2,7)]
PopM$Sex <- "Male"
names(PopM)[3] <- "Percentage"

Pop1 <- rbind(PopF,PopM)

p <- ggplot(data = Pop1, aes(x =  Age,  
                             y =  Percentage, 
                             fill =  Sex)) + 
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = function(x){paste0(abs(x),"%")}, 
                     limits = max(Pop1$Percentage) * c(-1.1,1.1)) +
  scale_x_continuous(n.breaks = 10)+
  labs(x = "Age", y = "Percentage of Population",
       title = paste("Population pyramid of",Names),
       subtitle = paste("Year:",Year1),
       caption = "Data source: HMD")+
  coord_flip()+                        # flip x and y axis
  scale_fill_brewer(palette= "Set1")+
  theme_minimal()
p

ggsave(paste0("population pyramid_",Names,"_",Year1,".png"),
       width=15, height=12,units="cm")

## 4. PLOT POPULATION PYRAMID ACROSS YEARS ####

Pop_total <- c()

for (year in unique(Pop$Year)){
  
  Pop_year <- Pop[Pop$Year==year,]
  
  Pop_year$pctf <- Pop_year$Female / sum(Pop_year$Total) *100
  Pop_year$pctm <- Pop_year$Male / sum(Pop_year$Total) *100*-1
  
  PopF <- Pop_year[,c(1,2,6)]
  PopF$Sex <- "Female"
  names(PopF)[3] <- "Percentage"
  
  PopM <- Pop_year[,c(1,2,7)]
  PopM$Sex <- "Male"
  names(PopM)[3] <- "Percentage"
  
  Pop_year <- rbind(PopF,PopM)
  
  Pop_total <- rbind(Pop_total,Pop_year)
}

## 4.1 Present it across facets ###

p <- 
  ggplot(Pop_total[Pop_total$Year %in% c(1981, 2000, 2019),],
         aes(x = Age,  y = Percentage, fill = Sex))+
  geom_bar(stat = "identity")+
  facet_wrap(~Year,ncol=3)+
  scale_y_continuous(labels = function(x){paste0(abs(x),"%")}, 
                     limits = max(Pop_total$Percentage) * c(-1.1,1.1)) +
  scale_x_continuous(n.breaks = 10)+
  labs(x = "Age", y = "Percentage of Population",
       title = paste("Mortality pyramids of",Names),
       caption = "Data source: HMD")+
  coord_flip()+ # flip x and y axis
  scale_fill_manual(values=c("blue","grey"))+
  theme_minimal()

p 

ggsave(paste0("population pyramid_",Names,"_","comp",".png"),
       width=20, height=8,units="cm")


### overlapping


ggplot()+
  geom_col(data=Pop_total[Pop_total$Year == 1981,],
           mapping = aes(x = Age,  y = Percentage, fill = Sex),
           alpha = 0.6,width = 1,show.legend = T)+
  geom_col(data=Pop_total[Pop_total$Year == 2019,],
           mapping = aes(x = Age,  y = Percentage, fill = Sex),
           alpha = 0.6,width = 1,show.legend = T)+
  scale_y_continuous(labels = function(x){paste0(x,"%")},
                     limits = max(Pop_total$Percentage) * c(-1.1,1.1)) +
  scale_x_continuous(n.breaks = 10)+
  scale_fill_brewer(type = "qual",palette = 2)+
  labs(x = "Age", y = "Percentage of Population",
       title = paste("Population pyramid of",Names),
       caption = "Data source: HMD")+
  coord_flip()+ # flip x and y axis
  guides(fill = guide_legend("Year"))+
  theme_minimal()+
  annotate("text",x=90,y=1,label="Female")+
  annotate("text",x=90,y=-1,label="Male")



## Alternatively, use gganimate package to generate and export a gif file
## Note: the gganimate package takes time to run.
library(gganimate)
library(gifski)

p1 <- ggplot(Pop_total, aes(x = Age,  y = Percentage, fill = Sex)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = function(x){paste0(abs(x),"%")}, 
                     limits = max(Pop_total$Percentage) * c(-1.1,1.1)) +
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
        renderer = gifski_renderer(loop = FALSE), 
        nframes= length(unique(Pop_total$Year))*2)

# save the gif file 
# anim_save(paste0("population pyramid_",Names,"_",
#                  min(Pop_total$Year),"_",max(Pop_total$Year),
#                  ".gif"))
