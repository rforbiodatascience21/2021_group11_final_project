# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")  
library("cowplot")
library("correlationfunnel")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "data/03_my_data_clean_aug.tsv")


# Wrangle data ------------------------------------------------------------
#my_data_clean_aug %>% ...

#site to numeric
my_data_clean_aug <- my_data_clean_aug %>%
  mutate(site_class = case_when(site == "Tanzania" ~ 0,
                                site == "Vietnam" ~ 1))
 
# Model data
#my_data_clean_aug %>% ...
#my_data_clean_aug = my_data_clean_aug %>%
#  select(outcome, pull(gravier_data_long_nested, gene))

pca_fit <- my_data_clean_aug %>% 
  select(where(is.numeric)) %>% # retain only numeric columns
  prcomp(scale = TRUE) 

pca_fit %>%
  augment(my_data_clean_aug) %>% # add original dataset back in
  ggplot(aes(.fittedPC1, .fittedPC2, color = site)) + 
  geom_point(size = 1.5) +
  scale_color_manual(
    values = c(malignant = "#D55E00", benign = "#0072B2")
  ) +
  theme_half_open(12) + background_grid()

pca_fit %>%
  tidy(matrix = "rotation")

# define arrow style for plotting
arrow_style <- arrow(
  angle = 20, ends = "first", type = "closed", length = grid::unit(8, "pt")
)

# plot rotation matrix
pca_fit %>%
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

pca_fit %>%
  tidy(matrix = "eigenvalues")

pca_fit %>%
  tidy(matrix = "eigenvalues") %>%
  ggplot(aes(PC, percent)) +
  geom_col(fill = "#56B4E9", alpha = 0.8) +
  scale_x_continuous(breaks = 1:9) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.01))
  ) +
  theme_minimal_hgrid(12)

# Visualise data ----------------------------------------------------------
#my_data_clean_aug %>% ...
ggplot(data = my_data_clean_aug,
       mapping = aes(x = OTU_Count,
                     y = Taxa,
                     fill = site)) +
  geom_boxplot()

ggplot(data = my_data_clean_aug,
       mapping = aes(x = Temp,
                     y = pH,
                     colour = site)) +
  geom_point()

ggplot(data = my_data_clean_aug,
       mapping = aes(x = Temp,
                     y = pH,
                     colour = site)) +
  geom_point()

ggplot(data = my_data_clean_aug,
       mapping = aes(x = Temp,
                     y = TS,
                     colour = site)) +
  geom_point()

# Write data --------------------------------------------------------------
#write_tsv(...)
#ggsave(...)