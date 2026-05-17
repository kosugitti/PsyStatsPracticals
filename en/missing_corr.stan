data{
    int<lower=0> Nobs;
    int<lower=0> Nmiss;
    array[Nobs] vector[2] obsX;
    array[Nmiss] real missX;
}

parameters{
    vector[2] mu;
    real<lower=0> sd1;
    real<lower=0> sd2;
    real<lower=-1,upper=1> rho;
}

transformed parameters{
    cov_matrix[2] Sig;
    Sig[1,1] = sd1 * sd1;
    Sig[1,2] = sd1 * sd2 * rho;
    Sig[2,1] = Sig[1,2];
    Sig[2,2] = sd2 * sd2;
}

model{
    //likelihood
    obsX ~ multi_normal(mu, Sig);
    missX ~ normal(mu[1], sd1);
    //prior
    mu[1] ~ uniform(0,100);
    mu[2] ~ uniform(0,100);
    sd1 ~ cauchy(0,5);
    sd2 ~ cauchy(0,5);
    rho ~ uniform(-1,1);
}
