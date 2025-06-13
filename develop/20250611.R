rm(list = ls())
pacman::p_load(tidyverse, MASS, patchwork)

# 2群の実験状況の散布図 ------------------------------------------------------------
# 一般的な回帰分析

# 単回帰分析モデルのダミーデータ
set.seed(123)
n <- 30
x <- rnorm(n, mean = 5, sd = 2)
y <- 10 + 2 * x + rnorm(n, sd = 3)

df_regression <- data.frame(x = x, y = y)

p1 <- ggplot(df_regression, aes(x = x, y = y)) +
    geom_point(alpha = 0.7, size = 2) +
    geom_smooth(method = "lm", se = FALSE, color = "blue") +
    theme_minimal() +
    labs(x = "説明変数", y = "目的変数", title = "連続データの場合") +
    theme(text = element_text(family = "IPAexGothic"))



# データの準備
set.seed(17)
N <- 30
x1 <- rnorm(N, mean = 1)
x2 <- rnorm(N)

# データフレームの作成
df_exp <- data.frame(
    group = factor(rep(c("統制群", "実験群"), each = N), levels = c("統制群", "実験群")),
    value = c(x2, x1)
)


# 散布図2：平均値を通る回帰直線（平均値バー付き）
p2 <- ggplot(df_exp, aes(x = group, y = value)) +
    geom_point(alpha = 0.6) +
    geom_segment(
        data = df_exp %>% group_by(group) %>% summarise(mean_value = mean(value)),
        aes(
            x = as.numeric(group) - 0.1, xend = as.numeric(group) + 0.1,
            y = mean_value, yend = mean_value
        ),
        color = "gray", linewidth = 1
    ) +
    geom_segment(
        x = 0.5, xend = 2.5,
        y = mean(df_exp$value[df_exp$group == "統制群"]) - 0.65,
        yend = mean(df_exp$value[df_exp$group == "実験群"]) + 0.65,
        color = "blue", linewidth = 1
    ) +
    theme_minimal() +
    labs(x = "群", y = "従属変数", title = "ダミーデータの場合") +
    theme(text = element_text(family = "IPAexGothic"))

# 散布図3：全体平均を通る直線（平均値バー付き）
p3 <- ggplot(df_exp, aes(x = group, y = value)) +
    geom_point(alpha = 0.6) +
    geom_segment(
        data = df_exp %>% group_by(group) %>% summarise(mean_value = mean(value)),
        aes(
            x = as.numeric(group) - 0.1, xend = as.numeric(group) + 0.1,
            y = mean_value, yend = mean_value
        ),
        color = "gray", linewidth = 1
    ) +
    geom_hline(yintercept = mean(df_exp$value), linetype = "dashed", color = "blue", linewidth = 1) +
    theme_minimal() +
    labs(x = "群", y = "従属変数", title = "帰無仮説") +
    theme(text = element_text(family = "IPAexGothic"))

p4 <- p1 + p2

# プロットの保存
ggsave("docs/images/13_GLM.png", p4, width = 6, height = 4)
ggsave("genko/figure/ch04_exp_scatter3.png", p4, width = 6, height = 4)
