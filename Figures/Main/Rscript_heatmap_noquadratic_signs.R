# No quadratic terms (diagonal)

rm(list = ls())

# Relevant interactions

if (!require(haven)) install.packages("haven"); library(haven)
if (!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
if (!require(lattice)) install.packages("lattice"); library(lattice)
if (!require(dplyr)) install.packages("dplyr"); library(dplyr)
if (!require(Rmisc)) install.packages("Rmisc"); library(Rmisc)
if (!require(estimatr)) install.packages("estimatr"); library(estimatr)
if (!require(tidyverse)) install.packages("tidyverse"); library(tidyverse)
if (!require(zoo)) install.packages("zoo"); library(zoo)
if (!require(scales)) install.packages("scales"); library(scales)
if (!require(lubridate)) install.packages("lubridate"); library(lubridate)
if (!require(tidyr)) install.packages("tidyr"); library(tidyr)
if (!require(devtools)) install.packages("devtools"); library(devtools)
if (!require(lfe)) install.packages("lfe"); library(lfe)
if (!require(ggExtra)) install.packages("ggExtra"); library(ggExtra)
if (!require(gridExtra)) install.packages("gridExtra"); library(gridExtra)
if (!require(ggthemes)) install.packages("ggthemes"); library(ggthemes)
if (!require(coefplot)) install.packages("coefplot"); library(coefplot)
if (!require(jtools)) install.packages("jtools"); library(jtools)
if (!require(base)) install.packages("base"); library(base)
if (!require(sjmisc)) install.packages("sjmisc"); library(sjmisc)
if (!require(grid)) install.packages("grid"); library(grid)
if (!require(cowplot)) install.packages("cowplot"); library(cowplot)

setwd("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Main/")

proper=function(x) paste0(toupper(substr(x, 1, 1)), tolower(substring(x, 2)))


# keep only half of grid
{
  replace <- c(
    "local_businesses#local_alcohol" = "local_alcohol#local_businesses",
    "local_checkpoints#local_alcohol" = "local_alcohol#local_checkpoints",
    "local_curfew#local_alcohol" = "local_alcohol#local_curfew",
    "local_events#local_alcohol" = "local_alcohol#local_events",
    "local_fines#local_alcohol" = "local_alcohol#local_fines",
    "local_masks#local_alcohol" = "local_alcohol#local_masks",
    "local_transportation#local_alcohol" = "local_alcohol#local_transportation",
    "local_publicplaces#local_alcohol" = "local_alcohol#local_publicplaces",
    "local_school#local_alcohol" = "local_alcohol#local_school",
    "inflow_alcohol#local_alcohol" = "local_alcohol#inflow_alcohol",
    "inflow_businesses#local_alcohol" = "local_alcohol#inflow_businesses",
    "inflow_checkpoints#local_alcohol" = "local_alcohol#inflow_checkpoints",
    "inflow_curfew#local_alcohol" = "local_alcohol#inflow_curfew",
    "inflow_events#local_alcohol" = "local_alcohol#inflow_events",
    "inflow_fines#local_alcohol" = "local_alcohol#inflow_fines",
    "inflow_masks#local_alcohol" = "local_alcohol#inflow_masks",
    "inflow_transportation#local_alcohol" = "local_alcohol#inflow_transportation",
    "inflow_publicplaces#local_alcohol" = "local_alcohol#inflow_publicplaces",
    "inflow_school#local_alcohol" = "local_alcohol#inflow_school",
    "local_checkpoints#local_businesses" = "local_businesses#local_checkpoints",
    "local_curfew#local_businesses" = "local_businesses#local_curfew",
    "local_events#local_businesses" = "local_businesses#local_events",
    "local_fines#local_businesses" = "local_businesses#local_fines",
    "local_masks#local_businesses" = "local_businesses#local_masks",
    "local_transportation#local_businesses" = "local_businesses#local_transportation",
    "local_publicplaces#local_businesses" = "local_businesses#local_publicplaces",
    "local_school#local_businesses" = "local_businesses#local_school",
    "inflow_alcohol#local_businesses" = "local_businesses#inflow_alcohol",
    "inflow_businesses#local_businesses" = "local_businesses#inflow_businesses",
    "inflow_checkpoints#local_businesses" = "local_businesses#inflow_checkpoints",
    "inflow_curfew#local_businesses" = "local_businesses#inflow_curfew",
    "inflow_events#local_businesses" = "local_businesses#inflow_events",
    "inflow_fines#local_businesses" = "local_businesses#inflow_fines",
    "inflow_masks#local_businesses" = "local_businesses#inflow_masks",
    "inflow_transportation#local_businesses" = "local_businesses#inflow_transportation",
    "inflow_publicplaces#local_businesses" = "local_businesses#inflow_publicplaces",
    "inflow_school#local_businesses" = "local_businesses#inflow_school",
    "local_curfew#local_checkpoints" = "local_checkpoints#local_curfew",
    "local_events#local_checkpoints" = "local_checkpoints#local_events",
    "local_fines#local_checkpoints" = "local_checkpoints#local_fines",
    "local_masks#local_checkpoints" = "local_checkpoints#local_masks",
    "local_transportation#local_checkpoints" = "local_checkpoints#local_transportation",
    "local_publicplaces#local_checkpoints" = "local_checkpoints#local_publicplaces",
    "local_school#local_checkpoints" = "local_checkpoints#local_school",
    "inflow_alcohol#local_checkpoints" = "local_checkpoints#inflow_alcohol",
    "inflow_businesses#local_checkpoints" = "local_checkpoints#inflow_businesses",
    "inflow_checkpoints#local_checkpoints" = "local_checkpoints#inflow_checkpoints",
    "inflow_curfew#local_checkpoints" = "local_checkpoints#inflow_curfew",
    "inflow_events#local_checkpoints" = "local_checkpoints#inflow_events",
    "inflow_fines#local_checkpoints" = "local_checkpoints#inflow_fines",
    "inflow_masks#local_checkpoints" = "local_checkpoints#inflow_masks",
    "inflow_transportation#local_checkpoints" = "local_checkpoints#inflow_transportation",
    "inflow_publicplaces#local_checkpoints" = "local_checkpoints#inflow_publicplaces",
    "inflow_school#local_checkpoints" = "local_checkpoints#inflow_school",
    "local_events#local_curfew" = "local_curfew#local_events",
    "local_fines#local_curfew" = "local_curfew#local_fines",
    "local_masks#local_curfew" = "local_curfew#local_masks",
    "local_transportation#local_curfew" = "local_curfew#local_transportation",
    "local_publicplaces#local_curfew" = "local_curfew#local_publicplaces",
    "local_school#local_curfew" = "local_curfew#local_school",
    "inflow_alcohol#local_curfew" = "local_curfew#inflow_alcohol",
    "inflow_businesses#local_curfew" = "local_curfew#inflow_businesses",
    "inflow_checkpoints#local_curfew" = "local_curfew#inflow_checkpoints",
    "inflow_curfew#local_curfew" = "local_curfew#inflow_curfew",
    "inflow_events#local_curfew" = "local_curfew#inflow_events",
    "inflow_fines#local_curfew" = "local_curfew#inflow_fines",
    "inflow_masks#local_curfew" = "local_curfew#inflow_masks",
    "inflow_transportation#local_curfew" = "local_curfew#inflow_transportation",
    "inflow_publicplaces#local_curfew" = "local_curfew#inflow_publicplaces",
    "inflow_school#local_curfew" = "local_curfew#inflow_school",
    "local_fines#local_events" = "local_events#local_fines",
    "local_masks#local_events" = "local_events#local_masks",
    "local_transportation#local_events" = "local_events#local_transportation",
    "local_publicplaces#local_events" = "local_events#local_publicplaces",
    "local_school#local_events" = "local_events#local_school",
    "inflow_alcohol#local_events" = "local_events#inflow_alcohol",
    "inflow_businesses#local_events" = "local_events#inflow_businesses",
    "inflow_checkpoints#local_events" = "local_events#inflow_checkpoints",
    "inflow_curfew#local_events" = "local_events#inflow_curfew",
    "inflow_events#local_events" = "local_events#inflow_events",
    "inflow_fines#local_events" = "local_events#inflow_fines",
    "inflow_masks#local_events" = "local_events#inflow_masks",
    "inflow_transportation#local_events" = "local_events#inflow_transportation",
    "inflow_publicplaces#local_events" = "local_events#inflow_publicplaces",
    "inflow_school#local_events" = "local_events#inflow_school",
    "local_masks#local_fines" = "local_fines#local_masks",
    "local_transportation#local_fines" = "local_fines#local_transportation",
    "local_publicplaces#local_fines" = "local_fines#local_publicplaces",
    "local_school#local_fines" = "local_fines#local_school",
    "inflow_alcohol#local_fines" = "local_fines#inflow_alcohol",
    "inflow_businesses#local_fines" = "local_fines#inflow_businesses",
    "inflow_checkpoints#local_fines" = "local_fines#inflow_checkpoints",
    "inflow_curfew#local_fines" = "local_fines#inflow_curfew",
    "inflow_events#local_fines" = "local_fines#inflow_events",
    "inflow_fines#local_fines" = "local_fines#inflow_fines",
    "inflow_masks#local_fines" = "local_fines#inflow_masks",
    "inflow_transportation#local_fines" = "local_fines#inflow_transportation",
    "inflow_publicplaces#local_fines" = "local_fines#inflow_publicplaces",
    "inflow_school#local_fines" = "local_fines#inflow_school",
    "local_transportation#local_masks" = "local_masks#local_transportation",
    "local_publicplaces#local_masks" = "local_masks#local_publicplaces",
    "local_school#local_masks" = "local_masks#local_school",
    "inflow_alcohol#local_masks" = "local_masks#inflow_alcohol",
    "inflow_businesses#local_masks" = "local_masks#inflow_businesses",
    "inflow_checkpoints#local_masks" = "local_masks#inflow_checkpoints",
    "inflow_curfew#local_masks" = "local_masks#inflow_curfew",
    "inflow_events#local_masks" = "local_masks#inflow_events",
    "inflow_fines#local_masks" = "local_masks#inflow_fines",
    "inflow_masks#local_masks" = "local_masks#inflow_masks",
    "inflow_transportation#local_masks" = "local_masks#inflow_transportation",
    "inflow_publicplaces#local_masks" = "local_masks#inflow_publicplaces",
    "inflow_school#local_masks" = "local_masks#inflow_school",
    "local_transportation#local_publicplaces" = "local_publicplaces#local_transportation",
    "local_school#local_transportation" = "local_transportation#local_school",
    "inflow_alcohol#local_transportation" = "local_transportation#inflow_alcohol",
    "inflow_businesses#local_transportation" = "local_transportation#inflow_businesses",
    "inflow_checkpoints#local_transportation" = "local_transportation#inflow_checkpoints",
    "inflow_curfew#local_transportation" = "local_transportation#inflow_curfew",
    "inflow_events#local_transportation" = "local_transportation#inflow_events",
    "inflow_fines#local_transportation" = "local_transportation#inflow_fines",
    "inflow_masks#local_transportation" = "local_transportation#inflow_masks",
    "inflow_transportation#local_transportation" = "local_transportation#inflow_transportation",
    "inflow_publicplaces#local_transportation" = "local_transportation#inflow_publicplaces",
    "inflow_school#local_transportation" = "local_transportation#inflow_school",
    "local_school#local_publicplaces" = "local_publicplaces#local_school",
    "inflow_alcohol#local_publicplaces" = "local_publicplaces#inflow_alcohol",
    "inflow_businesses#local_publicplaces" = "local_publicplaces#inflow_businesses",
    "inflow_checkpoints#local_publicplaces" = "local_publicplaces#inflow_checkpoints",
    "inflow_curfew#local_publicplaces" = "local_publicplaces#inflow_curfew",
    "inflow_events#local_publicplaces" = "local_publicplaces#inflow_events",
    "inflow_fines#local_publicplaces" = "local_publicplaces#inflow_fines",
    "inflow_masks#local_publicplaces" = "local_publicplaces#inflow_masks",
    "inflow_transportation#local_publicplaces" = "local_publicplaces#inflow_transportation",
    "inflow_publicplaces#local_publicplaces" = "local_publicplaces#inflow_publicplaces",
    "inflow_school#local_publicplaces" = "local_publicplaces#inflow_school",
    "inflow_alcohol#local_school" = "local_school#inflow_alcohol",
    "inflow_businesses#local_school" = "local_school#inflow_businesses",
    "inflow_checkpoints#local_school" = "local_school#inflow_checkpoints",
    "inflow_curfew#local_school" = "local_school#inflow_curfew",
    "inflow_events#local_school" = "local_school#inflow_events",
    "inflow_fines#local_school" = "local_school#inflow_fines",
    "inflow_masks#local_school" = "local_school#inflow_masks",
    "inflow_transportation#local_school" = "local_school#inflow_transportation",
    "inflow_publicplaces#local_school" = "local_school#inflow_publicplaces",
    "inflow_school#local_school" = "local_school#inflow_school",
    "inflow_businesses#inflow_alcohol" = "inflow_alcohol#inflow_businesses",
    "inflow_checkpoints#inflow_alcohol" = "inflow_alcohol#inflow_checkpoints",
    "inflow_curfew#inflow_alcohol" = "inflow_alcohol#inflow_curfew",
    "inflow_events#inflow_alcohol" = "inflow_alcohol#inflow_events",
    "inflow_fines#inflow_alcohol" = "inflow_alcohol#inflow_fines",
    "inflow_masks#inflow_alcohol" = "inflow_alcohol#inflow_masks",
    "inflow_transportation#inflow_alcohol" = "inflow_alcohol#inflow_transportation",
    "inflow_publicplaces#inflow_alcohol" = "inflow_alcohol#inflow_publicplaces",
    "inflow_school#inflow_alcohol" = "inflow_alcohol#inflow_school",
    "inflow_checkpoints#inflow_businesses" = "inflow_businesses#inflow_checkpoints",
    "inflow_curfew#inflow_businesses" = "inflow_businesses#inflow_curfew",
    "inflow_events#inflow_businesses" = "inflow_businesses#inflow_events",
    "inflow_fines#inflow_businesses" = "inflow_businesses#inflow_fines",
    "inflow_masks#inflow_businesses" = "inflow_businesses#inflow_masks",
    "inflow_transportation#inflow_businesses" = "inflow_businesses#inflow_transportation",
    "inflow_publicplaces#inflow_businesses" = "inflow_businesses#inflow_publicplaces",
    "inflow_school#inflow_businesses" = "inflow_businesses#inflow_school",
    "inflow_curfew#inflow_checkpoints" = "inflow_checkpoints#inflow_curfew",
    "inflow_events#inflow_checkpoints" = "inflow_checkpoints#inflow_events",
    "inflow_fines#inflow_checkpoints" = "inflow_checkpoints#inflow_fines",
    "inflow_masks#inflow_checkpoints" = "inflow_checkpoints#inflow_masks",
    "inflow_transportation#inflow_checkpoints" = "inflow_checkpoints#inflow_transportation",
    "inflow_publicplaces#inflow_checkpoints" = "inflow_checkpoints#inflow_publicplaces",
    "inflow_school#inflow_checkpoints" = "inflow_checkpoints#inflow_school",
    "inflow_events#inflow_curfew" = "inflow_curfew#inflow_events",
    "inflow_fines#inflow_curfew" = "inflow_curfew#inflow_fines",
    "inflow_masks#inflow_curfew" = "inflow_curfew#inflow_masks",
    "inflow_transportation#inflow_curfew" = "inflow_curfew#inflow_transportation",
    "inflow_publicplaces#inflow_curfew" = "inflow_curfew#inflow_publicplaces",
    "inflow_school#inflow_curfew" = "inflow_curfew#inflow_school",
    "inflow_fines#inflow_events" = "inflow_events#inflow_fines",
    "inflow_masks#inflow_events" = "inflow_events#inflow_masks",
    "inflow_transportation#inflow_events" = "inflow_events#inflow_transportation",
    "inflow_publicplaces#inflow_events" = "inflow_events#inflow_publicplaces",
    "inflow_school#inflow_events" = "inflow_events#inflow_school",
    "inflow_masks#inflow_fines" = "inflow_fines#inflow_masks",
    "inflow_transportation#inflow_fines" = "inflow_fines#inflow_transportation",
    "inflow_publicplaces#inflow_fines" = "inflow_fines#inflow_publicplaces",
    "inflow_school#inflow_fines" = "inflow_fines#inflow_school",
    "inflow_transportation#inflow_masks" = "inflow_masks#inflow_transportation",
    "inflow_publicplaces#inflow_masks" = "inflow_masks#inflow_publicplaces",
    "inflow_school#inflow_masks" = "inflow_masks#inflow_school",
    "inflow_transportation#inflow_publicplaces" = "inflow_publicplaces#inflow_transportation",
    "inflow_school#inflow_transportation" = "inflow_transportation#inflow_school",
    "inflow_school#inflow_publicplaces" = "inflow_publicplaces#inflow_school",
    "local_alcohol#local_alcohol" = "local_alcohol#local_alcohol",
    "local_businesses#local_businesses" = "local_businesses#local_businesses",
    "local_checkpoints#local_checkpoints" = "local_checkpoints#local_checkpoints",
    "local_curfew#local_curfew" = "local_curfew#local_curfew",
    "local_events#local_events" = "local_events#local_events",
    "local_fines#local_fines" = "local_fines#local_fines",
    "local_masks#local_masks" = "local_masks#local_masks",
    "local_transportation#local_transportation" = "local_transportation#local_transportation",
    "local_publicplaces#local_publicplaces" = "local_publicplaces#local_publicplaces",
    "local_school#local_school" = "local_school#local_school",
    "inflow_alcohol#inflow_alcohol" = "inflow_alcohol#inflow_alcohol",
    "inflow_businesses#inflow_businesses" = "inflow_businesses#inflow_businesses",
    "inflow_checkpoints#inflow_checkpoints" = "inflow_checkpoints#inflow_checkpoints",
    "inflow_curfew#inflow_curfew" = "inflow_curfew#inflow_curfew",
    "inflow_events#inflow_events" = "inflow_events#inflow_events",
    "inflow_fines#inflow_fines" = "inflow_fines#inflow_fines",
    "inflow_masks#inflow_masks" = "inflow_masks#inflow_masks",
    "inflow_transportation#inflow_transportation" = "inflow_transportation#inflow_transportation",
    "inflow_publicplaces#inflow_publicplaces" = "inflow_publicplaces#inflow_publicplaces",
    "inflow_school#inflow_school" = "inflow_school#inflow_school"
  )
}


m5 <- read.csv("m5_heatmap_nodiagonal.csv") %>%
  subset(iden3 == "m5") %>% # m5 only (not m5_14 nor m5_21)
  mutate(vars_original = graph) %>%
  mutate(graph = gsub("_mobility","_transportation",graph)) %>%
  mutate(positive_coef = ifelse(coef>0,1,0))

m5$graph <- str_replace_all(m5$graph,replace) 

m5 <- m5 %>%
  separate(graph, c("policy_1","policy_2"),sep = "#") %>%
  arrange(policy_1) %>% 
  mutate(vars = ifelse(is.na(policy_2) == F, paste0(policy_1,"#",policy_2), policy_1))

m5_lags <- read.csv("m5_heatmap_nodiagonal.csv") %>%
  subset(iden3 == "m5_lags") %>% # m5 lags from t to t-7
  mutate(vars_original = graph) %>%
  mutate(graph = gsub("_mobility","_transportation",graph)) %>%
  mutate(positive_coef = ifelse(coef>0,1,0))

m5_lags$graph <- str_replace_all(m5_lags$graph,replace) 

m5_lags <- m5_lags %>%
  separate(graph, c("policy_1","policy_2"),sep = "#") %>%
  arrange(policy_1) %>% 
  mutate(vars = ifelse(is.na(policy_2) == F, paste0(policy_1,"#",policy_2), policy_1))

# back(ground)
{
  restrictions <- c("alcohol","businesses","checkpoints","curfew","events","fines","masks","publicplaces","transportation")
  type <- c("local","inflow")
  back1 <- apply(expand.grid(type,restrictions), 1, paste, collapse="_")
  back <- apply(expand.grid(back1,back1), 1, paste, collapse="#")
  back <- as.data.frame(back) %>% separate(back, c("policy_1","policy_2"),sep = "#") 
  back <- back %>% mutate(depvar = gsub("local_|inflow_","",policy_1),
                          type = gsub("_","",str_replace(policy_1,depvar,"")))
  # order              
  back1 <- as.data.frame(back1) %>% mutate(depvar = gsub("local_|inflow_","",back1),
                                           type = gsub("_","",str_replace(back1,depvar,""))) %>%
    arrange(desc(type),depvar) %>% dplyr::mutate(back1, order = row_number())
  
  back <- left_join(back,back1, by = c("depvar","type")) %>% select(-back1) %>%
    arrange(order, policy_2)
  
  back1 <- back1 %>% mutate(policy_2 = back1)
  back <- left_join(back1,back, by = "policy_2", suffix = c("_2","")) %>% select(-back1,-depvar_2,-type_2)
  # diagonal / quadratic terms
  back$quadratic <- ifelse(back$policy_1 == back$policy_2,1,0)
  # if NA, gray area
  back <- back %>% mutate(inter = ifelse(is.na(policy_2) == F, paste0(policy_1,"#",policy_2), policy_1))
  nas <- as.data.frame(replace) %>% dplyr::rename(inter = replace) %>% mutate(nas = 1)
  back <- left_join(back,nas)
  }

# SS (statistical significance)

# MR2, interactions

{
  mr2_int <- subset(m5,interactionss == 1 & iden1 == "mr2") %>%
    group_by(vars) %>% add_count(name = "n") %>%
    distinct(policy_1,policy_2,n)
  
  mr2_int_positive <- subset(m5,interactionss == 1 & iden1 == "mr2" & positive_coef == 1) %>%
    group_by(vars) %>% add_count(name = "n_positive") %>%
    distinct(policy_1,policy_2,n_positive)
  mr2_int_negative <- subset(m5,interactionss == 1 & iden1 == "mr2" & positive_coef == 0) %>%
    group_by(vars) %>% add_count(name = "n_negative") %>%
    distinct(policy_1,policy_2,n_negative)
  
  mr2_int_sign <- full_join(mr2_int_positive,mr2_int_negative, by = c("policy_1","policy_2"), suffix = c("","")) %>%
    mutate(n_negative = ifelse(is.na(n_negative) == T, 0, n_negative)) %>%
    mutate(n_positive = ifelse(is.na(n_positive) == T, 0, n_positive))
  mr2_int <- left_join(mr2_int,mr2_int_sign, by = c("policy_1","policy_2"), suffix = c("",""))
  mr2_int <- mr2_int %>% mutate(values = ifelse(is.na(n_positive) & is.na(n_negative),"",paste0(n_positive,"/",n_negative)))
  
  mr2_int <- left_join(back,mr2_int, by = c("policy_1","policy_2"), suffix = c("",".y"), all = T) %>%
    mutate(n = ifelse(is.na(n) == T & nas == 1,0,n)) %>%
    mutate(n = ifelse(quadratic == 1 & n == 0,NA,n)) # second condition to make sure estimation code was correct
  
  breaks <- c(na.omit(unique(as.numeric(mr2_int$n))),length(unique(m5$iden2)))
  
  ggplot(mr2_int, aes(x = reorder(policy_1,order), y = reorder(policy_2,desc(order_2)))) +
    geom_tile(aes(fill = n)) + 
    geom_text(aes(label = values), color = "black", size = 4) +
    annotate(geom="text", x=20.25, y=4.6, col="black",label="Sign of the\ncoefficient:\nPositive / Negative") + 
    #geom_text(data = . %>% mutate(n_positive = ifelse(is.na(n_positive)==T,as.character(""), as.character(n_positive)),
    #                              n_negative = ifelse(is.na(n_negative)==T,as.character(""), as.character(n_negative))),
    #          aes(label = paste0(n_positive,"/",n_negative)), 
    #          color = "black", size = 4) +
    ylab(label = (expression(paste("External                     ",bold(Policy),"                     Local")))) + 
    xlab(label = (expression(paste("Local                                      ",bold(Policy),"                                      External")))) + 
    scale_y_discrete(labels=c("local_alcohol" = "Alcohol",
                              "local_businesses" = "Businesses",
                              "local_checkpoints" = "Checkpoints",
                              "local_curfew" = "Curfew",
                              "local_events" = "Events",
                              "local_fines" = "Fines",
                              "local_masks" = "Masks",
                              "local_transportation" = "Transportation",
                              "local_publicplaces" = "Public Spaces",
                              "inflow_alcohol" = "Alcohol",
                              "inflow_businesses" = "Businesses",
                              "inflow_checkpoints" = "Checkpoints",
                              "inflow_curfew" = "Curfew",
                              "inflow_events" = "Events",
                              "inflow_fines" = "Fines",
                              "inflow_masks" = "Masks",
                              "inflow_transportation" = "Transportation",
                              "inflow_publicplaces" = "Public Spaces")) + 
    scale_x_discrete(labels=c("local_alcohol" = "Alcohol",
                              "local_businesses" = "Businesses",
                              "local_checkpoints" = "Checkpoints",
                              "local_curfew" = "Curfew",
                              "local_events" = "Events",
                              "local_fines" = "Fines",
                              "local_masks" = "Masks",
                              "local_transportation" = "Transportation",
                              "local_publicplaces" = "Public Spaces",
                              "inflow_alcohol" = "Alcohol",
                              "inflow_businesses" = "Businesses",
                              "inflow_checkpoints" = "Checkpoints",
                              "inflow_curfew" = "Curfew",
                              "inflow_events" = "Events",
                              "inflow_fines" = "Fines",
                              "inflow_masks" = "Masks",
                              "inflow_transportation" = "Transportation",
                              "inflow_publicplaces" = "Public Spaces")) + 
    coord_cartesian(ylim = c(1,18), xlim = c(1,18), clip = "off") + 
    # annotate(geom = "text", x=5, y=-12, label="Local") +
    # annotate(geom = "text", x=15, y=-12, label="Inflow") +
    # annotate(geom = "text", x=-7, y=5, label="Inflow") +
    # annotate(geom = "text", x=-7, y=15, label="Local") +
    geom_vline(xintercept = 9.5, linetype = "solid") + 
    geom_hline(yintercept = 9.5, linetype = "solid") + 
    scale_fill_gradient(low = "white", high = "steelblue", 
                        na.value = "gray80",
                        limits = c(0,length(unique(m5$iden2))),
                        breaks = breaks,
                        name = "Frequency\n") + 
    theme_bw() + 
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
          plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5),
          axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0), size = 16),
          axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0), size = 16),
          text = element_text(size = 14)) + 
    #ggtitle(expression(paste("Perc. of users present in only one tile (0.6 km by 0.6km sq) in at least 3 hours of the day (", italic("stay-at-home outcome"),")"))) + 
    #labs(subtitle = "Number of times first-order interaction was selected by LASSO and registered statistical significance at the 0.05 level\nLASSO Spillovers interactions: All policies at t interacted") 
    ggsave("mr2_heatmap_ss_noquadratic_signs.png", height = 7, width = 10)
}

