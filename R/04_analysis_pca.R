# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")  
library("cowplot")
library("correlationfunnel")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")

# Wrangle data ------------------------------------------------------------
pca_fit <- my_data_clean_aug %>% 
  select(where(is.numeric)) %>% 
  prcomp(scale = TRUE, center = TRUE) 

# Visualise data ----------------------------------------------------------

# Plot data in PC coordinates
pca <- pca_fit %>%
  augment(my_data_clean_aug) %>% # combine with original data to color by site
  ggplot(aes(.fittedPC1, .fittedPC2, color = site)) + 
  geom_point(size = 1.5) +
  scale_color_manual(
    values = c(Tanzania = "#D55E00", Vietnam = "#0072B2")
  ) +
  theme_half_open(12) + background_grid()

# define arrow style for plotting
arrow_style <- arrow(
  angle = 20, ends = "first", type = "closed", length = grid::unit(8, "pt")
)

# plot rotation matrix
rotation <- pca_fit %>%
  tidy(matrix = "rotation") %>%
  pivot_wider(names_from = "PC", names_prefix = "PC", values_from = "value") %>%
  ggplot(aes(PC1, PC2)) +
  geom_segment(xend = 0, yend = 0, arrow = arrow_style) +
  geom_text(
    aes(label = column),
    hjust = 1, nudge_x = -0.02, 
    color = "#904C2F"
  ) +
  xlim(-1.25, .5) + ylim(-.5, 1) +
  coord_fixed() + # fix aspect ratio to 1:1
  theme_minimal_grid(12)

# Look at variance explained by each PC -----------------------------------
variance <- pca_fit %>%
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
ggsave(file ="/cloud/project/results/pca.png", plot = pca)
ggsave(file ="/cloud/project/results/rotation.png", plot = rotation)
ggsave(file ="/cloud/project/results/variance.png", plot = variance)
