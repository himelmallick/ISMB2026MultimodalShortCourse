###########################################################
# ISMB 2026 Tutorial VT4                                   #
# Multimodal Integration and Multimodal Causal Inference   #
# using R/Bioconductor                                     #
#                                                          #
#   Rscript setup/install.R                                #
#   # or, in RStudio:  source("setup/install.R")           #
#                                                          #
# Installs everything the three modules need, verifies the #
# Java runtime (Module 1 needs bartMachine), and reports   #
# anything that is missing or out of date.                 #
#                                                          #
# Re-running is cheap: a package is only (re)installed if  #
# it is missing or fails its requirement in REQUIRED below.#
# To force a full refresh:                                 #
#   ISMB2026_FORCE_REINSTALL=true Rscript setup/install.R  #
###########################################################

## Java options MUST be set before any JVM starts, or they are ignored.
options(java.parameters = c("-Xmx8000m", "--add-modules=jdk.incubator.vector"))

JAVA_REQUIRED <- 21L   # bartMachine needs JDK 21 exactly (see check_java)
FORCE_ALL <- tolower(Sys.getenv("ISMB2026_FORCE_REINSTALL", "false")) %in%
  c("1", "true", "yes")

if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")


###########################################################
# Helpers (4)                                             #
###########################################################

## Is the INSTALLED build good enough? Drives both installation and the report.
pkg_ok <- function(pkg, min_version = NULL, fn = NULL, args = NULL) {
  if (!requireNamespace(pkg, quietly = TRUE)) return(FALSE)
  if (!is.null(min_version) &&
      utils::packageVersion(pkg) < package_version(min_version)) return(FALSE)
  if (!is.null(fn)) {
    f <- tryCatch(getExportedValue(pkg, fn), error = function(e) NULL)
    if (is.null(f)) return(FALSE)
    if (!is.null(args) && !all(args %in% names(formals(f)))) return(FALSE)
  }
  TRUE
}

## CRAN, falling back to the CRAN Archive.
## Needed because 'scalreg' (orphaned since 2013) is archived, which cascades
## and archives 'hdi' too -- so plain install.packages() reports
##   ERROR: dependency 'hdi' is not available for package 'HIMA'
install_cran <- function(pkgs) {
  miss <- setdiff(pkgs, rownames(installed.packages()))
  if (length(miss)) suppressWarnings(try(install.packages(miss, dependencies = TRUE), silent = TRUE))
  for (p in setdiff(pkgs, rownames(installed.packages()))) {
    message("'", p, "' not available from CRAN -- trying the CRAN Archive ...")
    tryCatch(remotes::install_version(p, upgrade = "never"),
             error = function(e) message("  failed: ", conditionMessage(e)))
  }
}

install_bioc <- function(pkgs) {
  for (p in pkgs) {
    if (!requireNamespace(p, quietly = TRUE)) {
      BiocManager::install(p, ask = FALSE, update = FALSE)
    }
  }
}

## Install a GitHub package only if it is missing or fails its requirement.
## Falls back to the source tarball, which bypasses the GitHub API -- a stale
## PAT makes the API return HTML and remotes dies with "JSON: EXPECTED value GOT <".
## Accepts "owner/repo" and "owner/repo@ref".
install_gh <- function(pkg, repo, min_version = NULL, fn = NULL, args = NULL) {
  if (!FORCE_ALL && pkg_ok(pkg, min_version, fn, args)) {
    message("ok: ", pkg)
    return(invisible(TRUE))
  }
  message("installing ", pkg, " from ", repo, " ...")
  ok <- tryCatch({
    remotes::install_github(repo, dependencies = TRUE, upgrade = "never", force = TRUE)
    TRUE
  }, error = function(e) {
    message("  install_github failed: ", conditionMessage(e))
    FALSE
  })

  if (!ok) {
    message("  retrying via source tarball ...")
    spec <- strsplit(repo, "@", fixed = TRUE)[[1]]
    refs <- if (length(spec) > 1) spec[2] else c("master", "main")
    for (r in refs) for (kind in c("heads", "tags")) {
      u <- sprintf("https://github.com/%s/archive/refs/%s/%s.tar.gz", spec[1], kind, r)
      done <- tryCatch({ install.packages(u, repos = NULL, type = "source"); TRUE },
                       error = function(e) FALSE, warning = function(w) FALSE)
      if (done) break
    }
  }
  invisible(pkg_ok(pkg, min_version, fn, args))
}


