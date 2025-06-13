pacman::p_load(tidyverse, brms, bayesplot, multilevel)
dat <- read_csv("Baseball.csv") %>%
    filter(Year == "2020年度") %>%
    mutate(
        position = as.factor(position)
    ) %>%
    filter(position != "投手")

# Calculate ICC using multilevel package
# チームレベルのICC
icc_team <- multilevel::ICC1(aov(Hit ~ team, data = dat))

# ネスト構造を考慮したICC計算
# チーム内ポジションのICC
dat$team_position <- paste(dat$team, dat$position, sep = "_")
icc_team_position <- multilevel::ICC1(aov(Hit ~ team_position, data = dat))

# 参考：ポジション単独のICC
icc_position <- multilevel::ICC1(aov(Hit ~ position, data = dat))

print(paste("Team ICC1:", round(icc_team, 3)))
print(paste("Team:Position ICC1:", round(icc_team_position, 3)))
print(paste("Position ICC1:", round(icc_position, 3)))


# Poisson model for Hit count
model_hit <- brm(
    Hit ~ Games + height + weight + (1 + height + weight | team) + (1 + height + weight | team:position),
    data = dat,
    family = poisson(),
    chains = 4,
    iter = 10000,
    cores = 4
)
# Model summary for Hit model
summary(model_hit)

# Plot results for Hit model
plot(model_hit)

# Posterior predictive check for Hit model
pp_check(model_hit, ndraws = 100)


predicted_hit <- fitted(model_hit,
    newdata = dat,
    allow_new_levels = TRUE
) %>% as.data.frame()


plot_data <- data.frame(
    observed = dat$Hit,
    predicted = predicted_hit$Estimate,
    team = dat$team,
    position = dat$position
)

ggplot(plot_data, aes(x = observed, y = predicted, color = team)) +
    geom_point(alpha = 0.7, size = 2) +
    geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
    labs(
        x = "Observed Hit", y = "Predicted Hit",
        title = "Predicted vs Observed Hit Count (2020年度)",
        color = "Team"
    ) +
    facet_wrap(team ~ position, scales = "free") +
    theme_minimal() +
    theme(legend.position = "bottom")
