#                           NATIONAL LEVEL

{
data_population<-read.csv(file = "~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Coronanet/national_policies.csv")

data_population$cum_checkpoints = 0

ggplot(data_population, aes(x="", y = "")) +
  theme_bw() + theme(legend.position="bottom", 
                     plot.title = element_text(hjust = 0.5),
                     plot.subtitle = element_text(hjust = 0.5)) + 
  labs(x="Days with respect to the first Covid-19 case reported in the country",y="Number of Countries",
       subtitle = "Source: Coronanet Project (Nature)") + 
  scale_y_continuous(breaks = c(seq(0,170, by = 10))) +
  scale_x_continuous(breaks = c(seq(-20,212, by = 20),212)) + 
  geom_vline(xintercept = 0, linetype="dashed", color = "red", size=0.5) + 
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_school, color = "black"),  
             size = 1, fill = "black") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_alcohol, color = "red"),  
             size = 1, fill = "red") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_fines, color = "blue"),  
             size = 1, fill = "blue") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_curfew, color = "green4"),  
             size = 1, fill = "green4") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_businesses, color = "gold"),  
             size = 1, fill = "gold") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_publicplaces, color = "brown"),  
             size = 1, fill = "brown") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_checkpoints, color = "orange"),  
             size = 1, fill = "orange") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_events, color = "gray"),  
             size = 1, fill = "gray") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_masks, color = "violet"),  
             size = 1, fill = "violet") +  
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_mobility, color = "lightblue"),  
             size = 1, fill = "lightblue") +  
  scale_color_manual(
      name = "Social distancing restrictions",
      values = c("black", "red", "blue", "green4","gold","brown","orange","gray","violet","lightblue"),
      labels = c("Schools", "Fines", "Public places", "Businesses\n(non-essential)", "Events","Curfew","Mobility","Checkpoints","Alcohol sales","Masks")) + 
  ggtitle("Social Distancing policies at the National level")

ggsave("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Coronanet/policies_days_first_case.png",scale = 1.5)
}

#                               +120 days

{
  data_population<-read.csv(file = "~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Coronanet/national_policies.csv") %>%
    subset(days_first_case <= 120)
  
  data_population$cum_checkpoints = 0
  
  ggplot(data_population, aes(x="", y = "")) +
    theme_bw() + theme(legend.position="bottom", 
                       plot.title = element_text(hjust = 0.5),
                       plot.subtitle = element_text(hjust = 0.5)) + 
    labs(x="Days with respect to the first Covid-19 case reported in the country",y="Number of Countries",
         subtitle = "Source: Coronanet Project (Nature)") + 
    scale_y_continuous(breaks = c(seq(0,170, by = 10))) +
    scale_x_continuous(breaks = c(seq(-20,212, by = 20),212)) + 
    geom_vline(xintercept = 0, linetype="dashed", color = "red", size=0.5) + 
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_school, color = "black"),  
               size = 1, fill = "black") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_alcohol, color = "red"),  
               size = 1, fill = "red") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_fines, color = "blue"),  
               size = 1, fill = "blue") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_curfew, color = "green4"),  
               size = 1, fill = "green4") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_businesses, color = "gold"),  
               size = 1, fill = "gold") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_publicplaces, color = "brown"),  
               size = 1, fill = "brown") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_checkpoints, color = "orange"),  
               size = 1, fill = "orange") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_events, color = "gray"),  
               size = 1, fill = "gray") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_masks, color = "violet"),  
               size = 1, fill = "violet") +  
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_mobility, color = "lightblue"),  
               size = 1, fill = "lightblue") +  
    scale_color_manual(
      name = "Social distancing restrictions",
      values = c("black", "red", "blue", "green4","gold","brown","orange","gray","violet","lightblue"),
      labels = c("School", "Fines", "Public places", "Businesses (non-essential)", "Events","Curfew","Mobility","Checkpoints","Alcohol sales","Masks")) + 
    ggtitle("Social Distancing policies at the National level")
  
  ggsave("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Coronanet/policies_days_first_case_120.png",scale = 1.5)
}

#                           NATIONAL, PROVINCIAL or MUNICIPAL

