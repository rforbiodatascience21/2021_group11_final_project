# Distribution of samples 

# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")  
library("cowplot")
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

# In the description it is stated that a step in depth is 20cm.
# Filter data 
description_data <- my_data_clean_aug %>%
  distinct(Samples, .keep_all = TRUE) %>%
  mutate(latrine_number = as.integer(str_sub(Sample, str_locate(Sample, "\\d+")))) %>%
  mutate(sample_depth = (20*as.integer(str_sub(Samples, str_locate(Samples, "\\d+$")))))

# Visualizing data --------------------------------------------------------------
# Distribution of the samples within the two sites
ggplot(data = description_data, mapping = aes(x = latrine_number, fill = site))  +
  geom_bar(alpha = 0.8, position=position_dodge(1), width = 0.5) +
  labs(x = "Latrine", y = "Samples within Latrine", title ="Distribution of Samples") +
  theme(legend.position = "none") +
  facet_wrap(~site)

#This does not correlate with the information in table 1 of the article,
#However it does correlated with raw data. Conclusion is that some
#data cleaning / wrangling must have been carried regarding the article. 

# Sample depth in cm
ggplot(data = description_data, mapping = aes(x = latrine_number, y = sample_depth, color = site))  +
  geom_point(alpha = 0.8) +
  labs(x = "Latrine", y = "Samples depth [cm]", title ="Sample depth") +
  theme(legend.position = "none") +
  facet_wrap(~site)
