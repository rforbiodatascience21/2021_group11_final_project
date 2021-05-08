### T-test and plots ###
# Differences between OTU-count of each bacteria in the two countries # 
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")  
library("purrr")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")


# Wrangle data ------------------------------------------------------------
# Do unpaired two-sided t-tests for each known taxa
my_data_clean_aug_ttest <- my_data_clean_aug %>%
filter(Taxa != "Unclassified") %>%
  mutate(site = case_when(site == "Tanzania" ~ 0,
                          site == "Vietnam" ~ 1)) %>%
  select(Taxa, OTU_Count, site) %>%
  group_by(Taxa) %>%
  summarise(ttest = list(t.test(OTU_Count ~ site))) %>%
  mutate(ttest = map(ttest, tidy)) %>%
  unnest(cols = c(ttest)) %>%
  select(Taxa, estimate, p.value, conf.low,conf.high) %>%
  mutate(identified_as = case_when(p.value < 0.05 ~ "Significant",
                                   p.value >= 0.05 ~ "Not significant"))


# Calculate negative log10 of p-value for Manhattan plot
my_data_clean_aug_ttest_Manhattan <- my_data_clean_aug_ttest %>%
  mutate(neg_log10_p = -log10(p.value))


# Export list of bacteria that are significantly more in one country than in the other
significant_bacteria_countries <- my_data_clean_aug_ttest %>%
  filter(identified_as == "significant") %>%
  select(Taxa)


# Visualise data -------------------------------------------
# Manhattan plot
Manhattan_plot <- my_data_clean_aug_ttest_Manhattan %>%
  ggplot(mapping = aes(x = fct_reorder(Taxa, neg_log10_p, .desc = TRUE), y = neg_log10_p, color = identified_as)) + 
  geom_point() + 
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 65, hjust = 1)) + 
  labs(y = "Minus log10(p)", x = "Taxa", color = "Identified as") + 
  scale_color_manual(values = c("azure4", "chartreuse3")) +
  geom_hline(yintercept = -log10(0.05), linetype = "longdash") 


# Error bar plot
Error_bar_plot <- my_data_clean_aug_ttest %>% 
  ggplot(mapping = aes(x = estimate, y = fct_reorder(Taxa,estimate, .desc = TRUE), color = identified_as)) + 
  geom_point() + 
  geom_errorbar(width = .1, aes(xmin = conf.low, xmax = conf.high)) + 
  theme(legend.position = "bottom") + 
  geom_vline(xintercept = 0, linetype = "longdash") +
  labs(x = "Estimate", y = "", color = "Identified as") +
  scale_color_manual(values = c("azure4", "chartreuse3"))


# Zoom in on error bar plot
Error_bar_plot_zoom <- my_data_clean_aug_ttest %>% 
  ggplot(mapping = aes(x = estimate, y = fct_reorder(Taxa,estimate, .desc = TRUE), color = identified_as)) + 
  geom_point() + 
  geom_errorbar(width = .1, aes(xmin = conf.low, xmax = conf.high)) + 
  theme(legend.position = "bottom") + 
  geom_vline(xintercept = 0, linetype = "longdash") +
  labs(x = "Estimate", y = "", color = "Identified as") +
  scale_color_manual(values = c("azure4", "chartreuse3")) +
  xlim(-75,5)


# Write data --------------------------------------------------------------
# Export list of significant bacteria
write_tsv(x = significant_bacteria_countries,
          file = "/cloud/project/results/significant_bacteria.tsv")

# Export Manhattan plot
ggsave(file = "/cloud/project/results/Manhattan_plot.png", 
       plot = Manhattan_plot)

# Export error bar plots
ggsave(file = "/cloud/project/results/Error_bar_plot.png", 
       plot = Error_bar_plot)
ggsave(file = "/cloud/project/results/Error_bar_plot_zoom.png",
       plot = Error_bar_plot_zoom)


