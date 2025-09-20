data{
    int<lower=0> L; 
    array[L] real w;
}

parameters{
    real<lower=1, upper=L> tau;
    real beta0a;
    real beta0b;
    real beta1a;
    real<upper=0> beta1b;
    real<lower=0> sig;
}

model{
    //likelihood
    for(i in 1:L){
        if(i < tau){
            w[i] ~ normal(beta0a + beta1a * i, sig);
        }else{
            w[i] ~ normal(beta0b + beta1b * (i-tau+1), sig);
        }
    }
    //prior
    tau ~ uniform(1,L);
    beta0a ~ normal(80,10);
    beta0b ~ normal(80,10);
    beta1a ~ normal(0,10);
    beta1b ~ normal(0,10);
    sig ~ cauchy(0,5);

}
