# Using: ASFR from asfrRR.txt from HFD


## Read ASFR1.txt
asfr1 <- read.table("ASFR1.txt", header=TRUE, fill=TRUE)
# Need to clean up
asfr1$Age[asfr1$Age == "12-"] <- 12
asfr1$Age[asfr1$Age == "55+"] <- 55
asfr1$Age <- as.numeric(asfr1$Age)

# Only one year: 2022

# Korea only
asfr_kor <- asfr1[asfr1$Pop == "KOR", c("Age", "ASFR", "ASFR1")]
str(asfr_kor) # lowest BR

# USA only 
asfr_usa <- asfr1[asfr1$Pop == "USA", c("Age", "ASFR", "ASFR1")]
str(asfr_usa)

# TFR = sum f(a)
tfr_kor <- sum(asfr_kor$ASFR)
tfr_usa <- sum(asfr_usa$ASFR)

# MAC = sum f(a) (a + 0.5) / sum f(a)

MAC_usa <- 0
MAC_jpn <- 0

for (a in 12:55) {
  MAC_usa <- MAC_usa + (a + 0.5) * usa$ASFR[usa$Age == a]
  MAC_jpn <- MAC_jpn + (a + 0.5) * jpn$ASFR[jpn$Age == a]
}

# Above is inefficient. This is an alternative solution:
# MAC_usa <- sum((usa$Age + 0.5) * usa$ASFR) / sum(usa$ASFR)
# MAC_jpn <- sum((jpn$Age + 0.5) * jpn$ASFR) / sum(jpn$ASFR)

MAC_usa <- MAC_usa / TFR_usa
MAC_jpn <- MAC_jpn / TFR_jpn

plot(usa$Age, usa$ASFR)

plot(jpn$Age, jpn$ASFR)

library(ggplot2)

ggplot()+
  geom_line(data = usa, mapping=aes(x = Age, y = ASFR, col="red")) +
  geom_line(data = jpn, mapping=aes(x = Age, y = ASFR, col="blue"))




## Read AUS.txt
# No cleaning needed
aus <- read.table("AUS.txt", header=TRUE, fill=TRUE)

plot(x=aus$Year[3:N-1], y=aus$netMigration[3:N-1])

