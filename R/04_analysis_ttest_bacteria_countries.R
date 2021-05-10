# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("broom")  
library("purrr")
library("tidyverse")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(
  file = "/cloud/project/data/03_my_data_clean_aug.tsv")

# Wrangle data ------------------------------------------------------------
# Do unpaired two-sided t-tests for each known class
my_data_clean_aug_ttest <- my_data_clean_aug %>%
  filter(Class != "Unclassified") %>%
  mutate(site = case_when(site == "Tanzania" ~ 0,
                          site == "Vietnam" ~ 1)) %>%
  select(Class, 
         OTU_Count, 
         site) %>%
  group_by(Class) %>%
  summarise(ttest = list(t.test(OTU_Count ~ site))) %>%
  mutate(ttest = map(ttest, 
                     tidy)) %>%
  unnest(cols = c(ttest)) %>%
  select(Class, 
         estimate, 
         p.value, 
         conf.low, 
         conf.high) %>%
  mutate(identified_as = case_when(p.value < 0.05 ~ "Significant",
                                   p.value >= 0.05 ~ "Not significant"))

# Calculate negative log10 of p-value for Manhattan plot
my_data_clean_aug_ttest_Manhattan <- my_data_clean_aug_ttest %>%
  mutate(neg_log10_p = -log10(p.value))

# Export list of bacteria that are significantly more 
# in one country than in the other
significant_bacteria_countries <- my_data_clean_aug_ttest %>%
  filter(identified_as == "Significant") %>%
  select(Class,
         p.value)

# Visualise data -------------------------------------------
# Manhattan plot
Manhattan_plot <- my_data_clean_aug_ttest_Manhattan %>%
  ggplot(mapping = aes(x = fct_reorder(Class, 
                                       neg_log10_p, 
                                       .desc = TRUE), 
                       y = neg_log10_p, 
                       color = identified_as)) + 
  geom_point() + 
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 70, 
                                   hjust = 1)) + 
  labs(y = "Minus log10(p)", 
       x = "Class", 
       color = "Identified as",
       title = "Manhattan Plot") + 
  scale_color_manual(values = c("azure4", 
                                "chartreuse3")) +
  geom_hline(mapping = aes(yintercept = -log10(0.05), 
             linetype = "0.05")) +
  geom_hline(mapping = aes(yintercept = -log10(0.001), 
             linetype = "0.001"),
             colour = "azure4") +
  scale_linetype_manual(name = "Limits", 
                        values = c(2, 
                                   2), 
                        guide = guide_legend(
                          override.aes = list(color = c("azure4",
                                                        "black"))))

# Write data --------------------------------------------------------------
# Export list of significant bacteria
write_tsv(x = significant_bacteria_countries,
          file = "/cloud/project/results/significant_bacteria.tsv")

# Export Manhattan plot
ggsave(file = "/cloud/project/results/Manhattan_plot.png", 
       width = 10, 
       height = 6, 
       dpi = 150,
       units = "in",
       plot = Manhattan_plot)
