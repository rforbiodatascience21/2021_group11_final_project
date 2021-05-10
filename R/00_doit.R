# Run all scripts ---------------------------------------------------------
rm(list = ls())
source(file = "/cloud/project/R/01_load.R")
source(file = "/cloud/project/R/02_clean.R")
source(file = "/cloud/project/R/03_augment.R")
source(file = "/cloud/project/R/04_analysis_violinplots.R")
source(file = "/cloud/project/R/04_analysis_correlationplot.R")
source(file = "/cloud/project/R/04_analysis_heatmap.R")
source(file = "/cloud/project/R/04_analysis_pca.R")
source(file = "/cloud/project/R/04_analysis_ttest_bacteria_countries.R")
source(file = "/cloud/project/R/04_analysis_bacteirum_analysis.R")
source(file = "/cloud/project/R/04_kmeans.R")
source(file = "/cloud/project/R/04_analysis_taxa_boxplots.R")

# Knit presentation
rmarkdown::render("/cloud/project/doc/Presentation.Rmd")
