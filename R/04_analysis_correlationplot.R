# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")
library("corrr")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")
significant_bacteria <- read_tsv(file = "/cloud/project/results/significant_bacteria.tsv")


# Wrangeling the data ---------------------------------------------------------------
significant_bacteria <- significant_bacteria %>%
  filter(p.value <= 0.001) %>%
  select(Taxa) %>%
  unlist(use.names = FALSE)
attributes <- c(pH, Temp, TS, VS, VFA, CODt, CODs, perCODsbyt, NH4, Prot, Carbo, significant_bacteria)

# Visualise data ----------------------------------------------------------
# Correlation of attributes
correlation_attributes <- my_data_clean_aug %>%
  # Selects every row of the tibble that has numerical elements 
  select(where(is.numeric)) %>%
  # Creates a correlation matrix
  correlate(use = "all.obs") %>%
  # Puts the matrix on long form 
  pivot_longer(-term) %>%
  # Plotting the correlation
  ggplot(aes(x = factor(term), y = value, color = name, group = name))+
  geom_point(size = 3, alpha=0.7) +
  geom_hline(yintercept = 0, linetype="dashed", color = "black") +
  ylim(-1,1) +
  labs(y = "Pearson Correlation Value", title = "Correlation of attributes") +
  theme(axis.title.x = element_blank(), legend.title = element_blank(), axis.text.x = element_text(angle = 45, hjust=1))
# This code generates a warning that 5 rows containing NA was removed
# which is perfectly fine as these NA's are the attributes correlated by itself
# thereby yieling NA

# Visualise data ----------------------------------------------------------
# Correlation plot of bacteria
correlation_bacteria <- my_data_clean_aug %>%
  pivot_wider(names_from = Taxa, values_from = OTU_Count) %>%
  # Selects every row of the tibble that has numerical elements 
  select(significant_bacteria) %>%
  # Creates a correlation matrix
  correlate(use = "all.obs") %>%
  # Puts the matrix on long form 
  pivot_longer(-term) %>%
  # Plotting the correlation
  ggplot(aes(x = factor(term), y = value, color = name, group = name))+
  geom_point(size = 3, alpha=0.7) +
  geom_hline(yintercept = 0, linetype="dashed", color = "black") +
  ylim(-0,1) +
  labs(y = "Pearson Correlation Value", title = "Correlation of significant bacteria") +
  theme(axis.title.x = element_blank(), legend.title = element_blank(), axis.text.x = element_text(angle = 45, hjust=1), legend.position="bottom")
# This code generates a warning that 5 rows containing NA was removed
# which is perfectly fine as these NA's are the attributes correlated by itself
# thereby yieling NA

# Correlation plot of attributes vs. bacteria
correlation_attributes_bacteria <- my_data_clean_aug %>%
  pivot_wider(names_from = Taxa, values_from = OTU_Count) %>%
  # Selects every row of the tibble that has numerical elements 
  select(c(pH, Temp, TS, VS, VFA, CODt, CODs, perCODsbyt, NH4, Prot, Carbo, significant_bacteria)) %>%
  # Creates a correlation matrix
  correlate(use = "all.obs") %>%
  # Puts the matrix on long form 
  pivot_longer(-term) %>%
  filter(!term %in% significant_bacteria) %>%
  filter(name %in% significant_bacteria) %>%
  # Plotting the correlation
  ggplot(aes(x = factor(term), y = value, color = name, group = name))+
  geom_point(size = 3, alpha=0.7) +
  geom_hline(yintercept = 0, linetype="dashed", color = "black") +
  ylim(-0.5,0.5) +
  labs(y = "Pearson Correlation Value", title = "Correlation of attributes vs. significant bacteria") +
  theme(axis.title.x = element_blank(), legend.title = element_blank(), axis.text.x = element_text(angle = 45, hjust=1), legend.position="bottom")
# This code generates a warning that 5 rows containing NA was removed
# which is perfectly fine as these NA's are the attributes correlated by itself
# thereby yieling NA

# Write data ----------------------------------------------------------
ggsave("/cloud/project/results/correlation_attributest.png",plot = correlation_attributes)
ggsave("/cloud/project/results/correlation_bacteria.png",plot = correlation_bacteria)
ggsave("/cloud/project/results/correlation_attributes_bacteria.png",plot = correlation_attributes_bacteria)
