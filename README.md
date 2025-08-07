

# Multivariate Control Charts in R

Multivariate quality control refers to statistical techniques for monitoring and controlling processes involving multiple interrelated quality characteristics. These methods are essential when variables are correlated and cannot be effectively assessed using traditional univariate tools.

## Project Overview

This project explores Multivariate Statistical Process Control (MSPC) using R. It focuses on techniques such as Hotelling’s T² control chart and the Multivariate EWMA (MEWMA) chart to monitor processes with correlated quality variables.

Course Project – Statistical Quality Control  
Summer 2025  
Author: Megha Chowdhury

## Why Multivariate Control Charts?

In real-world manufacturing and service environments, quality characteristics often move together — not independently.

Traditional tools like X̄-bar charts can:
- Miss joint shifts  
- Give false alarms  
- Ignore correlations

This project shows how multivariate charts can:
- Detect subtle, joint shifts in multiple variables  
- Monitor both large and small changes  
- Avoid misleading interpretations

## Project Structure

| File/Folder | Description |
|-------------|-------------|
| `Multivariate_Control_Chart__Megha.pdf` | Full research paper (theory + implementation) |
| `Presentation_Multivariate_Control_Charts_Megha.pdf` | 15-minute Beamer-style slide deck |
| `code/` or `.R` scripts | All R code for simulation, analysis, and visualization |

## Techniques Covered

### 1. Hotelling’s T² Control Chart
- Monitors the mean vector of a multivariate process
- Sensitive to large shifts
- Applied to the Ryan92 dataset (Phase I & II)
- Includes outlier detection and data cleaning

### 2. Multivariate EWMA (MEWMA) Chart
- More sensitive to small or gradual shifts
- Uses exponential smoothing over time
- Compared side-by-side with T² results

### 3. Control Ellipses
- Visualize 2D control regions
- Highlights how variable correlations affect out-of-control detection

## R Packages Used

| Package | Purpose |
|---------|---------|
| `mvtnorm` | Simulate multivariate normal data |
| `qcc` | Construct T² and X̄ control charts |
| `ellipse` | Draw control region ellipses |
| `Hotelling` | Perform multivariate hypothesis tests |
| `MASS` | Generate MEWMA-style simulations |
| `IAcsSPCR` | Access real datasets for Phase II testing |

## Datasets

- **Ryan92**: A well-known dataset from Montgomery's book, used for Phase I–II process analysis
- **Simulated Phase II Data**: Generated using multivariate normal distribution to mimic small shifts for MEWMA testing

## Example Outputs

### Detecting Hidden Shifts
- X̄ chart flagged only X2
- Hotelling’s T² detected points 10 and 20 as out-of-control
- After data cleaning, only subgroup 6 remained problematic

### MEWMA's Strength
- T² missed a small mean shift introduced after point 15
- MEWMA detected it immediately by crossing the UCL of 9.21
- Ideal for real-time Phase II monitoring

## Key Takeaways

Multivariate control charts are crucial for detecting:

* Hidden variable interactions
* Joint distribution shifts
* Early warning signals in complex systems

Hotelling’s T² is best for large shifts.
MEWMA excels at detecting small drifts over time.

Applications include electronics, pharmaceuticals, and industrial quality control.

## Learn More

* Research Report: `Multivariate_Control_Chart__Megha.pdf`
* Presentation Slides: `Presentation_Multivariate_Control_Charts_Megha.pdf`

## Real-World Relevance

Example: In semiconductor production, tracking only the line width or etch depth may seem sufficient. But multivariate control charts can detect when both slightly drift together — preventing expensive defects early.

This makes multivariate quality control essential for modern process monitoring.

## Contact

Author: Megha Chowdhury
LinkedIn: [https://linkedin.com/in/meghachowdhury](https://linkedin.com/in/meghachowdhury)
Email: [meghachowdhury.1176@gmail.com](mailto:meghachowdhury.1176@gmail.com)

Happy to connect or collaborate on quality control, R programming, or applied statistics!



