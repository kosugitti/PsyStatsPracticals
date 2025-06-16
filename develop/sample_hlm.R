# HLM（階層線形モデル）の学級データ例
# ============================================

# パッケージの読み込み
pacman::p_load(tidyverse, brms, bayesplot, multilevel, MASS)

# データ生成
# ----------
set.seed(123)
n_classes <- 30 # 学級数
n_students_per_class <- 25 # 各学級の生徒数

# 学級レベルの変数
class_data <- data.frame(
    class_id = 1:n_classes,
    class_size = round(rnorm(n_classes, mean = 25, sd = 5)),
    teacher_experience = round(rnorm(n_classes, mean = 10, sd = 4))
)

# 学級レベルの固定効果パラメータ
gamma_00 <- 70 # 全体の切片（平均学習成績）
gamma_01 <- -0.5 # 学級規模の効果
gamma_02 <- 1.2 # 教師経験の効果
gamma_10 <- 2.5 # 学習時間の効果
gamma_11 <- 0.1 # 学級規模×学習時間の交互作用

# 学級レベルの変量効果の分散・共分散パラメータ
tau_00 <- 25 # 切片の分散
tau_11 <- 0.5 # 傾きの分散
tau_01 <- 2 # 切片と傾きの共分散

# 学級レベルの変量効果の共分散行列
Tau <- matrix(c(tau_00, tau_01, tau_01, tau_11), nrow = 2)

# 学級レベルの変量効果を生成
class_random_effects <- mvrnorm(n_classes, mu = c(0, 0), Sigma = Tau)

# 学級データに変量効果を追加
class_data <- class_data %>%
    mutate(
        u_0j = class_random_effects[, 1], # 学級の切片変量効果
        u_1j = class_random_effects[, 2] # 学級の傾き変量効果
    )

# 生徒レベルのデータ生成
student_data <- expand_grid(
    class_id = 1:n_classes,
    student_id = 1:n_students_per_class
) %>%
    left_join(class_data, by = "class_id") %>%
    mutate(
        study_hours = round(rnorm(n(), mean = 3, sd = 1.5)), # 学習時間
        initial_score = round(rnorm(n(), mean = 50, sd = 10)), # 初期成績
        # 学習成績の計算（HLMモデル）
        math_score = gamma_00 +
            gamma_01 * (class_size - 25) +
            gamma_02 * (teacher_experience - 10) +
            (gamma_10 + gamma_11 * (class_size - 25)) * study_hours +
            0.3 * initial_score +
            u_0j + u_1j * study_hours +
            rnorm(n(), mean = 0, sd = 5) # 個人レベルの誤差
    ) %>%
    # 現実的な範囲に調整
    mutate(
        study_hours = pmax(0, study_hours),
        math_score = pmax(0, pmin(100, round(math_score)))
    )

# データ構造の確認
# ---------------
print("=== データ構造の確認 ===")
print(paste("総学級数:", n_distinct(student_data$class_id)))
print(paste("総生徒数:", nrow(student_data)))
print(paste("学級あたりの平均生徒数:", round(mean(table(student_data$class_id)), 1)))

# 学級レベルの要約統計
print("\n=== 学級レベルの要約統計（最初の10学級） ===")
class_summary <- student_data %>%
    group_by(class_id) %>%
    summarise(
        n_students = n(),
        mean_math = round(mean(math_score), 1),
        mean_study = round(mean(study_hours), 1),
        class_size = first(class_size),
        teacher_exp = first(teacher_experience),
        .groups = "drop"
    )
print(head(class_summary, 10))

# ICC（級内相関係数）の計算
# -------------------------
print("\n=== ICC（級内相関係数）の計算 ===")
icc_class <- multilevel::ICC1(aov(math_score ~ class_id, data = student_data))
print(paste("学級レベルのICC:", round(icc_class, 3)))

# データの可視化
# -------------
print("\n=== データの可視化 ===")

