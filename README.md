# Multivariate-Control-Chart
Multivariate quality control refers to the statistical techniques used to monitor and control  processes involving multiple interrelated quality characteristics. These techniques are  essential in situations where variables are correlated and cannot be adequately assessed  using individual univariate tools. 

#  Multivariate Control Charts in R

This project explores **Multivariate Statistical Process Control (MSPC)** using R, highlighting techniques like **Hotelling’s T² chart** and **Multivariate EWMA (MEWMA)** to monitor processes involving correlated quality variables.

>  Course Project: Statistical Quality Control  
>  Summer 2025 |  By: Megha Chowdhury

---

##  Why This Project?

In real-world manufacturing and service processes, multiple quality characteristics often behave **together**, not in isolation.

Traditional univariate control charts (like X̄-bar charts) can **miss joint shifts** or give **false alarms**. This project shows how **multivariate charts** can:

 Detect subtle, joint shifts in multiple variables  
 Monitor both large and small changes  
 Avoid misleading interpretations

---

##  What’s Inside?

| Section | Description |
|--------|-------------|
|  `Multivariate_Control_Chart__Megha.pdf` | Full research report (theory + implementation) |
|  `Presentation_Multivariate_Control_Charts_Megha.pdf` | 15-minute beamer-style slide deck |
|  `code/` or `.R` script | All R code for simulation, analysis & visualization |

---

## 🔧 Techniques Covered

###  1. **Hotelling’s T² Control Chart**
- Monitors **mean vector** of multivariate processes.
- Sensitive to large shifts.
- Applied on the `Ryan92` dataset (Phase I and Phase II).
- Outlier detection and data cleaning demonstrated.

###  2. **MEWMA Chart**
- Detects **small or gradual shifts** better than T².
- Tracks weighted history of data.
- Includes side-by-side comparison with Hotelling’s T².

###  3. **Control Ellipses**
- Visualizes 2D control regions.
- Used to show differences between independent and correlated variables.

---

## 📦 R Packages Used

| Package | Purpose |
|--------|---------|
| `mvtnorm` | Simulate multivariate normal data |
| `qcc` | Construct T² and univariate X̄-bar charts |
| `ellipse` | Draw control region ellipses |
| `Hotelling` | Classical multivariate tests |
| `MASS` | MEWMA simulation |
| `IAcsSPCR` | Real datasets for Phase II analysis |

---

##  Datasets

- **Ryan92**: Classical example from Montgomery's SQC book.
- **Simulated Phase II data**: Created using multivariate normal distribution to illustrate control in practice.

---

##  Example Output

###  Detecting Missed Shifts

> 🔹 Univariate chart showed X2 out of control  
> 🔹 Hotelling’s T² revealed points 10 & 20 were also problematic  
> 🔹 After cleaning, only subgroup 6 was flagged → cleaner model

###  MEWMA Advantage

> 🔹 After a small mean shift, T² missed the change  
> 🔹 MEWMA detected it quickly → useful for real-time Phase II control

---

## 🗂 How to Use

To run the project:

1. Clone the repo
2. Open the `.R` script in RStudio
3. Install required packages:
```r
install.packages(c("mvtnorm", "qcc", "ellipse", "MASS", "Hotelling", "IAcsSPCR"))

4. Run the script block-by-block to generate charts and observe results.

---

## 🎯 Takeaways

This project demonstrates the power of **multivariate quality control** in:

 Identifying hidden correlations  
 Preventing false alarms  
 Detecting subtle but important process shifts

It reinforces how essential **Hotelling's T²** and **MEWMA** charts are for industries like electronics, pharmaceuticals, and manufacturing where multiple quality variables matter simultaneously.

---

##  Learn More

- 📄 **[Research Report](./Multivariate_Control_Chart__Megha.pdf)** – Detailed write-up with formulas, examples, and references.
- 🎥 **[Presentation Slides](./Presentation_Multivariate_Control_Charts_Megha.pdf)** – Compact visual summary for academic or professional sharing.

---

##  Real-World Relevance

>  Example: In electronics manufacturing, monitoring only the **line width** or **etch depth** separately may miss early signs of defect.  
> But with **multivariate control charts**, subtle shifts in multiple dimensions can be caught before costly failures.

This makes MSPC crucial for **predictive quality assurance** in modern systems.

---

##  Contact

Feel free to connect or reach out:

 [Megha Chowdhury – LinkedIn](https://linkedin.com/in/meghachowdhury)  
 Email: meghachowdhury.1176@gmail.com

Happy to discuss quality control, R programming, or statistical methods!

---


