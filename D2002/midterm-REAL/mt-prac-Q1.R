## Read AUS.txt
# No cleaning needed
rm(list = ls())
aus <- read.table("AUS.txt", header=TRUE, fill=TRUE)

str(aus)

# aus$Natural <- aus$Births - aus$Deaths
# aus$PopExNatural <- aus$Population - aus$Natural


N <- nrow(aus)


for  (x in 2:N) {
  aus$netMigration[x] <- aus$Population[x] - aus$Births[x - 1] + aus$Deaths[x - 1] - aus$Population[x-1]
  aus$popChange[x] <- aus$Population[x] - aus$Population[x-1]
}

for  (x in 1:(N-1)) {
  aus$PY[x] <- (aus$Population[x] + aus$Population[x+1] )/ 2
}

aus$PY[N] <- aus$Population[N]

ggplot()+
  geom_line(data=aus, mapping=aes(x=Year, y=netMigration))+
  labs(title="Net migration over time, Australia")

# for (x in 2:N) {
#   aus$netMigrationAlt[x] <- aus$Population[x] -aus$Population[x-1] - aus$Births[x-1] + aus$Deaths[x-1]
# }
# FAKE the first and last entries
# aus$netMigration[1] <- 100000
# aus$netMigration[N] <- 100000

maxAt <- which.max(aus$netMigration)
aus[maxAt, 1:5]

minAt <- which.min(aus$netMigration)
aus[minAt, 1:5]

cgr <- aus$popChange/aus$PY
cbr <- aus$Births/aus$PY
cdr <- aus$Deaths/aus$PY
cnmr <- aus$netMigration/aus$PY

rates <- data.frame(Year=aus$Year, cgr, cbr, cdr, cnmr)


library(ggplot2)

ggplot(data=rates)+
  geom_line(mapping=aes(Year, cgr*1000, col = "CGR"))+
  geom_line(mapping=aes(Year, cbr*1000, col = "CBR"))+
  geom_line(mapping=aes(Year, cdr*1000, col = "CDR"))+
  geom_line(mapping=aes(Year, cnmr*1000, col = "CNMR"))+
  labs(y="Rate per 1000 people", title="Population Crude Rates")


