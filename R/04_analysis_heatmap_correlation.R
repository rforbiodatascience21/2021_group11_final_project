# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("GGally")
library("patchwork")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "data/03_my_data_clean_aug.tsv")



# Visualise data ----------------------------------------------------------
# Bacteria in different toilets


p1 <- 
  my_data_clean_aug %>%
  group_by(Sample) %>% 
  mutate(Total_Sample = sum(OTU_Count)) %>% 
  select(Sample, Total_Sample) %>% 
  unique() %>% 
  ggplot(aes(x = Sample, y = 1, fill = Total_Sample)) +
  geom_tile() +
  scale_fill_gradientn(colours = c("white", "yellow", "green"), 
                       values = c(0, 0.1, 0.4, 1), 
                       breaks = waiver(), n.breaks = 7, name = "Total") +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(), 
        axis.text.y=element_blank(), axis.ticks.y=element_blank(), 
        legend.direction = "horizontal", legend.text = element_text(angle = 45, size = 8),
        plot.margin = margin(t = 0.1, b = 0.1)) +
  ylab("") + xlab("") 


p2 <- 
  my_data_clean_aug %>%
  group_by(Taxa, Sample) %>% 
  summarise(Taxa,
            count = sum(OTU_Count)) %>% 
  ggplot(aes(x = Sample, y = Taxa, fill = count)) +
  geom_tile() +
  scale_fill_gradientn(colours = c("grey90", "white", "purple", "blue"), values = c(0, 0.000001, 0.2, 1)) +
  theme(axis.text.x = element_text(size = 8, angle = 20),
        plot.margin = margin(t = 0.1))

(p1 / p2) + 
  plot_layout(heights = c(1, 30))

# Bacteria in different toilets
my_data_clean_aug %>%
  group_by(Taxa, Depth) %>% 
  summarise(Taxa,
            count = sum(OTU_Count)) %>% 
  ggplot(aes(x = factor(Depth), y = Taxa, fill = count)) +
  geom_tile() +
  scale_fill_gradient(low="white", high="red", limits=c(1, 10000)) +
  theme(axis.text.x = element_text(size = 8))


# Correlation, Vietnam
my_data_clean_aug %>% 
  filter(site == "Vietnam") %>% 
  select(-"Taxa", -"Samples", -"Sample", -"site", -"OTU_Count") %>% 
  ggpairs(title = "Vietnam")

# Correlation, Tanzania
my_data_clean_aug %>% 
  filter(site == "Tanzania") %>% 
  select(-"Taxa", -"Samples", -"Sample", -"site", -"OTU_Count") %>% 
  ggpairs(title = "Tanzania")

# Write data --------------------------------------------------------------
write_tsv(...)
ggsave(...)