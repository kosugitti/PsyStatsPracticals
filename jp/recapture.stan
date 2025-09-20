data {
  int<lower = 0> x;  // size of first sample (captures)
  int<lower = 0> n;  // size of second sample
  int<lower = 0, upper = n> k;  // number of recaptures from n
  int<lower = x> maxT;  // maximum population size
}

transformed data {
  int<lower=x> minT;
  minT = x + n - k;
}

transformed parameters {
  vector[maxT] lp;
  for (i in 1:maxT){ 
    if (i < minT)
      lp[i] = log(1.0 / maxT) + negative_infinity();
    else
      lp[i] = log(1.0 / maxT) + hypergeometric_lpmf(k | n, x, i - x);
  }
}

model {
  target += log_sum_exp(lp);
}

generated quantities {
  int<lower = minT, upper = maxT> t;
  simplex[maxT] tp;
  tp = softmax(lp);
  t = categorical_rng(tp);
}
