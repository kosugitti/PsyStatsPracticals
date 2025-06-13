rm(list = ls())
pacman::p_load(tidyverse, brms, lme4, bayesplot)
dat <- read_csv("Baseball.csv")

# Convert string variables to Factor type
dat <- dat %>%
    mutate(
        Year = as.factor(Year),
        Name = as.factor(Name),
        team = as.factor(team),
        bloodType = as.factor(bloodType),
        position = as.factor(position)
    )

# Data exploration and ICC calculation
# Check missing values
cat("Missing values in salary:", sum(is.na(dat$salary)), "\n")
cat("Missing values in Games:", sum(is.na(dat$Games)), "\n")

# Remove missing values for analysis
dat_clean <- dat %>%
    filter(!is.na(salary) & !is.na(Games) & salary > 0)

cat("Sample size after removing missing values:", nrow(dat_clean), "\n")

# Check ICC for nested structure

# Null model for ICC calculation
null_model <- lmer(log(salary) ~ 1 + (1 | Year) + (1 | team) + (1 | position),
    data = dat_clean
)

# Manual ICC calculation
variance_components <- VarCorr(null_model)
var_year <- as.numeric(variance_components$Year)
var_team <- as.numeric(variance_components$team)
var_position <- as.numeric(variance_components$position)
var_residual <- sigma(null_model)^2

total_variance <- var_year + var_team + var_position + var_residual

icc_year <- var_year / total_variance
icc_team <- var_team / total_variance
icc_position <- var_position / total_variance

cat("ICC for Year:", round(icc_year, 3), "\n")
cat("ICC for Team:", round(icc_team, 3), "\n")
cat("ICC for Position:", round(icc_position, 3), "\n")
cat("Total ICC:", round((var_year + var_team + var_position) / total_variance, 3), "\n")

# Check if nesting is appropriate
dat_clean %>%
    group_by(Year, team, position) %>%
    summarise(n = n(), .groups = "drop") %>%
    arrange(desc(n)) %>%
    head(10)

# Hierarchical linear model with log-normal distribution
# Using crossed random effects instead of strict nesting
model <- brm(
    log(salary) ~ Games + (1 | Year) + (1 | team) + (1 | position),
    data = dat_clean,
    family = gaussian(),
    prior = c(
        prior(normal(8, 2), class = Intercept), # log(salary) around 8-12
        prior(normal(0, 0.01), class = b), # small effect of Games
        prior(exponential(1), class = sd)
    ),
    chains = 4,
    iter = 2000,
    cores = 4
)

# Model summary
summary(model)

# Plot results

# Trace plots
plot(model)

# Posterior distributions of parameters
posterior_samples <- posterior_samples(model)
mcmc_areas(posterior_samples, pars = c("b_Intercept", "b_Games"))

# Random effects plots
plot(model, ask = FALSE)

# Posterior predictive checks
pp_check(model, ndraws = 100)

# Predicted vs observed values
predicted_values <- fitted(model)
observed_values <- log(dat_clean$salary)

ggplot(data.frame(
    observed = observed_values,
    predicted = predicted_values[, 1]
)) +
    geom_point(aes(x = observed, y = predicted), alpha = 0.6) +
    geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
    labs(
        x = "Observed log(salary)", y = "Predicted log(salary)",
        title = "Predicted vs Observed Values"
    ) +
    theme_minimal()

# Model diagnostics
plot(model, type = "trace")
plot(model, type = "rank_overlay")

# Alternative model: Hit count (for non-pitchers) with Poisson distribution
# Filter non-pitchers and add height/weight predictors
dat_hitters <- dat %>%
    filter(position != "投手" & !is.na(Hit) & !is.na(height) & !is.na(weight)) %>%
    mutate(
        height_c = scale(height)[, 1], # centered height
        weight_c = scale(weight)[, 1] # centered weight
    )

cat("Sample size for Hit model (non-pitchers):", nrow(dat_hitters), "\n")

# Check Hit distribution
hist(dat_hitters$Hit, main = "Distribution of Hit", xlab = "Hit count")

# Poisson model for Hit count
model_hit <- brm(
    Hit ~ Games + height_c + weight_c + (1 | Year) + (1 | team) + (1 | position),
    data = dat_hitters,
    family = poisson(),
    prior = c(
        prior(normal(3, 1), class = Intercept), # log(Hit) around 3-5
        prior(normal(0, 0.5), class = b), # moderate effects
        prior(exponential(1), class = sd)
    ),
    chains = 4,
    iter = 2000,
    cores = 4
)

# Model summary for Hit model
summary(model_hit)

# Posterior predictive check for Hit model
pp_check(model_hit, ndraws = 100)

# Plot results for Hit model
plot(model_hit)

# Predicted vs observed for Hit (2020年度のみ、チーム・ポジション別)
dat_hitters_2020 <- dat_hitters %>%
  filter(Year == "2020年度")

predicted_hit_2020 <- fitted(model_hit, newdata = dat_hitters_2020, 
                            allow_new_levels = TRUE)
observed_hit_2020 <- dat_hitters_2020$Hit

plot_data <- data.frame(
  observed = observed_hit_2020,
  predicted = predicted_hit_2020[, 1],
  team = dat_hitters_2020$team,
  position = dat_hitters_2020$position
)

# チーム別色分け
ggplot(plot_data, aes(x = observed, y = predicted, color = team)) +
  geom_point(alpha = 0.7, size = 2) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(x = "Observed Hit", y = "Predicted Hit",
       title = "Predicted vs Observed Hit Count (2020年度)",
       color = "Team") +
  theme_minimal() +
  theme(legend.position = "bottom")

# ポジション別facet
ggplot(plot_data, aes(x = observed, y = predicted, color = team)) +
  geom_point(alpha = 0.7, size = 2) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  facet_wrap(~position, scales = "free") +
  labs(x = "Observed Hit", y = "Predicted Hit",
       title = "Predicted vs Observed Hit Count by Position (2020年度)",
       color = "Team") +
  theme_minimal() +
  theme(legend.position = "bottom")