# COVID PC, interactions

{
  covid_int <- subset(m5,interactionss == 1 & iden1 == "covid_1_pc") %>%
    group_by(vars) %>% add_count(name = "n") %>%
    distinct(policy_1,policy_2,n)
  
  covid_int_positive <- subset(m5,interactionss == 1 & iden1 == "covid_1_pc" & positive_coef == 1) %>%
    group_by(vars) %>% add_count(name = "n_positive") %>%
    distinct(policy_1,policy_2,n_positive)
  covid_int_negative <- subset(m5,interactionss == 1 & iden1 == "covid_1_pc" & positive_coef == 0) %>%
    group_by(vars) %>% add_count(name = "n_negative") %>%
    distinct(policy_1,policy_2,n_negative)
  
  covid_int_sign <- full_join(covid_int_positive,covid_int_negative, by = c("policy_1","policy_2"), suffix = c("","")) %>%
    mutate(n_negative = ifelse(is.na(n_negative) == T, 0, n_negative)) %>%
    mutate(n_positive = ifelse(is.na(n_positive) == T, 0, n_positive))
  covid_int <- left_join(covid_int,covid_int_sign, by = c("policy_1","policy_2"), suffix = c("",""))
  covid_int <- covid_int %>% mutate(values = ifelse(is.na(n_positive) & is.na(n_negative),"",paste0(n_positive,"/",n_negative)))
  
  covid_int <- left_join(back,covid_int, by = c("policy_1","policy_2"), suffix = c("",".y"), all = T) %>%
    mutate(n = ifelse(is.na(n) == T & nas == 1,0,n))
  
  covid_int <- covid_int %>%
    mutate(policy_1_dv = proper(gsub("local_|inflow_","",policy_1)),
           policy_2_dv = proper(gsub("local_|inflow_","",policy_2))) %>%
    mutate(n = ifelse(quadratic == 1 & n == 0,NA,n)) # second condition to make sure estimation code was correct
  
  breaks <- c(na.omit(unique(as.numeric(covid_int$n))), length(unique(m5$iden2)))
  
  ggplot(covid_int, aes(x = reorder(policy_1,order), y = reorder(policy_2,desc(order_2)))) +
    geom_tile(aes(fill = n)) + 
    geom_text(aes(label = values), color = "black", size = 4) +
    annotate(geom="text", x=20.25, y=4.6, col="black",label="Sign of the\ncoefficient:\nPositive / Negative") + 
    ylab(label = (expression(paste("External                     ",bold(Policy),"                     Local")))) + 
    xlab(label = (expression(paste("Local                                      ",bold(Policy),"                                      External")))) + 
    scale_y_discrete(labels=c("local_alcohol" = "Alcohol",
                              "local_businesses" = "Businesses",
                              "local_checkpoints" = "Checkpoints",
                              "local_curfew" = "Curfew",
                              "local_events" = "Events",
                              "local_fines" = "Fines",
                              "local_masks" = "Masks",
                              "local_transportation" = "Transportation",
                              "local_publicplaces" = "Public Spaces",
                              "inflow_alcohol" = "Alcohol",
                              "inflow_businesses" = "Businesses",
                              "inflow_checkpoints" = "Checkpoints",
                              "inflow_curfew" = "Curfew",
                              "inflow_events" = "Events",
                              "inflow_fines" = "Fines",
                              "inflow_masks" = "Masks",
                              "inflow_transportation" = "Transportation",
                              "inflow_publicplaces" = "Public Spaces")) + 
    scale_x_discrete(labels=c("local_alcohol" = "Alcohol",
                              "local_businesses" = "Businesses",
                              "local_checkpoints" = "Checkpoints",
                              "local_curfew" = "Curfew",
                              "local_events" = "Events",
                              "local_fines" = "Fines",
                              "local_masks" = "Masks",
                              "local_transportation" = "Transportation",
                              "local_publicplaces" = "Public Spaces",
                              "inflow_alcohol" = "Alcohol",
                              "inflow_businesses" = "Businesses",
                              "inflow_checkpoints" = "Checkpoints",
                              "inflow_curfew" = "Curfew",
                              "inflow_events" = "Events",
                              "inflow_fines" = "Fines",
                              "inflow_masks" = "Masks",
                              "inflow_transportation" = "Transportation",
                              "inflow_publicplaces" = "Public Spaces")) + 
    coord_cartesian(ylim = c(1,18), xlim = c(1,18), clip = "off") + 
    # annotate(geom = "text", x=5, y=-12, label="Local") +
    # annotate(geom = "text", x=15, y=-12, label="Inflow") +
    # annotate(geom = "text", x=-7, y=5, label="Inflow") +
    # annotate(geom = "text", x=-7, y=15, label="Local") +
    geom_vline(xintercept = 9.5, linetype = "solid") + 
    geom_hline(yintercept = 9.5, linetype = "solid") + 
    scale_fill_gradient(low = "white", high = "steelblue", 
                        limits = c(0,length(unique(m5$iden2))), 
                        na.value = "gray80",
                        breaks = breaks,
                        name = "Frequency\n") + 
    theme_bw() + 
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
          plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5),
          axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0), size = 16),
          axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0), size = 16),
          text = element_text(size = 14)) + 
    #ggtitle("New COVID-19 cases") +
    #labs(subtitle = "Number of times first-order interaction was selected by LASSO and registered statistical significance at the 0.05 level\nLASSO Spillovers interactions: All policies at t-7 interacted") 
    ggsave("covid_heatmap_ss_noquadratic_signs.png", height = 7, width = 10)
}