# 学級ごとの成績分布
p1 <- ggplot(student_data, aes(x = factor(class_id), y = math_score)) +
    geom_boxplot(alpha = 0.7) +
    theme_minimal() +
    labs(x = "学級ID", y = "数学成績", title = "学級ごとの成績分布") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 学習時間と成績の関係（学級別）
p2 <- ggplot(student_data, aes(x = study_hours, y = math_score, color = factor(class_id))) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", se = FALSE, size = 0.5) +
    theme_minimal() +
    labs(x = "学習時間", y = "数学成績", title = "学習時間と成績の関係（学級別）") +
    theme(legend.position = "none")

print(p1)
print(p2)

# HLMモデルの推定
# ===============

print("\n=== HLMモデルの推定開始 ===")

# 1. 空モデル（無条件モデル）
print("1. 空モデル（無条件モデル）の推定中...")
model_null <- brms::brm(
    math_score ~ 1 + (1 | class_id),
    data = student_data,
    family = gaussian(),
    chains = 4,
    iter = 2000,
    cores = 4,
    seed = 123,
    refresh = 0 # 進行状況を非表示
)

print("空モデルの結果:")
print(summary(model_null))

# 2. レベル1変数を含むモデル
print("\n2. レベル1変数を含むモデルの推定中...")
model_level1 <- brms::brm(
    math_score ~ study_hours + initial_score + (1 + study_hours | class_id),
    data = student_data,
    family = gaussian(),
    chains = 4,
    iter = 2000,
    cores = 4,
    seed = 123,
    refresh = 0
)

print("レベル1モデルの結果:")
print(summary(model_level1))

# 3. 完全モデル（レベル1 + レベル2変数）
print("\n3. 完全モデルの推定中...")
model_full <- brms::brm(
    math_score ~ study_hours + initial_score +
        I(class_size - 25) + I(teacher_experience - 10) +
        study_hours:I(class_size - 25) +
        (1 + study_hours | class_id),
    data = student_data,
    family = gaussian(),
    chains = 4,
    iter = 2000,
    cores = 4,
    seed = 123,
    refresh = 0
)

print("完全モデルの結果:")
print(summary(model_full))

get_prior(model_full)
# モデル比較
print("\n=== モデル比較 ===")
loo_null <- loo(model_null)
loo_level1 <- loo(model_level1)
loo_full <- loo(model_full)

print("LOOによるモデル比較:")
print(loo_compare(loo_null, loo_level1, loo_full))

# 事後予測チェック
print("\n=== 事後予測チェック ===")
pp_check_plot <- pp_check(model_full, ndraws = 100)
print(pp_check_plot)

# 個人レベルの予測値と実測値の比較
fitted_values <- fitted(model_full) %>% as.data.frame()
plot_data <- data.frame(
    observed = student_data$math_score,
    predicted = fitted_values$Estimate,
    class_id = student_data$class_id
)

p3 <- ggplot(plot_data, aes(x = observed, y = predicted)) +
    geom_point(alpha = 0.6) +
    geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
    theme_minimal() +
    labs(
        x = "実測値", y = "予測値",
        title = "HLMモデルの予測値 vs 実測値"
    ) +
    coord_equal()

print(p3)

# 学級レベルの変量効果の可視化
print("\n=== 学級レベルの変量効果 ===")
random_effects <- ranef(model_full)
class_effects <- random_effects$class_id[, , 1] %>% as.data.frame()
class_effects$class_id <- as.numeric(rownames(class_effects))

p4 <- ggplot(class_effects, aes(x = class_id, y = Estimate)) +
    geom_point() +
    geom_errorbar(aes(ymin = Q2.5, ymax = Q97.5), width = 0.2) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    theme_minimal() +
    labs(
        x = "学級ID", y = "切片の変量効果",
        title = "学級レベルの切片変量効果"
    )

print(p4)

print("\n=== 分析完了 ===")
print("生成されたオブジェクト:")
print("- student_data: 生徒データ")
print("- class_data: 学級データ")
print("- model_null: 空モデル")
print("- model_level1: レベル1モデル")
print("- model_full: 完全モデル")
