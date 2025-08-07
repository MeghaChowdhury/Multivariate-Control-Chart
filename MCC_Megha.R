#install.packages(c("mvtnorm", "ggplot2", "dplyr"))

# Load libraries
library(mvtnorm)
library(ggplot2)
library(dplyr)
library(Hotelling)
library(qcc)
library(ellipse)
library(IAcsSPCR)
library(MASS)

# --- SECTION: Simulating Control Ellipses for Independent and Dependent Variables ---

set.seed(42)

# Parameters
mu <- c(50, 100)             # Process means for x1 and x2
sigma_indep <- matrix(c(4, 0,
                        0, 9), nrow = 2)    # Independent variables (std devs 2 and 3)
sigma_dep <- matrix(c(4, 5.19,   # Correlation = 0.97 → strong dependency
                      5.19, 9), nrow = 2)

n_subgroup <- 5    # subgroup size
k <- 30            # number of subgroups

# Simulate subgroup means
simulate_subgroups <- function(Sigma, label) {
  replicate(k, {
    x <- rmvnorm(n_subgroup, mean = mu, sigma = Sigma)
    colMeans(x)
  }) %>%
    t() %>%
    as.data.frame() %>%
    setNames(c("xbar1", "xbar2")) %>%
    mutate(group = 1:k, case = label)
}

data_indep <- simulate_subgroups(sigma_indep, "Independent")
data_dep <- simulate_subgroups(sigma_dep, "Dependent")
data_all <- bind_rows(data_indep, data_dep)

# Control limit (95% confidence for df=2)
ucl <- qchisq(0.95, df = 2)

# Function to create ellipse points
get_ellipse_df <- function(center, cov_matrix, n, label) {
  e <- ellipse(cov_matrix / n, centre = center, level = 0.95)
  as.data.frame(e) %>%
    mutate(case = label)
}

# Ellipse data for both cases
ellipse_indep <- get_ellipse_df(center = mu, cov_matrix = sigma_indep, n = n_subgroup, label = "Independent")
ellipse_dep   <- get_ellipse_df(center = mu, cov_matrix = sigma_dep, n = n_subgroup, label = "Dependent")
ellipse_all <- bind_rows(ellipse_indep, ellipse_dep)

# Plot: Subgroup means + Control Ellipse
ggplot(data_all, aes(x = xbar1, y = xbar2)) +
  geom_point(alpha = 0.5, color = "blue") +
  geom_path(data = ellipse_all, aes(x = x, y = y), color = "grey", size = 1.2) +
  facet_wrap(~case) +
  theme_minimal(base_size = 12) +
  labs(
    title = "95% Ellipse Region — Independent vs. Dependent Variables",
    x = expression(bar(x)[1]), y = expression(bar(x)[2])
  )

# --- SECTION: Phase I Monitoring — Hotelling's T² and Outlier Removal (Ryan92) ---

# Load and prepare data
data(Ryan92)
X1 <- with(Ryan92, matrix(x1, ncol = 4, byrow = TRUE))
X2 <- with(Ryan92, matrix(x2, ncol = 4, byrow = TRUE))
XR <- list(X1 = X1, X2 = X2)

# 1. Univariate control charts
qcc(X1, type = "xbar", title = "X-bar Chart for X1")
qcc(X2, type = "xbar", title = "X-bar Chart for X2")

# 2. Initial T² and ellipse chart
q_t2 <- mqcc(XR, type = "T2", title = "Initial Hotelling's T²")
ellipseChart(q_t2, show.id = TRUE)

# 3. Remove subgroups 10 and 20
XR_clean <- list(
  X1 = X1[-c(10, 20), , drop = FALSE],
  X2 = X2[-c(10, 20), , drop = FALSE]
)

# 4. Re-evaluate T² after cleaning
q_t2_clean <- mqcc(XR_clean, type = "T2",
                   title = "Cleaned Hotelling's T²")
ellipseChart(q_t2_clean, show.id = TRUE)

# --- SECTION: Phase II Monitoring — Hotelling's T² Chart on New Incoming Subgroups ---

# Phase II: Simulate new incoming subgroups
set.seed(321)
Xnew <- lapply(1:20, function(i) {
  mvrnorm(n = 4, mu = c(60, 18), Sigma = matrix(c(100, 30, 30, 25), nrow = 2))
})
Xnew_mat <- do.call(rbind, Xnew)
Xnew_df <- data.frame(
  x1 = Xnew_mat[, 1],
  x2 = Xnew_mat[, 2],
  subgroup = rep(1:20, each = 4)
)

# Format as list of matrices (one per variable)
X1_new <- matrix(Xnew_df$x1, nrow = 20, byrow = TRUE)
X2_new <- matrix(Xnew_df$x2, nrow = 20, byrow = TRUE)
Xn <- list(X1 = X1_new, X2 = X2_new)

