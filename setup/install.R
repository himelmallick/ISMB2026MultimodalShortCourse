###########################################################
# ISMB 2026 Tutorial VT4                                   #
# Multimodal Integration and Multimodal Causal Inference   #
# using R/Bioconductor                                     #
#                                                          #
# Setup script: setup/install.R                            #
# Run ONCE before the hands-on session:                    #
#   Rscript setup/install.R                                #
#                                                          #
# Installs and loads every package used across the three   #
# module notebooks in notebooks/:                          #
#   01  Vertical Multimodal Integration                    #
#   02  Horizontal Integration (Meta-Analysis)             #
#   03  Multiview Mediation with Zentangler                #
#                                                          #
# Repo: himelmallick/ISMB2026MultimodalShortCourse         #
###########################################################

cat("Installing packages for ISMB 2026 Tutorial VT4 (Modules 01-03)...\n\n")

#########################
# INSTALL CRAN PACKAGES #
#########################

cran_packages <- c(
  # Tooling
  "remotes",
  "devtools",
  # Global / visualization (Modules 1-3)
  "tidyverse",
  "ggplot2",
  "cowplot",
  "bayesplot",
  "dplyr",
  "ggpubr",
  # Module 1: vertical integration
  "ROCR",
  "SuperLearner",
  "caret",
  "bartMachine",
  "bartMachineJARs",
  "glmnet",
  "multiview",
  # Module 2: horizontal integration
  "igraph",
  "huge",
  "MASS",
  "vegan",
  # Module 3: multiview mediation (HIMA2 comparator)
  "HIMA"
)

missing_cran <- cran_packages[!cran_packages %in% installed.packages()[, "Package"]]

if (length(missing_cran)) {
  install.packages(missing_cran, dependencies = TRUE)
}

#############################
# INSTALL BIOCONDUCTOR PKGS #
#############################

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

install_bioc_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing Bioconductor package: ", pkg)
    BiocManager::install(pkg, ask = FALSE, update = FALSE)
  }
}

# Module 2: horizontal integration
install_bioc_if_missing("MMUPHin")
install_bioc_if_missing("sva")
install_bioc_if_missing("SummarizedExperiment")
install_bioc_if_missing("TreeSummarizedExperiment")
install_bioc_if_missing("curatedMetagenomicData")

# Module 3: multiview mediation (MultiAssayExperiment container)
install_bioc_if_missing("MultiAssayExperiment")
install_bioc_if_missing("S4Vectors")

###########################
# INSTALL GITHUB PACKAGES #
###########################

install_github_if_missing <- function(pkg, repo) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing GitHub package: ", repo)
    remotes::install_github(repo, dependencies = TRUE, upgrade = "never")
  }
}

# Module 1: vertical integration
install_github_if_missing("IntegratedLearner", "himelmallick/IntegratedLearner")
install_github_if_missing("BayesCOOP", "himelmallick/BayesCOOP")
install_github_if_missing("jafar", "niccoloanceschi/jafar")

# Module 2: horizontal integration
install_github_if_missing("pulsar", "zdk123/pulsar")
install_github_if_missing("SpiecEasi", "zdk123/SpiecEasi")
install_github_if_missing("SPRING", "GraceYoon/SPRING")
install_github_if_missing("NetCoMi", "stefpeschel/NetCoMi")
install_github_if_missing("muffinette", "himelmallick/muffinette")

# Module 3: multiview mediation
install_github_if_missing("Zentangler", "himelmallick/Zentangler")

########################################
# OPTIONAL Java Memory for bartMachine #
########################################

options(java.parameters = "-Xmx8000m")

#############
# Load Test #
#############

all_packages <- c(
  cran_packages,
  # Bioconductor
  "MMUPHin",
  "sva",
  "SummarizedExperiment",
  "TreeSummarizedExperiment",
  "curatedMetagenomicData",
  "MultiAssayExperiment",
  "S4Vectors",
  # GitHub
  "IntegratedLearner",
  "BayesCOOP",
  "jafar",
  "pulsar",
  "SpiecEasi",
  "SPRING",
  "NetCoMi",
  "muffinette",
  "Zentangler"
)

failed <- c()

for (p in all_packages) {
  if (!suppressWarnings(require(p, character.only = TRUE))) {
    failed <- c(failed, p)
  }
}

if (length(failed)) {
  cat("\nThe following packages failed to load:\n")
  print(failed)
} else {
  cat("\nAll packages installed and loaded successfully \u2705\n")
}

cat("\nSession Info:\n")
print(sessionInfo())
