rm(list = ls())

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


proper=function(x) paste0(toupper(substr(x, 1, 1)), tolower(substring(x, 2)))


setwd("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Main/")

fe = c("FE_municipiodate")
folder = c("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Main/")

depvar = c("mr2","mr1","covid_1_pc")
restrictions = c("alcohol","fines","curfew","businesses","publicplaces","checkpoints","events","masks","mobility")
type = c("local", "inflow")

  #########################################################################################################
  ########################                  Municipality FE + Date FE              ########################
  #########################################################################################################
  
# Restricted: Only (Single), No Spillovers (Local), Spillovers, Spillovers Lasso (Lasso), Spillovers Lasso ## (Lasso interaction)

  
## prep data
  
  {
  m1 <- read.csv(paste0(folder[[1]],"m1",".csv")) %>%
    dplyr::rename(dv = iden1, model = iden3, policy = iden2) %>%
    mutate(graph = "Only", policy = proper(policy)) %>%
    arrange(model,dv,order)
  
  m2 <- read.csv(paste0(folder[[1]],"m2",".csv")) %>%
    dplyr::rename(dv = iden1, model = iden3, policy = iden2) %>%
    mutate(graph = "No Spillovers", policy = proper(policy)) %>%
    arrange(model,dv,order)
  
  m3 <- read.csv(paste0(folder[[1]],"m3",".csv")) %>%
    dplyr::rename(dv = iden1, model = iden3, policy = iden2) %>%
    mutate(graph = ifelse(str_detect(graph,"local") == T, "Spillovers", "Spillovers Controls"), 
           policy = proper(policy)) %>%
    arrange(model,dv,order)
  
  m4 <- read.csv(paste0(folder[[1]],"m4",".csv")) %>%
    dplyr::rename(dv = iden1, model = iden3, policy = iden2) %>%
    mutate(graph = ifelse(str_detect(graph,"local") == T, "LASSO Spillovers", "LASSO Spillovers Controls"),
           policy = proper(policy), lags = gsub("M4","",proper(gsub("_"," ",model)))) %>%
    mutate(graph = paste0(graph,",",lags," days")) %>%
    mutate(graph = gsub("lags days","lags 7 days",graph)) %>%
    mutate(graph = gsub(", days","",graph)) %>%
    arrange(model,dv,order)
  
  m5 <- read.csv(paste0(folder[[1]],"m5",".csv")) %>%
    dplyr::rename(dv = iden1, model = iden3, policy = iden2) %>% 
    mutate(model = ifelse(model == "m5" & grepl("mr",dv) == F,"m5_07",model)) %>%
    mutate(graph = ifelse(str_detect(graph,"local") == T, "LASSO Spillovers interactions", "LASSO Spillovers Controls interactions"),
           policy = proper(policy), lags = gsub("M5","",proper(gsub("_"," ",model)))) %>%
    mutate(graph = paste0(graph,",",lags," days")) %>%
    mutate(graph = gsub("lags days","lags 7 days",graph)) %>%
    mutate(graph = gsub(", days","",graph)) %>%
    arrange(model,dv,order)
  
  allmodels <- bind_rows(m1, m2, m3, m4, m5) %>% 
    mutate(policy = proper(gsub("Inflow ","",policy))) %>%
    mutate(policy = gsub("Public places","Public Spaces",policy)) %>%
    mutate(policy = gsub("Publicplaces","Public Spaces",policy)) %>%
    mutate(policy = gsub("Mobility","Transportation",policy)) %>%
    #mutate(policy = gsub("School","Schools",policy)) %>%
    mutate(graph = gsub("lags 7 days","7-days lags",graph)) %>%
    mutate(graph = gsub("lags 14 days","14-days lags",graph)) %>%
    mutate(graph = gsub("lags 21 days","21-days lags",graph)) %>%
    mutate(graph = ifelse(model == "m5_07" & grepl("mr",dv) == F,paste0(graph," (t-7)"),graph)) %>%
    mutate(graph = ifelse(model == "m5_14" & grepl("mr",dv) == F,paste0(graph," (t-14)"),graph)) %>%
    mutate(graph = ifelse(model == "m5_21" & grepl("mr",dv) == F,paste0(graph," (t-21)"),graph))
  
  # add labels
  allmodels <- allmodels %>% 
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^Only$","Local policy at t-7",graph),gsub("^Only$","M1: Local policy at t",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^No Spillovers$","Local policies at t-7",graph),gsub("^No Spillovers$","M2: Local policies at t",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^Spillovers$","All policies at t-7",graph),gsub("^Spillovers$","M3: All policies at t",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^Spillovers Controls$","Spillovers: All policies at t-7",graph),gsub("^Spillovers Controls$","M3: Spillovers: All policies at t",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers$","All policies at t-7 (LASSO)",graph),gsub("^LASSO Spillovers$","M4: All policies at t (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers Controls$","Spillovers: All policies at t-7 (LASSO)",graph),gsub("^LASSO Spillovers Controls$","M4: Spillovers: All policies at t (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers interactions$","All policies at t-X interacted (LASSO)",graph),gsub("^LASSO Spillovers interactions$","M5: All policies at t interacted (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers Controls interactions$","Spillovers: All policies at t-X interacted (LASSO)",graph),gsub("^LASSO Spillovers Controls interactions$","M5: Spillovers: All policies at t interacted (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers, 7-days lags","M4 lags: All policies from t-1 to t-7 (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers, 14-days lags","M4 lags: All policies from t-1 to t-14 (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers, 21-days lags","M4 lags: All policies from t-1 to t-21 (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers Controls, 7-days lags","M4 lags: Spillovers: All policies from t-1 to t-7 (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers Controls, 14-days lags","M4 lags: Spillovers: All policies from t-1 to t-14 (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers Controls, 21-days lags","M4 lags: Spillovers: All policies from t-1 to t-21 (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers interactions, 07 days \\(t-7\\)$","M5: All policies at t-7 interacted (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers interactions, 14 days \\(t-14\\)$","M5: All policies at t-14 interacted (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers interactions, 21 days \\(t-21\\)$","M5: All policies at t-21 interacted (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers Controls interactions, 07 days \\(t-7\\)$","M5: Spillovers: All policies at t-7 interacted (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers Controls interactions, 14 days \\(t-14\\)$","M5: Spillovers: All policies at t-14 interacted (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers Controls interactions, 21 days \\(t-21\\)$","M5: Spillovers: All policies at t-21 interacted (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers interactions, 7-days lags","M5 lags: All policies from t-1 to t-7 interacted (LASSO)",graph),graph)) %>%
    mutate(graph = ifelse(str_detect(dv,"mr") == F,gsub("^LASSO Spillovers Controls interactions, 7-days lags","M5 lags: Spillovers: All policies from t-1 to t-7 interacted (LASSO)",graph),graph))
  
  allmodels <- allmodels %>% 
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F,graph,gsub("^Local policy at t-7","M1: Local policy at t-7",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F,graph,gsub("^Local policies at t-7","M2: Local policies at t-7",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M3:") == F,graph,gsub("^Spillovers: All policies at t-7$","M3: Spillovers: All policies at t-7",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M3:") == F,graph,gsub("^All policies at t-7$","M3: All policies at t-7",graph))) %>%  
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M4:") == F,graph,gsub("^Spillovers: All policies at t-7 \\(LASSO\\)$","M4: Spillovers: All policies at t-7 (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M4:") == F,graph,gsub("^All policies at t-7 \\(LASSO\\)$","M4: All policies at t-7 (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M4:") == F,graph,gsub("^Spillovers: All policies at t-7 \\(LASSO\\)$","M4: Spillovers: All policies at t-7 (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M4:") == F,graph,gsub("^All policies at t-7 \\(LASSO\\)$","M4: All policies at t-7 (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M4:") == F,graph,gsub("^Spillovers: All policies from t-1 to t-7 \\(LASSO\\)$","M4 lags: Spillovers: All policies from t-1 to t-7 (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M4:") == F,graph,gsub("^All policies from t-1 to t-7 \\(LASSO\\)$","M4 lags: All policies from t-1 to t-7 (LASSO)",graph))) %>%  
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M4:") == F,graph,gsub("^Spillovers: All policies from t-1 to t-14 \\(LASSO\\)$","M4 lags: Spillovers: All policies from t-1 to t-14 (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M4:") == F,graph,gsub("^All policies from t-1 to t-14 \\(LASSO\\)$","M4 lags: All policies from t-1 to t-14 (LASSO)",graph))) %>%  
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M4:") == F,graph,gsub("^Spillovers: All policies from t-1 to t-21 \\(LASSO\\)$","M4 lags: Spillovers: All policies from t-1 to t-21 (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M4:") == F,graph,gsub("^All policies from t-1 to t-21 \\(LASSO\\)$","M4 lags: All policies from t-1 to t-21 (LASSO)",graph))) %>%  
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M5:") == F,graph,gsub("^Spillovers: All policies at t-7 interacted \\(LASSO\\)","M5: Spillovers: All policies at t-7 interacted (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M5:") == F,graph,gsub("^All policies at t-7 interacted \\(LASSO\\)","M5: All policies at t-7 interacted (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M5:") == F,graph,gsub("^Spillovers: All policies from t-1 to t-7 interacted \\(LASSO\\)","M5 lags: Spillovers: All policies from t-1 to t-7 interacted (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M5:") == F,graph,gsub("^All policies from t-1 to t-7 interacted \\(LASSO\\)","M5 lags: All policies from t-1 to t-7 interacted (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M5:") == F,graph,gsub("^Spillovers: All policies from t-1 to t-14 interacted \\(LASSO\\)","M5 lags: Spillovers: All policies from t-1 to t-14 interacted (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M5:") == F,graph,gsub("^All policies from t-1 to t-14 interacted \\(LASSO\\)","M5 lags: All policies from t-1 to t-14 interacted (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M5:") == F,graph,gsub("^Spillovers: All policies from t-1 to t-21 interacted \\(LASSO\\)","M5 lags: Spillovers: All policies from t-1 to t-21 interacted (LASSO)",graph))) %>%
    mutate(graph = ifelse(str_detect(dv,"covid_1_pc|deaths_pc") == F & str_detect(dv,"^M5:") == F,graph,gsub("^All policies from t-1 to t-21 interacted \\(LASSO\\)","M5 lags: All policies from t-1 to t-21 interacted (LASSO)",graph)))
  
  # Main effects:
  allmodels_main <- allmodels %>%
    subset(!grepl("Spillovers\\:", allmodels$graph)) 
  
  # Controls:
  allmodels_controls <- allmodels %>%
    subset(grepl("Spillovers\\:", allmodels$graph)) 
  
}

  
  # MR2 (stay-at-home)
  
  {
  mod = "mr2"
    
  # Keep if depvar == `d` (loop)
  allmodels_main_graph <- allmodels_main %>%
    subset(dv == mod) %>%
    subset(grepl("m5",model)==F)
  
  allmodels_controls_graph <- allmodels_controls %>%
    subset(dv == mod)  %>%
    subset(grepl("m5",model)==F)
  
  # define xlim
  allmodels_main_graph$xlimd <- allmodels_main_graph$lb95*1.1
  allmodels_main_graph$xlimu <- allmodels_main_graph$ub95*1.1
  
  allmodels_controls_graph$xlimd <- allmodels_controls_graph$lb95*1.1
  allmodels_controls_graph$xlimu <- allmodels_controls_graph$ub95*1.1  

  # fixed scales
  ggplot(allmodels_main_graph, aes(coef, reorder(graph, order))) +
    coord_cartesian(ylim=c(0.5,4.5)) +
    geom_point(aes(colour = factor(policy))) + 
    facet_wrap(~policy, nrow = 3, scales = "free_x") +
    geom_vline(xintercept=0,  color='red') + 
    geom_errorbarh(aes(xmin=lb95, xmax=ub95), colour="gray33") +
    scale_x_continuous(breaks = scales::pretty_breaks(5),limits = function(x){c(min(x,-0.025), max(0.025, x))}) +
    scale_y_discrete(limits = unique(rev(allmodels_main_graph$graph)),
                     expand = expansion(mult = c(0.02, 0.02))) + 
    #labs(y="",x=paste0("Estimate\n","municipio FE + date FE"), 
    #     subtitle="Each point estimate is generated from an independent regression. Marginal effect of policy i at time t.",
      labs(y = "", x = "", colour = "Social distancing restrictions") + 
    theme_bw() +
    scale_color_manual(
      name = "Social distancing restrictions",
      breaks = c("Alcohol",
                 "Businesses",
                 "Checkpoints",
                 "Curfew",
                 "Events",
                 "Fines",
                 "Masks",
                 "Transportation",
                 "Public Spaces"),
                 #"Schools"),
      values = c("violet",
                 "green4",
                 "gray",
                 "brown",
                 "gold",
                 "red",
                 "lightblue",
                 "orange",
                 "blue")) +
                 #"black")) +
    #ggtitle(expression(paste("Perc. of users present in only one tile (0.6 km by 0.6km sq) in at least 3 hours of the day (", italic("stay-at-home outcome"),")"))) + 
    theme(plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5),
          legend.position = "none",
          strip.background =element_rect(fill="steelblue3"),
          strip.text = element_text(colour = 'white', size = 16),
          text = element_text(size = 14))
  
  ggsave(paste0(folder[[1]],"/",mod,".png"), height = 7 , width = 7 * 2.5)
  
  # spillovers
  ggplot(allmodels_controls_graph, aes(coef, reorder(graph, order))) +
    coord_cartesian(ylim=c(0.5,2.5)) +
    geom_point(aes(colour = factor(policy))) + 
    facet_wrap(~policy, nrow = 3, scales = "free_x") +
    geom_vline(xintercept=0,  color='red') + 
    geom_errorbarh(aes(xmin=lb95, xmax=ub95), colour="gray33") +
    scale_x_continuous(breaks = scales::pretty_breaks(4),limits = function(x){c(min(x,-0.025), max(0.025, x))}) +
    scale_y_discrete(limits = unique(rev(allmodels_controls_graph$graph)),
                     expand = expansion(mult = c(0.02, 0.02))) + 
    #labs(y="",x=paste0("Estimate\n","municipio FE + date FE"), 
    #     subtitle="Each point estimate is generated from an independent regression. Spillovers of policy i at time t.",
     labs(y = "", x = "", colour = "Social distancing restrictions") + 
    theme_bw() +
    scale_color_manual(
      name = "Social distancing restrictions",
      breaks = c("Alcohol",
                 "Businesses",
                 "Checkpoints",
                 "Curfew",
                 "Events",
                 "Fines",
                 "Masks",
                 "Transportation",
                 "Public Spaces"),
                 #"Schools"),
      values = c("violet",
                 "green4",
                 "gray",
                 "brown",
                 "gold",
                 "red",
                 "lightblue",
                 "orange",
                 "blue")) +
                 #"black")) +
    #ggtitle(expression(paste("Perc. of users present in only one tile (0.6 km by 0.6km sq) in at least 3 hours of the day (", italic("stay-at-home outcome"),")"))) + 
    theme(plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5),
          legend.position = "none",
          strip.background =element_rect(fill="steelblue3"),
          strip.text = element_text(colour = 'white', size = 16),
          text = element_text(size = 14))
  
  ggsave(paste0(folder[[1]],"/",mod,"_spillovers",".png"), height = 7 , width = 7 * 2.5)
  
  
  }
 
  # MR1 (mobility)
  
  {
    mod = "mr1"
    
    # Keep if depvar == `d` (loop)
    allmodels_main_graph <- allmodels_main %>%
      subset(dv == mod) %>%
      subset(grepl("m5",model)==F)
    
    allmodels_controls_graph <- allmodels_controls %>%
      subset(dv == mod)  %>%
      subset(grepl("m5",model)==F)
    
    # define xlim
    allmodels_main_graph$xlimd <- allmodels_main_graph$lb95*1.1
    allmodels_main_graph$xlimu <- allmodels_main_graph$ub95*1.1
    
    allmodels_controls_graph$xlimd <- allmodels_controls_graph$lb95*1.1
    allmodels_controls_graph$xlimu <- allmodels_controls_graph$ub95*1.1  
    
    # fixed scales
    ggplot(allmodels_main_graph, aes(coef, reorder(graph, order))) +
      coord_cartesian(ylim=c(0.5,4.5)) +
      geom_point(aes(colour = factor(policy))) + 
      facet_wrap(~policy, nrow = 3, scales = "free_x") +
      geom_vline(xintercept=0,  color='red') + 
      geom_errorbarh(aes(xmin=lb95, xmax=ub95), colour="gray33") +
      scale_x_continuous(breaks = scales::pretty_breaks(5),limits = function(x){c(min(x,-0.025), max(0.025, x))}) +
      scale_y_discrete(limits = unique(rev(allmodels_main_graph$graph)),
                       expand = expansion(mult = c(0.02, 0.02))) + 
      #labs(y="",x=paste0("Estimate\n","municipio FE + date FE"), 
      #     subtitle="Each point estimate is generated from an independent regression. Marginal effect of policy i at time t.",
       labs(y = "", x = "", colour = "Social distancing restrictions") + 
      theme_bw() +
      scale_color_manual(
        name = "Social distancing restrictions",
        breaks = c("Alcohol",
                   "Businesses",
                   "Checkpoints",
                   "Curfew",
                   "Events",
                   "Fines",
                   "Masks",
                   "Transportation",
                   "Public Spaces"),
                   #"Schools"),
        values = c("violet",
                   "green4",
                   "gray",
                   "brown",
                   "gold",
                   "red",
                   "lightblue",
                   "orange",
                   "blue")) + 
                   #"black")) +
      #ggtitle(expression(paste("Avg. number of level-16 Bing tiles (0.6km by 0.6km sq) traveled in a 24-hour period (", italic("mobility outcome"),")"))) + 
      theme(plot.title = element_text(hjust = 0.5),
            plot.subtitle = element_text(hjust = 0.5),
            legend.position = "none",
            strip.background =element_rect(fill="steelblue3"),
            strip.text = element_text(colour = 'white', size = 16),
            text = element_text(size = 14))
    
    ggsave(paste0(folder[[1]],"/",mod,".png"), height = 7 , width = 7 * 2.5)
    
    
    # spillovers
    ggplot(allmodels_controls_graph, aes(coef, reorder(graph, order))) +
      coord_cartesian(ylim=c(0.5,2.5)) +
      geom_point(aes(colour = factor(policy))) + 
      facet_wrap(~policy, nrow = 3, scales = "free_x") +
      geom_vline(xintercept=0,  color='red') + 
      geom_errorbarh(aes(xmin=lb95, xmax=ub95), colour="gray33") +
      scale_x_continuous(breaks = scales::pretty_breaks(4),limits = function(x){c(min(x,-0.025), max(0.025, x))}) +
      scale_y_discrete(limits = unique(rev(allmodels_controls_graph$graph)),
                       expand = expansion(mult = c(0.02, 0.02))) + 
      #labs(y="",x=paste0("Estimate\n","municipio FE + date FE"), 
      #     subtitle="Each point estimate is generated from an independent regression. Spillovers of policy i at time t.",
       labs(y = "", x ="", colour = "Social distancing restrictions") + 
      theme_bw() +
      scale_color_manual(
        name = "Social distancing restrictions",
        breaks = c("Alcohol",
                   "Businesses",
                   "Checkpoints",
                   "Curfew",
                   "Events",
                   "Fines",
                   "Masks",
                   "Transportation",
                   "Public Spaces"),
                   #"Schools"),
        values = c("violet",
                   "green4",
                   "gray",
                   "brown",
                   "gold",
                   "red",
                   "lightblue",
                   "orange",
                   "blue")) + 
                   #"black")) +
      #ggtitle(expression(paste("Avg. number of level-16 Bing tiles (0.6km by 0.6km sq) traveled in a 24-hour period (", italic("mobility outcome"),")"))) + 
      theme(plot.title = element_text(hjust = 0.5),
            plot.subtitle = element_text(hjust = 0.5),
            legend.position = "none",
            strip.background =element_rect(fill="steelblue3"),
            strip.text = element_text(colour = 'white', size = 16),
            text = element_text(size = 14))
    
    ggsave(paste0(folder[[1]],"/",mod,"_spillovers",".png"), height = 7 , width = 7 * 2.5)
  }
 
  # COVID_1_pc (new cases per 100,000)
  
  {
    mod = "covid_1_pc"
    
    # Keep if depvar == `d` (loop)
    allmodels_main_graph <- allmodels_main %>%
      subset(dv == mod)
    
    allmodels_controls_graph <- allmodels_controls %>%
      subset(dv == mod)
    
    # define xlim
    allmodels_main_graph$xlimd <- allmodels_main_graph$lb95*1.1
    allmodels_main_graph$xlimu <- allmodels_main_graph$ub95*1.1
    
    allmodels_controls_graph$xlimd <- allmodels_controls_graph$lb95*1.1
    allmodels_controls_graph$xlimu <- allmodels_controls_graph$ub95*1.1  
    
    # Figure 2: only, no spillovers, spillovers, Lasso spillovers, Lasso spillovers interactions, 7 days
    # original
    fig2_main <- subset(allmodels_main_graph, str_detect(graph,"^M1: Local policy at t-7|^M2: Local policies at t-7|^M3: All policies at t-7|^M4: All policies at t-7 \\(LASSO\\)") == T)
    fig2_controls <- subset(allmodels_controls_graph, str_detect(graph,"^M3: Spillovers\\: All policies at t-7|^M4: Spillovers\\: All policies at t-7 \\(LASSO\\)") == T)
    
    # Figure 3: Lasso spillovers, Lasso spillovers 7-days lags, Lasso spillovers interacted, Lasso spillovers 7-days lags interacted
    # at t-7, from t-1 to t-7, at t-7 interacted, from t-1 to t-7 interacted 
    fig3_main <- subset(allmodels_main_graph, str_detect(graph,"^M4: All policies at t-7 \\(LASSO\\)|^M4 lags: All policies from t-1 to t-7 \\(LASSO\\)|^M5: All policies at t-7 interacted \\(LASSO\\)|^M5 lags: All policies from t-1 to t-7 interacted \\(LASSO\\)") == T)
    fig3_controls <- subset(allmodels_controls_graph, str_detect(graph,"^M4: Spillovers: All policies at t-7 \\(LASSO\\)|^M4 lags: Spillovers: All policies from t-1 to t-7 \\(LASSO\\)|^M5: Spillovers: All policies at t-7 interacted \\(LASSO\\)|^M5 lags: Spillovers: All policies from t-1 to t-7 interacted \\(LASSO\\)") == T)
    
    model = c("","_original","_lags")
    
    for (i in 2:3) { # no _lags model
    
    yl <- length(unique(eval(parse(text = paste0("fig",i,"_main$graph"))))) + 0.5
    ylc <- length(unique(eval(parse(text = paste0("fig",i,"_controls$graph"))))) + 0.5
    
    # fixed scales
    g <- ggplot(eval(parse(text = paste0("fig",i,"_main"))), aes(coef, reorder(graph, order))) +
      coord_cartesian(ylim=c(0.5,yl)) +
      geom_point(aes(colour = factor(policy))) + 
      facet_wrap(~policy, nrow = 3, scales = "free_x") +
      geom_vline(xintercept=0,  color='red') + 
      geom_errorbarh(aes(xmin=lb95, xmax=ub95), colour="gray33") +
      scale_x_continuous(breaks = scales::pretty_breaks(5),limits = function(x){c(min(x,-1), max(1, x))}) +
      scale_y_discrete(limits = unique(rev(eval(parse(text = paste0("fig",i,"_main$graph"))))),
                       expand = expansion(mult = c(0.02, 0.02))) + 
      theme_bw() +
      scale_color_manual(
        name = "Social distancing restrictions",
        breaks = c("Alcohol",
                   "Businesses",
                   "Checkpoints",
                   "Curfew",
                   "Events",
                   "Fines",
                   "Masks",
                   "Transportation",
                   "Public Spaces"),
                   #"Schools"),
        values = c("violet",
                   "green4",
                   "gray",
                   "brown",
                   "gold",
                   "red",
                   "lightblue",
                   "orange",
                   "blue")) +
                   #"black")) +
      #ggtitle("New COVID-19 cases") + 
      theme(plot.title = element_text(hjust = 0.5),
            plot.subtitle = element_text(hjust = 0.5),
            legend.position = "none",
            strip.background =element_rect(fill="steelblue3"),
            strip.text = element_text(colour = 'white', size = 16),
            text = element_text(size = 14))
    
    if (i == 2) {
        g + #labs(y="",x=paste0("Estimate\n","municipio FE + date FE"), 
            #subtitle = (expression(paste("Each point estimate is generated from an independent regression. Marginal effect at time t of policy i at time ", italic("t - 7"),"."))), 
            labs(y = "", x = "", colour = "Social distancing restrictions")
    } 
    if (i == 3) {
        g + #labs(y="",x=paste0("Estimate\n","municipio FE + date FE"), 
            #subtitle = (expression(paste("Each point estimate is generated from an independent regression. Marginal effect at time t of policy i at time ", italic("t - 7, t - 14, or t - 21"),". Lags: controls for policy j at ",italic("t - 21(14/7), ... , t.")))), 
            labs(y = "", x = "", colour = "Social distancing restrictions")
      }
    
    ggsave(paste0(folder[[1]],"/",mod,model[[i]],".png"), height = 7 , width = 7 * 2.5)
    
  # spillovers
    
    g <- ggplot(eval(parse(text = paste0("fig",i,"_controls"))), aes(coef, reorder(graph, order))) +
      coord_cartesian(ylim=c(0.5,ylc)) +
      geom_point(aes(colour = factor(policy))) + 
      facet_wrap(~policy, nrow = 3, scales = "free_x") +
      geom_vline(xintercept=0,  color='red') + 
      geom_errorbarh(aes(xmin=lb95, xmax=ub95), colour="gray33") +
      scale_x_continuous(breaks = scales::pretty_breaks(4),limits = function(x){c(min(x,-1), max(1, x))}) +
      scale_y_discrete(limits = unique(rev(eval(parse(text = paste0("fig",i,"_controls$graph"))))),
                       expand = expansion(mult = c(0.02, 0.02))) + 
      theme_bw() +
      scale_color_manual(
        name = "Social distancing restrictions",
        breaks = c("Alcohol",
                   "Businesses",
                   "Checkpoints",
                   "Curfew",
                   "Events",
                   "Fines",
                   "Masks",
                   "Transportation",
                   "Public Spaces"),
                   #"Schools"),
        values = c("violet",
                   "green4",
                   "gray",
                   "brown",
                   "gold",
                   "red",
                   "lightblue",
                   "orange",
                   "blue")) + 
                   #"black")) +
      #ggtitle("New COVID-19 cases") + 
      theme(plot.title = element_text(hjust = 0.5),
            plot.subtitle = element_text(hjust = 0.5),
            legend.position = "none",
            strip.background =element_rect(fill="steelblue3"),
            strip.text = element_text(colour = 'white', size = 16),
            text = element_text(size = 14))
    
    if (i == 2) {
      g + #labs(y="",x=paste0("Estimate\n","municipio FE + date FE"), 
          #subtitle = (expression(paste("Each point estimate is generated from an independent regression. Spillovers at time t of policy i at time ", italic("t - 7"),"."))), 
          labs(y = "", x = "",colour = "Social distancing restrictions")
    }
    if (i == 3) {
      g + #labs(y="",x=paste0("Estimate\n","municipio FE + date FE"), 
          #subtitle = (expression(paste("Each point estimate is generated from an independent regression. Spillovers at time t of policy i at time ", italic("t - 7, t - 14, or t - 21"),". Lags: controls for policy j at ",italic("t - 21(14/7), ... , t.")))), 
          labs(y = "", x = "",colour = "Social distancing restrictions")
    }
    
    ggsave(paste0(folder[[1]],"/",mod,model[[i]],"_spillovers",".png"), height = 7 , width = 7 * 2.5)
    }
  }
  
  
 