# COVID PC, lags from t to t-7, interactions

{
  covid_int <- subset(m5_lags,interactionss == 1 & iden1 == "covid_1_pc") %>%
    group_by(vars) %>% add_count(name = "n") %>%
    distinct(policy_1,policy_2,n) 

  covid_int_positive <- subset(m5_lags,interactionss == 1 & iden1 == "covid_1_pc" & positive_coef == 1) %>%
    group_by(vars) %>% add_count(name = "n_positive") %>%
    distinct(policy_1,policy_2,n_positive)
  covid_int_negative <- subset(m5_lags,interactionss == 1 & iden1 == "covid_1_pc" & positive_coef == 0) %>%
    group_by(vars) %>% add_count(name = "n_negative") %>%
    distinct(policy_1,policy_2,n_negative)
  
  covid_int_sign <- full_join(covid_int_positive,covid_int_negative, by = c("policy_1","policy_2"), suffix = c("","")) %>%
    mutate(n_negative = ifelse(is.na(n_negative) == T, 0, n_negative)) %>%
    mutate(n_positive = ifelse(is.na(n_positive) == T, 0, n_positive))
  covid_int <- left_join(covid_int,covid_int_sign, by = c("policy_1","policy_2"), suffix = c("",""))
  covid_int <- covid_int %>% mutate(values = ifelse(is.na(n_positive) & is.na(n_negative),"",paste0(n_positive,"/",n_negative))) %>%
    mutate(values = ifelse(length(values) >= 7 & is.na(values) == F,gsub(" ","",values,fixed=TRUE),values))
  
  covid_int <- left_join(back,covid_int, by = c("policy_1","policy_2"), suffix = c("",".y"), all = T) %>%
    mutate(n = ifelse(is.na(n) == T & nas == 1,0,n))
  
  covid_int <- covid_int %>%
    mutate(policy_1_dv = proper(gsub("local_|inflow_","",policy_1)),
           policy_2_dv = proper(gsub("local_|inflow_","",policy_2))) %>%
    mutate(n = ifelse(quadratic == 1 & n == 0,NA,n)) # second condition to make sure estimation code was correct
  
  breaks <- sort(na.omit(unique(as.numeric(covid_int$n))))
  breaks <- c(0,seq(15,50,10),max(breaks),80)
  
  ggplot(covid_int, aes(x = reorder(policy_1,order), y = reorder(policy_2,desc(order_2)))) +
    geom_tile(aes(fill = n)) + 
    geom_text(aes(label = values), color = "black", size = 4) +
    annotate(geom="text", x=20.25, y=4.6, col="black",label="Sign of the\ncoefficient:\nPositive / Negative") + 
    ylab(label = (expression(paste("External                     ",bold(Policy),"                     Local")))) + 
    xlab(label = (expression(paste("Local                                      ",bold(Policy),"                                      External")))) + 
    scale_y_discrete(labels=c("local_alcohol" = "Alcohol",
                              "local_businesses" = "Businesses",
                              "local_checkpoints" = "Checkpoints",
                              "local_curfew" = "Curfew",
                              "local_events" = "Events",
                              "local_fines" = "Fines",
                              "local_masks" = "Masks",
                              "local_transportation" = "Transportation",
                              "local_publicplaces" = "Public Spaces",
                              "inflow_alcohol" = "Alcohol",
                              "inflow_businesses" = "Businesses",
                              "inflow_checkpoints" = "Checkpoints",
                              "inflow_curfew" = "Curfew",
                              "inflow_events" = "Events",
                              "inflow_fines" = "Fines",
                              "inflow_masks" = "Masks",
                              "inflow_transportation" = "Transportation",
                              "inflow_publicplaces" = "Public Spaces")) + 
    scale_x_discrete(labels=c("local_alcohol" = "Alcohol",
                              "local_businesses" = "Businesses",
                              "local_checkpoints" = "Checkpoints",
                              "local_curfew" = "Curfew",
                              "local_events" = "Events",
                              "local_fines" = "Fines",
                              "local_masks" = "Masks",
                              "local_transportation" = "Transportation",
                              "local_publicplaces" = "Public Spaces",
                              "inflow_alcohol" = "Alcohol",
                              "inflow_businesses" = "Businesses",
                              "inflow_checkpoints" = "Checkpoints",
                              "inflow_curfew" = "Curfew",
                              "inflow_events" = "Events",
                              "inflow_fines" = "Fines",
                              "inflow_masks" = "Masks",
                              "inflow_transportation" = "Transportation",
                              "inflow_publicplaces" = "Public Spaces")) + 
    coord_cartesian(ylim = c(1,18), xlim = c(1,18), clip = "off") + 
    # annotate(geom = "text", x=5, y=-12, label="Local") +
    # annotate(geom = "text", x=15, y=-12, label="Inflow") +
    # annotate(geom = "text", x=-7, y=5, label="Inflow") +
    # annotate(geom = "text", x=-7, y=15, label="Local") +
    geom_vline(xintercept = 9.5, linetype = "solid") + 
    geom_hline(yintercept = 9.5, linetype = "solid") + 
    scale_fill_gradient(low = "white", high = "steelblue", 
                        limits = c(0,80), 
                        na.value = "gray80",
                        breaks = breaks,
                        name = "Frequency\n") + 
    theme_bw() + 
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
          plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5),
          axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0), size = 16),
          axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0), size = 16),
          text = element_text(size = 14)) + 
    #ggtitle("New COVID-19 cases") +
    #labs(subtitle = "Number of times first-order interaction was selected by LASSO and registered statistical significance at the 0.05 level\nLASSO Spillovers interactions: All policies at t-7 interacted") 
    ggsave("covid_lags_t_to_t-7_heatmap_ss_noquadratic_signs.png", height = 7, width = 10)
}

