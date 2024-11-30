# Histograms
library(haven)
library(tidyverse)
rm(list = ls())

# day of the week
weights_dow <- read_dta("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Weights/weights_dow.dta")

# local
local <-  weights_dow %>% filter(code_INEGI == end_code_INEGI) %>% select(code_INEGI,weight_local_dow)
local <- unique(local[c("code_INEGI","weight_local_dow")])
mean <- round(mean(local$weight_local_dow, na.rm = T), 4)
sd <- round(sd(local$weight_local_dow, na.rm = T), 4)
ggplot(local, aes(weight_local_dow)) + geom_density(color = "navy", fill = "white", na.rm = T, bw = 0.001) + theme_bw() + 
  xlab("") + 
  #xlab(paste0("1 = only local population is moving within the municipality\nmean = ",mean,"; std. dev. = ",sd)) + 
  #xlab("Local weight \n Average of benchmark period (Feb 17 - March 29)") + 
  #xlab(expression(paste(local[iw],"/","(",local[iw],"+",Sigma[i],inflow[jw],")"," \n ", "mean = ", mean,"; std. dev. = ",sd))) + 
  ylab("Density") + 
  scale_x_continuous(breaks = seq(0.4,1,0.1))
ggsave("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Weights/histogram_dow_local_density.png")
mean
sd

# inflow
inflow <-  weights_dow %>% filter(code_INEGI != end_code_INEGI) %>% select(code_INEGI,weight_inflow_dow) %>% distinct()
round(mean(inflow$weight_inflow_dow, na.rm = T), 4)
round(sd(inflow$weight_inflow_dow, na.rm = T), 4)
mean <- round(mean(inflow$weight_inflow_dow, na.rm = T), 4)
sd <- round(sd(inflow$weight_inflow_dow, na.rm = T), 4)
ggplot(inflow, aes(weight_inflow_dow)) + geom_density(color = "navy", fill = "white", na.rm = T, bw = 0.001) + theme_bw() + 
  xlab("") + 
  #xlab(paste0("1 = only local population is moving within the municipality\nmean = ",mean,"; std. dev. = ",sd)) + 
  #xlab("Inflow weight \n Average of benchmark period (Feb 17 - March 29)") + 
  #xlab(expression(paste(inflow[iw],"/","(",local[iw],"+",Sigma[i],inflow[jw],")"," \n ", "mean = ", mean,"; std. dev. = ",sd))) + 
  ylab("Density") + 
  scale_x_continuous(limits = c(0,0.5), breaks = seq(0,0.5,0.1))
ggsave("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Weights/histogram_dow_inflow_density.png")
mean
sd
