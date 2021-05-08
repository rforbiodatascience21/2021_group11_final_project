# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")
library("corrr")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")

# Visualise data ----------------------------------------------------------
# Correlation plot
correlationplot <- my_data_clean_aug %>%
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
  labs(y = "Pearson Correlation Value", title = "Correlationplot") +
  theme(axis.title.x = element_blank(), legend.title = element_blank(), axis.text.x = element_text(angle = 45, hjust=1))
# This code generates a warning that 5 rows containing NA was removed
# which is perfectly fine as these NA's are the attributes correlated by itself
# thereby yieling NA
correlationplot

# A point plot that visualizes the distribution of Depth vs VS as it has the highest 
# absolute (pearson) correlation value
creating_correlation_pointplot("Depth", "VS")
  
# Write data ----------------------------------------------------------
ggsave("/cloud/project/results/correlationplot.png")

