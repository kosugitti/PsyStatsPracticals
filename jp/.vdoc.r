#
#
#
#
#
#
#
#
#
#
#
library(tidyverse)
set.seed(17)
n <- 10
mu <- 4
X <- rnorm(n, mean = mu, sd = 1)
print(X)
#
#
#
#
#
#
#
#
#
#
#
result <- t.test(X, mu = mu)
print(result)
#
#
#
#
#
#
#
#
#
n <- 3
mu <- 4
X <- rnorm(n, mean = mu, sd = 1)
mean(X) %>%
  round(3) %>%
  print()
result <- t.test(X, mu = mu)
print(result)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
n1 <- 10
n2 <- 10
mu1 <- 4
sigma <- 1
d <- 1
mu2 <- mu1 + (sigma * d)

set.seed(42)
X1 <- rnorm(n1, mean = mu1, sd = sigma)
X2 <- rnorm(n2, mean = mu2, sd = sigma)

X1 %>%
  mean() %>%
  round(3) %>%
  print()
X2 %>%
  mean() %>%
  round(3) %>%
  print()

result <- t.test(X1, X2, var.equal = TRUE)
print(result)
#
#
#
#
#
#
#
#
#
dataSet <- data.frame(group = c(rep(1,n1),rep(2,n2)), value = c(X1,X2)) %>% 
    mutate(group = as.factor(group))
t.test(value ~ group, data = dataSet, var.equal = TRUE)
#
#
#
#
#
#
#
#
library(car)
leveneTest(value ~ group, data = dataSet, center = mean)
#
#
#
#
#
result2 <- t.test(value ~ group, data = dataSet, var.equal = FALSE)
print(result2)
```
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| echo: FALSE
#| message: FALSE
library(tidyverse)
library(ggplot2)
library(gridExtra)
dL <- 2
dS <- 0.2
sL <- 2
sS <- 0.2

g1 <- ggplot(data.frame(x = c(-4, 4)), aes(x = x)) +
    stat_function(fun = dnorm,args=list(mean=dL,sd=sS),color="red") +
    stat_function(fun = dnorm,args=list(mean=-dL,sd=sS),color="blue") +
    xlab("")+ylab("")+theme(axis.text.y=element_blank())
g2 <- ggplot(data.frame(x = c(-4, 4)), aes(x = x)) +
    stat_function(fun = dnorm,args=list(mean=dS,sd=sS),color="red") +
    stat_function(fun = dnorm,args=list(mean=-dS,sd=sS),color="blue") +
    xlab("")+ylab("")+theme(axis.text.y=element_blank())
g3 <- ggplot(data.frame(x = c(-4, 4)), aes(x = x)) +
    stat_function(fun = dnorm,args=list(mean=dL,sd=sL),color="red") +
    stat_function(fun = dnorm,args=list(mean=-dL,sd=sL),color="blue") +
    xlab("")+ylab("")+theme(axis.text.y=element_blank())
g4 <- ggplot(data.frame(x = c(-4, 4)), aes(x = x)) +
    stat_function(fun = dnorm,args=list(mean=dS,sd=sL),color="red") +
    stat_function(fun = dnorm,args=list(mean=-dS,sd=sL),color="blue") +
    xlab("")+ylab("")+theme(axis.text.y=element_blank())
g <- grid.arrange(g1,g2,g3,g4)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
library(effsize)
cohen.d(value ~ group, data = dataSet)
cohen.d(value ~ group, data = dataSet, hedges.correction =TRUE)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
n <- 10
mu1 <- 4
sigma <- 1
d <- 1
X1 <- rnorm(n, mu1, sigma)
X2 <- X1 + sigma*d + rnorm(n, 0,sigma)
t.test(X1,X2,paired = TRUE)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| message: FALSE
library(MASS)  # 多次正規乱数を生成するのに必要
n <- 10
mu1 <- 4
sigma <- 1
d <- 1
mu <- c(mu1, mu1 + sigma * d)
rho <- 0.4
SIG <- matrix(c(sigma^2, rho*sigma*sigma, rho*sigma*sigma, sigma^2),ncol=2,nrow=2)
X <- mvrnorm(n, mu, SIG)
t.test(X[,1], X[,2], paired = TRUE)
#
#
#
#
#
cohen.d(X[,1],X[,2])
cohen.d(X[,1],X[,2], hedges.correction =TRUE)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