###########################################################
# CRAN                                                    #
###########################################################

install_cran(c(
  # tooling
  "remotes", "devtools", "rJava",
  # shared / plotting
  "tidyverse", "ggplot2", "cowplot", "bayesplot", "dplyr", "ggpubr", "purrr",
  # Module 1
  "ROCR", "SuperLearner", "caret", "bartMachine", "bartMachineJARs",
  "glmnet", "multiview", "quadprog",
  # Module 2
  "igraph", "huge", "MASS", "vegan",
  # Module 3 -- HIMA's dependency chain.
  # lars -> scalreg -> hdi are archived on CRAN; install_cran() handles that.
  # NOTE: 'lars' compiles C/Fortran and can fail on macOS with
  #   fatal error: 'libintl.h' file not found
  # If so:  brew install gettext
  "lars", "scalreg", "hdi",
  "ncvreg", "HDMT", "conquer", "quantreg", "hommel",
  "nlme", "survival", "iterators", "foreach", "doParallel"
))


###########################################################
# Bioconductor                                            #
###########################################################

install_bioc(c(
  "SummarizedExperiment", "TreeSummarizedExperiment", "MultiAssayExperiment",
  "S4Vectors", "sva", "curatedMetagenomicData",
  "maaslin3",   # MMUPHin's backend
  # HIMA loads qvalue at namespace-load time but does NOT declare it, so nothing
  # installs it automatically; without it HIMA fails to build with
  #   Error in loadNamespace(...): there is no package called 'qvalue'
  "qvalue"
))


###########################################################
# GitHub -- with the requirement each install must satisfy #
#                                                         #
# Ordered: dependencies first.                            #
###########################################################

# Module 1
install_gh("IntegratedLearner", "himelmallick/IntegratedLearner",
           fn = "IntegratedLearner",
           args = c("PCL_train", "PCL_valid", "outcome_col", "run_screening"))
install_gh("BayesCOOP", "himelmallick/BayesCOOP",
           fn = "BayesCOOP",
           args = c("data_train", "bb", "bbiters", "warning", "control"))
install_gh("jafar", "niccoloanceschi/jafar")
install_gh("Coracle", "himelmallick/Coracle")

# Module 2
# MMUPHin must come from GitHub: the Bioconductor RELEASE still exports the old
# lm_meta(), while Module 2 calls the renamed maaslin_meta().
install_gh("MMUPHin", "biobakery/MMUPHin", fn = "maaslin_meta")
install_gh("pulsar", "zdk123/pulsar")
# NetCoMi Depends on SpiecEasi (>= 2.0.0), but SpiecEasi's DEFAULT branch is
# still 1.99.0 -- 2.0.0 lives only on the Bioconductor release branch. SpiecEasi
# is NOT in NetCoMi's Remotes:, so nothing resolves this for us.
install_gh("SpiecEasi", "zdk123/SpiecEasi@RELEASE_3_23", min_version = "2.0.0")
install_gh("SPRING", "GraceYoon/SPRING")
install_gh("NetCoMi", "stefpeschel/NetCoMi")
install_gh("muffinette", "himelmallick/muffinette")

# Module 3
# HIMA must come from GitHub: CRAN ships 1.0.7 (2018), which predates the
# hima()/hima2() API the module calls.
install_gh("HIMA", "YinanZheng/HIMA", min_version = "2.0.0")
install_gh("Zentangler", "himelmallick/Zentangler")


###########################################################
# Java / bartMachine check (Module 1 only)                #
#                                                         #
# bartMachine's classes are class file version 65 (JDK 21) #
# and use the INCUBATOR module jdk.incubator.vector, which #
# has no cross-release compatibility guarantee. So BOTH    #
# older and newer JDKs fail:                              #
#   Java 17  -> UnsupportedClassVersionError              #
#   Java 21  -> works                                     #
#   Java 22+ -> NoClassDefFoundError:                     #
#               jdk/incubator/vector/Vector               #
# Either way SuperLearner drops SL.BART in every fold and #
# stops with "All algorithms dropped from library".       #
# Modules 2 and 3 do not use Java.                        #
###########################################################

