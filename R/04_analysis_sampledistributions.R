# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")

# Wrangle data ------------------------------------------------------------
# In the description it is stated that a step in depth is 20cm.
description_data <- my_data_clean_aug %>%
  distinct(Samples, .keep_all = TRUE) %>%
  mutate(latrine_number = as.integer(str_sub(Sample, str_locate(Sample, "\\d+")))) %>%
  mutate(sample_depth = (20*as.integer(str_sub(Samples, str_locate(Samples, "\\d+$")))))

# Visualise data --------------------------------------------------------------
# Distribution of the samples within the two sites
samplesdist_historgam <- ggplot(data = description_data, mapping = aes(x = latrine_number, fill = site))  +
  geom_bar(alpha = 0.8, position = position_dodge(1), width = 0.5) +
  labs(x = "Latrine", y = "Samples within Latrine", title ="Distribution of Samples") +
  theme(legend.position = "none") +
  facet_wrap(~site)

#This does not correlate with the information in table 1 of the article,
#However it does correlated with raw data. Conclusion is that some
#data cleaning / wrangling must have been carried regarding the article. 

# Sample depth in cm
samplesdepth_historgam <- ggplot(data = description_data, mapping = aes(x = latrine_number, y = sample_depth, color = site))  +
  geom_point(alpha = 0.8) +
  labs(x = "Latrine", y = "Samples depth [cm]", title ="Sample depth") +
  theme(legend.position = "none") +
  facet_wrap(~site)

# Write data --------------------------------------------------------------
ggsave("/cloud/project/results/samplesdist_historgam.png")
ggsave("/cloud/project/results/samplesdepth_historgam.png")

