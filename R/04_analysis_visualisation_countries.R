### Visualisation of variables split on the two countries ###
# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")


# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "/cloud/project/data/03_my_data_clean_aug.tsv")

## pH - in latrine ##
# Boxplot


my_data_clean_aug %>% 
  ggplot(aes(site, pH)) +
  geom_boxplot() +
  ggtitle("pH")

# Density plot
my_data_clean_aug %>% 
  ggplot(aes(pH)) +
  facet_wrap(vars(site)) +
  geom_density() +
  ggtitle("pH")

## Temperature ##
# Boxplot
my_data_clean_aug %>% 
  ggplot(aes(site, Temp)) +
  geom_boxplot() +
  ggtitle("Temperature")

# Density plot
my_data_clean_aug %>% 
  ggplot(aes(Temp)) +
  facet_wrap(vars(site)) +
  geom_density() +
  ggtitle("Temperature")


## Prot - Information about substrate (%) ##
# Boxplot
my_data_clean_aug %>% 
  ggplot(aes(site, Prot)) +
  geom_boxplot() +
  ggtitle("Prot")

# Density plot
my_data_clean_aug %>% 
  ggplot(aes(Prot)) +
  facet_wrap(vars(site)) +
  geom_density() +
  ggtitle("Prot")



## Carbo - Information about substrate (%) ##
# Boxplot
my_data_clean_aug %>% 
  ggplot(aes(site, Carbo)) +
  geom_boxplot() +
  ggtitle("Carbo")

# Density plot
my_data_clean_aug %>% 
  ggplot(aes(Carbo)) +
  facet_wrap(vars(site)) +
  geom_density() +
  ggtitle("Carbo")



## NH4 - made by the bacteria ##
# Boxplot
my_data_clean_aug %>% 
  ggplot(aes(site, NH4)) +
  geom_boxplot() +
  ggtitle("NH4")

# Density plot
my_data_clean_aug %>% 
  ggplot(aes(NH4)) +
  facet_wrap(vars(site)) +
  geom_density() +
  ggtitle("NH4")



