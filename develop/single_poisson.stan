data {
  int<lower=0> N;           // データ数
  array[N] int<lower=0> y;  // 観測値
}

parameters {
  real<lower=0> lambda;     // ポアソンパラメータ
}

model {
  // 事前分布
  lambda ~ gamma(2, 0.1);   // lambdaの事前分布

  // 尤度関数 (単一ポアソン分布)
  for (n in 1:N) {
    y[n] ~ poisson(lambda);
  }
}
