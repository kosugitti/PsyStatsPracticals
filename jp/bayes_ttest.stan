data {
  int<lower=0> N1;          // 第1群のサンプルサイズ
  int<lower=0> N2;          // 第2群のサンプルサイズ
  array[N1] real X1;        // 第1群の観測値
  array[N2] real X2;        // 第2群の観測値
}

parameters {
  real mu1;                 // 第1群の母平均
  real mu2;                 // 第2群の母平均
  real<lower=0> sigma;      // 共通の標準偏差（等分散の仮定）
}

model {
  // 尤度：各群が同じ散らばりを持つ正規分布から生じる
  X1 ~ normal(mu1, sigma);
  X2 ~ normal(mu2, sigma);
  // 事前分布
  mu1 ~ normal(50, 50);
  mu2 ~ normal(50, 50);
  sigma ~ cauchy(0, 5);
}

generated quantities {
  real diff;                // 平均値差そのもの
  real delta;               // 標準化した効果量（Cohen's d 相当）
  array[N1 + N2] real X_pred;  // 事後予測分布のための複製データ

  diff = mu1 - mu2;
  delta = (mu1 - mu2) / sigma;
  for (i in 1 : N1) {
    X_pred[i] = normal_rng(mu1, sigma);
  }
  for (i in 1 : N2) {
    X_pred[N1 + i] = normal_rng(mu2, sigma);
  }
}
