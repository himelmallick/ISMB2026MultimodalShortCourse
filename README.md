# ISMB 2026 Tutorial VT4

Materials for **ISMB 2026 Tutorial VT4: Multimodal Integration and Multimodal Causal Inference using R/Bioconductor** (July 06, 2026), taught in **R/Bioconductor**.

This repository contains the notebooks, datasets, and setup script used during the tutorial. Everything is organized so participants can follow along live and revisit the material afterward.

## Course overview

This short course covers methods for integrating multiple biological data modalities and for reasoning about causal questions across them, using the Bioconductor ecosystem. The day is delivered as three hands-on modules, each pairing a short conceptual introduction with a hands-on R Markdown notebook.

## Modules

| # | Module | Notebook |
|---|--------|----------|
| 1 | Vertical Multi-omics Integration | `notebooks/01_vertical_integration.Rmd` |
| 2 | Horizontal Integration (Meta-Analysis) | `notebooks/02_horizontal_integration.Rmd` |
| 3 | Multiview Mediation with Zentangler | `notebooks/03_multiview_mediation.Rmd` |


## Requirements

- **R** >= 4.4
- **JDK 21** — needed only by Module 1 (`bartMachine`), which requires version 21 exactly. Modules 2 and 3 do not use Java.

`setup/install.R` checks this for you and prints step-by-step instructions if your Java needs changing.

## Materials

- **Rendered notebooks (HTML)** — browsable in this repository; nothing to install.
- **Notebook sources (`.Rmd`) and lecture slides (PDF)** — distributed to registered participants via a shared Dropbox folder.

## Running the notebooks yourself

1. Install the course packages and run the environment check (once):
   ```bash
   Rscript setup/install.R
   ```
2. Open a module `.Rmd` in RStudio and click **Knit** to produce an HTML report.

The notebooks download their data at knit time, so they run from whichever folder you keep them in; you do not need to clone this repository or arrange files in any particular layout. An internet connection is required.

## Repository structure

```
ISMB2026MultimodalShortCourse/
├── notebooks/    R Markdown sources and rendered HTML, one per module
├── data/         Datasets served to the notebooks over HTTPS
└── setup/        Installation script (install.R)
```

Modules 1 and 3 read the `.RData` files in `data/` directly from this repository over HTTPS; Module 2 pulls its cohorts from `curatedMetagenomicData`. 

## Instructors

- **Organizer:** Himel Mallick, Cornell University
- **Speakers:** Himel Mallick (Cornell University), Saptarshi Roy (Texas A&M University), Sreya Sarkar (University of Iowa)

## License

Code is released under the MIT License (see [`LICENSE`](LICENSE)). Course materials such as notebook prose may be reused under CC BY 4.0 unless noted otherwise.
