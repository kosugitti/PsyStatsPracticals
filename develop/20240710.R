pacman::p_load(ggplot2)

# パラメータ設定
rho <- 0.3
n <- 20
alpha <- 0.05
df <- n - 2
n_sim <- 10000

# 無相関の場合のシミュレーション
null_r <- replicate(n_sim, cor(rnorm(n), rnorm(n)))

# 相関がある場合のシミュレーション
true_r <- replicate(n_sim, {
  x <- rnorm(n)
  y <- rho * x + sqrt(1 - rho^2) * rnorm(n)
  cor(x, y)
})

# t分布への変換
null_t <- null_r * sqrt(df / (1 - null_r^2))
true_t <- true_r * sqrt(df / (1 - true_r^2))

# 臨界値の計算（双方向）
critical_value_t <- qt(1 - alpha / 2, df)
critical_value_r <- critical_value_t / sqrt(df + critical_value_t^2)

# 検出力の計算（片方向）
ncp <- sqrt(n) * rho / sqrt(1 - rho^2)
power <- mean(true_t > critical_value_t)

# データフレームの作成
data <- data.frame(
  t_value = c(null_t, true_t),
  group = factor(rep(c("Null Distribution", "True Distribution"), each = n_sim))
)

# ggplotでプロット
ggplot(data, aes(x = t_value, fill = group)) +
  geom_histogram(position = "identity", bins = 50, alpha = 0.5) +
  geom_vline(xintercept = c(-critical_value_t, critical_value_t), linetype = "dashed", color = "black") +
  labs(title = "Distribution of t Values", x = "t Value", y = "Frequency") +
  scale_fill_manual(values = c("red", "blue")) +
  annotate("text", x = critical_value_t + 1, y = max(table(data$t_value)), label = sprintf("Power = %.2f", power), color = "black") +
  theme_minimal()
