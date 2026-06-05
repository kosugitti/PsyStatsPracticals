data {
  int<lower=0> Lv;                       // number of levels (groups)
  int<lower=0> L;                        // total number of observations
  array[L] int<lower=1, upper=Lv> idx;   // group ID of each observation
  array[L] real X;                       // observations
}

parameters {
  real gm;                               // grand mean
  array[Lv - 1] real raw_delta;          // effects; Lv-1 of them, by the degrees of freedom
  real<lower=0> sigma;                   // within-group spread (error)
}

transformed parameters {
  array[Lv] real delta;                  // effects rebuilt so that they sum to zero
  array[Lv] real mu;                     // population mean of each group

  for (l in 1 : (Lv - 1)) {
    delta[l] = raw_delta[l];             // copy the first Lv-1 effects
  }
  delta[Lv] = -sum(raw_delta);           // the last one follows from "effects sum to zero"

  for (l in 1 : Lv) {
    mu[l] = gm + delta[l];               // group mean = grand mean + effect
  }
}

model {
  // likelihood: observation l scatters around the mean of its group, mu[idx[l]]
  for (l in 1 : L) {
    X[l] ~ normal(mu[idx[l]], sigma);
  }
  // priors
  gm ~ normal(50, 50);
  raw_delta ~ normal(0, 50);
  sigma ~ cauchy(0, 5);
}

generated quantities {
  array[L] real X_pred;                  // replicated data for the posterior predictive distribution

  for (l in 1 : L) {
    X_pred[l] = normal_rng(mu[idx[l]], sigma);
  }
}