# Mobility (MR2) + Covid cases (COVID_PC)

{
mr2_int <- subset(m5,interactionss == 1 & iden1 == "mr2") %>%
  group_by(vars) %>% add_count(name = "n") %>%
  distinct(policy_1,policy_2,n)

mr2_int_positive <- subset(m5,interactionss == 1 & iden1 == "mr2" & positive_coef == 1) %>%
  group_by(vars) %>% add_count(name = "n_positive") %>%
  distinct(policy_1,policy_2,n_positive)
mr2_int_negative <- subset(m5,interactionss == 1 & iden1 == "mr2" & positive_coef == 0) %>%
  group_by(vars) %>% add_count(name = "n_negative") %>%
  distinct(policy_1,policy_2,n_negative)

mr2_int_sign <- full_join(mr2_int_positive,mr2_int_negative, by = c("policy_1","policy_2"), suffix = c("","")) %>%
  mutate(n_negative = ifelse(is.na(n_negative) == T, 0, n_negative)) %>%
  mutate(n_positive = ifelse(is.na(n_positive) == T, 0, n_positive))
mr2_int <- left_join(mr2_int,mr2_int_sign, by = c("policy_1","policy_2"), suffix = c("",""))
mr2_int <- mr2_int %>% mutate(values = ifelse(is.na(n_positive) & is.na(n_negative),"",paste0(n_positive,"/",n_negative)))

mr2_int <- left_join(back,mr2_int, by = c("policy_1","policy_2"), suffix = c("",".y"), all = T) %>%
  mutate(n = ifelse(is.na(n) == T & nas == 1,0,n)) %>%
  mutate(n = ifelse(quadratic == 1 & n == 0,NA,n)) # second condition to make sure estimation code was correct

breaks <- c(na.omit(unique(as.numeric(mr2_int$n))),length(unique(m5$iden2)))

g1 <- ggplot(mr2_int, aes(x = reorder(policy_1,order), y = reorder(policy_2,desc(order_2)))) +
  geom_tile(aes(fill = n)) + 
  geom_text(aes(label = values), color = "black", size = 4) +
  annotate(geom="text", x=19.65, y=4.6, col="black",label="Sign of the\ncoefficient:\nPositive / Negative") + 
  #geom_text(data = . %>% mutate(n_positive = ifelse(is.na(n_positive)==T,as.character(""), as.character(n_positive)),
  #                              n_negative = ifelse(is.na(n_negative)==T,as.character(""), as.character(n_negative))),
  #          aes(label = paste0(n_positive,"/",n_negative)), 
  #          color = "black", size = 4) +
  ylab(label = (expression(paste("External                     ",bold(Policy),"                     Local")))) + 
  xlab(label = (expression(paste("Local                                      ",bold(Policy),"                                      External")))) + 
  scale_y_discrete(labels=c("local_alcohol" = "Alcohol",
                            "local_businesses" = "Businesses",
                            "local_checkpoints" = "Checkpoints",
                            "local_curfew" = "Curfew",
                            "local_events" = "Events",
                            "local_fines" = "Fines",
                            "local_masks" = "Masks",
                            "local_transportation" = "Transportation",
                            "local_publicplaces" = "Public Spaces",
                            "inflow_alcohol" = "Alcohol",
                            "inflow_businesses" = "Businesses",
                            "inflow_checkpoints" = "Checkpoints",
                            "inflow_curfew" = "Curfew",
                            "inflow_events" = "Events",
                            "inflow_fines" = "Fines",
                            "inflow_masks" = "Masks",
                            "inflow_transportation" = "Transportation",
                            "inflow_publicplaces" = "Public Spaces")) + 
  scale_x_discrete(labels=c("local_alcohol" = "Alcohol",
                            "local_businesses" = "Businesses",
                            "local_checkpoints" = "Checkpoints",
                            "local_curfew" = "Curfew",
                            "local_events" = "Events",
                            "local_fines" = "Fines",
                            "local_masks" = "Masks",
                            "local_transportation" = "Transportation",
                            "local_publicplaces" = "Public Spaces",
                            "inflow_alcohol" = "Alcohol",
                            "inflow_businesses" = "Businesses",
                            "inflow_checkpoints" = "Checkpoints",
                            "inflow_curfew" = "Curfew",
                            "inflow_events" = "Events",
                            "inflow_fines" = "Fines",
                            "inflow_masks" = "Masks",
                            "inflow_transportation" = "Transportation",
                            "inflow_publicplaces" = "Public Spaces")) + 
  coord_cartesian(ylim = c(1,18), xlim = c(1,18), clip = "off") + 
  # annotate(geom = "text", x=5, y=-12, label="Local") +
  # annotate(geom = "text", x=15, y=-12, label="Inflow") +
  # annotate(geom = "text", x=-7, y=5, label="Inflow") +
  # annotate(geom = "text", x=-7, y=15, label="Local") +
  geom_vline(xintercept = 9.5, linetype = "solid") + 
  geom_hline(yintercept = 9.5, linetype = "solid") + 
  scale_fill_gradient(low = "white", high = "steelblue", 
                      na.value = "gray80",
                      limits = c(0,length(unique(m5$iden2))),
                      breaks = breaks,
                      name = "Frequency\n") + 
  labs(title = (expression(paste("Mobility measure (",italic("Fraction staying at home"),")")))) + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        plot.title = element_text(hjust = 0.5, size = 18),
        plot.subtitle = element_text(hjust = 0.5),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0), size = 16),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0), size = 16),
        text = element_text(size = 14))


