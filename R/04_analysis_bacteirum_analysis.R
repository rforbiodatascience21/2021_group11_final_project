# Distribution of samples 

# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")  
library("cowplot")
library("patchwork")
#library("correlationfunnel")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "data/03_my_data_clean_aug.tsv")

# Wrangle data ------------------------------------------------------------
#site to numeric
my_data_clean_aug <- my_data_clean_aug %>%
  mutate(site_class = case_when(site == "Tanzania" ~ 0,
                                site == "Vietnam" ~ 1))

creating_bacterium_barplot("Bacilli", "pH")





