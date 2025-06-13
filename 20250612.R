rm(list = ls())
pacman::p_load(tidyverse, cmdstanr, brms, patchwork, lmerTest)
# データ生成
set.seed(17)
n_person <- 10 # 個人数
n_obs <- 20 # 各個人の観測数
beta_0 <- 1
beta_1 <- 2
sigma_u <- 1 # 個人差の標準偏差
sigma_e <- 0.5 # 誤差の標準偏差

# 個人ごとのランダム切片
person_intercepts <- rnorm(n_person, mean = 0, sd = sigma_u)

# データフレーム作成
df_random_intercept <- expand_grid(
    person = 1:n_person,
    obs = 1:n_obs
) %>%
    mutate(
        x = runif(n(), min = 0, max = 10),
        u_0 = person_intercepts[person],
        y = beta_0 + u_0 + beta_1 * x + rnorm(n(), mean = 0, sd = sigma_e),
        person_factor = factor(person)
    )

## データの確認
df_random_intercept %>% head()

# p1: 線形回帰（全体で一つの回帰線）
p1 <- ggplot(df_random_intercept, aes(x = x, y = y)) +
    geom_point(alpha = 0.5, size = 1) +
    geom_smooth(method = "lm", se = FALSE, color = "blue", linewidth = 1.2) +
    theme_minimal() +
    labs(x = "説明変数", y = "目的変数", title = "線形回帰（固定効果のみ）") +
    theme(text = element_text(family = "IPAexGothic"))

# p2: ランダム切片モデル（個人ごとに異なる切片の回帰線）
p2 <- ggplot(df_random_intercept, aes(x = x, y = y, color = person_factor)) +
    geom_point(alpha = 0.6, size = 1) +
    geom_smooth(method = "lm", se = FALSE, linewidth = 0.8) +
    theme_minimal() +
    labs(x = "説明変数", y = "目的変数", title = "ランダム切片モデル") +
    theme(
        text = element_text(family = "IPAexGothic"),
        legend.position = "none"
    )

p1 + p2

result.bayes.random_intercept <- brm(
    y ~ x + (1 | person),
    family = gaussian(),
    data = df_random_intercept,
    seed = 12345,
    chains = 4, cores = 4, backend = "cmdstanr",
    iter = 2000, warmup = 1000,
    refresh = 0
)
summary(result.bayes.random_intercept)
plot(result.bayes.random_intercept)

## 比較のためにML推定も行っておく

result.ml.random_intercept <- lmer(y ~ x + (1 | person), data = df_random_intercept)
summary(result.ml.random_intercept)

## さらに比較のために，普通の回帰分析も行ってみる
result.ml.random_intercept.ordinal <- lm(y ~ x, data = df_random_intercept)
summary(result.ml.random_intercept)

## 推定値
bayes_estimates <- fixef(result.bayes.random_intercept)
bayes_sigma_u <- VarCorr(result.bayes.random_intercept)$person$sd[1]
bayes_variances <- VarCorr(result.bayes.random_intercept)
bayes_sigma_u <- sqrt(bayes_variances$person$sd[1,1]^2)  # 個人間分散の標準偏差
bayes_sigma_e <- bayes_variances$residual__$sd[1,1]
# ML推定値を抽出
ml_estimates <- fixef(result.ml.random_intercept)
ml_sigma_u <- as.data.frame(VarCorr(result.ml.random_intercept))$sdcor[1]
ml_sigma_e <- sigma(result.ml.random_intercept)
# 普通の回帰分析の推定値を抽出
lm_estimates <- coef(result.ml.random_intercept.ordinal)

