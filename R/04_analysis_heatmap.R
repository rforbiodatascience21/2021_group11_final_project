# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("GGally")
library("patchwork")


# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")


# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")

# Visualise data ----------------------------------------------------------

# Mini heatmap for total count pr. sample
total_count_heatmap <- 
  my_data_clean_aug %>%
  mutate(Samples = as.character(Samples)) %>% 
  group_by(Samples) %>% 
  dplyr::summarise(Total_Sample = sum(OTU_Count)) %>% 
  ggplot(mapping = aes(x = Samples, y = 1, fill = Total_Sample)) +
  geom_tile() +
  scale_fill_gradientn(colours = c("white", "yellow", "green"), 
                       values = c(0, 0.1, 0.4, 1), 
                       breaks = waiver(), n.breaks = 7, name = "Total") +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(), 
        axis.text.y=element_blank(), axis.ticks.y=element_blank(), 
        legend.direction = "horizontal", legend.text = element_text(angle = 45, size = 8),
        plot.margin = margin(t = 0.1, b = 0.1)) +
  ylab("") + xlab("") 

# Heatmap for OTU counts for samples vs. Taxa
count_heatmap <- 
  my_data_clean_aug %>%
  group_by(Taxa, Samples) %>% 
  dplyr::summarise(count = sum(OTU_Count)) %>% 
  ggplot(mapping = aes(x = Samples, y = Taxa, fill = count)) +
  geom_tile() +
  scale_fill_gradientn(colours = c("grey90", "white", "purple", "blue"), values = c(0, 0.000001, 0.2, 1)) +
  theme(axis.text.x = element_text(size = 3, angle = 45),
        axis.text.y = element_text(size = 5),
        legend.key.size = unit(0.3, "cm"),
        plot.margin = margin(t = 0.1))

# Gather in one plot
full_count_heatmap <-
  (total_count_heatmap / count_heatmap) + 
  plot_layout(heights = c(1, 30)) +
  ggsave("/cloud/project/results/count_heatmap.png")
  




