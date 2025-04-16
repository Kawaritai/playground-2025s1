# Using: period TFR (tfr.txt) and cohort TFR (ccf.txt)

# a) Show the time trends of TFR and CCF for Sweden in one plot

library(ggplot2)

tfr <- read.table("tfr.txt", header=TRUE, fill=TRUE, skip=2)

ccf <- read.table("ccf.txt", header=TRUE, fill=TRUE, skip=2)

# Sweden = SWE

swe_tfr <- tfr[tfr$Code == "SWE", c("Year", "TFR", "TFR40")]

swe_ccf <- ccf[ccf$Code == "SWE", c("Cohort", "CCF", "CCF40")]

ggplot()+
  geom_line(data=swe_tfr, mapping=aes(x=Year, y=TFR, col="blue"))+
  geom_line(data=swe_ccf, mapping=aes(x=Cohort, y=CCF40, col="red"))

ggplot()+
  geom_line(data=swe_tfr, mapping=aes(x=Year, y=TFR40, col="blue"))+
  geom_line(data=swe_ccf, mapping=aes(x=Cohort + 26, y=CCF40, col="red"))
