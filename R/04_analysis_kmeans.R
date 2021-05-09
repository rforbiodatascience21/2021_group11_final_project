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
#set.seed(5)
  
# Add pca information to the tibble 
pca_fit_aug <- augment(pca_fit, data = my_data_clean_aug)

# Get all PCs
principal_components <- pca_fit_aug %>%
  select(starts_with(".fittedPC"))

# Model Data ---------------------------------------------------------------

# Function that runs kmeans
run_kmeans <- function(data, n_clusters) {
  cluster <- tibble(k = n_clusters) %>%
    mutate(kclust = map(k, 
                   ~kmeans(data, .x)),
      tidied = map(kclust, 
                   tidy),
      glanced = map(kclust,
                    glance),
      augmented = map(kclust,
                      augment,
                      data))
  return(cluster)
}

make_assignments <- function(kmeans_cluster) {
  assignments <- 
    kmeans_cluster %>% 
    unnest(cols = c(augmented))
  return(assignments)
}
make_clusterings <- function(kmeans_cluster) {
  clusterings <- 
    kmeans_cluster %>%
    unnest(cols = c(glanced))
  return(clusterings)
}

clust_1_9 <- run_kmeans(data = principal_components, n_clusters = 1:9)
clust_1_9_assignments <- make_assignments(clust_1_9)
clust_4 <- run_kmeans(data = principal_components, n_clusters = 4)
clust_4_assignments <- make_assignments(clust_4)
clust_1_9_clusterings <- make_clusterings(clust_1_9)


# Visualise data ----------------------------------------------------------
clust_1_9_plot <- 
  ggplot(clust_1_9_assignments, aes(x = .fittedPC1, y = .fittedPC2)) +
  geom_point(aes(color = .cluster), alpha = 0.8) + 
  facet_wrap(~ k)

clust_4_plot <- 
  ggplot(clust_4_assignments, aes(x = .fittedPC1, y = .fittedPC2)) +
  geom_point(aes(color = .cluster), alpha = 0.8) + 
  facet_wrap(~ k)

elbowplot <- 
ggplot(clust_1_9_clusterings, aes(k, tot.withinss)) +
  geom_line() +
  geom_point()

clust_1_9_plot
clust_4_plot
elbowplot


clust_4_pca_plot <- ggplot(clust_4_assignments, aes(x = .fittedPC1, y = .fittedPC2)) +
  geom_point(aes(color = .cluster), alpha = 0.8) +
  coord_equal() + 
  geom_text(data=datapc, aes(x=v1, y=v2, label=varnames), size = 4, vjust=-.1, hjust=1.2, color="black") + 
  geom_segment(data=datapc, aes(x=0, y=0, xend=v1, yend=v2), 
               arrow=arrow(length=unit(0.1,"cm")), alpha=0.75, color="black") + 
  xlab("Principal component 1") +
  ylab("Principal component 2") +
  labs(color='Cluster no.')

# Write data --------------------------------------------------------------
ggsave(file ="/cloud/project/results/elbowplot.png", plot = elbowplot)
ggsave(file ="/cloud/project/results/clust_1_to_9.png", plot = clust_1_9_plot)
ggsave(file ="/cloud/project/results/clust_4_pca.png", plot = clust_4_pca_plot)
