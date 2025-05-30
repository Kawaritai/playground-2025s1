
## R tutorial 6 - Migration
## DEMO2002

# Install circlize package before the tutorial

# install.packages("circlize")

library(circlize)

## Set working directory
# setwd("  ")
# Prepare the data ####

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

# All the age bins
# 1. "0-9 years"
# 2. "10-19 years"
# 3. "20-29 years"
# 4. "30-39 years"
# 5. "40-49 years"
# 6. "50-59 years"
# 7. "60-69 years"
# 8. "70-79 years"
# 9. "80-89 years"
# 10. "90-99 years"
# 11. "100 years and over"
# 12. "Total"

age <- c("0-9 years", "10-19 years", "20-29 years", "30-39 years", 
         "40-49 years", "50-59 years", "60-69 years", "70-79 years", 
         "80-89 years", "90-99 years", "100 years and over", "Total")




df0$AGE10P...Age.in.Ten.Year.Groups[1:768] <- rep(age, each=64)

df0$STATE..5YR.[1:768]<-rep(rep(state, each=8), times=12)

df0<-df0[df0$STATE..UR.%in%state & df0$STATE..5YR.%in%state,]

# Shorten state and territory 3 letter codes
STATE=c("NSW", "VIC", "QLD", "SA", "WA", "TAS", "NT", "ACT")

# Run through replacing each unique state
for (i in 1:8){
  df0$STATE..UR.<- ifelse(df0$STATE..UR.==state[i],
                          STATE[i],  df0$STATE..UR.)
  df0$STATE..5YR.<- ifelse(df0$STATE..5YR.==state[i],
                           STATE[i], df0$STATE..5YR.)
}

# Let's count flows in thousand
df0$X <- df0$X/1000

# 3. Plot internal migration using circle plot ####

## The circle plot is adapted from: 
## Abel, G.J., and Sander, N. (2014). Quantifying global international miggration flows. Science, 343(6178): 1520-22.
## And Abel's Github https://github.com/gjabel/migest/blob/master/demo/cfplot_reg2.R

df0$AGE10P...Age.in.Ten.Year.Groups <- factor(
  df0$AGE10P...Age.in.Ten.Year.Groups,
  levels = age
)

ag0 <- split(df0, df0$AGE10P...Age.in.Ten.Year.Groups)

cols_select <- c("STATE..5YR.", "STATE..UR.", "X")

## Default chord Diagram
chordDiagram(x =  ag0[[1]][, cols_select]) # the majority of the flow are "stayers"

## exclude the "stayers" and keep only those who changed state/territory of usual residence between 2016 and 2021
df1<-df0[df0$STATE..UR.!= df0$STATE..5YR.,]
ag1 <- split(df1, df1$AGE10P...Age.in.Ten.Year.Groups)


chordDiagram(x =  ag1[[12]][, cols_select]) 

## Set parameters
## Every time you want to change default graphical settings, you need to use circos.clear() to reset it the plot.
## If you meet some errors when re-drawing the circular plot, try running circos.clear() and it will solve most of the problems.
circos.clear() 

# Step-wise plotting 

## Step 1: Add gaps between states and territories 
circos.par(gap.after = 5)

## Step 2: Change colors
my.color = c("#F0E442", "#0072B2", "#D55E00","#CC79A7", "#999999", "#E69F00", "#56B4E9", "#009E73")

# chordDiagram(x =  ag1[[1]][, cols_select], grid.col =  my.color)

## Step 3: Adjust transparency
# chordDiagram(x = ag1[[1]][, cols_select], grid.col =  my.color,
#              transparency =  0.05)

## Step 4: Add direction of flow
# chordDiagram(x = ag1[[1]][, cols_select], grid.col = my.color, 
#              transparency = 0.05,
#              directional = 1, 
#              # direction.type = c("arrows", "diffHeight"), 
#              diffHeight  = -0.04)

# chordDiagram(x = ag1[[1]][, cols_select], grid.col = my.color, 
#              transparency = 0.05,
#              directional = 1, 
#              # direction.type = c("arrows", "diffHeight"), 
#              diffHeight  = -0.04)

## Second line indicates that chords should be directional. 
### The direction of the chords will be illustrated by both arrows and a difference in height. 
### The height difference is negative to make the chord shorter at the end (with the arrow head).

## Step 5: Change the type of arrows
# (Honestly, I don't like this option)
# chordDiagram(x =, grid.col = my.color, 
#              transparency = 0.05,
#              directional = 1, 
#              direction.type = c("arrows", "diffHeight"), 
#              diffHeight  = -0.04,
#              link.arr.type =      )

## Third line indicates the plot should use big arrows, 

# Aggregate and summarise just to get the scale for age group [3]
xtab <- xtabs(X ~ STATE..5YR. + STATE..UR., data = ag1[[3]][, cols_select])
result <- as.data.frame.matrix(xtab)
sum(result)


## Step 6: Sort the flow by size 
circos.clear()
par(mfrow=c(1,1))
circos.par(gap.degree = 2, start.degree = 90)

# DO: [1] 0-9, [3] 20-29, [9] 80-89
chordDiagram(x = ag1[[3]][, cols_select], grid.col = my.color, 
             transparency = 0.05,
             directional = 1, 
             direction.type = c("arrows", "diffHeight"), 
             diffHeight  = -0.04,
             link.arr.type = "big.arrow", 
             link.sort = TRUE, link.largest.ontop = TRUE,
             scale=TRUE)

## Fourth line sort the chords left to right in each sector and  plots the smallest chords first.


## Step 7: Add title and data source to plot
title(main = "Five-year interstate migration flows ('000s) for 80-89 years, 
Australia, 2011-16 (source: 2016 Australian Census)",
      cex.main = 1.6, font.main= 2, col.main= "black",line = -3)


## Export the plot
jpeg("interstate aus 2016-21.jpg", 
     width = 1800, height = 1800,
     units = "px",res = 300)

chordDiagram(x =   , grid.col = my.color, 
             transparency = 0.05,
             directional = 1, 
             direction.type = c("arrows", "diffHeight"), 
             diffHeight  = -0.04,
             link.arr.type = "big.arrow", 
             link.sort = TRUE, link.largest.ontop = TRUE)

title(main = "Five-year interstate migration flows (in thousand), Australia, 2016-21
      (source: 2021 Australian Census)",
      cex.main = 0.9, 
      font.main= 2, 
      col.main= "black",line = -0.65)

dev.off()

