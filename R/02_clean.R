# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_counts <- read_tsv(file = "data/01_my_data_counts.tsv")
my_data_taxonomy <- read_tsv(file = "data/01_my_data_taxonomy.tsv")
my_data_ENV <- read_tsv(file = "data/01_my_data_ENV.tsv")


# Wrangle data ------------------------------------------------------------
# Set class of unclassified bacteria to "Unclassified" in taxonomy data
my_data_clean_taxonomy <- my_data_taxonomy %>%
  mutate(Class = case_when(is.na(Class) ~ "Unclassified",
                           str_detect(Class, "unclassified") ~ "Unclassified",
                           str_detect(Class, "incertae_sedis") ~ "Unclassified",
                           TRUE ~ Class))

# Define clean versions of counts and ENV data
my_data_clean_counts <- my_data_counts
my_data_clean_ENV <- my_data_ENV

# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean_taxonomy,
          file = "data/02_my_data_clean_taxonomy.tsv")

write_tsv(x = my_data_clean_counts,
          file = "data/02_my_data_clean_counts.tsv")

write_tsv(x = my_data_clean_ENV,
          file = "data/02_my_data_clean_ENV.tsv")
