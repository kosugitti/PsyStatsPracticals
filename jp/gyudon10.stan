data{
    int N;
    array[N] real Y;
}
parameters{
    real mu;
    array[N] real<lower=0> sigma;
}
model{
    // likelihood
    for(i in 1:N){
        Y[i] ~ normal(mu, sigma[i]);
    }
    // prior
    mu ~ uniform(0, 200);
    sigma ~ cauchy(0,5);
}
