# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_counts <- read_tsv(file = "data/02_my_data_clean_counts.tsv")
my_data_clean_taxonomy <- read_tsv(file = "data/02_my_data_clean_taxonomy.tsv")
my_data_clean_ENV <- read_tsv(file = "data/02_my_data_clean_ENV.tsv")

# Wrangle data ------------------------------------------------------------
# Join samples and taxonomy information based on OTU
my_data_clean_aug_counts_taxonomy <- my_data_clean_counts %>%
  left_join(y = my_data_clean_taxonomy, 
            by = c("OTU"= "OTUs")) %>%
  select(-OTU, 
         -Domain, 
         -Phylum, 
         -Order, 
         -Family, 
         -Genus) %>%
  select(Class, 
         everything()) %>%
  group_by(Class) %>%
  summarise(across(everything(), 
                   sum))

# Make samples and taxonomy data ready for join with meta data
my_data_clean_aug_counts_taxonomy <- my_data_clean_aug_counts_taxonomy %>%
  pivot_longer(cols = -Class,
               names_to = "Samples",
               values_to = "OTU_Count")

# Join counts and taxonomy to metadata
my_data_clean_aug <- my_data_clean_ENV %>%
  left_join(y = my_data_clean_aug_counts_taxonomy,
            by = "Samples")

# Add sites column
my_data_clean_aug <- my_data_clean_aug %>%
  mutate(site = case_when(str_detect(Samples, "^T") ~ "Tanzania",
                        str_detect(Samples, "^V") ~ "Vietnam"))

# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean_aug,
          file = "data/03_my_data_clean_aug.tsv")
