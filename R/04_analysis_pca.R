# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")
library("cowplot")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(
  file = "/cloud/project/data/03_my_data_clean_aug.tsv"
)

# Wrangle data ------------------------------------------------------------
pca_fit <- my_data_clean_aug %>%
  select(where(is.numeric)) %>% 
  prcomp(scale = TRUE) 

pca <- pca_fit %>%
  augment(my_data_clean_aug)

datapc <- pca_fit %>%
  pluck("rotation") %>%
  as_tibble(rownames = "varnames")

data_PC1 <- pca %>% 
  pluck(".fittedPC1")

data_PC2 <- pca %>%
  pluck(".fittedPC2")

datapc_PC1 <- datapc %>%
  pluck("PC1")

datapc_PC2 <- datapc %>%
  pluck("PC2")

mult <- min(
  (max(data_PC2) - min(data_PC2) / (max(datapc_PC2) - min(datapc_PC2))),
  (max(data_PC1) - min(data_PC1) / (max(datapc_PC1) - min(datapc_PC1)))
)

datapc <- transform(datapc,
  v1 = 1.3 * mult * (get("PC1")),
  v2 = 1.3 * mult * (get("PC2"))
)

# Visualise data ----------------------------------------------------------

# Plot in PC coordinates
pca_plot <- ggplot(
  pca,
  aes(x = .fittedPC1, y = .fittedPC2, color = site)
) +
  geom_point(size = 1.3) +
  coord_equal() +
  geom_text(
    data = datapc,
    aes(x = v1, y = v2, label = varnames),
    size = 4,
    vjust = -.4,
    hjust = 1,
    color = "black"
  ) +
  geom_segment(
    data = datapc,
    aes(x = 0, y = 0, xend = v1, yend = v2),
    arrow = arrow(length = unit(0.2, "cm")),
    alpha = 0.75,
    color = "black"
  ) +
  xlab("Principal component 1") +
  ylab("Principal component 2") +
  scale_color_manual(
    name = "Country",
    values = c(Tanzania = "#6495ed", Vietnam = "#b22222")
  )

# Variance explained by each PC
pca_variance_plot <- pca_fit %>%
  tidy(matrix = "eigenvalues") %>%
  ggplot(aes(PC, percent)) +
  geom_col(fill = "#556b2f", alpha = 0.8) +
  scale_x_continuous(breaks = 1:13) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, .01))
  ) +
  ylab("Percentage of variance explained") +
  xlab("Principal component")

# Write data --------------------------------------------------------------
ggsave(
  file = "/cloud/project/results/pca_plot.png",
  plot = pca_plot
)
ggsave(
  file = "/cloud/project/results/pca_variance_plot.png", 
  plot = pca_variance_plot
)
