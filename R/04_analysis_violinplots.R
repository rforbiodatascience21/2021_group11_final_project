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
pHTempNH4_violinplot <-  creating_attribute_violinplot("Temp") + 
  creating_attribute_violinplot("Carbo") + 
  creating_attribute_violinplot("NH4") + 
  plot_annotation(
    title = 'Environmental Features In the Two Countries')

# Write data --------------------------------------------------------------
ggsave(file = "/cloud/project/results/pHTempNH4_violinplot.png", 
       plot = pHTempNH4_violinplot)
