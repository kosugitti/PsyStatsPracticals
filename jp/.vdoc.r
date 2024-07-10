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
#| eval: FALSE
#| include: FALSE

library(ggplot2)
# パラメータ設定
rho <- 0.4
n <- 20
alpha <- 0.05
df <- n - 2
# 臨界値の計算（双方向）
critical_value_t <- qt(1 - alpha / 2, df)
# 非心パラメータ（ncp）の計算
ncp <- sqrt(n) * rho / sqrt(1 - rho^2)
# 理論的なt分布の値を計算
t_values <- seq(-5, 5, length.out = 1000)
null_density <- dt(t_values, df)
true_density <- dt(t_values, df, ncp = ncp)
# データフレームの作成
data <- data.frame(
  t_value = rep(t_values, 2),
  density = c(null_density, true_density),
  group = factor(rep(c("Null Distribution", "True Distribution"), each = length(t_values)))
)

# 検出力の計算
power <- pt(critical_value_t, df, ncp = ncp, lower.tail = FALSE) + pt(-critical_value_t, df, ncp = ncp, lower.tail = TRUE)
## 検算
library(pwr)
pwr.r.test(n=20,r=0.4)
h# ggplotでプロット
ggplot(data, aes(x = t_value, y = density, color = group, fill = group)) +
  geom_line(size = 1) +
  geom_vline(xintercept = c(-critical_value_t, critical_value_t), linetype = "dashed", color = "black") +
  labs(title = "Distribution of t Values", x = "t Value", y = "Density") +
  scale_color_manual(values = c("red", "blue")) +
  scale_fill_manual(values = c("red", "blue"), guide = "none") +
  annotate("text", x = critical_value_t + 1, y = max(null_density) * 0.5, label = sprintf("Power = %.2f", power), color = "black") +
  theme_minimal()
#
#
#
# 必要なパッケージを読み込む
library(tidyverse)

# パラメータ設定
set.seed(123)
n <- 99 # 全体のサンプルサイズ
n_groups <- 3 # サブグループの数
group_size <- n %/% n_groups # サブグループのサイズ

# グループごとにデータを生成
x <- rnorm(n)
y <- numeric(n)

# 各サブグループで負の相関を持つデータを生成
for (i in 1:n_groups) {
  start_index <- (i - 1) * group_size + 1
  end_index <- i * group_size
  intercept <- (i - 2) * 5 # グループごとに異なる切片
  slope <- -0.3 # 一貫した負の相関
  y[start_index:end_index] <- intercept + slope * x[start_index:end_index] + rnorm(group_size, sd = 1)
}

# 全体として正の相関を持つように調整
# 全体の正の相関を持たせるためにyにxを加算しますが、サブグループ内の負の相関は保たれます

# データフレームの作成
data <- data.frame(
  x = x,
  y = y,
  group = factor(rep(1:n_groups, each = group_size))
)

# 散布図をプロット
ggplot(data, aes(x = x, y = y, color = group)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Overall Positive Correlation with Negative Correlation in Subgroups",
       x = "X",
       y = "Y",
       color = "Group") +
  theme_minimal()

cor(data$x,data$y)
data %>% group_by(group) %>% summarise(r = cor(x,y))
#
#
#
