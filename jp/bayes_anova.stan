data {
  int<lower=0> Lv;                       // 水準数（群の数）
  int<lower=0> L;                        // データの総数
  array[L] int<lower=1, upper=Lv> idx;   // 各データが属する群のID
  array[L] real X;                       // 観測値
}

parameters {
  real gm;                               // 全体平均（grand mean）
  array[Lv - 1] real raw_delta;          // 効果。自由度の関係で Lv-1 個
  real<lower=0> sigma;                   // 群内の散らばり（誤差）
}

transformed parameters {
  array[Lv] real delta;                  // 総和が0になるよう作り直した効果
  array[Lv] real mu;                     // 各群の母平均

  for (l in 1 : (Lv - 1)) {
    delta[l] = raw_delta[l];             // 最初の Lv-1 個はコピー
  }
  delta[Lv] = -sum(raw_delta);           // 最後の1つは「効果の総和=0」から決まる

  for (l in 1 : Lv) {
    mu[l] = gm + delta[l];               // 各群の平均 = 全体平均 + 効果
  }
}

model {
  // 尤度：l 番目のデータは，その群の平均 mu[idx[l]] を中心に散らばる
  for (l in 1 : L) {
    X[l] ~ normal(mu[idx[l]], sigma);
  }
  // 事前分布
  gm ~ normal(50, 50);
  raw_delta ~ normal(0, 50);
  sigma ~ cauchy(0, 5);
}

generated quantities {
  array[L] real X_pred;                  // 事後予測分布のための複製データ

  for (l in 1 : L) {
    X_pred[l] = normal_rng(mu[idx[l]], sigma);
  }
}
