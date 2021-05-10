# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")
library("corrr")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(
  file = "/cloud/project/data/03_my_data_clean_aug.tsv")
significant_bacteria_countries <- read_tsv(
  file = "/cloud/project/results/significant_bacteria.tsv")

# Wrangeling the data -----------------------------------------------------
# Ectracting bacteria that are significant at alpha = 0.001
significant_bacteria_countries <- significant_bacteria_countries %>%
  filter(p.value <= 0.001) %>%
  select(Class) %>%
  unlist(use.names = FALSE)

# Visualise data ----------------------------------------------------------
# Created a correlation of attributes
correlation_attributes <- my_data_clean_aug %>%
  select(where(is.numeric)) %>%
  select(-OTU_Count) %>%
  correlate(use = "all.obs",
            method = "pearson") %>%
  pivot_longer(cols = -term) %>%
  ggplot(aes(x = factor(term),
             y = value, 
             color = name, 
             group = name))+
  geom_point(size = 3, 
             alpha=0.7) +
  geom_hline(yintercept = 0, 
             linetype="dashed", 
             color = "black") +
  ylim(min = -1,
       max = 1) +
  labs(y = "Pearson Correlation Value", 
       title = "Correlation of Environmental Features") +
  theme(axis.title.x = element_blank(), 
        legend.title = element_blank(), 
        axis.text.x = element_text(angle = 45, 
                                   hjust=1))

# Correlation plot of attributes vs. bacteria
correlation_attributes_bacteria <- my_data_clean_aug %>%
  pivot_wider(names_from = Class, 
              values_from = OTU_Count) %>%
  select(c(pH, 
           Temp, 
           TS, 
           VS, 
           VFA, 
           CODt, 
           CODs, 
           perCODsbyt, 
           NH4, 
           Prot, 
           Carbo, 
           significant_bacteria_countries)) %>%
  correlate(use = "all.obs",
            method = "pearson") %>%
  pivot_longer(cols = -term) %>%
  filter(!term %in% significant_bacteria_countries) %>%
  filter(name %in% significant_bacteria_countries) %>%
  ggplot(aes(x = factor(term), 
             y = value, 
             color = name, 
             group = name))+
  geom_point(size = 3, 
             alpha=0.7) +
  geom_hline(yintercept = 0, 
             linetype="dashed", 
             color = "black") +
  ylim(min = -0.5,
       max = 0.5) +
  labs(y = "Pearson Correlation Value", 
       title = "Correlations Between Environmental Features and Bacteria") +
  theme(axis.title.x = element_blank(), 
        legend.title = element_blank(), 
        axis.text.x = element_text(angle = 45, 
                                   hjust=1), 
        legend.position="bottom")

# This code generates a warning that 5 rows containing NA was removed
# which is perfectly fine as these NA's are the attributes correlated by itself
# thereby yieling NA

# Write data ----------------------------------------------------------
ggsave(filename = "/cloud/project/results/correlation_attributest.png",
       width = 10, 
       height = 6, 
       dpi = 150,
       units = "in",
       plot = correlation_attributes)
ggsave(filename = "/cloud/project/results/correlation_attributes_bacteria.png",
       width = 10, 
       height = 6, 
       dpi = 150,
       units = "in",
       plot = correlation_attributes_bacteria)
