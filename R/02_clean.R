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
# Set class of unclassified bacteria to "Unclassified" - in taxonomy data
my_data_clean_taxonomy <- my_data_taxonomy %>%
  mutate(Class = case_when(is.na(Class) ~ "Unclassified",
                           str_detect(Class, "unclassified") ~ "Unclassified",
                           str_detect(Class, "incertae_sedis") ~ "Unclassified",
                           TRUE ~ Class))


# Join samples and taxonomy information based on OTU
my_data_clean_counts_taxonomy <- my_data_counts %>%
  left_join(my_data_clean_taxonomy, 
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
my_data_clean_counts_taxonomy <- my_data_clean_counts_taxonomy %>%
  pivot_longer(cols = -Class,
               names_to = "Samples",
               values_to = "OTU_Count")


# Join counts and taxonomy to metadata (only for the samples we have metadata for)
my_data_clean <- my_data_ENV %>%
  left_join(my_data_clean_counts_taxonomy,
            by = "Samples") %>%
  rename(Taxa = Class)


# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean,
          file = "data/02_my_data_clean.tsv")
