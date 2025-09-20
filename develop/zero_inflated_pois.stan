data {
  int<lower=0> N;
  array[N] int<lower=0> y;
}

parameters {
  real<lower=0, upper=1> theta;
  real<lower=0> lambda;
}

model {
  // likelihood
  for (n in 1:N) {
    if (y[n] == 0) {
      target += log_mix(theta,
                        0,
                        poisson_lpmf(0 | lambda));      // ポアソンからの0
    } else {
      target += log(1 - theta) + poisson_lpmf(y[n] | lambda);
    }
  }
  // prior
  theta ~ beta(1, 1);
  lambda ~ gamma(5, 0.1);
}

generated quantities {
  array[N] int y_pred;     // 事後予測分布
  for (n in 1:N) {
    if (bernoulli_rng(theta) == 1) {
      y_pred[n] = 0;  // 構造的ゼロ
    } else {
      y_pred[n] = poisson_rng(lambda);  // ポアソン分布から生成
    }
  }
}

