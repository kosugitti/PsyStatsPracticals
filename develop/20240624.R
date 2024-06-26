rm(list=ls())
rho <- 0.0
n <- 25
iter <- 1000
alpha <- 0.05

p <- rep(NA,iter)
set.seed(12345)
for(i in 1:iter){
    Y1 <- rnorm(n, 0, 1)
    Y2 <- Y1 * rho + rnorm(n, 0, sqrt(1-rho^2))
    p[i] <- cor.test(Y1,Y2)$p.value
    ## N増し
    count <- 0
    ##
    while(p[i] >= alpha && count < n * 2){
        additional <- rnorm(1, 0, 1)
        additionalY2 <- additional * rho + rnorm(1, 0, sqrt(1-rho^2))
        Y1 <- c(Y1,additional)
        Y2 <- c(Y2,additionalY2)
        p[i] <- cor.test(Y1,Y2)$p.value
        count <- count +1
    }
}

mean(p < alpha)
