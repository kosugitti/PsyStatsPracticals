data {
  int<lower=0> N;           // データ数
  array[N] int<lower=0> y;  // 観測値
}

parameters {
  real<lower=0, upper=1> theta;
  real<lower=0> mu;              // 負の二項分布の平均
  real<lower=0> phi;             // 負の二項分布の過分散パラメータ
}

model {
  // 事前分布
  theta ~ beta(1, 1);
  mu ~ gamma(5, 0.1);
  phi ~ gamma(2, 0.1);

  // 尤度関数 (0過剰負の二項分布)
  for (i in 1:N) {
    if (y[i] == 0) {
      target += log_mix(theta,
                        0,
                        neg_binomial_2_lpmf(0 | mu, phi));
    } else {
      target += log(1 - theta) + neg_binomial_2_lpmf(y[i] | mu, phi);
    }
  }
}

generated quantities {
  array[N] int y_pred;     // 事後予測分布

  for (i in 1:N) {
    // 事後予測分布の生成
    if (bernoulli_rng(theta) == 1) {
      y_pred[i] = 0;  // 構造的ゼロ
    } else {
      y_pred[i] = neg_binomial_2_rng(mu, phi);  // 負の二項分布から生成
    }
  }
}