check_java <- function() {
  ver <- tryCatch({
    rJava::.jinit()
    rJava::.jcall("java/lang/System", "S", "getProperty", "java.version")
  }, error = function(e) NA_character_)

  if (!is.na(ver)) {
    # This is the JVM R actually loads -- it can differ from the shell's `java`.
    cat("Java runtime used by R: ", ver, "\n", sep = "")
    major <- suppressWarnings(as.integer(sub("^([0-9]+).*$", "\\1", ver)))

    if (!is.na(major) && major == JAVA_REQUIRED) {
      # A version number can look right while rJava is still bound to an old
      # libjvm, so the only real test is fitting a model.
      ok <- tryCatch({
        suppressPackageStartupMessages(library(bartMachine))
        set.seed(1)
        invisible(bartMachine::bartMachine(
          data.frame(x1 = rnorm(50), x2 = rnorm(50)), rnorm(50),
          num_trees = 5, num_burn_in = 5, num_iterations_after_burn_in = 20,
          verbose = FALSE, serialize = FALSE))
        TRUE
      }, error = function(e) {
        cat("bartMachine fit FAILED: ", conditionMessage(e), "\n", sep = "")
        FALSE
      })
      if (ok) return(TRUE)
    } else {
      cat("Java ", ver, " is unusable: bartMachine needs JDK ",
          JAVA_REQUIRED, " exactly.\n", sep = "")
    }
  } else {
    cat("Could not start a JVM.\n")
  }

  cat("\n  Fix on macOS -- JDK ", JAVA_REQUIRED, " EXACTLY:\n",
      "    brew install --cask temurin@", JAVA_REQUIRED, "\n",
      "    # in ~/.Renviron (a shell 'export' does NOT reach RStudio):\n",
      "    JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-", JAVA_REQUIRED,
      ".jdk/Contents/Home\n",
      "    sudo R CMD javareconf\n",
      "    # quit RStudio fully, reopen, then:\n",
      "    install.packages('rJava', type = 'source')   # MUST rebuild\n",
      sep = "")
  FALSE
}

cat("\n== Java / bartMachine (Module 1) ==\n")
java_ok <- check_java()


###########################################################
# Report                                                  #
#                                                         #
# REQUIRED restates what each module calls, so a stale or #
# missing package is reported here rather than failing    #
# halfway through a knit.                                 #
###########################################################

REQUIRED <- list(
  list(pkg = "IntegratedLearner", fn = "IntegratedLearner",
       args = c("PCL_train", "PCL_valid", "outcome_col", "run_screening")),
  list(pkg = "BayesCOOP", fn = "BayesCOOP",
       args = c("data_train", "bb", "bbiters", "warning", "control")),
  list(pkg = "MMUPHin", fn = "maaslin_meta"),
  list(pkg = "SpiecEasi", min_version = "2.0.0"),
  list(pkg = "HIMA", min_version = "2.0.0"),
  list(pkg = "Coracle"), list(pkg = "muffinette"), list(pkg = "Zentangler"),
  list(pkg = "jafar"), list(pkg = "NetCoMi"), list(pkg = "SPRING"),
  list(pkg = "multiview"), list(pkg = "bartMachine"), list(pkg = "qvalue"),
  list(pkg = "curatedMetagenomicData"), list(pkg = "MultiAssayExperiment")
)

bad <- Filter(function(r) {
  !pkg_ok(r$pkg, r$min_version, r$fn, r$args)
}, REQUIRED)

cat("\n== Summary ==\n")
if (length(bad) == 0) {
  cat("All packages present and matching the notebooks ✅\n")
} else {
  cat("The following are missing or out of date:\n")
  for (r in bad) {
    v <- tryCatch(as.character(utils::packageVersion(r$pkg)),
                  error = function(e) "not installed")
    cat("  - ", r$pkg, " (", v, ")\n", sep = "")
  }
  cat("\nRe-run with a forced refresh:\n")
  cat("  ISMB2026_FORCE_REINSTALL=true Rscript setup/install.R\n")
}

if (isTRUE(java_ok)) {
  cat("Java + bartMachine OK -- Module 1 will run ✅\n")
} else {
  cat("\n⚠️  Java check FAILED: Module 1 (SL.BART) will not run.\n")
  cat("   Modules 2 and 3 do not use Java and are unaffected.\n")
}
