# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
my_data_clean_ENV <- read_tsv(file = "data/02_my_data_clean_ENV.tsv")
my_data_clean_SPE <- read_tsv(file = "data/02_my_data_clean_SPE.tsv")


# Wrangle data ------------------------------------------------------------
my_data_clean_aug <- my_data_clean_SPE %>%
  pivot_longer(cols = -Taxa,
               names_to = "Samples",
               values_to = "OTU_Count") %>%
  full_join(my_data_clean_ENV, by = "Samples") %>%
  mutate(site = case_when(str_detect(Samples, "^T") ~ "Tanzania",
                          str_detect(Samples, "^V") ~ "Vietnam")) %>%
  separate(Samples, into = c("Sample", "Depth"), sep="_(?=[^_]+$)", remove=F)


# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean_aug,
          file = "data/03_my_data_clean_aug.tsv")