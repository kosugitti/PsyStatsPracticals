rm(list = ls())
pacman::p_load(tidyverse)
pacman::p_load(broom)
# 検定の繰り返し問題 -------------------------------------------------------

### t検定を繰り返す
alpha <- 0.05
n1 <- n2 <- n3 <- 10
mu <- 10
sigma <- 2

mu1 <- mu2 <- mu3 <- mu


set.seed(12345)
iter <- 1000

anova.detect <- rep(NA, iter)
ttest.detect <- rep(NA, iter)

for (i in 1:iter) {
  X1 <- rnorm(n1, mu, sigma)
  X2 <- rnorm(n2, mu, sigma)
  X3 <- rnorm(n3, mu, sigma)

  dat <- data.frame(
    group = c(rep(1, n1), rep(2, n2), rep(3, n3)),
    value = c(X1, X2, X3)
  )
  result.anova <- aov(value ~ group, data = dat) %>% tidy()
  anova.detect[i] <- ifelse(result.anova$p.value[1] < alpha, 1, 0)

  # t.test repeat
  ttest12 <- t.test(X1, X2)$p.value
  ttest13 <- t.test(X1, X3)$p.value
  ttest23 <- t.test(X2, X3)$p.value

  ttest.detect[i] <- ifelse(ttest12 < alpha | ttest13 < alpha | ttest23 < alpha, 1, 0)
}
ttest.detect %>% mean()
anova.detect %>% mean()


### ひとつの研究の中で複数回検定ものをする
alpha <- 0.05

studyMake <- function(n, mu, sigma, delta) {
  X1 <- rnorm(n, mu, sigma)
  X2 <- rnorm(n, mu + sigma * delta, sigma)
  dat <- data.frame(
    group = rep(1:2, each = n),
    value = c(X1, X2)
  )
  result <- t.test(X1, X2)$p.value
  return(result)
}


iter <- 1000
alpha <- 0.05
num_studies <- 3
alpha_adjust <- alpha / num_studies

FLG.detect <- rep(NA, iter)
FLG.detect.adj <- rep(NA, iter)
for (i in 1:iter) {
  p_values <- replicate(num_studies, studyMake(n = 10, mu = 10, sigma = 1, delta = 0))
  FLG.detect[i] <- ifelse(any(p_values < alpha), 1, 0)
  FLG.detect.adj[i] <- ifelse(any(p_values < alpha_adjust), 1, 0)
}


FLG.detect %>% mean()
FLG.detect.adj %>% mean()



# N増 --------------------------------------------------------------

## 設定と準備
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
  Y1 <- rnorm(N, mu, sigma) # グループ1のデータを生成
  Y2 <- rnorm(N, mu + sigma * delta, sigma) # グループ2のデータを生成
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
hist(add.vec)

# 24/7 ------------------------------------------------------------

set.seed(2018)
# Nを固定していた場合 --------------------------------------------------------------
N <- 24
# 7回表が出る確率
pbinom(7, N, 0.5) * 2


# kを固定していた場合 --------------------------------------------------------------
k <- 7
# 24回以上必要な確率
pnbinom(k, 24, 0.5) * 2


# 5分間のトライアルだった場合 ----------------------------------------------------------
set.seed(12345)
iter <- 100000 # 発生させる乱数の数
## 24回がピークに来るトライアル回数
trial <- as.array(rpois(iter, 24))
## トライアル回数ごとに，帰無仮説のもとで成功した確率
result <- rep(NA, iter)
for (i in 1:iter) {
  result[i] <- rbinom(1, trial[i], 0.5) / trial[i]
}
## 7/24よりも小さい確率で起こった?
length(result[result < (7 / 24)]) / iter
