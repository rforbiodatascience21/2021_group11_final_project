# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")  
library("cowplot")
#library("correlationfunnel")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")

# Wrangle data ------------------------------------------------------------
pca_fit <- my_data_clean_aug %>% 
  select(where(is.numeric)) %>% # select only numeric columns 
  prcomp(scale = TRUE) # scale data to unit variance and perform PCA 

# Visualise data ----------------------------------------------------------

# Plot data in PC coordinates
pca <- pca_fit %>%
  augment(my_data_clean_aug) %>% # combine with original data to color by site
  ggplot(aes(.fittedPC1, .fittedPC2, color = site)) + 
  geom_point(size = 1.3) +
  xlab("Principal component 1") +
  ylab("Principal component 2") +
  scale_color_manual(
    name = "Country",
    values = c(Tanzania = "#6495ed", Vietnam = "#b22222")
  ) 

# Arrow style
arrow_style <- arrow(
  angle = 20, ends = "first", type = "closed", length = grid::unit(8, "pt")
)

# Plot rotation matrix
rotation <- pca_fit %>%
  tidy(matrix = "rotation") %>%
  pivot_wider(names_from = "PC", names_prefix = "PC", values_from = "value") %>%
  ggplot(aes(PC1, PC2)) +
  geom_segment(xend = 0, yend = 0, arrow = arrow_style) +
  geom_text(
    aes(label = column),
    hjust = 1.2, vjust = -0.5, nudge_x = 0.02, 
    color = "#556b2f"
  ) +
  xlim(-.75, .5) + ylim(-.5, .5) +
  coord_fixed() 

# Variance explained by each PC
variance <- pca_fit %>%
  tidy(matrix = "eigenvalues") %>%
  ggplot(aes(PC, percent)) +
  geom_col(fill = "#556b2f", alpha = 0.8) +
  scale_x_continuous(breaks = 1:13) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.01))
  ) +
  ylab("Percent of variance explained")

# Write data --------------------------------------------------------------
ggsave(file ="/cloud/project/results/pca.png", plot = pca)
ggsave(file ="/cloud/project/results/rotation.png", plot = rotation)
ggsave(file ="/cloud/project/results/variance.png", plot = variance)
