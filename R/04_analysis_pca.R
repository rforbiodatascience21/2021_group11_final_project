# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")  
library("cowplot")
library("correlationfunnel")
library("devtools")
#install_github("vqv/ggbiplot")
library("ggbiplot")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "data/03_my_data_clean_aug.tsv")

# Wrangle data ------------------------------------------------------------

# Remove non-numeric columns and scale to unit variance
pca_fit <- my_data_clean_aug %>% 
  select(where(is.numeric)) %>% 
  prcomp(scale = TRUE, center = TRUE)

# Visualise data ----------------------------------------------------------

# Plot rotation matrix and datapoints along PC1 and 2  
pca_rotation <- ggbiplot(pca_fit,ellipse=TRUE, groups=my_data_clean_aug$site)

# Variance explained by each PC 
pca_variance <- pca_fit %>%
  tidy(matrix = "eigenvalues") %>%
  ggplot(aes(PC, percent)) +
  geom_col(fill = "#56B4E9", alpha = 0.8) +
  scale_x_continuous(breaks = 1:9) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.01))
  ) +
  theme_minimal_hgrid(12)

# Write data --------------------------------------------------------------
#write_tsv(...)
ggsave("/cloud/project/results/pca_rotation.png") 
ggsave("/cloud/project/results/pca_variance.png")
