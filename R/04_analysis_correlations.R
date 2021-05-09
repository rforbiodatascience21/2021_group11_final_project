# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("GGally")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")

# Visualise data ----------------------------------------------------------

# Plot of correlations, Vietnam
Vietnam_correlation <- 
  my_data_clean_aug %>% 
  filter(site == "Vietnam") %>% 
  select(-"Taxa", -"Samples", -"site", -"OTU_Count") %>% 
  ggpairs(title = "Vietnam") 

# Plot of correlations, Tanzania
Tanzania_correlation <- 
  my_data_clean_aug %>% 
  filter(site == "Tanzania") %>% 
  select(-"Taxa", -"Samples", -"site", -"OTU_Count") %>% 
  ggpairs(title = "Tanzania")

# Write data ----------------------------------------------------------
png("/cloud/project/results/Vietnam_correlation.png")
Vietnam_correlation
dev.off()
png("/cloud/project/results/Tanzania_correlation.png")
Tanzania_correlation
dev.off()


