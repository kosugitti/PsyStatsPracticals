rm(list = ls())
library(tidyverse)
pacman::p_load(brms, patchwork)

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
pacman::p_load(lmerTest)
result.ml.random_intercept <- lmer(y ~ x + (1 | person), data = df_random_intercept)
summary(result.ml.random_intercept)

## さらに比較のために，普通の回帰分析も行ってみる
result.ml.random_intercept.ordinal <- lm(y ~ x, data = df_random_intercept)
summary(result.ml.random_intercept.ordinal)
bayes_estimates <- fixef(result.bayes.random_intercept)
bayes_sigma_u <- VarCorr(result.bayes.random_intercept)$person$sd[1]
bayes_variances <- # 個人ごとの変量効果を取得
  random_effects <- ranef(result.bayes.random_intercept)


# 確認 ----------------------------------------------------------------------

# 個人ごとの変量効果を取得して表示してみる
random_effects <- brms::ranef(result.bayes.random_intercept)
print(random_effects)
# 個人1-3の切片の変量効果の事後分布(MCMCサンプル)を取得
posterior_samples <- as_draws_df(result.bayes.random_intercept) %>%
  select(starts_with("r_person")) %>%
  rowid_to_column("iter") %>%
  pivot_longer(-iter) %>%
  mutate(person = str_extract(name, pattern = "\\d+")) %>%
  mutate(person = factor(person, levels = as.character(1:10))) %>%
  select(-name)
# MCMCサンプルを使った要約
posterior_samples %>%
  group_by(person) %>%
  summarise(
    q025 = quantile(value, 0.025),
    EAP = mean(value),
    median = quantile(value, 0.5),
    q975 = quantile(value, 0.975),
    sd = sd(value),
    .groups = "drop"
  )

# 事後分布の描画
p1 <- ggplot(posterior_samples, aes(x = value, fill = person)) +
  geom_density(alpha = 0.7) +
  facet_wrap(~person, scales = "free_y") +
  theme_minimal() +
  labs(x = "切片の変量効果", y = "事後密度", title = "個人ごとの切片変量効果の事後分布") +
  theme(text = element_text(family = "IPAexGothic"), legend.position = "none")

print(p1)


# 各個人の実際の切片（固定効果+変量効果）を取得
individual_coefs <- coef(result.bayes.random_intercept)$person

# 実際の切片の事後分布（固定効果+変量効果）
total_intercept_samples <- as_draws_df(result.bayes.random_intercept) %>%
  select(b_Intercept, starts_with("r_person")) %>%
  rowid_to_column("iter") %>%
  pivot_longer(-c(iter, b_Intercept)) %>%
  mutate(person = str_extract(name, pattern = "\\d+")) %>%
  mutate(person = factor(person, levels = as.character(1:10))) %>%
  mutate(total_intercept = b_Intercept + value) %>%
  select(iter, person, total_intercept)

# 実際の切片の事後分布の描画
p2 <- ggplot(total_intercept_samples, aes(x = total_intercept, fill = person)) +
  geom_density(alpha = 0.7) +
  facet_wrap(~person, scales = "free_y") +
  theme_minimal() +
  labs(
    x = "実際の切片（固定効果+変量効果）", y = "事後密度",
    title = "個人ごとの実際の切片の事後分布"
  ) +
  theme(text = element_text(family = "IPAexGothic"), legend.position = "none")

print(p2)

# 実際の切片の信頼区間
total_intercept_summary <- total_intercept_samples %>%
  group_by(person) %>%
  summarise(
    q025 = quantile(total_intercept, 0.025),
    EAP = mean(total_intercept),
    median = quantile(total_intercept, 0.5),
    q975 = quantile(total_intercept, 0.975),
    sd = sd(total_intercept),
    .groups = "drop"
  )

print(total_intercept_summary)
