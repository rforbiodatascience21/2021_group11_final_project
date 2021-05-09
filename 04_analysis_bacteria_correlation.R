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


# Visualise data ----------------------------------------------------------
# Correlation plot
correlationplot <- my_data_clean_aug %>%
  pivot_wider(names_from = Taxa, values_from = OTU_Count) %>%
  # Selects every row of the tibble that has numerical elements 
  select(unlist(x = significant_bacteria, use.names = FALSE)) %>%
  # Creates a correlation matrix
  correlate(use = "all.obs") %>%
  # Puts the matrix on long form 
  pivot_longer(-term) %>%
  # Plotting the correlation
  ggplot(aes(x = factor(term), y = value, color = name, group = name))+
  geom_point(size = 3, alpha=0.7) +
  geom_hline(yintercept = 0, linetype="dashed", color = "black") +
  ylim(-0.5,1) +
  labs(y = "Pearson Correlation Value", title = "Correlationplot") +
  theme(axis.title.x = element_blank(), legend.title = element_blank(), axis.text.x = element_text(angle = 45, hjust=1), legend.position="bottom")
# This code generates a warning that 5 rows containing NA was removed
# which is perfectly fine as these NA's are the attributes correlated by itself
# thereby yieling NA

