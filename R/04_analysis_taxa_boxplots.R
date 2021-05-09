# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")
significant_bacteria_data <- read_tsv(file = "/cloud/project/results/significant_bacteria.tsv")


# Wrangle data ------------------------------------------------------------
significant_bacteria <- 
  significant_bacteria_data %>% 
  pull(Taxa)


# Visualise data ------------------------------------------------------------
taxa_boxplots <- 
  my_data_clean_aug %>%
  select(Samples, 
         OTU_Count, 
         Taxa, 
         site) %>% 
  filter(Taxa %in% significant_bacteria) %>% 
  group_by(Samples) %>% 
  mutate(norm_count = OTU_Count/sum(OTU_Count)) %>% 
  ggplot(mapping = aes(x = Taxa, 
                       y = norm_count, 
                       color = site)) +
  geom_boxplot(outlier.size = 0.5,
               outlier.alpha = 0.6) + 
  #geom_jitter(mapping = aes(alpha = 0.5)) +
  theme(axis.text.x=element_text(angle = 45, 
                                 hjust = 1, 
                                 size = 6), 
        axis.text.y=element_text(size = 6)) +
  ylab("Proportion") + 
  xlab("Taxa") +
  plot_annotation(
    title = "Boxplot over OTU Counts",
    subtitle ="OTU Counts normalised per sample")



# Write data ------------------------------------------------------------
ggsave("/cloud/project/results/taxa_boxplots.png", plot = taxa_boxplots)

