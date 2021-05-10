# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(
  file = "/cloud/project/data/03_my_data_clean_aug.tsv")

# Visualise data ----------------------------------------------------------
bacilli_pH_barplot <- creating_bacterium_barplot(
  bacterium = "Bacilli", 
  attribute = "pH")

# Write data --------------------------------------------------------------
ggsave("/cloud/project/results/bacilli_pH_barplot.png")

