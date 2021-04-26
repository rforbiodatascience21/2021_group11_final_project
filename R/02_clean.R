# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
my_data_ENV <- read_tsv(file = "data/01_my_data_ENV.tsv")
my_data_SPE <- read_tsv(file = "data/01_my_data_SPE.tsv")


# Wrangle data ------------------------------------------------------------
my_data_clean_ENV <- my_data_ENV
my_data_clean_SPE <- my_data_SPE


# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean_ENV,
          file = "data/02_my_data_clean_ENV.tsv")
write_tsv(x = my_data_clean_SPE,
          file = "data/02_my_data_clean_SPE.tsv")