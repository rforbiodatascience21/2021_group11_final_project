# Run all scripts ---------------------------------------------------------
rm(list = ls())
source(file = "/cloud/project/R/01_load.R")
source(file = "/cloud/project/R/02_clean.R")
source(file = "/cloud/project/R/03_augment.R")
source(file = "/cloud/project/R/04_analysis_sampledistributions.R")
source(file = "/cloud/project/R/04_analysis_visualisation_countries.R")

rmarkdown::render("/cloud/project/doc/Presentation.Rmd")
