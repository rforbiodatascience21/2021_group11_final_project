# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")

# Wrangle data ------------------------------------------------------------

# Visualise data --------------------------------------------------------------
pHandTemp_violinplot <- creating_attribute_violinplot("pH") + creating_attribute_violinplot("Temp")

# Write data --------------------------------------------------------------
ggsave("/cloud/project/results/pHandTemp_violinplot.png")