covid_int <- subset(m5,interactionss == 1 & iden1 == "covid_1_pc") %>%
  group_by(vars) %>% add_count(name = "n") %>%
  distinct(policy_1,policy_2,n)

covid_int_positive <- subset(m5,interactionss == 1 & iden1 == "covid_1_pc" & positive_coef == 1) %>%
  group_by(vars) %>% add_count(name = "n_positive") %>%
  distinct(policy_1,policy_2,n_positive)
covid_int_negative <- subset(m5,interactionss == 1 & iden1 == "covid_1_pc" & positive_coef == 0) %>%
  group_by(vars) %>% add_count(name = "n_negative") %>%
  distinct(policy_1,policy_2,n_negative)

covid_int_sign <- full_join(covid_int_positive,covid_int_negative, by = c("policy_1","policy_2"), suffix = c("","")) %>%
  mutate(n_negative = ifelse(is.na(n_negative) == T, 0, n_negative)) %>%
  mutate(n_positive = ifelse(is.na(n_positive) == T, 0, n_positive))
covid_int <- left_join(covid_int,covid_int_sign, by = c("policy_1","policy_2"), suffix = c("",""))
covid_int <- covid_int %>% mutate(values = ifelse(is.na(n_positive) & is.na(n_negative),"",paste0(n_positive,"/",n_negative)))

