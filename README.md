# ISMB 2026 Multimodal Short Course

Materials for the **Multimodal Short Course** at ISMB 2026, taught in **R and Bioconductor**.

This repository contains the notebooks, slides, datasets, and setup instructions used during the tutorial. Everything is organized so participants can follow along live and revisit the material afterward.

## Course overview

This short course introduces methods for working with and integrating multiple data modalities in computational biology (for example single-cell multiomics, spatial transcriptomics, imaging, and proteomics) using the Bioconductor ecosystem. Each module pairs a short conceptual introduction with a hands-on R Markdown notebook.

> Note: the module list below is a starting scaffold. Edit the titles and topics to match your final syllabus.

## Modules

| # | Module | Notebook |
|---|--------|----------|
| 00 | Introduction and setup | `notebooks/00_introduction.Rmd` |
| 01 | Working with multimodal data | `notebooks/01_data_basics.Rmd` |
| 02 | Single-cell multiomics | `notebooks/02_single_cell_multiomics.Rmd` |
| 03 | Spatial and imaging data | `notebooks/03_spatial_imaging.Rmd` |
| 04 | Integration methods | `notebooks/04_integration_methods.Rmd` |
| 05 | Evaluation and wrap-up | `notebooks/05_evaluation.Rmd` |

## Getting started

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-org>/ISMB2026MultimodalShortCourse.git
   cd ISMB2026MultimodalShortCourse
   ```
2. Install R (>= 4.4) and the course packages, following [`setup/installation.md`](setup/installation.md):
   ```bash
   Rscript setup/install.R
   ```
3. Open `notebooks/00_introduction.Rmd` in RStudio and click **Knit**.

## Repository structure

```
ISMB2026MultimodalShortCourse/
├── notebooks/    Hands-on R Markdown notebooks, one per module
├── R/            Shared helper functions sourced by the notebooks
├── data/         Small example datasets and download scripts
├── slides/       Lecture slides (PDF or source)
├── setup/        Installation script and instructions
├── docs/         Schedule, syllabus, and supporting documentation
└── DESCRIPTION   Package-style manifest listing CRAN and Bioconductor deps
```

The `DESCRIPTION` file follows the Bioconductor workshop convention: it lists dependencies in one place and makes it straightforward to later add a Docker image, pkgdown site, or continuous integration if you want.

## Schedule

See [`docs/schedule.md`](docs/schedule.md) for the session plan and timing.

## Instructors

This course is organized by the teaching team. Add instructor names and contact details here.

Cornell University

## License

Code is released under the MIT License (see [`LICENSE`](LICENSE)). Course materials such as slides and notebook prose may be reused under CC BY 4.0 unless noted otherwise.
