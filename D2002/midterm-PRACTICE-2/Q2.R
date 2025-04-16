tfr <- read.table("tfr.txt", header=TRUE, skip=2, fill=TRUE)

ccf <- read.table("ccf.txt", header=TRUE, skip=2, fill=TRUE)

# Sweden = SWE

tfr_swe <- tfr[tfr$Code == "SWE", c("Year", "TFR", "TFR40")]

ccf_swe <- ccf[ccf$Code == "SWE", c("Cohort", "CCF", "CCF40")]

head(tfr_swe)
head(ccf_swe)

plot(tfr_swe)
plot(ccf_swe)

with(tfr_swe, plot(x=Year, y=TFR))
with(ccf_swe, plot(x=Cohort, y=CCF40))
library(ggplot2)

ggplot()+
  geom_line(data = tfr_swe, mapping=aes(x=Year, y=TFR, col="TFR"))+
  geom_line(data = ccf_swe, mapping=aes(x=Cohort +26, y=CCF40, col="CCF"))
# TODO: How do I modify this further? Lmao. 