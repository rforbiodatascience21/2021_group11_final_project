# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("patchwork")
library("ggdendro")
library("tidyverse")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(
  file = "/cloud/project/data/03_my_data_clean_aug.tsv")

# Wrangle data ----------------------------------------------------------
# Make wide format for matrix and 
my_data_clean_aug_wide <- my_data_clean_aug %>% 
  select(Samples, 
         Class, 
         OTU_Count) %>% 
  pivot_wider(names_from = Samples, 
              values_from = OTU_Count) 

# Convert to matrix for dendrogram
class_dendro <- my_data_clean_aug_wide %>% 
  column_to_rownames(var = "Class") %>% 
  as.matrix() %>% 
  scale() %>% 
  dist() %>% 
  hclust() %>% 
  as.dendrogram()

# Defines order from dendrogram 
dendro_order <- labels(class_dendro) 

# Reorder original data (for heatmap) corresponding to order from dendrogram
my_data_clean_aug_reordered <- my_data_clean_aug %>% 
  mutate(Class = factor(x = Class, 
                       levels = dendro_order,
                       ordered = TRUE))

# Visualise data ----------------------------------------------------------
# Dendrogram plot
dendro_plot <- class_dendro %>% 
  ggdendrogram(rotate = TRUE) + 
  theme(axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        plot.margin = margin(t = -10, 
                             r = 0.1, 
                             l = 0.1)) +
  scale_x_continuous(expand = c(0.01, 
                                0.01))

# Small heatmap for total counts per sample
total_count_heatmap <- my_data_clean_aug %>%
  mutate(Samples = as.character(Samples)) %>% 
  group_by(Samples) %>% 
  summarise(Total_Sample = sum(OTU_Count)) %>% 
  ggplot(mapping = aes(x = Samples, 
                       y = 1, 
                       fill = Total_Sample)) +
  geom_tile(color = "gray") +
  scale_fill_gradientn(colours = c("white", 
                                   "yellow", 
                                   "green"), 
                       values = c(0, 
                                  0.1, 
                                  0.4, 
                                  1), 
                       breaks = waiver(), 
                       n.breaks = 7, 
                       name = "Total") +
  theme(axis.text.x=element_blank(), 
        axis.ticks.x=element_blank(), 
        axis.text.y=element_blank(), 
        axis.ticks.y=element_blank(), 
        legend.title = element_text(size = 8),
        plot.margin = margin(t = -10),
        legend.position = "left") +
  ylab("") + 
  xlab("") +
  guides(color = FALSE)

# Heatmap for OTU counts for samples vs. Class
count_heatmap <- my_data_clean_aug_reordered %>%
  group_by(Class, 
           Samples) %>% 
  summarise(count = sum(OTU_Count)) %>% 
  ggplot(mapping = aes(x = Samples, 
                       y = Class, 
                       fill = count)) +
  geom_tile(color = "gray") +
  scale_fill_gradientn(colours = c("grey90", 
                                   "white", 
                                   "purple", 
                                   "blue"), 
                       values = c(0, 
                                  0.000001, 
                                  0.2, 
                                  1),
                       name = "OTU Count") +
  theme(axis.text.x = element_text(size = 7, 
                                   angle = 90),
        axis.text.y = element_text(size = 6),
        plot.margin = margin(t = -10),
        legend.position = "left") +
  guides(color = FALSE) 

# Line up plots nicely
# Heatmap with dendrogram
heatmap_dendro <- plot_grid(count_heatmap, 
                            dendro_plot, 
                            align = "h", 
                            axis = "tb", 
                            rel_widths = c(5, 
                                           2)) +
  plot_annotation(title = 'OTU Count of Different Bacteria Class per Sample')

# Heatmap with total bar
full_count_heatmap <- (total_count_heatmap / count_heatmap) + 
  plot_layout(heights = c(1, 
                          40), 
              guides = "collect") +
  plot_annotation(
    title = 'OTU Count of Different Bacteria Class and Total per Sample')

# Write data ----------------------------------------------------------
ggsave(file = "/cloud/project/results/heatmap_with_dendrogram.png", 
       width = 11, 
       height = 7, 
       dpi = 150,
       units = "in",
       plot = heatmap_dendro)

ggsave(file = "/cloud/project/results/heatmap_with_totalbar.png", 
       width = 9, 
       height = 5, 
       dpi = 150,
       units = "in",
       plot = full_count_heatmap)

