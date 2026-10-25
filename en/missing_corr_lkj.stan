data{
    int<lower=0> Nobs;
    int<lower=0> Nmiss;
    array[Nobs] vector[2] obsX;
    array[Nmiss] real missX;
}

parameters{
    vector<lower=0,upper=100>[2] mu;
    real<lower=0> sd1;
    real<lower=0> sd2;
    corr_matrix[2] Omega;
}

transformed parameters{
    real rho = Omega[1,2];
    cov_matrix[2] Sig = quad_form_diag(Omega, [sd1, sd2]');
}

model{
    //likelihood
    obsX ~ multi_normal(mu, Sig);
    missX ~ normal(mu[1], sd1);
    //prior
    mu ~ uniform(0,100);
    sd1 ~ cauchy(0,5);
    sd2 ~ cauchy(0,5);
    Omega ~ lkj_corr(1);
}
