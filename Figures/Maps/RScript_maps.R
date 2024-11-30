
## Sample and Mobility data

rm(list = ls())

# packages

if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
if(!require(lattice)) install.packages("lattice"); library(lattice)
if(!require(plyr)) install.packages("plyr"); library(plyr)
if(!require(Rmisc)) install.packages("Rmisc"); library(Rmisc)
if(!require(estimatr)) install.packages("estimatr"); library(estimatr)
if(!require(tidyverse)) install.packages("tidyverse"); library(tidyverse)
if(!require(sf)) install.packages("sf"); library(sf)
if(!require(sp)) install.packages("sp"); library(sp)
if(!require(spdep)) install.packages("spdep"); library(spdep)
if(!require(tmap)) install.packages("tmap"); library(tmap)
if(!require(tmaptools)) install.packages("tmaptools"); library(tmaptools)
if(!require(maptools)) install.packages("maptools"); library(maptools)
if(!require(rgeos)) install.packages("rgeos"); library(rgeos)
if(!require(rgdal)) install.packages("rgdal"); library(rgdal)
if(!require(dplyr)) install.packages("dplyr"); library(dplyr)
if(!require(readxl)) install.packages("readxl"); library(readxl)
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
if(!require(expss)) install.packages("expss"); library(expss)
if(!require(haven)) install.packages("haven"); library(haven)
if(!require(scales)) install.packages("scales"); library(scales)
if(!require(foreign)) install.packages("foreign"); library(foreign)
if(!require(devtools)) install.packages("devtools"); library(devtools)
if(!require(ggpubr)) install.packages("ggpubr"); library(ggpubr)


mexico <-st_read("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Maps/muni_2018gw/muni_2018gw.shp", stringsAsFactors = FALSE) %>%
  mutate(CVEGEO = as.numeric(CVEGEO))
row.names(mexico) <- as.character(mexico$CVEGEO)


# Mobility data (as outcome) 1,075 
mobility_data <- read.csv("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Maps/maps_sample.csv") %>%
  select(code_INEGI,sample_mobility) %>%
  filter(is.na(sample_mobility) == FALSE)
map <- left_join(mexico,mobility_data, by = c("CVEGEO" = "code_INEGI"))

ggplot(map, aes(fill = as.factor(sample_mobility))) + 
  geom_sf(size = 0.1, ) + 
  scale_color_manual(guide = FALSE) + 
  scale_fill_manual(name = "Mobility\n(outcome variable)",
                    values = c("0" = "white","1" = "navy"), 
                    labels = c("0" = "No Data","1" = "Data")) +
  coord_sf(xlim = c(-116,-86), ylim = c(15,32)) + 
  theme_void()

ggsave("~/Dropbox/COVID-19 Mexico/Analysis/First stage/Graphs/Maps/mobility_data_1075.png", dpi=600, width = 7, height = 4)

# Weighted policies data: 1,392 
mobility_data <- read.csv("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Maps/maps_sample.csv") %>%
  select(code_INEGI,sample_cases_2) %>%
  filter(is.na(sample_cases_2) == FALSE)
map2 <- left_join(mexico,mobility_data, by = c("CVEGEO" = "code_INEGI"))

ggplot(map2, aes(fill = as.factor(sample_cases_2))) + 
  geom_sf(size = 0.1, ) + 
  scale_color_manual(guide = FALSE) + 
  scale_fill_manual(name = "Weighted policies",
                    values = c("0" = "white","1" = "aquamarine3"), 
                    labels = c("0" = "No Data","1" = "Data")) +
  coord_sf(xlim = c(-116,-86), ylim = c(15,32)) + 
  theme_void()

ggsave("~/Dropbox/COVID-19 Mexico/Analysis/First stage/Graphs/Maps/cases_data_1392.png", dpi=600, width = 7, height = 4)
