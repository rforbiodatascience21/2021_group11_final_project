# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data ---------------------------------------------------------------
# Samples
my_data_raw_counts <- read_csv(file = "data/_raw/All_Good_P2_C03-1.csv")

# Meta data
my_data_raw_taxonomy <- read_csv(
  file = "data/_raw/All_Good_P2_C03_Taxonomy-1.csv")

my_data_raw_ENV <- read_csv(file = "data/_raw/ENV_pitlatrine.csv")

# Wrangle data ------------------------------------------------------------
my_data_counts <- my_data_raw_counts
my_data_taxonomy <- my_data_raw_taxonomy
my_data_ENV <- my_data_raw_ENV

# Write data --------------------------------------------------------------
write_tsv(x = my_data_counts,
          file = "data/01_my_data_counts.tsv")

write_tsv(x = my_data_taxonomy,
          file = "data/01_my_data_taxonomy.tsv")

write_tsv(x = my_data_ENV,
          file = "data/01_my_data_ENV.tsv")

