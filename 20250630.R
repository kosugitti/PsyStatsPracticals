rm(list = ls())
library(tidyverse)
set.seed(12345)
mu1 <- -2
sig1 <- 1
mu2 <- 2
sig2 <- 1.5

N1 <- 1000
N2 <- 3000

dat <- data.frame(
    x = c(rnorm(N1, mu1, sig1), rnorm(N2, mu2, sig2)),
    id = c(rep(1, N1), rep(2, N2))
) %>%
    mutate(id = as.factor(id))
dat %>%
    ggplot(aes(x = x))+geom_density()+theme_minimal()

pacman::p_load(mixtools,EMCluster, ClusterR)