covid_int <- left_join(back,covid_int, by = c("policy_1","policy_2"), suffix = c("",".y"), all = T) %>%
  mutate(n = ifelse(is.na(n) == T & nas == 1,0,n))

covid_int <- covid_int %>%
  mutate(policy_1_dv = proper(gsub("local_|inflow_","",policy_1)),
         policy_2_dv = proper(gsub("local_|inflow_","",policy_2))) %>%
  mutate(n = ifelse(quadratic == 1 & n == 0,NA,n)) # second condition to make sure estimation code was correct

breaks <- c(na.omit(unique(as.numeric(covid_int$n))), length(unique(m5$iden2)))

g2 <- ggplot(covid_int, aes(x = reorder(policy_1,order), y = reorder(policy_2,desc(order_2)))) +
  geom_tile(aes(fill = n)) + 
  geom_text(aes(label = values), color = "black", size = 4) +
  annotate(geom="text", x=19.65, y=4.6, col="black",label="Sign of the\ncoefficient:\nPositive / Negative") + 
  ylab(label = (expression(paste("External                     ",bold(Policy),"                     Local")))) + 
  xlab(label = (expression(paste("Local                                      ",bold(Policy),"                                      External")))) + 
  scale_y_discrete(labels=c("local_alcohol" = "Alcohol",
                            "local_businesses" = "Businesses",
                            "local_checkpoints" = "Checkpoints",
                            "local_curfew" = "Curfew",
                            "local_events" = "Events",
                            "local_fines" = "Fines",
                            "local_masks" = "Masks",
                            "local_transportation" = "Transportation",
                            "local_publicplaces" = "Public Spaces",
                            "inflow_alcohol" = "Alcohol",
                            "inflow_businesses" = "Businesses",
                            "inflow_checkpoints" = "Checkpoints",
                            "inflow_curfew" = "Curfew",
                            "inflow_events" = "Events",
                            "inflow_fines" = "Fines",
                            "inflow_masks" = "Masks",
                            "inflow_transportation" = "Transportation",
                            "inflow_publicplaces" = "Public Spaces")) + 
  scale_x_discrete(labels=c("local_alcohol" = "Alcohol",
                            "local_businesses" = "Businesses",
                            "local_checkpoints" = "Checkpoints",
                            "local_curfew" = "Curfew",
                            "local_events" = "Events",
                            "local_fines" = "Fines",
                            "local_masks" = "Masks",
                            "local_transportation" = "Transportation",
                            "local_publicplaces" = "Public Spaces",
                            "inflow_alcohol" = "Alcohol",
                            "inflow_businesses" = "Businesses",
                            "inflow_checkpoints" = "Checkpoints",
                            "inflow_curfew" = "Curfew",
                            "inflow_events" = "Events",
                            "inflow_fines" = "Fines",
                            "inflow_masks" = "Masks",
                            "inflow_transportation" = "Transportation",
                            "inflow_publicplaces" = "Public Spaces")) + 
  coord_cartesian(ylim = c(1,18), xlim = c(1,18), clip = "off") + 
  # annotate(geom = "text", x=5, y=-12, label="Local") +
  # annotate(geom = "text", x=15, y=-12, label="Inflow") +
  # annotate(geom = "text", x=-7, y=5, label="Inflow") +
  # annotate(geom = "text", x=-7, y=15, label="Local") +
  geom_vline(xintercept = 9.5, linetype = "solid") + 
  geom_hline(yintercept = 9.5, linetype = "solid") + 
  scale_fill_gradient(low = "white", high = "steelblue", 
                      limits = c(0,length(unique(m5$iden2))), 
                      na.value = "gray80",
                      breaks = breaks,
                      name = "Frequency\n") + 
  labs(title = "New COVID cases per 100,000 inhabitants") + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        plot.title = element_text(hjust = 0.5, size = 18),
        plot.subtitle = element_text(hjust = 0.5),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0), size = 16),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0), size = 16),
        text = element_text(size = 14))

plot_grid(g1, g2, labels = "AUTO", label_size = 30, label_colour = "navy", ncol = 1, nrow = 2)
ggsave("double_heatmap_ss_noquadratic_signs_vertical.png", height = 18, width = 14)

plot_grid(g1, g2, labels = "AUTO", label_size = 30, label_colour = "navy", ncol = 2, nrow = 1)
ggsave("double_heatmap_ss_noquadratic_signs_horizontal.png", height = 14, width = 24)
}