# Phase II T² Chart
q_phaseII <- mqcc(
  data = XR_clean,        # Phase I in-control data
  type = "T2",
  newdata = Xn,           # Phase II observations
  limits = FALSE,         # Don’t use default Phase I limits
  pred.limits = TRUE,     # Use Phase II prediction limits 
  center = q_t2_clean$center,
  cov = q_t2_clean$cov,
  title = "T² Control Chart for Phase II Monitoring"
)

# --- SECTION: Comparing MEWMA and Hotelling's T² Charts for Detecting Small Mean Shifts ---

set.seed(123)
n_total <- 30
n_cal <- 15
mu_in <- c(0, 0)
mu_out <- c(1, 1)
Sigma <- matrix(c(1, 0.6, 0.6, 1), 2)

X_cal <- mvrnorm(n_cal, mu_in, Sigma)
X_new <- mvrnorm(n_total - n_cal, mu_out, Sigma)
X_all <- rbind(X_cal, X_new)

# Step 2: Compute MEWMA Z_i values
lambda <- 0.2
p <- ncol(X_all)
Z <- matrix(0, n_total, p)
Z[1, ] <- lambda * X_all[1, ]
for (i in 2:n_total) {
  Z[i, ] <- lambda * X_all[i, ] + (1 - lambda) * Z[i - 1, ]
}

# Step 3: Compute MEWMA T² statistics
S <- cov(X_cal)
h <- lambda / (2 - lambda) * (1 - (1 - lambda)^(2 * (1:n_total)))
T2 <- numeric(n_total)
for (i in 1:n_total) {
  T2[i] <- t(Z[i, ]) %*% solve(S * h[i]) %*% Z[i, ]
}

# Step 4: Control limit
alpha <- 0.01
UCL <- qchisq(1 - alpha, df = p)

# Step 5: Improved plot
par(mar = c(5, 5, 4, 2))  # Increase margins
plot(T2, type = "o", pch = 19, lwd = 2, col = ifelse(1:n_total <= n_cal, "grey", "black"),
     ylim = c(0, max(T2, UCL) + 1), xaxt = "n",
     xlab = "Observation Index", ylab = expression(T[i]^2),
     main = expression("MEWMA Control Chart for Phase II Monitoring"),
     cex.lab = 1.3, cex.axis = 1.1, cex.main = 1.4)

axis(1, at = 1:n_total)

# Add control limit
abline(h = UCL, col = "red", lty = 2, lwd = 2)
text(x = n_total, y = UCL + 0.5, labels = "UCL", col = "red", pos = 2, cex = 1)

# Phase boundary
abline(v = n_cal + 0.5, lty = 3)
mtext("Phase I", side = 3, line = 0.5, at = n_cal / 2, cex = 1.1)
mtext("Phase II", side = 3, line = 0.5, at = n_cal + (n_total - n_cal) / 2, cex = 1.1)

# Add summary box
legend("topleft",
       legend = c(
         paste("Groups:", n_total),
         paste("Calibration:", n_cal),
         bquote("|S| =" ~ .(round(det(S), 3))),
         bquote(UCL == .(round(UCL, 2)))
       ),
       bty = "n", cex = 1)

# --- Hotelling's T² Chart (Phase II Monitoring) ---

# Step 1: Compute Hotelling T² stats using X_all vs. Phase I mean/cov
mu0 <- colMeans(X_cal)
T2_hotelling <- apply(X_all, 1, function(x) {
  t(x - mu0) %*% solve(S) %*% (x - mu0)
})

# Step 2: Control limit for individual Hotelling chart
UCL_hotelling <- qchisq(1 - alpha, df = p)

# Step 3: Plot Hotelling chart
par(mar = c(5, 5, 4, 2))
plot(T2_hotelling, type = "o", pch = 19, lwd = 2,
     col = ifelse(1:n_total <= n_cal, "grey", "black"),
     ylim = c(0, max(T2_hotelling, UCL_hotelling) + 1), xaxt = "n",
     xlab = "Observation Index", ylab = expression(T[i]^2),
     main = expression("Hotelling's " * T^2 * " Chart for Phase II Monitoring"),
     cex.lab = 1.3, cex.axis = 1.1, cex.main = 1.4)

axis(1, at = 1:n_total)

# Add UCL
abline(h = UCL_hotelling, col = "red", lty = 2, lwd = 2)
text(x = n_total, y = UCL_hotelling + 0.5, labels = "UCL", col = "red", pos = 2, cex = 1)

# Add Phase boundary
abline(v = n_cal + 0.5, lty = 3)
mtext("Phase I", side = 3, line = 0.5, at = n_cal / 2, cex = 1.1)
mtext("Phase II", side = 3, line = 0.5, at = n_cal + (n_total - n_cal) / 2, cex = 1.1)

# Add summary box
legend("topleft",
       legend = c(
         paste("Groups:", n_total),
         paste("Calibration:", n_cal),
         bquote("|S| =" ~ .(round(det(S), 3))),
         bquote(UCL == .(round(UCL_hotelling, 2)))
       ),
       bty = "n", cex = 1)
