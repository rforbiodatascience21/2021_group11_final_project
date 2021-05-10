# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(
  file = "/cloud/project/data/03_my_data_clean_aug.tsv")

# Wrangle data ------------------------------------------------------------

# Visualize data ----------------------------------------------------------
TempCarboNH4pH_violinplot <-  
  creating_attribute_violinplot(data = my_data_clean_aug, 
                                attribute = "Temp") + 
  creating_attribute_violinplot(data = my_data_clean_aug, 
                                attribute = "Carbo") + 
  creating_attribute_violinplot(data = my_data_clean_aug, 
                                attribute = "NH4") + 
  creating_attribute_violinplot(data = my_data_clean_aug, 
                                attribute = "pH")
  plot_annotation(
    title = 'Environmental Features In the Two Countries')

# Write data --------------------------------------------------------------
ggsave(file = "/cloud/project/results/TempCarboNH4pH_violinplot.png", 
       width = 10, 
       height = 6, 
       dpi = 150,
       units = "in",
       plot = TempCarboNH4pH_violinplot)
