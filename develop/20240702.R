# 必要なパッケージの読み込み
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("broom", quietly = TRUE)) install.packages("broom")

library(tidyverse)
library(broom)

# シミュレーションの設定
set.seed(123)  # 再現性のためのシード設定
n_sim <- 1000  # シミュレーションの回数
n_start <- 10  # 初期サンプルサイズ
n_max <- 100   # データ追加の上限
rho <- 0.3     # 母相関
alpha <- 0.05  # 有意水準

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

#------------------------------------------------
# 必要なパッケージの読み込み
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("broom", quietly = TRUE)) install.packages("broom")

library(tidyverse)
library(broom)

# シミュレーションの設定
set.seed(123)  # 再現性のためのシード設定
n_sim <- 1000  # シミュレーションの回数
n <- 10        # 各水準のサンプルサイズ
alpha <- 0.05  # 有意水準
delta <- 2     # 効果量
sigma <- 1     # 標準偏差

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



