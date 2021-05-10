# Run all scripts ---------------------------------------------------------
rm(list = ls())

# Make directory for results
dir.create("/cloud/project/results", showWarnings = FALSE)

# Source scripts
source(file = "/cloud/project/R/01_load.R")
source(file = "/cloud/project/R/02_clean.R")
source(file = "/cloud/project/R/03_augment.R")

Sys.sleep(time = 3)

source(file = "/cloud/project/R/04_analysis_violinplots.R")
source(file = "/cloud/project/R/05_analysis_heatmap.R")
source(file = "/cloud/project/R/06_analysis_pca.R")
source(file = "/cloud/project/R/07_analysis_kmeans.R")
source(file = "/cloud/project/R/08_analysis_ttest_bacteria_countries.R")
source(file = "/cloud/project/R/09_analysis_correlationplot.R")
source(file = "/cloud/project/R/10_analysis_class_boxplots_countries.R")
source(file = "/cloud/project/R/11_analysis_bacterium.R")

# Knit presentation
rmarkdown::render(input = "/cloud/project/doc/Presentation.Rmd")
