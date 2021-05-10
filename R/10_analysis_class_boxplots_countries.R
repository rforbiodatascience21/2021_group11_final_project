# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(
  file = "/cloud/project/data/03_my_data_clean_aug.tsv")
significant_bacteria_contries <- read_tsv(
  file = "/cloud/project/results/significant_bacteria.tsv")

# Wrangle data ------------------------------------------------------------
# Pulls bacteria that are sign. different between the contries as vector
significant_bacteria <- significant_bacteria_contries %>% 
  pull(Class)

# Visualise data ------------------------------------------------------------
class_boxplots <- my_data_clean_aug %>%
  select(Samples, 
         OTU_Count, 
         Class, 
         site) %>% 
  filter(Class %in% significant_bacteria) %>% 
  ggplot(mapping = aes(x = Class, 
                       y = OTU_Count, 
                       color = site)) +
  geom_boxplot(outlier.size = 0.5,
               outlier.alpha = 0.6) + 
  theme(axis.text.x=element_text(angle = 52, 
                                 hjust = 1, 
                                 size = 8), 
        axis.text.y=element_text(size = 8)) +
  labs(y = "Proportion",
       x = "Class", 
       title = "Boxplot for OTU Counts per Bacteria Class split on Country") +
  scale_color_manual(name = "Country",
                     values = c(Tanzania = "#6496ed", 
                                Vietnam = "#b22222")) +
  ylim(0, 
       3000)

# Write data ------------------------------------------------------------
ggsave(file = "/cloud/project/results/class_boxplots.png", 
       width = 6, 
       height = 4, 
       dpi = 150,
       units = "in",
       plot = class_boxplots)

