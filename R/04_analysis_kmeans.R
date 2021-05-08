# K-means of principal components:
# Inspired by algorithm: https://www.tidymodels.org/learn/statistics/k-means/
# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/04_analysis_pca.R")


# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")


# Wrangle data ------------------------------------------------------------
set.seed(3)
set.seed(5)

# Get pca information
pca_fit %>% tidy(,"pcs")
  
# Add pca information to the tibble 
pca_fit_aug <- augment(pca_fit, data = my_data_clean_aug)

# Get all PCs
principal_components <- pca_fit_aug %>%
  select(starts_with(".fittedPC"))

# Model Data ---------------------------------------------------------------
run_kmeans <- function(data, n_clusters) {
  tibble(k = 1:9) %>%
    mutate(
      kclust = map(k, ~kmeans(data, .x)),
      tidied = map(kclust, tidy),
      glanced = map(kclust, glance),
      augmented = map(kclust, augment, data))
}

clust_1_9 <- run_kmeans(data = principal_components, n_clusters = 1:9)
clust_4 <- run_kmeans(data = principal_components, n_clusters = 4)


# Plot of first 2 PC's
ggplot(pca_fit_aug, aes(.fittedPC1, .fittedPC2)) +
  geom_point()

# Unnest
clusters <- 
  clust_1_9 %>%
  unnest(cols = c(tidied))

assignments <- 
  clust_1_9 %>% 
  unnest(cols = c(augmented))

clusterings <- 
  clust_1_9 %>%
  unnest(cols = c(glanced))


# Visualise data ----------------------------------------------------------
clusters <- 
  ggplot(assignments, aes(x = .fittedPC1, y = .fittedPC2)) +
  geom_point(aes(color = .cluster), alpha = 0.8) + 
  facet_wrap(~ k)

elbowplot <- 
ggplot(clusterings, aes(k, tot.withinss)) +
  geom_line() +
  geom_point()

# Write data --------------------------------------------------------------
ggsave("/cloud/project/results/clusters.png", plot = clusters)
ggsave("/cloud/project/results/elbowplot.png", plot = elbowplot)