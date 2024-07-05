#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| message: FALSE
library(tidyverse)
library(broom) # 分析結果をtidyに整形するパッケージ。ない場合はinstallしておこう
```
#
alpha <- 0.05 # 有意水準を0.05に設定
n1 <- n2 <- n3 <- 10 # 各グループのサンプルサイズを10に設定
mu <- 10 # 平均値を10に設定
sigma <- 2 # 標準偏差を2に設定

mu1 <- mu2 <- mu3 <- mu # 各グループの平均値を同じに設定

set.seed(12345) # 乱数のシードを設定して再現性を確保
iter <- 1000 # シミュレーションの繰り返し回数を1000に設定

anova.detect <- rep(NA, iter) # ANOVA検出結果の保存用ベクトルを初期化
ttest.detect <- rep(NA, iter) # t検定検出結果の保存用ベクトルを初期化

for (i in 1:iter) { # 1000回のシミュレーションを繰り返すループ
  X1 <- rnorm(n1, mu1, sigma) # グループ1のデータを生成
  X2 <- rnorm(n2, mu2, sigma) # グループ2のデータを生成
  X3 <- rnorm(n3, mu3, sigma) # グループ3のデータを生成

  dat <- data.frame( # データフレームを作成
    group = c(rep(1, n1), rep(2, n2), rep(3, n3)), # グループ番号を追加
    value = c(X1, X2, X3) # データを追加
  )
  result.anova <- aov(value ~ group, data = dat) %>% tidy() # ANOVAを実行し結果を整形
  anova.detect[i] <- ifelse(result.anova$p.value[1] < alpha, 1, 0) # 有意差があるかを判定して保存

  # t検定を繰り返す
  ttest12 <- t.test(X1, X2)$p.value # グループ1と2のt検定
  ttest13 <- t.test(X1, X3)$p.value # グループ1と3のt検定
  ttest23 <- t.test(X2, X3)$p.value # グループ2と3のt検定

  ttest.detect[i] <- ifelse(ttest12 < alpha | ttest13 < alpha | ttest23 < alpha, 1, 0) # いずれかのt検定で有意差があれば保存
}

ttest.detect %>% mean() # t検定で有意差が検出された割合を計算
anova.detect %>% mean() # ANOVAで有意差が検出された割合を計算
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# シミュレーション用の関数を定義
studyMake <- function(n, mu, sigma, delta) {
  X1 <- rnorm(n, mu, sigma) # グループ1のデータを生成
  X2 <- rnorm(n, mu + sigma * delta, sigma) # グループ2のデータを生成（平均値が異なる）
  dat <- data.frame( # データフレームを作成
    group = rep(1:2, each = n), # グループ番号を追加
    value = c(X1, X2) # データを追加
  )
  result <- t.test(X1, X2)$p.value # グループ間のt検定を実行
  return(result) # p値を返す
}
#
#
#
#
# 使用例；t検定の結果のp値が戻ってくる
studyMake(n = 10, mu = 10, sigma = 1, delta = 0)
#
#
#
#
#
set.seed(12345) # 乱数のシードを設定して再現性を確保
iter <- 1000 # シミュレーションの繰り返し回数を1000に設定
alpha <- 0.05 # 有意水準を0.05に設定
num_studies <- 3 # 研究の数を3に設定
alpha_adjust <- alpha / num_studies # 多重検定補正後の有意水準を計算

FLG.detect <- rep(NA, iter) # 検出結果を保存するベクトルを初期化
FLG.detect.adj <- rep(NA, iter) # 補正後の検出結果を保存するベクトルを初期化
for (i in 1:iter) { # 1000回のシミュレーションを繰り返すループ
  p_values <- replicate(num_studies, studyMake(n = 10, mu = 10, sigma = 1, delta = 0)) # 各研究のp値を生成
  FLG.detect[i] <- ifelse(any(p_values < alpha), 1, 0) # 補正前の有意差検出を判定して保存
  FLG.detect.adj[i] <- ifelse(any(p_values < alpha_adjust), 1, 0) # 補正後の有意差検出を判定して保存
}

FLG.detect %>% mean() # 補正前の有意差検出率を計算
FLG.detect.adj %>% mean() # 補正後の有意差検出率を計算
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
iter <- 1000 # シミュレーションの繰り返し回数を1000に設定
alpha <- 0.05 # 有意水準を0.05に設定
p <- rep(0, iter) # p値を保存するベクトルを初期化
add.vec <- rep(0, iter) # 増やした人数を保存するベクトルを初期化

set.seed(123) # 乱数のシードを設定して再現性を確保

n1 <- n2 <- 10 # 各グループのサンプルサイズを10に設定
mu <- 10 # 平均値を10に設定
sigma <- 2 # 標準偏差を2に設定
delta <- 0 # 平均の差を0に設定

## シミュレーション本体
for (i in 1:iter) { # 1000回のシミュレーションを繰り返すループ
  # 最初のデータを生成
  Y1 <- rnorm(n1, mu, sigma) # グループ1のデータを生成
  Y2 <- rnorm(n2, mu + sigma * delta, sigma) # グループ2のデータを生成
  p[i] <- t.test(Y1, Y2)$p.value # t検定を実行しp値を保存
  # データを追加する
  count <- 0 # 追加したデータの数をカウント
  ## p値が5%を下回るか、データが100になるまでデータを増やし続ける
  while (p[i] >= alpha && count < 100) { # 条件を満たすまでループを繰り返す
    # 有意でなかった場合、変数ごとに1つずつデータを追加
    Y1_add <- rnorm(1, mu, sigma) # グループ1に新しいデータを1つ追加
    Y2_add <- rnorm(1, mu + sigma * delta, sigma) # グループ2に新しいデータを1つ追加
    Y1 <- c(Y1, Y1_add) # グループ1のデータを更新
    Y2 <- c(Y2, Y2_add) # グループ2のデータを更新
    p[i] <- t.test(Y1, Y2)$p.value # 新しいデータでt検定を再度実行しp値を更新
    count <- count + 1 # データを追加した回数をカウント
  }
  add.vec[i] <- count
}

## 結果
ifelse(p < 0.05, 1, 0) |> mean() # p値が5%未満の割合を計算
hist(p)
hist(add.vec)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
N <- 24
# 7回表が出る確率
pbinom(7, N, 0.5) * 2
#
#
#
#
#
#
#
k <- 7
# 24回以上必要な確率
pnbinom(k, 24, 0.5) * 2
#
#
#
#
#
#
#
#
#
set.seed(12345)
iter <- 100000 # 発生させる乱数の数
## 24回がピークに来るトライアル回数
trial <- rpois(iter, 24)
hist(trial)
#
#
#
#
#
result <- rep(NA, iter)
for (i in 1:iter) {
  result[i] <- rbinom(1, trial[i], 0.5) / trial[i]
}
## 7/24よりも小さい確率で起こった?
length(result[result < (7 / 24)]) / iter
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| dev: "ragg_png"
# データの準備
df <- 10 # 自由度を指定
# ggplotでプロット
ggplot(data.frame(x = c(-5, 5)), aes(x = x)) +
  stat_function(fun = dt, args = list(df = df, ncp = 0), aes(color = "ncp=0")) +
  stat_function(fun = dt, args = list(df = df, ncp = 3), aes(color = "ncp=3")) +
  labs(
    title = "非心t分布",
    x = "x",
    y = "密度",
    color = "ncp"
  )
#
#
#
#
#
#
#
#
qt(0.975, df = 10, ncp = 0)
#
#
#
#
#
qt(0.975, df = 10, ncp = 0) %>% pt(df = 10, ncp = 3)
#
#
#
#
#
#
#
#
#
#
#
alpha <- 0.05
beta <- 0.2
delta <- 0.5

for (n in 10:1000) {
  df <- n + n - 2
  lambda <- delta * (sqrt((n * n) / (n + n)))
  cv <- qt(p = 1 - alpha / 2, df = df) # Type1errorの臨界値
  er <- pt(cv, df = df, ncp = lambda) # Type2errorの確率
  if (er <= beta) {
    break
  }
}
print(n)
#
#
#
#
#
#
#
#
#
#
#
#
#
#| message: FALSE
library(MASS)
set.seed(12345)
alpha <- 0.05
beta <- 0.2
rho <- 0.5
sd <- 1
Sigma <- matrix(NA, ncol = 2, nrow = 2)
Sigma[1, 1] <- Sigma[2, 2] <- sd^2
Sigma[1, 2] <- Sigma[2, 1] <- sd * sd * rho

iter <- 1000

for (n in seq(from = 10, to = 1000, by = 1)) {
  FLG <- rep(0, iter)
  for (i in 1:iter) {
    X <- mvrnorm(n, c(0, 0), Sigma)
    cor_test <- cor.test(X[, 1], X[, 2])
    FLG[i] <- ifelse(cor_test$p.value > alpha, 1, 0)
  }
  t2error <- mean(FLG)
  print(paste("n=", n, "のとき，betaは", t2error, "です。"))
  if (t2error <= beta) {
    break
  }
}

print(n)
#
#
#
#
#
#
#
#
#
#
#
#| eval: FALSE
#| include: FALSE
#| echo: FALSE

## 課題1
# 必要なパッケージの読み込み
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("broom", quietly = TRUE)) install.packages("broom")

library(tidyverse)
library(broom)

# シミュレーションの設定
set.seed(123) # 再現性のためのシード設定
n_sim <- 1000 # シミュレーションの回数
n <- 10 # 各水準のサンプルサイズ
alpha <- 0.05 # 有意水準
delta <- 2 # 効果量
sigma <- 1 # 標準偏差

# 分散分析で有意差が見られるかどうかを確認する関数
perform_anova <- function(data) {
  model <- aov(value ~ group, data = data)
  anova_result <- tidy(model)
  p_value <- anova_result$p.value[1]
  return(p_value < alpha)
}

# ペアごとのt検定を行い、有意差が見られるかどうかを確認する関数
perform_pairwise_t_tests <- function(data) {
  pairwise_results <- pairwise.t.test(data$value, data$group, p.adjust.method = "none")
  any(pairwise_results$p.value < alpha, na.rm = TRUE)
}

# シミュレーションの実行
simulate <- function(delta, sigma, n, n_sim) {
  anova_results <- logical(n_sim)
  t_test_results <- logical(n_sim)

  for (i in 1:n_sim) {
    group1 <- rnorm(n, mean = 0, sd = sigma)
    group2 <- rnorm(n, mean = delta, sd = sigma)
    group3 <- rnorm(n, mean = 0, sd = sigma)

    data <- data.frame(
      value = c(group1, group2, group3),
      group = factor(rep(c("A", "B", "C"), each = n))
    )

    anova_results[i] <- perform_anova(data)
    t_test_results[i] <- perform_pairwise_t_tests(data)
  }

  anova_type_2_error <- mean(!anova_results)
  t_test_type_2_error <- mean(!t_test_results)

  return(list(anova = anova_type_2_error, t_test = t_test_type_2_error))
}

# シミュレーションの実行
results <- simulate(delta, sigma, n, n_sim)

# 結果の表示
cat("ANOVAのタイプ2エラー率:", results$anova, "\n")
cat("ペアごとのt検定のタイプ2エラー率:", results$t_test, "\n")

## 課題2
library(tidyverse)
library(broom)

# シミュレーションの設定
set.seed(123) # 再現性のためのシード設定
n_sim <- 1000 # シミュレーションの回数
n_start <- 10 # 初期サンプルサイズ
n_max <- 100 # データ追加の上限
rho <- 0.3 # 母相関
alpha <- 0.05 # 有意水準

# 相関係数の検定で有意差が見られるかどうかを確認する関数
perform_correlation_test <- function(x, y) {
  test_result <- cor.test(x, y)
  p_value <- test_result$p.value
  return(p_value < alpha)
}

# シミュレーションの実行
simulate <- function(rho, n_start, n_max, n_sim) {
  significant_results <- logical(n_sim)

  for (i in 1:n_sim) {
    n <- n_start
    significant <- FALSE
    x <- rnorm(n)
    y <- rho * x + sqrt(1 - rho^2) * rnorm(n)

    while (n <= n_max && !significant) {
      add.x <- rnorm(1)
      add.y <- rho * add.x + sqrt(1 - rho^2) * rnorm(1)

      x <- c(x, add.x)
      y <- c(y, add.y)

      significant <- perform_correlation_test(x, y)
      n <- n + 1
    }

    significant_results[i] <- significant
  }

  proportion_significant <- mean(significant_results)

  return(proportion_significant)
}

# シミュレーションの実行
result <- simulate(rho, n_start, n_max, n_sim)

# 結果の表示
cat("最終的に有意になる割合:", result, "\n")

## 課題3

## 解析的な方法
# 必要なパッケージの読み込み
if (!requireNamespace("pwr", quietly = TRUE)) install.packages("pwr")
library(pwr)

# 効果量 δ = 1, α = 0.05, β = 0.2 の場合のサンプルサイズ計算
effect_size <- 1
alpha <- 0.05
power <- 0.8 # パワーは1-β

sample_size <- pwr.t.test(d = effect_size, sig.level = alpha, power = power, type = "two.sample", alternative = "two.sided")
sample_size

## シミュレーション
# シミュレーションの設定
set.seed(123) # 再現性のためのシード設定
n_sim <- 1000 # シミュレーションの回数
alpha <- 0.05 # 有意水準
beta <- 0.2 # タイプ2エラー率
effect_size <- 1

simulate_power <- function(n, effect_size, alpha, n_sim) {
  significant_results <- replicate(n_sim, {
    group1 <- rnorm(n, mean = 0, sd = 1)
    group2 <- rnorm(n, mean = effect_size, sd = 1)
    t_test <- t.test(group1, group2)
    t_test$p.value < alpha
  })
  power <- mean(significant_results)
  return(power)
}

# サンプルサイズを見つけるための探索
find_sample_size <- function(effect_size, alpha, beta, n_sim) {
  n <- 2
  while (TRUE) {
    power <- simulate_power(n, effect_size, alpha, n_sim)
    if (power >= 1 - beta) {
      break
    }
    n <- n + 1
  }
  return(n)
}

sample_size_simulation <- find_sample_size(effect_size, alpha, beta, n_sim)
sample_size_simulation
#
#
#
#