{

data_population<-read.csv(file = "~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Coronanet/any_policies.csv")

data_population$cum_checkpoints = 0

ggplot(data_population, aes(x="", y = "")) +
  theme_bw() + theme(legend.position="bottom", 
                     plot.title = element_text(hjust = 0.5),
                     plot.subtitle = element_text(hjust = 0.5)) + 
  labs(x="Days with respect to day when the first Covid-19 case",y="Number of Countries",
       subtitle = "Source: Coronanet Project (Nature)") + 
  scale_y_continuous(breaks = c(seq(0,170, by = 10))) +
  scale_x_continuous(breaks = c(seq(-20,212, by = 20),212)) + 
  geom_vline(xintercept = 0, linetype="dashed", color = "red", size=0.5) + 
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_school, color = "black"),  
             size = 1, fill = "black") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_alcohol, color = "red"),  
             size = 1, fill = "red") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_fines, color = "blue"),  
             size = 1, fill = "blue") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_curfew, color = "green4"),  
             size = 1, fill = "green4") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_businesses, color = "gold"),  
             size = 1, fill = "gold") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_publicplaces, color = "brown"),  
             size = 1, fill = "brown") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_checkpoints, color = "orange"),  
             size = 1, fill = "orange") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_events, color = "gray"),  
             size = 1, fill = "gray") +
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_masks, color = "violet"),  
             size = 1, fill = "violet") +  
  geom_point(data_population, mapping=aes(x = days_first_case, y = cum_mobility, color = "lightblue"),  
             size = 1, fill = "lightblue") +  
  scale_color_manual(
    name = "Social\ndistancing\nrestrictions",
    values = c("black", "red", "blue", "green4","gold","brown","orange","gray","violet","lightblue"),
    labels = c("School", "Fines", "Public places", "Businesses (non-essential)", "Events","Curfew","Mobility","Checkpoints","Alcohol sales","Masks")) + 
  ggtitle("Social Distancing policies at the National, Provincial or Municipal level")

ggsave("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Coronanet/policies_days_first_case_any.png",scale = 1.5)
}

#                               +120 days

{
  
  data_population<-read.csv(file = "~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Coronanet/any_policies.csv") %>%
    subset(days_first_case <= 120)
  
  data_population$cum_checkpoints = 0
  
  ggplot(data_population, aes(x="", y = "")) +
    theme_bw() + theme(legend.position="bottom", 
                       plot.title = element_text(hjust = 0.5),
                       plot.subtitle = element_text(hjust = 0.5)) + 
    labs(x="Days with respect to the day when first Covid-19 case was reported in the country",y="Number of Countries") +
         #subtitle = "Source: Coronanet Project (Nature)") + 
    scale_y_continuous(breaks = c(seq(0,170, by = 20))) +
    scale_x_continuous(breaks = c(seq(-20,212, by = 20),212)) + 
    geom_vline(aes(xintercept = 0, linetype = "First COVID-19 case reported"), color = "red", size=0.5) + 
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_school, color = "black"),  
               size = 1, fill = "black") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_alcohol, color = "red"),  
               size = 1, fill = "red") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_fines, color = "blue"),  
               size = 1, fill = "blue") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_curfew, color = "green4"),  
               size = 1, fill = "green4") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_businesses, color = "gold"),  
               size = 1, fill = "gold") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_publicplaces, color = "brown"),  
               size = 1, fill = "brown") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_checkpoints, color = "orange"),  
               size = 1, fill = "orange") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_events, color = "gray"),  
               size = 1, fill = "gray") +
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_masks, color = "violet"),  
               size = 1, fill = "violet") +  
    geom_point(data_population, mapping=aes(x = days_first_case, y = cum_mobility, color = "lightblue"),  
               size = 1, fill = "lightblue") +
    scale_linetype_manual(name = "", values=c("dashed")) +
    scale_color_manual(
      name = "Social\ndistancing\nrestrictions",
      values = c("black", "red", "blue", "green4","gold","brown","orange","gray","violet","lightblue"),
      labels = c("Schools", "Fines", "Public spaces", "Businesses\n(non-essential)", "Events","Curfew","Transportation","Checkpoints","Alcohol sales","Masks")) + 
    #ggtitle("Social Distancing policies at the National, Provincial or Municipal level")
  
  ggsave("~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Coronanet/policies_days_first_case_any_120.png",width = 9, height = 4.79)
}
