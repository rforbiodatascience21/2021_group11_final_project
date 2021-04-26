# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
my_data_raw_ENV <- read_csv(file = "data/_raw/ENV_pitlatrine.csv")

my_data_raw_SPE <- read_csv(file = "data/_raw/SPE_pitlatrine.csv")

# Wrangle data ------------------------------------------------------------
my_data <- my_data_raw # %>% ...


# Write data --------------------------------------------------------------
write_tsv(x = my_data,
          file = "data/01_my_data.tsv")
