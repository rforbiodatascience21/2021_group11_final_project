# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Define functions --------------------------------------------------------
source(file = "/cloud/project/R/99_project_functions.R")

# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(
  file = "/cloud/project/data/03_my_data_clean_aug.tsv")

# Visualise data ----------------------------------------------------------
bacilli_Temp_barplot <- creating_bacterium_barplot(
  bacterium = "Bacilli", 
  attribute = "Temp")

bacilli_Carbo_barplot <- creating_bacterium_barplot(
  bacterium = "Bacilli", 
  attribute = "Carbo")

Gammaproteobacteria_Temp_barplot <- creating_bacterium_barplot(
  bacterium = "Gammaproteobacteria", 
  attribute = "Temp")

Gammaproteobacteria_Carbo_barplot <- creating_bacterium_barplot(
  bacterium = "Gammaproteobacteria", 
  attribute = "Carbo")

# Write data --------------------------------------------------------------
ggsave(file = "/cloud/project/results/bacilli_pH_barplot.png",
       width = 10, 
       height = 6, 
       dpi = 150,
       units = "in", 
       plot = bacilli_Temp_barplot)
ggsave(file = "/cloud/project/results/bacilli_pH_barplot.png",
       width = 10, 
       height = 6, 
       dpi = 150,
       units = "in", 
       plot = bacilli_Carbo_barplot)
ggsave(file = "/cloud/project/results/bacilli_pH_barplot.png",
       width = 10, 
       height = 6, 
       dpi = 150,
       units = "in", 
       plot = Gammaproteobacteria_Temp_barplot)
ggsave(file = "/cloud/project/results/bacilli_pH_barplot.png",
       width = 10, 
       height = 6, 
       dpi = 150,
       units = "in", 
       plot = Gammaproteobacteria_Carbo_barplot)
