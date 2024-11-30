rm(list = ls())

library(lubridate)
library(scales)

data_population<-read.csv(file ="~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Population/population_date.csv") %>%
  filter(is.na(date) == F & date != "")

data_population$date <- lubridate::dmy(as.character(data_population$date))

data_population <- data_population %>%
  filter(date <= as.Date("2020-06-08")) # end plote on June 8th, 2020

ggplot(data_population, aes(x="", y = "")) +
  theme_bw() + theme(legend.position="bottom") + labs(x="Date (2020)",y="Population") + 
  scale_y_continuous(breaks = c(seq(0,126000000, by = 25000000)), labels = scales::comma) + 
  scale_x_date(date_breaks = "1 week", date_minor_breaks = "1 month",labels = date_format("%m/%d")) + 
  geom_vline(xintercept = as.numeric(as.Date("2020-02-27")), linetype="dashed", color = "red", size=0.5) + 
  geom_point(data_population, mapping=aes(x = date, y = populationschool, color = "black"),  
             size = 1, fill = "black") +
  geom_point(data_population, mapping=aes(x = date, y = populationalcohol, color = "red"),  
             size = 1, fill = "red") +
  geom_point(data_population, mapping=aes(x = date, y = populationfines, color = "blue"),  
             size = 1, fill = "blue") +
  geom_point(data_population, mapping=aes(x = date, y = populationcurfew, color = "green4"),  
             size = 1, fill = "green4") +
  geom_point(data_population, mapping=aes(x = date, y = populationbusinesses, color = "gold"),  
             size = 1, fill = "gold") +
  geom_point(data_population, mapping=aes(x = date, y = populationpublicplaces, color = "brown"),  
             size = 1, fill = "brown") +
  geom_point(data_population, mapping=aes(x = date, y = populationcheckpoints, color = "orange"),  
             size = 1, fill = "orange") +
  geom_point(data_population, mapping=aes(x = date, y = populationevents, color = "gray"),  
             size = 1, fill = "gray") +
  geom_point(data_population, mapping=aes(x = date, y = populationmasks, color = "violet"),  
             size = 1, fill = "violet") +  
  geom_point(data_population, mapping=aes(x = date, y = populationmobility, color = "lightblue"),  
             size = 1, fill = "lightblue") +  
  scale_color_manual(
      name = "Social distancing restrictions",
      values = c("black", "red", "blue", "green4","gold","brown","orange","gray","violet","lightblue"),
      labels = c("Schools", "Fines", "Public places", "Businesses\n(non-essential)", "Events","Curfew","Transportation","Checkpoints","Alcohol sales","Masks"))

ggsave("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Population/population_date.png",width = 9, height = 4.79)



ggplot(data_population, aes(x="", y = "")) +
  theme_bw() + theme(legend.position="bottom") + labs(x="Date (2020)",y="Population") + 
  scale_y_continuous(breaks = c(seq(0,126000000, by = 25000000)), labels = scales::comma,
                     sec.axis = sec_axis( trans=~.*(1/126000000)*100,name="Percentage of total population")) + 
  scale_x_date(date_breaks = "1 week", date_minor_breaks = "1 month",labels = date_format("%m/%d")) + 
  geom_vline(aes(xintercept = as.numeric(as.Date("2020-02-27")), linetype="First COVID-19 case reported"), color = "red", size=0.5) + 
  #geom_point(data_population, mapping=aes(x = date, y = populationschool, color = "black"),  
  #           size = 1, fill = "black") +
  geom_point(data_population, mapping=aes(x = date, y = populationalcohol, color = "red"),  
             size = 1, fill = "red") +
  geom_point(data_population, mapping=aes(x = date, y = populationfines, color = "blue"),  
             size = 1, fill = "blue") +
  geom_point(data_population, mapping=aes(x = date, y = populationcurfew, color = "green4"),  
             size = 1, fill = "green4") +
  geom_point(data_population, mapping=aes(x = date, y = populationbusinesses, color = "gold"),  
             size = 1, fill = "gold") +
  geom_point(data_population, mapping=aes(x = date, y = populationpublicplaces, color = "brown"),  
             size = 1, fill = "brown") +
  geom_point(data_population, mapping=aes(x = date, y = populationcheckpoints, color = "orange"),  
             size = 1, fill = "orange") +
  geom_point(data_population, mapping=aes(x = date, y = populationevents, color = "gray"),  
             size = 1, fill = "gray") +
  geom_point(data_population, mapping=aes(x = date, y = populationmasks, color = "violet"),  
             size = 1, fill = "violet") +  
  geom_point(data_population, mapping=aes(x = date, y = populationmobility, color = "lightblue"),  
             size = 1, fill = "lightblue") +  
  scale_linetype_manual(name = "", values=c("dashed")) +
  scale_color_manual(
    name = "Social\ndistancing\nrestrictions",
    #values = c("black", "red", "blue", "green4","gold","brown","orange","gray","violet","lightblue"),
    values = c("red", "blue", "green4","gold","brown","orange","gray","violet","lightblue"),
    #labels = c("Schools\n(state-level)", "Fines", "Public places", "Businesses\n(non-essential)", "Events","Curfew","Mobility","Checkpoints","Alcohol sales","Masks"))
    labels = c("Fines", "Public spaces", "Businesses\n(non-essential)", "Events","Curfew","Transportation","Checkpoints","Alcohol sales","Masks"))

ggsave("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Population/population_date_note.png",width = 9, height = 4.79)

