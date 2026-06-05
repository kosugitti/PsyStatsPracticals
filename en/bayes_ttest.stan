data {
  int<lower=0> N1;          // sample size of group 1
  int<lower=0> N2;          // sample size of group 2
  array[N1] real X1;        // observations of group 1
  array[N2] real X2;        // observations of group 2
}

parameters {
  real mu1;                 // population mean of group 1
  real mu2;                 // population mean of group 2
  real<lower=0> sigma;      // common standard deviation (equal-variance assumption)
}

model {
  // likelihood: each group arises from a normal with the same spread
  X1 ~ normal(mu1, sigma);
  X2 ~ normal(mu2, sigma);
  // priors
  mu1 ~ normal(50, 50);
  mu2 ~ normal(50, 50);
  sigma ~ cauchy(0, 5);
}

generated quantities {
  real diff;                // the mean difference itself
  real delta;               // standardised effect size (Cohen's d)
  array[N1 + N2] real X_pred;  // replicated data for the posterior predictive distribution

  diff = mu1 - mu2;
  delta = (mu1 - mu2) / sigma;
  for (i in 1 : N1) {
    X_pred[i] = normal_rng(mu1, sigma);
  }
  for (i in 1 : N2) {
    X_pred[N1 + i] = normal_rng(mu2, sigma);
  }
}
