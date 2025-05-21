rm(list = ls())
options(scipen = 999)
library(ggplot2)

df <- read.table("Population.txt", header=TRUE, skip=2, fill=TRUE)
str(df)
range(df$Year)

minYear <- as.numeric(range(df$Year)[1])
maxYear <- as.numeric(range(df$Year)[2])

df$Age[df$Age == "110+"] <- "110"
df$Age <- as.numeric(df$Age)

# 1. Make a single population pyramid
{
  Year1 <- minYear
  
  # We want to extract Age, Sex, Population (pct) from df
  Pop1 <- df[df$Year == Year1, ]
  Pop1$fpct <- Pop1$Female * 100 / sum(Pop1$Total)
  Pop1$mpct <- Pop1$Male * (-1) * 100 / sum(Pop1$Total)
  str(Pop1)
    # FIX: Meant to do pct's in the original, then we only 
    # branch off in order to fix column names cleanly. 
  
  # FIX: And so, when we branch, we only take YEAR, AGE, PCT
  Pop1_F <- Pop1[, c(1, 2, 6)]
  Pop1_F$Sex <- "Female" # FIX: This is a new column. 
  names(Pop1_F)[3] <- "Percentage" # FIX: This is how you rename a column.  
  # str(Pop1_F)
  
  
  Pop1_M <- Pop1[, c(1, 2, 7)]
  Pop1_M$Sex <- "Male"
  names(Pop1_M)[3] <- "Percentage"
  # str(Pop1_M)
  
  # Look, one other way is to overwrite Pop1 with rbind (under circumstances)
  Pop1 <- rbind(Pop1_F, Pop1_M)
  str(Pop1)
  
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
}

# 2. Make population pyramid comparisons - adjacent
# Think: I think... this uses facets? Right? But how do they work? LOL. 
  # 1) Do the FIRST step, with all the years
  # 2) Add two-ish things to the former graph. It's rather easy. 
{
  str(Pop1)
  # Notice: Pop1 has "Year" attribute. Then we can cumulatively rbind
  # more of such Pops into a `Pop_total`
  
  Pop_total <- c()
  
  for (y in unique(df$Year)) {
    PopY <- df[df$Year == y, ]
    PopY$fpct <- PopY$Female * 100 / sum(PopY$Total)
    PopY$mpct <- PopY$Male * (-1) * 100 / sum(PopY$Total)
    # str(PopY)
    # FIX: Meant to do pct's in the original, then we only 
    # branch off in order to fix column names cleanly. 
    
    # FIX: And so, when we branch, we only take YEAR, AGE, PCT
    PopY_F <- PopY[, c(1, 2, 6)]
    PopY_F$Sex <- "Female" # FIX: This is a new column. 
    names(PopY_F)[3] <- "Percentage" # FIX: This is how you rename a column.  
    # str(PopY_F)
    
    
    PopY_M <- PopY[, c(1, 2, 7)]
    PopY_M$Sex <- "Male"
    names(PopY_M)[3] <- "Percentage"
    # str(PopY_M)
    
    PopY <- rbind(PopY_F, PopY_M) # OVERWRITE
    
    Pop_total <- rbind(Pop_total, PopY) # ACCUMULATE
  }
  
  
  # There are only two-ish things you need to add, to make a facet graph:
  # 1) Subset the `data` using %in%
  # 2) Use `facet_wrap`, specifying a singular formula and ncol. 
  ggplot(data = Pop_total[Pop_total$Year %in% c(1950, 2000, 2020), ], 
         mapping = aes(x=Age, y=Percentage, fill=Sex)) +
    geom_bar(stat = "identity") + 
    facet_wrap(~Year,ncol=3)+
    scale_y_continuous(
      labels = function(x) {x}, # 1
      limits = max(Pop_total$Percentage)*c(-1.1, 1.1) # 2
    ) +
    scale_x_continuous(n.breaks=10) + # 3
    # See: labels, limits, breaks!
    coord_flip() + 
    labs(title="Facets Population Pyramids",
         subtitle = paste("Year:", Year1)
    ) +
    scale_fill_brewer(palette="Set1")+
    theme_bw()
}

# 3. Make population pyramid comparison - overlap
  # Only two new things
  # 1) You add two, separate `geom_col`'s, and with them, you specify alpha
  # 2) And that's it, lol) 
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
  labs(title="Overlapping Population Pyramids",
       subtitle = paste("Year:", Year1)
  ) +
  coord_flip()+ # flip x and y axis
  guides(fill = guide_legend("Year"))+
  theme_minimal()
