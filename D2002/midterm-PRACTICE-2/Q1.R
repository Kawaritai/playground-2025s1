df = read.table("asfrRR.txt", header=TRUE, fill=TRUE)

# Clean up data
str(df)
df$Age[df$Age == "-12"] <- "12"

df$Age[df$Age == "55+"] <- "55"

df$Age <- as.numeric(df$Age)

str(df)

chosen_col <- c("Age", "ASFR")
df.usa <- df[df$Country=="USA", chosen_col]
head(df.usa)

df.jpn <- df[df$Country=="JPN", chosen_col]
head(df.jpn)



# TFR = sum of all ASFR (since it's a synthetic total fertility rate)
tfr.usa <- sum(df.usa$ASFR)

tfr.jpn <- sum(df.jpn$ASFR)

tfr.usa
tfr.jpn

# Seems as if USA has a higher TFR. 

# Mean Age at Childbearing = weighted average of ASFR
calc_mac <- function(x, asfr) {
  mac <- sum(asfr * x) / sum(asfr)
  return(mac)
}

mac.usa <- calc_mac(df.usa$Age, df.usa$ASFR)
mac.jpn <- calc_mac(df.jpn$Age, df.jpn$ASFR)

mac.usa
mac.jpn

# Seems like Japan has an older mean at childbearing