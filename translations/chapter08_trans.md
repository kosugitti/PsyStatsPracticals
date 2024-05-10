| 原文 | 翻訳 |
|---|---|
| `# 平均値差の検定` | `# Testing for Difference in Means` |
| `平均値差の検定は，実験計画の結論を出すために用いられる手段である。無作為割り当てによって個人差や背景要因が相殺され，平均的な因果効果を検証することができるからである。` | `The test of mean difference is a method used to draw conclusions from a research design. This is because random assignment offsets individual differences and background factors, allowing for the verification of the average causal effect.` |
| `その結果を一般化するためには，やはり推測統計学の知見が必要であり，サンプルサイズやタイプ1,2エラーが関わってくることに変わりはない。` | `To generalize these results, knowledge of inferential statistics is indeed necessary, with sample size and Type 1 and 2 errors remaining crucial factors.` |
| `## 一標本検定` | `## One-Sample Test` |
| `まず配置標本検定の例から始める。母平均がわかっている，あるいは理論的に仮定される特定の値に対して，標本平均が統計的に有意に異なっていると言って良いかどうかの判断をするときに用いる。` | `We'll start with an example of permutation sample testing. This method is used to determine whether the sample mean is statistically significantly different from a specific value, which is known or theoretically assumed as the population mean.` |
| `たとえば7件法のデータを取ったときに，ある項目の平均が中点4より有意に離れていると言って良いかどうか，といった判定をするときに用いる。かりに，サンプルサイズ10で7件法のデータが得られたとしよう。ここでは平均4,SD1の正規乱数を10件生成することで表現する。実際にはこの値を，人に対する尺度カテゴリへの反応として得ているはずである。` | `For example, when collecting data based on a 7-point scale, we determine whether or not it's accurate to say that the average of a certain item significantly deviates from the midpoint of 4. Suppose we obtained data from a 7-point scale with a sample size of 10. Here, we represent it by generating 10 normal random numbers with an average of 4 and a standard deviation of 1. In reality, these values should be obtained as responses to scale categories from individuals.` |
| `library(tidyverse)` | `library(tidyverse)` |
| `set.seed(17)` | `set.seed(17)` |
| `n <- 10` | `n <- 10` |
| `mu <- 4` | `mu <- 4` |
| `X <- rnorm(n, mean = mu, sd = 1)` | `X <- rnorm(n, mean = mu, sd = 1)` |
| `print(X)` | `print(X)` |
| `今回，標本平均は`r round(mean(X),3)`であり，これより極端な値が$\mu = 4$の母集団から得られるかどうかを検定する。帰無仮説検定の手順にそって進めていくと，以下のようになる。` | `In this case, the sample mean is `r round(mean(X),3)`. From here, we will test whether we can obtain a more extreme value from a population where $\mu = 4$. If we follow the procedure for null hypothesis testing, it would look something like this.` |
| `1. 帰無仮説は母平均が理論的な値(ここでは尺度の中点4)であること，すなわち$\mu =4$であり，対立仮説は$\mu \neq 4$ である。` | `1. The null hypothesis is that the population mean is the theoretical value (here the midpoint of the scale 4), in other words, $\mu =4$. The alternative hypothesis is $\mu \neq 4$.` |
| `2. 検定統計量は，正規母集団から得られる標本平均が従う標本分布であり，母分散が未知の場合の区間推定に用いたT統計量になる。` | `2. The test statistic is the sample distribution that the sample mean derived from a normal population follows. It turns into the T statistic used for interval estimation when the population variance is unknown.` |
| `3. 判断基準は心理学の慣例に沿って5%とする。` | `3. We set the decision criterion at 5%, in accordance with the conventions of psychology.` |
| `このあと，検定統計量の計算と判定である。これをRは`t.test`関数で一気に処理できる。` | `Next, we will carry out the computation and determination of test statistics. R can handle this all at once with the `t.test` function.` |
| `result <- t.test(X, mu = mu)` | `result <- t.test(X, mu = mu)` |
| `print(result)` | `print(result)` |
| `結果として，今回の検定統計量の実現値は`r round(result$statistic,3)`であり，自由度`r result$parameter`のt分布からこれ以上の値が出てくる確率は，`r round(result$p.value,3)`であることがわかる。これは5%水準と見比べてより大きいので，レアケースではないと判断できる。つまり，母平均4の正規母集団から，`r round(mean(X),3)`の標本平均が得られることはそれほど珍しいものではなく，統計的に有意に異なっていると判断するには及ばない，ということである。` | `As a result, the realized value of our test statistic is `r round(result$statistic,3)`, and the probability of getting a value higher than this from a t-distribution with `r result$parameter` degrees of freedom is `r round(result$p.value,3)`. Since this is larger compared to the 5% level, we can conclude that it's not a rare case. In other words, it's not unusual to get a sample mean of `r round(mean(X),3)` from a normal population with a mean of 4, and we cannot say it's statistically significantly different.` |
| `レポートなどに記載するときは，これら実現値やp値を踏まえて「$t(9)=0.66776,p=0.5151 ,n.s.$」などとする。ここでn.s.はnot significantの略である。` | `When writing reports, consider these actual values and p-values and indicate as "$t(9)=0.66776, p=0.5151, n.s.$" The "n.s." here stands for "not significant".` |
| `さてこの例では，母平均4の正規乱数を生成し，その平均が4と異なるとはいえない，と結論づけた。これは一見，当たり前のことのようであり，無意味な行為におもえるかもしれない。しかし次の例を見てみよう。` | `In this example, we generated normal random numbers with a mean of 4 and concluded that the mean does not necessarily differ from 4. This may seem self-evident and perhaps even pointless at first glance. However, let's consider the following example.` |
| `n <- 3` | `n <- 3` |
| `mu <- 4` | `mu <- 4` |
| `X <- rnorm(n, mean = mu, sd = 1)` | `X <- rnorm(n, mean = mu, sd = 1)` |
| `mean(X) %>%` | `mean(X) %>%` |
| `round(3) %>%` | `round(3) %>%` |
| `print()` | `print()` |
| `result <- t.test(X, mu = mu)` | `result <- t.test(X, mu = mu)` |
| `print(result)` | `print(result)` |
| `ここではサンプルサイズ$n=3$であり，標本平均が`r round(mean(X),3)`であった。このときt値は5%臨界値を上回っており，「母平均4のところから得られる値にしては極端」であるから，統計的に有意に異なる，と判断することになる。乱数生成時は平均を確かに4に設定したが，母平均から取り出したごく一部が，そこから大きく離れてしまうことはあり得るのである。` | `In this instance, the sample size is $n=3$, and the sample mean was `r round(mean(X),3)`. If the t-value exceeds the 5% critical value, it is considered 'extreme' compared to what would typically be obtained from a population mean of 4, and is therefore statistically significantly different. Remember, even though the mean was indeed set to 4 when generating random numbers, it's perfectly possible for a small part drawn from the population mean to veer significantly from it.` |
| `## 二標本検定` | `## Two-Sample Test` |
| `続いて二標本の検定について考えよう。実験群と統制群のように，無作為割り当てをすることで平均因果効果をみる際に行われるのが，この検定である。帰無仮説は「群間差はない」であり，対立仮説はその否定である。また，正規母集団からの標本を仮定するので，検定統計量はここでもt分布に従う値になる。帰無仮説検定の手順に沿って，改めて確認しておこう。` | `Let's now consider the test of two samples. This test is performed when looking at the average causal effect by randomly assigning groups, like an experimental group and a control group. The null hypothesis is that "there is no difference between the groups," and the alternative hypothesis is the negation of that. Also, assuming samples from a normal population, the test statistic here also follows a t-distribution. Let's confirm this again following the procedure of the null hypothesis test.` |
| `1. 帰無仮説は「二群の母平均に差がない」である。二群の母平均をそれぞれ$\mu_1,\mu_2$とすると，帰無仮説は$\mu_1 = \mu_2$，あるいは$\mu_1 - \mu_2 = 0$と表される。対立仮説は$\mu_1 \neq \mu_2$あるいは$\mu_1-\mu_2 \neq 0$である。` | `1. The null hypothesis is "There is no difference in the mean of the two groups." If we denote the mean of the two groups as $\mu_1$ and $\mu_2$ respectively, the null hypothesis is represented as $\mu_1 = \mu_2$ or $\mu_1 - \mu_2 = 0$. The alternative hypothesis is $\mu_1 \neq \mu_2$ or $\mu_1-\mu_2 \neq 0$.` |
| `2. 検定統計量は，正規母集団から得られる標本平均が従う標本分布であり，母分散が未知の場合の区間推定に用いたT統計量になる。` | `2. The test statistic is a sampling distribution of sample means derived from a normal population. In case of unknown population variance, it becomes the T statistic used for interval estimation.` |
| `3. 判断基準は心理学の慣例に沿って5%とする。` | `3. We will set the criterion of judgment at 5%, following the convention in psychology.` |
| `これを検証するために，サンプルデータを乱数で生成しよう。` | `Let's generate random sample data to verify this.` |
| `まず，各群のサンプルサイズを`n1,n2`とする。ここでは話を簡単にするため，サンプルサイズは両群ともに`10`とした。つぎに両群の母平均だが，群1の母平均を$\mu_1$，群2の母平均を$\mu_2 = \mu_1 + d$で表現した。この`d`は差分であり，これが$d=0$であれば母平均が等しいこと，$d \neq 0$であれば母平均が異なることになる。最後に両群の母SDを設定した。` | `First, let’s denote the sample sizes of each group as `n1` and `n2`. To keep things simple, this example assumes that the sample size of both groups is `10`. Then we proceed to the mean of both groups. We expressed the first group's population mean as $\mu_1$, and the second group's population mean as $\mu_2 = \mu_1 + d$. The `d` represents the difference. If `d=0`, the population means are equal, and if `d \neq 0`, the population means are different. At the end, we set the population standard deviation (SD) for both groups.` |
| `ここでの検定は，この差分$d$が母平均0の母集団から得られたと判断して良いかどうか，という形で行われる。検定統計量$T$は，次式で算出されるものである。` | `The test conducted here assesses whether it is reasonable to assume that this difference, $d$, arises from a population with a mean of zero. The test statistic $T$ is calculated using the following formula.` |
| `$$ T = \frac{d - \mu_0}{\sqrt{U^2_p/\frac{n_1n_2}{n_1+n_2}}}$$` | `Without specific Japanese text provided, the translation cannot be accomplished. The formula presented appears to be a statistical test formula, likely relevant for determining a T-score in experimental psychology or similar fields. It isn't in Japanese and therefore doesn't require translation. It's advisable to provide the Japanese text to be translated.` |
| `ここで$U^2_p$はプールされた不偏分散と呼ばれ，二群を合わせて計算された全体の母分散推定量である。各群の標本分散をそれぞれ$S^2_1, S^2_2$とすると，次式で算出される。` | `Here, $U^2_p$ is called the pooled unbiased variance, which is an estimate of the overall population variance calculated by combining the two groups. If we denote the sample variances of each group as $S^2_1, S^2_2$, they are calculated by the following equation.` |
| `$$ U^2_p = \frac{n_1S^2_1+ n_2S^2_2}{n_1 + n_2 -2} $$` | `You've encountered a mathematical formula! This formula looks more complex than it actually is. Don't worry, we will break it down for you.

$$ U^2_p = \frac{n_1S^2_1+ n_2S^2_2}{n_1 + n_2 -2} $$

This is a typical formula for Pooled Variance, denoted here as $ U^2_p $. Pooled variance is a type of weighted average of the variances of two or more groups.

In the numerator of the fraction, you have `n_1S^2_1 + n_2S^2_2`, which represents the sum of the product of each group size `n` and its variance `S^2`. Here, `n_1` and `S^2_1` refer to the size and variance of Group 1, while `n_2` and `S^2_2` are the size and variance of Group 2.

The denominator, `n_1 + n_2 - 2`, is the total number of observations from both groups minus 2. This serves to adjust the variance calculation, taking into account the degrees of freedom in the data.

To understand this in simpler terms, think of pooled variance as a way to find the "average scatter" in your data when you're looking at more than one group at a time. It's an essential tool for understanding and interpreting data, helping you uncover the underlying patterns in your analysis.

Understanding these mathematical concepts is key to mastering psychological statistics with R and RStudio. So, keep practicing, and don't hesitate to ask questions as they come up. Keep up the good work!` |
| `これらの式はつまり，サンプルサイズの違いを考慮するため，一旦両群の標本分散に各サンプルサイズを掛け合わせ，プールした全体のサンプルサイズから各々$-1$をすることで全体として不偏分散にしている。` | `In essence, these formulas consider differences in sample sizes. They provide unbiased variance for the entire pool by first multiplying the sample variance of each group by their respective sample sizes, then subtracting $1$ from the total sample size of the pool.` |
| `これを踏まえて，具体的な数字で見ていこう。` | `With that in mind, let's take a look at the specific numerical data.` |
| `その上で乱数でデータを生成し，その標本平均を確認した上で，`t.test`関数によって検定を行っている。` | `In addition, we generate data with random numbers, confirm the sample mean, and then conduct a test using the `t.test` function.` |
| `n1 <- 10` | `n1 <- 10` |
| `n2 <- 10` | `n2 <- 10` |
| `mu1 <- 4` | `mu1 <- 4` |
| `sigma <- 1` | `sigma <- 1` |
| `d <- 1` | `d <- 1` |
| `mu2 <- mu1 + (sigma * d)` | `mu2 <- mu1 + (sigma * d)` |
| `set.seed(42)` | `set.seed(42)` |
| `X1 <- rnorm(n1, mean = mu1, sd = sigma)` | `X1 <- rnorm(n1, mean = mu1, sd = sigma)` |
| `X2 <- rnorm(n2, mean = mu2, sd = sigma)` | `X2 <- rnorm(n2, mean = mu2, sd = sigma)` |
| `X1 %>%` | `X1 %>%` |
| `mean() %>%` | `mean() %>%` |
| `round(3) %>%` | `round(3) %>%` |
| `print()` | `print()` |
| `X2 %>%` | `X2 %>%` |
| `mean() %>%` | `mean() %>%` |
| `round(3) %>%` | `round(3) %>%` |
| `print()` | `print()` |
| `result <- t.test(X1, X2, var.equal = TRUE)` | `result <- t.test(X1, X2, var.equal = TRUE)` |
| `print(result)` | `print(result)` |
| `今回の母平均は$\mu_1 = 4, \mu_2 = 4+1$にしているが，標本平均は`r round(mean(X1),3)`と`r round(mean(X2),3)`であり，標本上では大きな差が見られなかった。結果として，t値は`r abs(result$statistic)`であり，自由度`r result$parameter`のもとでのp値は`r result$p.value`である。5%水準を上回る値であるから，結論としては対立仮説を採択するには至らない，差があるとはいえない，である。` | `In this instance, we have set the population means to $\mu_1 = 4, \mu_2 = 4+1$. However, the sample means are `r round(mean(X1),3)` and `r round(mean(X2),3)`, respectively, and no significant difference is observed in the samples. Consequently, the t value is `r abs(result$statistic)`, and the p-value under the degrees of freedom `r result$parameter` is `r result$p.value`. As this exceeds the 5% level, we cannot conclude to accept the alternative hypothesis, in other words, we cannot claim there is a significant difference.` |
| `今回の設定では母平均に差があるはず($4 \neq 4 + 1$)なのだから，これは誤った判断で，タイプ2エラーが生じているケースということになる。研究実践場面では，母平均やその差については知り得ないのだから，このような判断ミスが生じていたかどうかは分かり得ないことに留意しよう。` | `In this setup, there should be a difference in the population mean ($4 \neq 4 + 1$), so this is a case where a type II error is being made, which is an incorrect judgment. In practical research settings, note that it would be impossible to know whether such a judgment error occurred, as we have no way of knowing about the population mean or any differences in it.` |
| `なお，ここではわかりやすく2群であることを示すために`X1`,`X2`と2つのオブジェクトを用意したが，実践的にはデータフレームの中で群わけを示す変数があり，`formula`の形で次のように書くことが多いだろう。` | `Moreover, in this case, to indicate that there are two groups for easy understanding, we prepared two objects, `X1` and `X2`. However, in practice, there is often a variable indicating group divisions within the data frame, which you would likely write in the form of a `formula` as follows.` |
| `dataSet <- data.frame(group = c(rep(1,n1),rep(2,n2)), value = c(X1,X2)) %>%` | `dataSet <- data.frame(group = c(rep(1,n1),rep(2,n2)), value = c(X1,X2)) %>%` |
| `mutate(group = as.factor(group))` | `mutate(group = as.factor(group))` |
| `t.test(value ~ group, data = dataSet, var.equal = TRUE)` | `t.test(value ~ group, data = dataSet, var.equal = TRUE)` |
| `## 二標本検定(ウェルチの補正)` | `## Two-Sample Test (Welch's Correction)` |
| `先ほどのt.test関数には，`var.equal = TRUE`というオプションが追加されていた。これは2群の分散が等しいと仮定した場合の検定になる。t検定は歴史的にこちらが先に登場しているが，2群の分散が等しいかどうかはいきなり前提できるものでもない。等分散性の検定は，Levene検定を行うのが一般的であり，R においては，`car`パッケージや`lawstat` パッケージが対応する関数を持っている。ここでは`car`パッケージの `leveneTest`関数を用いる例を示す。` | `The previous t.test function added an option, `var.equal = TRUE`. This is a test that assumes equal variances between the two groups. While t-tests historically first appeared in this form, it's not a premise that can be immediately made whether the variances of the two groups are equal. Testing for equality of variances is typically done using the Levene test, and in R, the `car` and `lawstat` packages provide corresponding functions. Here, we will show an example using the `leveneTest` function from the `car` package.` |
| `library(car)` | `library(car)` |
| `leveneTest(value ~ group, data = dataSet, center = mean)` | `leveneTest(value ~ group, data = dataSet, center = mean)` |
| `この結果を見ると，p値から明らかなように，2群の分散が等しいという帰無仮説が棄却**できなかった**ので，等しいと考えてt検定に進むことができる。もしこれが棄却されてしまったら，2群の分散が等しいという帰無仮説が成り立たないのだから，等分散性の仮定を外す必要がある。実行は簡単で，`var.equal`を`FALSE`にすれば良い。` | `Upon reviewing the results, as indicated by the p-value, we were unable to reject the null hypothesis that the variances of the two groups are equal. Consequently, we can presume their equality and proceed to the t-test. If we were to reject this, it would mean that the null hypothesis of equal variances does not hold. In this case, we would need to remove the assumption of equal variances. The execution is straightforward: simply set `var.equal` to `FALSE`.` |
| `result2 <- t.test(value ~ group, data = dataSet, var.equal = FALSE)` | `result2 <- t.test(value ~ group, data = dataSet, var.equal = FALSE)` |
| `print(result2)` | `print(result2)` |
| `よく見ると，タイトルがWelch Two Sample t-testに変わっている。Welchの補正が入ったt検定という意味である。また自由度が実数(`r result2$paramter`)になっているが，このようにt分布の自由度を調整することで等分散性の仮定から逸脱した場合の補正となる。もちろん報告する際は「$t($ `r round(result2$parameter,3)` $)=$ `r round(result2$statistic,3)`, $p=$ `r round(result2$p.value,3) `」のように書くことになるから，自由度が実数であれば補正済みであると考えられるだろう。` | `Upon closer inspection, the title has changed to Welch Two Sample t-test. This refers to a t-test with Welch's adjustment applied. You may also have noticed that the degrees of freedom has become a real number (`r result2$parameter`). By adjusting the degrees of freedom in this way, it is possible to correct for deviations from the assumption of homoscedasticity. Of course, when reporting this, one would write it as "$ t($ `r round(result2$parameter,3)` $) = $ `r round(result2$statistic,3)`, $p = $ `r round(result2$p.value,3) `". Therefore, it can be considered that if the degrees of freedom are real, they are adjusted.` |
| `しかし，分散が等しいという仮定は，等しくない場合の特殊系であるから，最初からWelchの補正がはいった検定だけで十分である。このような考え方から，Rにおける`t.test` 関数のデフォルトでは`var.equal = FALSE`となっており，特段の指定をしなければ等分散性の仮定をしない。こちらの方が検定を重ねることがないので，より望ましい。` | `However, the assumption of equal variance is a special system for cases where it is not equal, so it's sufficient to only use the Welch’s adjusted test from the start. From this perspective, the default setting for the 't.test' function in R is 'var.equal = FALSE', and it does not assume equal variance unless specifically specified. This is more desirable as it eliminates the need for repeated testing.` |
| `## 対応のある二標本検定` | `## Paired Two-Sample T-Test` |
| `## レポートを書くような課題` | `## Assignments Similar to Writing a Report` |
