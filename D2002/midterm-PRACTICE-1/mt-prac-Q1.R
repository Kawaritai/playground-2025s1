# Using: ASFR from asfrRR.txt from HFD

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
