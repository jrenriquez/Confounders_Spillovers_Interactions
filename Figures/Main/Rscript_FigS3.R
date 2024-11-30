# Figure S3

cluster_se <- function(x,data,cluster) {
  coeftest(x, vcov = vcovCL(x, cluster = data$cluster))[,2]
}
proper=function(x) paste0(toupper(substr(x, 1, 1)), tolower(substring(x, 2)))


# Correlation matrix
# this method does not account for panel data

panel <- read_dta("~/Dropbox/COVID-19 Mexico/Analysis/First stage/panel_COVIDTreatMR_fixdates.dta") %>%
  select(code_INEGI, date, 
         starts_with("cum_"), -cum_any) %>%
  dplyr::filter(is.na(code_INEGI) == FALSE & is.na(date) == FALSE) %>%
  dplyr::rename(id = code_INEGI)

pdata <- plm::pdata.frame(panel, index = c("id", "date")) %>%
  dplyr::rename_at(vars(starts_with("cum_")), funs(sub("cum_", "", .)))

policies <- c("alcohol","businesses","checkpoints","curfew",
              "events","fines","masks","mobility",
              "publicplaces","school")

cor_matrix <- cor(pdata[, policies], use = "pairwise.complete.obs",method="pearson")
print(cor_matrix)

cor(pdata %>% select(-id,-date), method = "pearson")

# accounting for panel data
# "within" is a fixed effects model
cor_matrix_panel <- matrix(NA, nrow = length(policies), ncol = length(policies))
cor_matrix_graph <- matrix(NA, nrow = length(policies)^2, ncol = 3)
counter = 1
for (i in 1:length(policies)) {
  for (j in 1:length(policies)) {
    if (i > j) {
      form <- as.formula(paste0(policies[i]," ~ ", paste(policies[j], collapse = " + ")))
      #form <- as.formula(paste0(policies[i]," ~ ",policies[j],"+ factor(id) + factor(date)"))
      # Fit panel data model
      model <- plm::plm(form, data = pdata, model = "within")
      # Compute pairwise correlation
      print(paste0("correlation : ",policies[i]," & ",policies[j],": ",round(cor(model$model[,1], model$model[,2],method="pearson"),3)))
      cor_matrix_panel[i, j] <- cor(model$model[,1], model$model[,2],method="pearson")
      # print(paste0("correlation : ",policies[i]," & ",policies[j],": ",round(cor(model$model[,1], model$model[,2]),3)))
      # cor_matrix_panel[i, j] <- cor(model$model[,1], model$model[,2])
      cor_matrix_graph[counter,2] <-  policies[i]
      cor_matrix_graph[counter,1] <-  policies[j]
      cor_matrix_graph[counter,3] <-  cor(model$model[,1], model$model[,2],method="pearson")
    }
    else if (i == j) {
      cor_matrix_panel[i, j] <- 1
      cor_matrix_graph[counter,2] <-  policies[i]
      cor_matrix_graph[counter,1] <-  policies[j]
      cor_matrix_graph[counter,3] <-  1
    }
    else {
      cor_matrix_panel[i, j] <- NA
    }
    counter = counter + 1
  }
}
print(cor_matrix_panel)

matrix_graph <- as.data.frame(cor_matrix_graph) %>%
      mutate(order = seq(1,10,by = 1)) %>%
      dplyr::filter(is.na(`V3`) == FALSE)
names(matrix_graph) <- c("policy1", "policy2","corr","order")

my.lines <- data.frame(x=c(9.5,10.5), y=c(1.5,1.5), 
                     xend=c(-1.5,9.5), yend=c(1.5,1.5))
my.lines2 <- data.frame(x=c(9.5,9.5), y=c(0.5,10), 
                     xend=c(9.5,9.5), yend=c(11.5,11.5))
# Figure 
ggplot(matrix_graph, 
       aes(x = (policy1), y = reorder(policy2,-order), fill = as.numeric(corr))) + 
  geom_tile(color = "white",
            lwd = 1.0,
            linetype = 1) + 
  geom_text(aes(label = sprintf("%0.2f", as.numeric(corr))), color = "black", size = 5) + 
  scale_fill_gradient2(low = "red", 
                      mid = "white", 
                      high = "steelblue",
                      midpoint = 0, 
                      na.value = "gray80",
                      limits = c(-1,1),
                      breaks = seq(-1,1,0.5),
                      name = "Correlation\ncoefficient\n") + 
  scale_x_discrete(expression(paste(bold("Policy"))),
                   position = "top",
                   labels = c("alcohol" = "Alcohol",
                              "businesses" = "Businesses",
                              "checkpoints" = "Checkpoints",
                              "curfew" = "Curfew",
                              "events" = "Events",
                              "fines" = "Fines",
                              "masks" = "Masks",
                              "mobility" = "Mobility",
                              "publicplaces" = "Public places",
                              "school" = "Schools")) + 
  scale_y_discrete(expression(paste(bold("Policy"))),
                   labels = c("alcohol" = "Alcohol",
                              "businesses" = "Businesses",
                              "checkpoints" = "Checkpoints",
                              "curfew" = "Curfew",
                              "events" = "Events",
                              "fines" = "Fines",
                              "masks" = "Masks",
                              "mobility" = "Mobility",
                              "publicplaces" = "Public places",
                              "school" = "Schools")) + 
  geom_segment(data = my.lines, 
               aes(x, y, xend = xend, yend = yend), 
               size=1, inherit.aes=FALSE) + 
  geom_segment(data = my.lines2, 
               aes(x, y, xend = xend, yend = yend), 
               size=1, inherit.aes=FALSE) + 
  theme_void() + 
  theme(axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 3, l = 0), 
                                    angle = 0, size = 20),
        axis.title.y = element_text(margin = margin(t = 5, r = 10, b = -25, l = 0), 
                                    angle = 90, size = 20),
        axis.text.x = element_text(color = "black", size=16, angle=0, vjust=0, hjust=0.5,  
                                   margin = margin(t = 5, r = 10, b = 10, l = 10)),
        axis.text.y = element_text(color = "black", size=16, angle=90, vjust=0, hjust=0.5,  
                                   margin = margin(t = 0, r = -30, b = 0, l = 0)),
        legend.title = element_text(size = 24),
        legend.text = element_text(size = 24),
        legend.title.align = 0.5,
        legend.text.align = 0.5) + 
  coord_cartesian(ylim = c(0.5,10),
                  xlim = c(0.5,10),
                  clip = "off") +
  theme(plot.margin = unit(c(0.5,0,0,0), "lines")) + 
  theme(axis.text = element_text(size = 24))

ggsave("correlation_matrix_policies.png", height=15, width = 18)
