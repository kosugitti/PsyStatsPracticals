data {
  int<lower=0> N;           // データ数
  array[N] int<lower=0> y;  // 観測値
}

parameters {
  real<lower=0, upper=1> theta;  // 混合比率 (0: 少数群, 1: 量産群)
  real<lower=0, upper=10> lambda1;         // 少数群のポアソンパラメータ（制約強化）
  real<lower=10> lambda2;         // 量産群のポアソンパラメータ（順序制約）
}

model {
  // 事前分布
  theta ~ beta(1, 1);      // 混合比率の事前分布
  lambda1 ~ gamma(2, 2);   // 少数群のlambdaの事前分布（より小さい値）
  lambda2 ~ gamma(5, 0.1); // 量産群のlambdaの事前分布 (より大きな値を期待)

  // 尤度関数 (混合分布)
  for (n in 1:N) {
    target += log_mix(theta,
                      poisson_lpmf(y[n] | lambda2),  // theta=1: 量産群
                      poisson_lpmf(y[n] | lambda1)); // theta=0: 少数群
  }
}

