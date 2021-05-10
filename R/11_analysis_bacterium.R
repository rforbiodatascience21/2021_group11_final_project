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
Gammaproteobacteria_Temp_barplot <- creating_bacterium_barplot(
  bacterium = "Gammaproteobacteria", 
  attribute = "Temp")

Gammaproteobacteria_pH_barplot <- creating_bacterium_barplot(
  bacterium = "Gammaproteobacteria", 
  attribute = "pH")

Gammaproteobacteria_NH4_barplot <- creating_bacterium_barplot(
  bacterium = "Gammaproteobacteria", 
  attribute = "NH4")

Gammaproteobacteria_Carbo_barplot <- creating_bacterium_barplot(
  bacterium = "Gammaproteobacteria", 
  attribute = "Carbo")

# Write data --------------------------------------------------------------
ggsave(file = "/cloud/project/results/gammaproteobacteria_Temp_barplot.png",
       width = 10, 
       height = 6, 
       dpi = 150,
       units = "in", 
       plot = Gammaproteobacteria_Temp_barplot)
ggsave(file = "/cloud/project/results/gammaproteobacteria_pH_barplot.png",
       width = 10, 
       height = 6, 
       dpi = 150,
       units = "in", 
       plot = Gammaproteobacteria_pH_barplot)
ggsave(file = "/cloud/project/results/gammaproteobacteria_NH4_barplot.png",
       width = 10, 
       height = 6, 
       dpi = 150,
       units = "in", 
       plot = Gammaproteobacteria_NH4_barplot)
ggsave(file = "/cloud/project/results/gammaproteobacteria_Carbo_barplot.png",
       width = 10, 
       height = 6, 
       dpi = 150,
       units = "in", 
       plot = Gammaproteobacteria_Carbo_barplot)
