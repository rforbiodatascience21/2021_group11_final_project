# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")


# Visualise data ------------------------------------------------------------
my_data_clean_aug %>%
  group_by(Samples) %>% 
  mutate(Total_Sample = sum(OTU_Count), Norm_count = OTU_Count/Total_Sample) %>% 
  ggplot(mapping = aes(x = Taxa, y = Norm_count, color = site)) +
  geom_boxplot() + geom_jitter(mapping = aes(alpha = 0.5)) +
  theme(axis.text.x=element_text(angle = 45, hjust = 1, size = 5), 
        axis.text.y=element_text(size = 5)) +
  ylab("Proportion") + xlab("Taxa") +
  ggsave("/cloud/project/results/taxa_boxplots.png")

## NBNB: Her bruges Total_sample fra et andet script, maaske skal den skrives i en fil og sources




