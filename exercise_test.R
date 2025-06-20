# 実習課題の検証コード
# Chapter 13: 線形モデルの展開 - 課題検証

library(brms)
library(tidyverse)
library(bayesplot)
library(multilevel)

# ============================================
# 基本問題1: ロジスティック回帰のパラメータリカバリ
# ============================================

# Step 1: 既知のパラメータでデータを生成
set.seed(123)
n <- 200
true_intercept <- 0.5
true_slope <- 1.2
x <- rnorm(n, mean = 0, sd = 1)
p <- plogis(true_intercept + true_slope * x)  # logistic function
y <- rbinom(n, size = 1, prob = p)

# データフレーム作成
df_logistic <- data.frame(x = x, y = y)

# Step 2: brmsでベイズ推定
model_logistic <- brm(
    y ~ x,
    family = bernoulli(),
    data = df_logistic,
    prior = c(
        prior(normal(0, 2.5), class = Intercept),
        prior(normal(0, 2.5), class = b)
    ),
    chains = 4,
    iter = 2000,
    cores = 4,
    refresh = 0
)

# 結果の確認
summary(model_logistic)
posterior_summary(model_logistic)

# パラメータリカバリの確認
posterior_est <- posterior_summary(model_logistic)
intercept_est <- posterior_est["b_Intercept", "Estimate"]
slope_est <- posterior_est["b_x", "Estimate"]

cat("真の切片:", true_intercept, ", 推定切片:", round(intercept_est, 3), "\n")
cat("真の傾き:", true_slope, ", 推定傾き:", round(slope_est, 3), "\n")

# 信頼区間に真の値が含まれているか確認
intercept_ci <- posterior_est["b_Intercept", c("Q2.5", "Q97.5")]
slope_ci <- posterior_est["b_x", c("Q2.5", "Q97.5")]

cat("切片の95%CI:", round(intercept_ci[1], 3), "-", round(intercept_ci[2], 3), 
    ", 真の値含まれる:", (true_intercept >= intercept_ci[1] & true_intercept <= intercept_ci[2]), "\n")
cat("傾きの95%CI:", round(slope_ci[1], 3), "-", round(slope_ci[2], 3), 
    ", 真の値含まれる:", (true_slope >= slope_ci[1] & true_slope <= slope_ci[2]), "\n")

# ============================================
# 基本問題2: ポアソン回帰のパラメータリカバリ
# ============================================

set.seed(456)
n <- 300
true_intercept_pois <- 1.0
true_slope_pois <- 0.8
x_pois <- runif(n, min = 0, max = 3)
lambda <- exp(true_intercept_pois + true_slope_pois * x_pois)
y_pois <- rpois(n, lambda = lambda)

df_poisson <- data.frame(x = x_pois, y = y_pois)

# ベイズ推定
model_poisson <- brm(
    y ~ x,
    family = poisson(),
    data = df_poisson,
    prior = c(
        prior(normal(0, 2.5), class = Intercept),
        prior(normal(0, 2.5), class = b)
    ),
    chains = 4,
    iter = 2000,
    cores = 4,
    refresh = 0
)

# 結果の確認
summary(model_poisson)
posterior_summary_pois <- posterior_summary(model_poisson)

# パラメータリカバリの確認
intercept_est_pois <- posterior_summary_pois["b_Intercept", "Estimate"]
slope_est_pois <- posterior_summary_pois["b_x", "Estimate"]

cat("ポアソン回帰 - 真の切片:", true_intercept_pois, ", 推定切片:", round(intercept_est_pois, 3), "\n")
cat("ポアソン回帰 - 真の傾き:", true_slope_pois, ", 推定傾き:", round(slope_est_pois, 3), "\n")

# ============================================
# 応用問題: 野球データの階層モデリング（サンプルデータ）
# ============================================

# サンプルデータを作成（実際のBaseballデータがない場合）
set.seed(789)
n_years <- 3
n_teams <- 12
n_positions <- 6
n_players_per_team_pos <- 3

# 階層構造を持つサンプルデータの生成
sample_data <- expand_grid(
    Year = paste0(2018:2020, "年度"),
    team = paste0("チーム", 1:n_teams),
    position = c("捕手", "一塁手", "二塁手", "三塁手", "遊撃手", "外野手")
) %>%
    slice_sample(n = 500) %>%
    mutate(
        Games = rpois(n(), lambda = 100),
        height = rnorm(n(), mean = 175, sd = 8),
        weight = rnorm(n(), mean = 75, sd = 10),
        # 階層効果を含む安打数の生成
        year_effect = case_when(
            Year == "2018年度" ~ rnorm(n(), 0, 0.1),
            Year == "2019年度" ~ rnorm(n(), 0.1, 0.1),
            TRUE ~ rnorm(n(), -0.1, 0.1)
        ),
        team_effect = rnorm(n(), 0, 0.2),
        position_effect = case_when(
            position == "捕手" ~ rnorm(n(), -0.1, 0.05),
            position == "一塁手" ~ rnorm(n(), 0.1, 0.05),
            position == "外野手" ~ rnorm(n(), 0.05, 0.05),
            TRUE ~ rnorm(n(), 0, 0.05)
        ),
        lambda_hit = exp(log(Games/100) + 2.5 + 
                        0.01 * (height - 175) + 
                        0.005 * (weight - 75) +
                        year_effect + team_effect + position_effect),
        Hit = rpois(n(), lambda = lambda_hit)
    ) %>%
    select(Year, team, position, Games, height, weight, Hit) %>%
    mutate(
        Year = as.factor(Year),
        team = as.factor(team),
        position = as.factor(position),
        height_centered = scale(height)[,1],
        weight_centered = scale(weight)[,1]
    )

# ICCの計算
icc_year <- multilevel::ICC1(aov(Hit ~ Year, data = sample_data))
icc_team <- multilevel::ICC1(aov(Hit ~ team, data = sample_data))
icc_position <- multilevel::ICC1(aov(Hit ~ position, data = sample_data))

cat("Year ICC:", round(icc_year, 3), "\n")
cat("Team ICC:", round(icc_team, 3), "\n")
cat("Position ICC:", round(icc_position, 3), "\n")

# 階層モデルの構築（簡単版）
model_hierarchical_sample <- brm(
    Hit ~ Games + height_centered + weight_centered + 
          (1 | Year) + (1 | team),
    data = sample_data,
    family = poisson(),
    chains = 2,  # 計算時間短縮のため
    iter = 1000,
    cores = 2,
    refresh = 0
)

# 結果の確認
summary(model_hierarchical_sample)

# モデル比較
model_no_hierarchy <- brm(
    Hit ~ Games + height_centered + weight_centered,
    data = sample_data,
    family = poisson(),
    chains = 2,
    iter = 1000,
    cores = 2,
    refresh = 0
)

# LOO比較
loo_hierarchical <- loo(model_hierarchical_sample)
loo_no_hierarchy <- loo(model_no_hierarchy)

cat("モデル比較結果:\n")
print(loo_compare(loo_hierarchical, loo_no_hierarchy))

# 事後予測チェック
pp_check(model_hierarchical_sample, ndraws = 50)

cat("\n===============================\n")
cat("課題検証完了！\n")
cat("===============================\n")