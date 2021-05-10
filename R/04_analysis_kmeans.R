# K-means of principal components:
# Inspired by algorithm: https://www.tidymodels.org/learn/statistics/k-means/
# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("scales")


# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/04_analysis_pca.R")
source(file = "/cloud/project/R/99_project_functions.R")


# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(
  file = "/cloud/project/data/03_my_data_clean_aug.tsv")


# Wrangle data ------------------------------------------------------------
set.seed(10)

  
# Add pca information to the tibble and use only data from PC1 and PC2
pca_fit_aug <- augment(x = pca_fit,
                       data = my_data_clean_aug) %>%
  select(.fittedPC1,
         .fittedPC2)

# Model Data ---------------------------------------------------------------

# Run kmeans for clusters 1-9
my_9_clusters <- pca_fit_aug %>%
  run_kmeans(n_clusters = 1:9)

# Run kmeans for cluster 4 with pca
my_cluster <- run_kmeans(data = pca_fit_aug,
                         n_clusters = 4)

# Visualise Data ------------------------------------------------------------

# Plot all 9 clusters
clust_1_9_plot <- my_9_clusters %>%  
  unnest(cols = c(augmented)) %>%
  ggplot(mapping = aes(x = .fittedPC1,
                       y = .fittedPC2)) +
  geom_point(mapping = aes(color = .cluster),
             alpha = 0.8) + 
  facet_wrap(~ k)

# Make elbow plot of these 9 clusters
elbowplot <- my_9_clusters %>%
  unnest(cols = c(glanced)) %>%
  ggplot(mapping = aes(x = k,
                       y = tot.withinss)) +
  geom_line() +
  geom_point() + 
  scale_x_continuous(breaks = pretty_breaks())

# Make plot of kmeans with 4 clusters and principal components
clust_4_pca_plot <- my_cluster %>%
  unnest(cols = c(augmented)) %>%
  ggplot(aes(x = .fittedPC1,
             y = .fittedPC2)) +
  geom_point(aes(color = .cluster),
             alpha = 0.8) +
  coord_equal() + 
  geom_text(data = datapc,
            aes(x = v1,
                y = v2,
                label = varnames),
            size = 4, 
            vjust = -.1,
            hjust = 1.2, 
            color = "black") + 
  geom_segment(data = datapc,
               aes(x = 0,
                   y = 0,
                   xend = v1, 
                   yend = v2), 
               arrow = arrow(length = unit(0.1, 
                                           units = "cm")),
               alpha=0.75,
               color="black") + 
  xlab("Principal component 1") +
  ylab("Principal component 2") +
  labs(color='Cluster no.')

# Write data --------------------------------------------------------------
ggsave(file ="/cloud/project/results/elbowplot.png", plot = elbowplot)
ggsave(file ="/cloud/project/results/clust_1_to_9.png", plot = clust_1_9_plot)
ggsave(file ="/cloud/project/results/clust_4_pca.png", plot = clust_4_pca_plot)
