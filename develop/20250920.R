rm(list=ls())
pacman::p_load(tidyverse,cmdstanr)

y <- read_csv("Baseball.csv") |> 
  filter(Year == "2020年度") |> 
  filter(team %in% c("Giants","Tigers","Carp","Swallows","DeNA","Dragons")) |> 
  select(position, Hit, team) |>
  mutate(Hit = ifelse(is.na(Hit),0,Hit))
y |>  ggplot(aes(x=Hit)) + geom_histogram()
summary(y$Hit)

model <- cmdstan_model("zero_inflated_negbinom.stan")

dataSet <- list(
  N = length(y$Hit),
  y = y$Hit
)

fit <- model$sample(
  data = dataSet,
  parallel_chains = 4
)

bayestestR::describe_posterior(fit$draws(c("theta","mu","phi")),
  centrality = c("mean", "median", "MAP"), ci = 0.95,
  ci_method = "hdi", test = NULL)


# 事後予測チェック用のパッケージを読み込み
pacman::p_load(bayesplot)

# fitから事後予測分布を抽出
y_pred <- fit$draws("y_pred", format = "matrix")

# 観測データ
y_obs <- y$Hit

# 事後予測チェック
# 1. ヒストグラムの比較
ppc_hist(y_obs, y_pred[1:50, ])

# 2. 密度分布の比較
ppc_dens_overlay(y_obs, y_pred[1:50, ])

# 3. 統計量の比較（平均）
ppc_stat(y_obs, y_pred, stat = "mean")

# 4. 統計量の比較（分散）
ppc_stat(y_obs, y_pred, stat = "var")

# 5. 0の個数の比較
ppc_stat(y_obs, y_pred, stat = function(x) sum(x == 0))

# 6. 散布図（観測値 vs 予測値の分位点）
ppc_scatter_avg(y_obs, y_pred)
