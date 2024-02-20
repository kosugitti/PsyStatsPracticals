| 原文 | 翻訳 |
|---|---|
| `# 統計的仮説検定(Null Hypothesis Statistical Testing)` | `# Statistical Hypothesis Testing (Null Hypothesis Statistical Testing)` |
| `帰無仮説検定は，心理学における統計の利用シーンの代表的なものだろう。` | `Null hypothesis testing is likely a representative scene of using statistics in psychology.` |
| `その手順は形式化されており，統計パッケージによってはデータの種類を指定するだけで自動的に結果の記述までしてくれるものもあるほどである。誰がやっても同じ結果になり，また，機械的に手続きを自動化できることは大きな利点ではある。欠点は，初学者がそのメカニズムを十分に理解せずに誤った結果を得たり，悪意のある利用者が自分に都合の良い数字を出させたりすることにある。科学的営みは悪意をもった実践者を想定しておらず，もしそのような悪例が露見した場合には事後的に摘発・対処するしかない。しかし残念なことながら，初学者の浅慮や意図せぬ悪用も多くみられる。` | `These procedures are formalized, and some statistical packages can automatically provide results just by specifying the type of data. It has the significant advantage of yielding the same results for anyone who carries out the procedures and allowing for automation of these procedures. Its downside, however, is that beginners might obtain erroneous results without fully understanding the mechanisms, or malicious users could manipulate the results to their advantage. Scientific endeavors don't typically anticipate malevolent practitioners, and if such misconduct emerges, the only recourse is to expose and address it after the fact. Regrettably, we often see careless mistakes and unintended misuse among beginners.` |
| `心理学において，先行研究の結果が再現しないことを再現性問題というが，そのひとつは統計的手法の誤った使い方にあるとされる[@Ikeda2016]。改めて，丁寧に帰無仮説検定の手続きやロジックを見ていくことにしよう。` | `In psychology, the failure to replicate the results of previous studies is referred to as the replication crisis, one cause of which is considered to be the improper use of statistical methods [@Ikeda2016]. Let's take a moment to revisit and carefully examine the procedures and logic behind null hypothesis testing.` |
| `## 帰無仮説検定の理屈と手続き` | `## The Logic and Procedures of Null Hypothesis Testing` |
| `### 帰無仮説検定の目的` | `### The Purpose of Null Hypothesis Testing` |
| `帰無仮説検定は，実験や調査で得たデータから得られた知見が意味のあるものかどうか，母集団の性質として一般化可能かどうかを判定するための枠組みである。手法と判断基準が明確なゲームの一種だと考えたよう。というのも，帰無仮説検定は**有意水準**という基準を設けて，**帰無仮説**と**対立仮説**という2つの考え方(モデル)を対決させ，勝敗を決するものだからである。勝敗を決するとしたのは，帰無仮説と対立仮説は排他的な関係にあるからであり，どちらも正しいとかどちらも間違っているという結末にはならないからである。ただし，あくまでも推測統計的なロジックに基づく判定であるから，判定結果にも確率的な要素が含まれる。本当は帰無仮説が正しい時に，間違って「対立仮説が正しい」と判定してしまう確率はゼロではない。逆に帰無仮説が正しくない時に，間違って「対立仮説が正しくない(帰無仮説が正しい)」と判定してしまう可能性もある。前者を**タイプ1エラー**，後者を**タイプ2エラー**という。どちらの確率もゼロであってほしいが，そうはならないので，前者を$\alpha$，後者を$\beta$としたときに，それぞれを一定の水準以下に抑えたい。この目的のために手順を整え，一般化したのが帰無仮説検定である。なお，先に述べた有意水準は，この$\alpha$の許容される水準であり，心理学では一般に5%に設定する。` | `The null hypothesis testing is a framework used to determine whether the findings obtained from the data collected through experiments or surveys carry any significance, and whether these can be generalized as characteristics of the population. It can be thought of as a kind of game with explicit methods and criteria. That's because null hypothesis testing involves a showdown between two models (approaches) known as the "null hypothesis" and the "alternative hypothesis," using a criterion called the "significance level" to determine the victor. The reason we use terms like victories or defeats is that the null hypothesis and the alternative hypothesis are in an exclusive relationship - it won't end in a conclusion where both are correct or both are wrong. However, we must remember, since the judgments are based on stochastic statistical logic, the results also involve elements of probability. The likelihood of erroneously adjudging the alternative hypothesis as right when the null hypothesis is, in fact, correct is not nil. Conversely, there is also a chance of wrongly ruling that the alternative hypothesis is incorrect (or the null hypothesis is correct) when in reality the null hypothesis is not correct. The former is known as a "Type 1 Error", and the latter as a "Type 2 Error". While we would like both these probabilities to be zero, that's not how it turns out, so when we denote Type 1 error as $\alpha$ and Type 2 error as $\beta$, we aim to keep both under a certain level. The null hypothesis testing was generalized and regulated procedure for this purpose. The aforementioned significance level is the allowable level for this $\alpha$, which is commonly set at 5% in psychology.` |
| `このように帰無仮説検定という考え方は，エラーの統制が本来の狙いであるから，「有意になるように工夫する」という発想は根本的に間違っている。また，統計的推定という数学的手続きに，人間が納得しやすい判定を下すという人為的手続きが組み合わさったものであるから，帰無仮説検定の結果に過剰な意味を持たせたり一喜一憂したりすることがないように注意しよう。` | `Thus, the concept of null hypothesis testing is fundamentally misguided by the idea of "manipulating to become significant," as the original intention is to control errors. Moreover, since statistical estimation is a mathematical procedure combined with a human intervention to make judgments that are easy for humans to accept, care should be taken not to attach excessive meaning to the results of null hypothesis testing or to become overly excited or discouraged by them.` |
| `### 帰無仮説検定の手続き` | `### Procedure for Null Hypothesis Testing` |
| `帰無仮説検定の手続きを一般化すれば，次のようになる。` | `When we generalize the procedure for null hypothesis testing, it becomes as follows.` |
| `1. 帰無仮説と対立仮説を設定する。` | `1. Setting up the null hypothesis and alternative hypothesis.` |
| `2. 検定統計量を選択する。` | `2. Choose a Test Statistic.` |
| `3. 判定基準を決定する。` | `3. Establishing the criteria for judgement.` |
| `4. 検定統計量を計算する。` | `4. Calculate the test statistic.` |
| `5. 判定する。` | `5. Make a decision.` |
| `帰無仮説検定は，群間の平均値に差があるかどうか，相関係数に統計的な意味があるかどうかといった事例に対して適用される。` | `Null hypothesis testing is applied to instances to determine whether there is a difference in the mean values between groups or whether there is statistical significance in the correlation coefficients.` |
| `当然のことながら，これは標本から母集団を推定するという文脈における話で，物理学的な真偽を理論的に判断するとか，全数調査のように母集団全体の情報が手に入る場合といった場合の話ではない。また，標本のサンプルサイズが小さく，標本統計量の信頼区間が大きいことから，枠組みなしには判定できないという背景があることも再確認しておこう。` | `Of course, this discussion is about estimating a population from a sample, and does not pertain to contexts such as theoretically judging the truth in physics, or instances where information of the entire population is available, like a census. Additionally, let's remind ourselves that the sample size is small and the confidence interval of the sample statistic is large, which means it cannot be determined without a framework.` |
| `母集団の状態がわからないので，仮説を設定する。帰無仮説Null Hypothesisは空っぽの仮説という意味で，母平均差がない(差がゼロ，$\mu_1 - \mu_2 = 0$)とか，母相関がゼロ($\rho = 0$)である，とされる。対立仮説Alternative Hypothesisは帰無仮説と排他的な関係にある仮説としてつくられるから，「差が無くはない($\mu_1 - \mu_2 \neq 0$)」「相関がゼロではない($\rho \neq 0$)」という表現になる。なぜ帰無仮説がゼロであることから始められるかといえば，ふたつの排他的な仮説を考えた時にゼロでない状態というのは無数にあり得るので，仮説として特定できないからである(差が1のとき，1.1のとき，1.11のとき・・・と延々と検定し続けるわけにもいくまい)。` | `As we cannot understand the state of the population, we set up a hypothesis. The Null Hypothesis reflects the idea of an "empty" hypothesis, stating that there is no mean difference (the difference is zero, $\mu_1 - \mu_2 = 0$) or the population correlation is zero ($\rho = 0$). The Alternative Hypothesis is created as a hypothesis that has an exclusive relationship with the Null Hypothesis, hence it is expressed in terms like "there is not no difference ($\mu_1 - \mu_2 \neq 0$)" and "the correlation is not zero ($\rho \neq 0$)".

You may wonder why we start with the Null Hypothesis being zero. This is because when we think about two exclusive hypotheses, there are countless situations in which the state is not zero, so it cannot be specifically asserted as a hypothesis (it wouldn't make sense to keep testing it indefinitely when the difference is 1, 1.1, 1.11, and so on).` |
| `検定統計量の選択は，二群の平均値差のときは$t$，三群以上の時は$F$，相関係数の検定も$t$，と天下り的に示されることが一般的である。もちろんこれらの統計量が選ばれるのは，数理統計的な論拠に基づいている。判定基準は5%水準とすることが一般的だし，検定統計量の計算はアルゴリズムに沿って機械的に可能である。判定は客観的な指標に基づいて行われるから，「どの状況でどのような帰無仮説をおくか」が類型化できれば，この手続き全体が自動的に進められる。` | `The selection of test statistics is generally presented in a given manner, such as using 't' for the difference in mean values between two groups, 'F' for three or more groups, and 't' for testing correlation coefficients. These statistics are selected based on mathematical and statistical evidence. It's common to use a threshold of a 5% level for deciding. As the calculation of test statistics can be mechanically done according to algorithms, decisions are made based on objective indicators. Consequently, if we can categorize "what null hypothesis should be set in which situation", then this entire procedure can be carried out automatically.` |
| `しかしここでは改めて，丁寧に手順を追いながらみてみよう。` | `However, let's take a careful look at the process again here, following each step meticulously.` |
| `## 相関係数の検定` | `## Testing the Correlation Coefficient` |
| `ここでは相関係数の検定を例に取り上げる。俗に「無相関検定」と呼ばれるように，相関がどれほど大きいとかどれほど意味があるということをチェックするのでは無く，無相関ではない，ということをチェックする。もちろん標本相関は計算してゼロでなければ，それは無相関ではない。ここで考えたいのは，母相関がゼロではないということである。言い換えると，母相関がゼロの状態であっても，標本相関がゼロでないことは，小標本のサンプリングという背景のもとでは当然のことである。` | `We will look at the test of the correlation coefficient, commonly referred to as the "correlation absence test." Instead of checking how big the correlation is or how significant it is, we check if it's not uncorrelated. Of course, if the sample correlation is calculated and isn't zero, then it's not uncorrelated. What we want to consider here is that the population correlation is not zero. In other words, even if the population correlation is in a state of zero, the fact that the sample correlation isn't zero is a natural thing under the context of sampling a small sample.` |
| `確認してみよう。まず，無相関なデータセットを作ることを考える。Rの`MASS`パッケージを使い，多変量正規分布の確率分布関数から乱数を生成しよう。` | `Let's check it out. First, consider creating an uncorrelated dataset. Use the `MASS` package in R, and generate random numbers from the probability distribution function of a multivariate normal distribution.` |
| `library(MASS)` | `library(MASS)` |
| `set.seed(12345)` | `set.seed(12345)` |
| `N <- 100000` | `N <- 100000` |
| `X <- mvrnorm(N,` | `X <- mvrnorm(N,` |
| `mu = c(0, 0),` | `mu = c(0, 0),` |
| `Sigma = matrix(c(1, 0, 0, 1), ncol = 2),` | `Sigma = matrix(c(1, 0, 0, 1), ncol = 2),` |
| `empirical = TRUE` | `empirical = TRUE` |
| `)` | `)` |
| `head(X)` | `head(X)` |
| `ここでは`r N`個の乱数を生成した。つくられたオブジェクト`X`は表示されているように，2変数からなる。ここでは相関のある2変数を想定しており，各変数がそれぞれ標準正規分布に従っているという設定である。`rnorm`関数を2つ使って2変数をつくっても良いのだが，2変数セットで取り出すことを考えると多変量正規分布をかんがえることになる。多変量正規分布は，ひとつひとつの変数については正規分布として平均とSDをもち，かつ，変数の組み合わせとして共分散をもつものである。`mvrnorm`の引数をみると，`mu`は平均ベクトルであり，`Sigma`が分散共分散行列である。分散共分散行列とは，ここでは$2\times 2$の正方行列であり，対角項に分散を，対角項に共分散をもつ行列である。共分散は標準偏差と相関係数の積で表される。` | `We have generated `r N` random numbers here. The object `X` that we created consists of two variables, as shown. The assumption here is that we are working with two variables that are correlated and follow a standard normal distribution. One could use the `rnorm` function twice to create the two variables but considering that we would derive them as a two-variable set, it leads us to contemplate a multivariate normal distribution. The multivariate normal distribution has a mean and standard deviation (SD) for each individual variable and also possesses covariance for variable combinations. Looking at the arguments for `mvrnorm`, `mu` represents a mean vector and `Sigma` is the variance-covariance matrix. Here, the variance-covariance matrix is a $2 \times 2$ square matrix, where diagonal elements represent variance and off-diagonal elements represent covariance. Covariance is expressed as the product of standard deviation and correlation coefficient.` |
| `**分散**` | `**Variance**` |
| `$$ s_x^2 = \frac{1}{n}\sum (x_i - \bar{x})^2 =  \frac{1}{n}\sum (x_i - \bar{x})(x_i - \bar{x})$$` | `The above formula calculates the variance, denoted as \( s_x^2 \), for a given set of data. It is calculated by summing the squares of the differences between each data point \( x_i \) and the mean of the data set \( \bar{x} \). This sum is then divided by the number of data points, \( n \), to calculate the variance. This average of squared differences from the mean represents how spread out the data is. As you can see, each difference \( (x_i - \bar{x}) \) is squared before being summed to ensure all differences are treated as positive values.` |
| `**標準偏差**` | `**Standard Deviation**` |
| `$$ s_x = \sqrt{s_x^2} = \sqrt{\frac{1}{n}\sum (x_i - \bar{x})^2}$$` | `This equation represents the standard deviation (s_x), which is derived from the square root of variance (s_x²). The variance is calculated by summing up the squared differences between each observation in a dataset (represented as x_i) and the mean of the dataset (represented as x̄), and then dividing this total by the number of observations in the dataset (represented as n).` |
| `**共分散**` | `**Covariance**` |
| `$$ s_{xy} = \frac{1}{n}\sum (x_i - \bar{x})(y_i - \bar{y})$$` | `This formula calculates the covariance between two variables. In this equation, "s_xy" represents the covariance of the variables x and y. The summation sign Σ (sum) is used to add together the products of each pair of corresponding elements in the x and y data sets. "x_i" and "y_i" are the individual data points in the variables x and y, while "n" signifies the total number of data points. The terms "\bar{x}" and "\bar{y}" denote the means of the x and y variables respectively. 

This measurement of covariance allows us to understand and quantify the relationship between two variables. A positive covariance indicates that the two variables tend to increase or decrease together, while a negative covariance suggests that one variable tends to increase when the other decreases.` |
| `**相関係数**` | `**Correlation Coefficient**` |
| `$$r_{xy} = \frac{s_{xy}}{s_xs_y} = \frac{\frac{1}{n}\sum (x_i - \bar{x})(y_i - \bar{y})}{\sqrt{\frac{1}{n}\sum (x_i - \bar{x})^2}\sqrt{\frac{1}{n}\sum (y_i - \bar{y})^2}}$$` | `The formula above is for computing the correlation coefficient (r_xy) between two variables, x and y. The correlation coefficient, often denoted as r, measures the strength and direction of a linear relationship between two variables. It's a unit-less measure ranging from -1 to +1, where -1 suggests a perfect negative linear relationship and +1 indicates a perfect positive linear relationship.

Let's break down this formula:

- $x_i$ and $y_i$ are the individual sample points indexed with i.
- $\bar{x}$ and $\bar{y}$ represent the mean (average) of the x and y variables.
- $s_{xy}$, in the numerator, is the covariance of x and y, which is the average of the product of their deviations from their respective means.
- $s_x$ and $s_y$, in the denominator, represent the standard deviations of x and y respectively. The standard deviation is a measure of how spread out the numbers are from their average value, larger values indicating more variability.

In sum, the correlation coefficient equals the covariance of x and y divided by the product of their standard deviations.

Learning and implementing such statistical calculations in R and RStudio will give you a better understanding and control over your data analysis process, helping you tease out meaningful patterns and relationships. These tools allow us to perform complex statistics with ease, alleviating the manual math work seen above. But understanding the underlying math continually lays the foundation for deeper and more insightful analysis.` |
| `**分散共分散行列**` | `**Variance-Covariance Matrix**` |
| `$$\Sigma = \begin{pmatrix} s_x^2 & s_{xy} \\ s_{yx} & s_y^2 \end{pmatrix}` | `$$\Sigma = \begin{pmatrix} s_x^2 & s_{xy} \\ s_{yx} & s_y^2 \end{pmatrix}
\end{document}$$

This formula expresses a covariance matrix. In this matrix:

$s_x^2$ represents the variance of X,
$s_y^2$ stands for the variance of Y,
$s_{xy}$ and $s_{yx}$ denote the covariance between X and Y.

Variance is a measure that exhibits how much a set of values spreads out, while covariance provides insight into how much two variables vary together. These values play a crucial role in various statistical operations and analyses.` |
| `= \begin{pmatrix} s_x^2 & r_{xy}s_xs_y \\ r_{xy}s_xs_y & s_y^2 \end{pmatrix}$$` | `You didn't provide any Japanese text to translate into English. If you need to translate something, please provide the Japanese text.` |
| `今回`Sigma = matrix(c(1,0,0,1),ncol = 2)`としたのは，この2変数が無相関であること(SDはそれぞれ1であること)を指定している。ちなみに`empirical = TRUE`のオプションは，生成された乱数が設定した分散共分散行列のもつ相関係数と一致するように補正することを意味している。` | `The reason for using `Sigma = matrix(c(1,0,0,1),ncol = 2)` is to state that these two variables are uncorrelated and that their standard deviations are each 1. By the way, the option `empirical = TRUE` means it will adjust the generated random numbers to match the correlation coefficient of the variance-covariance matrix that has been set.` |
| `可視化しておこう。つくられた乱数が無相関であることを，散布図を使って確認する。` | `Let's visualize this. We will verify that the created random numbers are uncorrelated by using a scatter diagram.` |
| `#| fig.height: 5` | `#| fig.height: 5` |
| `#| fig.width: 5` | `#| fig.width: 5` |
| `#| dev: "ragg_png"` | `#| dev: "ragg_png"` |
| `library(tidyverse)` | `library(tidyverse)` |
| `X %>%` | `X %>%` |
| `as.data.frame() %>%` | `as.data.frame() %>%` |
| `ggplot(aes(x = V1, y = V2)) +` | `ggplot(aes(x = V1, y = V2)) +` |
| `geom_point()` | `geom_point()` |
| `数値的にも確認しておこう。` | `Let's also verify this numerically.` |
| `cor(X) %>% round(5)` | `cor(X) %>% round(5)` |
| `つくられた乱数が無相関であることが確認できた。さてこれが母集団であったとして，ここからたとえば`n = 20`のサンプルをとったとする。この時の相関はどうなるだろうか。` | `We have confirmed that the generated random numbers are uncorrelated. Now, assuming this is the population, let's say we take a sample of `n = 20` from here. What would the correlation be at this time?` |
| `Rで計算してみよう。`sample`関数をつかって抜き出す行を決めて，該当する行だけ`s1`オブジェクトに代入する。その上で相関係数を計算してみよう。` | `Let's do some calculations using R. Decide which rows to extract using the `sample` function, and assign only the corresponding rows to the `s1` object. Then let's try calculating the correlation coefficient.` |
| `selected_row <- sample(1:N, 20)` | `selected_row <- sample(1:N, 20)` |
| `print(selected_row)` | `print(selected_row)` |
| `s1 <- X[selected_row, ]` | `s1 <- X[selected_row, ]` |
| `cor(s1)` | `cor(s1)` |
| `今回の相関係数は`r cor(s1)[1,2]`となった。母集団の相関係数が0であっても，適当に抜き出した20点が相関係数を持ってしまう(0でない)ことはあり得ることなのである。問題は，これがどの程度あり得ることなのか，である。いいかえると，研究者が$n=20$のサンプルをとって相関を得た時，それが$r = 0.14$であったとしても，母相関$\rho = 0.0$からのサンプルである可能性がどれぐらいあるか，ということである。` | `The correlation coefficient this time turned out to be `r cor(s1)[1,2]`. Even if the population correlation is 0, it's possible for a randomly selected 20 points to have a correlation coefficient (not 0). The question is, to what extent is this possible? In other words, if a researcher obtains a correlation using a sample of $n=20$ and it turns out to be $r = 0.14$, how likely is it that the sample came from a population correlation of $\rho = 0.0$?` |
| `## 標本相関係数の分布と検定` | `## Distribution and Testing of Sample Correlation Coefficients` |
| `標本相関係数は確率変数なので，毎回標本を取る度に値が変わるし，どの実現値がどの程度出現するかは標本分布で表現できる。` | `The sample correlation coefficient is a random variable, so its value changes each time a sample is taken, and the degree to which each value appears can be represented by the sample distribution.` |
| `ではどのような標本分布に従うのだろうか。先ほどのサンプリングを繰り返して，乱数によって近似してみよう[^7.1]。` | `So, what kind of sampling distribution might we follow? Let's try to approximate it by repeating the previous sampling and through the use of random numbers[^7.1].` |
| `[^7.1]: このような二度手間を取らず，`mvrnorm`からサンプルサイズ20の乱数を反復生成しても良い。母集団を具体的なものとしてイメージするために，母相関が`0`の母集団からサンプリングを繰り返す方法をとった。` | `[^7.1]: You can streamline this process by iteratively generating random numbers of sample size 20 from `mvrnorm`. To have a concrete image of the population, we chose the method of repeatedly sampling from a population with a parent correlation of `0`.` |
| `iter <- 10000` | `iter <- 10000` |
| `samples <- c()` | `samples <- c()` |
| `for (i in 1:iter) {` | `for (i in 1:iter) {` |
| `selected_row <- sample(1:N, 20)` | `selected_row <- sample(1:N, 20)` |
| `s_i <- X[selected_row, ]` | `s_i <- X[selected_row, ]` |
| `cor_i <- cor(s_i)[1, 2]` | `cor_i <- cor(s_i)[1, 2]` |
| `samples <- c(samples, cor_i)` | `samples <- c(samples, cor_i)` |
| `}` | `}` |
| `df <- data.frame(R = samples)` | `df <- data.frame(R = samples)` |
| `# ヒストグラムの描画` | `# ヒストグラムの描画` |
| `g <- df %>%` | `g <- df %>%` |
| `ggplot(aes(x = R)) +` | `ggplot(aes(x = R)) +` |
| `geom_histogram(binwidth = 0.01)` | `geom_histogram(binwidth = 0.01)` |
| `print(g)` | `print(g)` |
| `ヒストグラムを見ると，サンプルサイズが20の場合，母相関係数$\rho = 0.0$であっても$r = 0.3$や$r=0.4$程度の標本相関が出現することはある程度みられることである。` | `When we examine the histogram, it can be seen that even in instances where the population correlation coefficient $\rho = 0.0$ and the sample size is 20, sample correlations around $r = 0.3$ or $r = 0.4$ can still occur to a certain extent.` |
| `また，標本分布は左右対称の何らかの理論分布に従っていそうだ。数理統計学の知見から，相関係数の場合，標本相関係数を次の式によって変換することで，自由度が$n-2$の$t$分布に従うことが知られている。` | `Moreover, it seems that the sample distribution follows some symmetric theoretical distribution. From the findings of mathematical statistics, it is known that for the correlation coefficient, by converting the sample correlation coefficient using the following formula, it follows a t-distribution with degrees of freedom of $n-2$.` |
| `$$ t = \frac{r\sqrt{n-2}}{\sqrt{1-r^2}} $$` | `In the field of psychology, it's crucial to grasp the basics of statistics, specifically how to conduct a correlation analysis. You may confront this formula while dealing with such analysis:

$$ t = \frac{r\sqrt{n-2}}{\sqrt{1-r^2}} $$

This can look a little daunting at first, but don't worry, let's break it down. This is the formula to calculate the value of 't'. Here, 't' is the t-statistic, 'r' is the correlation coefficient, and 'n' is the number of data pairs. This t-statistic is commonly used in hypothesis testing, specifically when dealing with Pearson's correlation. Remember, understanding this foundational statistical formula is vital to grasp more complex psychological analysis and concepts we will explore further. Using R and RStudio makes such statistical analysis more efficient and accessible.` |
| `df %>%` | `df %>%` |
| `mutate(T = R * sqrt(18) / sqrt(1 - R^2)) %>%` | `mutate(T = R * sqrt(18) / sqrt(1 - R^2)) %>%` |
| `ggplot(aes(x = T)) +` | `ggplot(aes(x = T)) +` |
| `geom_histogram(aes(y = after_stat(density)), binwidth = 0.1) +` | `geom_histogram(aes(y = after_stat(density)), binwidth = 0.1) +` |
| `# 自由度18のt分布の確率密度関数を追加` | `# 自由度18のt分布の確率密度関数を追加` |
| `stat_function(fun = dt, args = list(df = 18), color = "red", linewidth = 2) +` | `stat_function(fun = dt, args = list(df = 18), color = "red", linewidth = 2) +` |
| `# Y軸のラベルを変更` | `# Y軸のラベルを変更` |
| `ylab("Density")` | `ylab("Density")` |
| `これを利用して相関係数の検定が行われる。以下，サンプルサイズ20で標本相関係数が$r=0.5$だったとして，手順に沿って解説する。` | `We will use this to perform a test of correlation coefficient. Below, assuming a sample correlation coefficient of $r=0.5$ with a sample size of 20, we will explain the procedure step by step.` |
| `1. 帰無仮説は母相関$\rho = 0.0$とする。対立仮説は$\rho \neq 0.0$である。` | `1. The null hypothesis sets the population correlation, $\rho = 0.0$. The alternative hypothesis is $\rho \neq 0.0$.` |
| `2. 検定統計量は相関係数$r$を変換した$t$とする。` | `2. The test statistic is denoted as 't', which is the transformed correlation coefficient 'r'.` |
| `3. 判定基準として，$\alpha = 0.05$とする。すなわち，母相関が0であるという仮説を棄却して間違える確率を5%以下に制御したい。` | `3. For our decision criteria, we will set $\alpha = 0.05$. That is, we want to control the probability of mistakenly rejecting the hypothesis that the population correlation is 0 to be less than 5%.` |
| `4. 検定統計量を計算する。$n=20,r=0.5$ より，` | `4. Calculate the test statistic. From $n=20, r=0.5$,` |
| `$$t = \frac{0.5\times(\sqrt{18})}{\sqrt{1-0.5^2}} = 2.449$$` | `$$t = \frac{0.5\times(\sqrt{18})}{\sqrt{1-0.5^2}} = 2.449$$

This equation is saying that we are calculating the value of t (which is a statistic we often use in psychology) by taking 0.5 times the square root of 18 (which could be any given numbers in your actual data), then dividing this by the square root of 1 minus 0.5 squared. After calculating, you will find that the value of t in this case is 2.449.` |
| `5. 標本相関係数の**絶対値が**0.5を**超える**確率は，$t$分布の理論値から，次のように計算できる。あるいは，$t$分布の両端5%を切り出す**臨界値** を次のように計算できる。` | `5. The probability that the absolute value of the sample correlation coefficient exceeds 0.5 can be calculated from the theoretical values ​​of the t-distribution as follows. Alternatively, the critical value, which is 5% at both ends of the t-distribution, can be calculated in the following way.` |
| `(1 - pt(0.5 * sqrt(18) / sqrt(1 - 0.5^2), df = 18)) * 2` | `(1 - pt(0.5 * sqrt(18) / sqrt(1 - 0.5^2), df = 18)) * 2` |
| `qt(0.975, df = 18)` | `qt(0.975, df = 18)` |
| `ここで注意してほしい点は，今回の検定の目的が「母相関が0であるという帰無仮説を棄却できるかどうか」であり，相関係数の符号については関心がなく絶対値で考える点である。`pt`関数は，ある確率点までの累積面積であるから，1から引くことでその確率点以上の値がでる確率が示される。$t$分布は左右対称の分布なので，これを2倍した値が絶対値で考えた時の出現確率である。これが5%よりも小さければ，有意であると判断できる。今回は，統計的に有意であるといって良い。` | `The important thing to note here is that the purpose of our current test is to determine "whether we can reject the null hypothesis that the population correlation is zero," with no interest in the sign of the correlation coefficient; we consider it in absolute value terms. The `pt` function represents the cumulative area up to a certain probability point, so by subtracting it from one, we are showing the probability of obtaining a value higher than this probability point. Because the $t$ distribution is a symmetric distribution, twice this value is the probability of occurrence when considered in absolute terms. If this value is less than 5%, we can judge it to be statistically significant. Based on our results, it is indeed fair to say that our findings are statistically significant.` |
| `なお，表現上の細かい注意点になるが，この確率は今回の実現値「以上」のより極端な値が出る確率であり，この実現値が出る確率という言い方はしない。確率は面積であり，点に対する面積はないからである。` | `Furthermore, a minor point to note in expression is that this probability refers to the probability of obtaining more extreme values "than or equal to" this observed value. It does not refer to the probability of obtaining this exact observed value. This is because probabilities are considered as areas, and there's no area assigned to a single point.` |
| ``qt`関数で示されるのは確率点なので，これ以上の値を今回の実現値が出していたら，統計的に有意であると判断できる。今回の実現値から算出した値は$t(18)=2.449$であり，臨界値の$2.100$よりも大きな値なので，有意であると判断できる。` | `The function `qt` represents probabilistic points, from which we can determine if the realized value exceeded these points, hence statistically significant. The value calculated from our realized value is $t(18)=2.449$, and since this is greater than the critical value of $2.100$, we can conclude that it is significant.` |
| `## 2種類の検定のエラー確率` | `## Probability of Errors in Two Types of Tests

In any statistical test, there is always a possibility of making wrong conclusions. For instance, when you conduct a hypothesis test, you might incorrectly reject the null hypothesis (an error known as "Type I Error"), or you may incorrectly hold on to the null hypothesis when it's false (an error referred to as "Type II Error").

Understanding these two types of errors and being able to control their probabilities is one of the indispensable skills in statistical analysis. This skill aids in producing more precise and reliable research findings. In the next section, we're going to explore how to do this using R and RStudio. It may be challenging at first, but remember, practice makes perfect.` |
| `上では丁寧に計算過程をみてきたが，実践場面ではサンプルはひとつであり，標本統計量もひとつ算出されるだけである。自分の大切なデータであるから，標本分布から得られた特定のケースにすぎないことが直感的にわかりにくいかもしれない。` | `Although we have carefully examined the calculations above, in practical situations we only have one sample and only one sample statistic is computed. Since this is your own valuable data, it might be difficult to intuitively grasp that it's just a specific case derived from the sample distribution.` |
| `相関係数の検定をするときは，Rの関数`cor.test`を使って次のように行う。ここでは`mvrnorm`関数を使って，相関毛数0.5の仮想データを作っている。` | `When conducting a correlation coefficient test, use R's `cor.test` function as follows. Here, we use the `mvrnorm` function to create hypothetical data with a correlation coefficient of 0.5.` |
| `set.seed(17)` | `set.seed(17)` |
| `n <- 20` | `n <- 20` |
| `sampleData <- mvrnorm(n,` | `sampleData <- mvrnorm(n,` |
| `mu = c(0, 0),` | `mu = c(0, 0),` |
| `Sigma = matrix(c(1, 0.5, 0.5, 1), ncol = 2),` | `Sigma = matrix(c(1, 0.5, 0.5, 1), ncol = 2),` |
| `empirical = TRUE` | `empirical = TRUE` |
| `)` | `)` |
| `cor.test(sampleData[, 1], sampleData[, 2])` | `cor.test(sampleData[, 1], sampleData[, 2])` |
| `結果として示されている，tの値や自由度，$p$値が先ほど示した例と対応していることを確認できる。さらに，相関係数の信頼区間や標本相関係数そのものも示されている。この信頼区間が0を跨いでいないことからも，帰無仮説が棄却されることが見て取れるだろう。` | `We can confirm that the values of t, degrees of freedom, and the $p$ value shown in the results correspond with the examples we showed earlier. Moreover, the confidence interval of the correlation coefficient and the sample correlation coefficient itself are also indicated. From the fact that this confidence interval does not cross zero, we can see that the null hypothesis would be rejected.` |
| `われわれは既に，母相関が0のデータセットの一部を取り出すと，その相関係数が0ではなく0.5のような数字になることも知っている。もちろん母相関が0であれば標本相関も0近い値が出やすいとしても，である。つまり標本から得られた値をあまり大事に考えすぎない方が良い(もちろん一般化を念頭においている時は，である)。` | `We already know that if we take a subset of a data set with a correlation of 0, the correlation coefficient won't necessarily be 0; it might be a number like 0.5. Even if the population correlation is 0, it's possible that the sample correlation might yield a value close to 0. What this suggests is that we shouldn't place too much importance on the values derived from the sample (of course, this assumes we are working with generalizations).` |
| `また，帰無仮説は「母相関が0である」なので，これが**棄却**されたとしても「母相関が0であるとは言えない」のに過ぎない。ここから，母相関も$r=0.5$付近にあるはずだとか，$p$値が2.4%なので5%よりもずいぶん低いのは証拠の重要さを物語っているのだ，と論じるのは適切ではない。母相関が0という仮想的な状況のもとでの話であって，母相関が実際にどの程度なのかを検討しているわけではない。この点が誤解されやすいので特に注意してほしい。` | `Furthermore, the null hypothesis is that the "population correlation is 0". So, even if it gets **rejected**, it merely means that "we can’t claim that the population correlation is 0". From this, it's inappropriate to argue that the population correlation is likely around $r=0.5$, or that the $p$ value being significantly lower than 5% at 2.4% speaks to the importance of the evidence. This query is based on the hypothetical situation of the population correlation being 0. It does not mean that we are examining what the actual degree of population correlation is. This point is easily misunderstood, so take particular care in understanding this detail.` |
| `ここに来るとタイプ1エラー，タイプ2エラーがより具体的に理解できるようになってきたではないだろうか。タイプ1エラーはこの帰無仮説が正しい時に，標本相関から計算した統計量で判断する確率であるから，上の手続きで見たことそのものである。` | `Hopefully, by now, it has become easier to understand Type 1 and Type 2 errors in a more concrete way. Type 1 error is the probability of making a decision using the statistic calculated from the sample correlation, if the null hypothesis is correct. This is exactly what we saw in the previous steps.` |
| `別の角度で見てみよう。`cor.test`をつかうと標本統計量の信頼区間が算出できる。この信頼区間が母相関--ここでは帰無仮説である$\rho =0$を「正しく」含んでいる割合を見てみよう。` | `Let's take a look at this from a different angle. `cor.test` can be used to calculate the confidence interval of a sample statistic. Let's analyze the proportion that correctly includes $ \rho = 0 $, which is the null hypothesis here, within this confidence interval.` |
| ``cor.test`関数が返すオブジェクトには，`conf.int`という名前のものがあり，デフォルトではここで95%の信頼区間が含まれている。` | `The object returned by the `cor.test` function includes something named `conf.int`, which by default contains the 95% confidence interval.` |
| `シミュレーションに先立って，結果を格納する2列のデータフレームを作っておき，シミュレーション後に`ifelse`関数で母相関が含まれているかどうかの判定をした。` | `Before starting the simulation, we created a two-column data frame to store the results. After the simulation, we used the `ifelse` function to determine whether the population correlation was included.` |
| `set.seed(42)` | `set.seed(42)` |
| `iter <- 10000` | `iter <- 10000` |
| `intervals <- data.frame(matrix(NA, nrow = iter, ncol = 2))` | `intervals <- data.frame(matrix(NA, nrow = iter, ncol = 2))` |
| `names(intervals) <- c("Lower", "Upper")` | `names(intervals) <- c("Lower", "Upper")` |
| `for (i in 1:iter) {` | `for (i in 1:iter) {` |
| `selected_row <- sample(1:N, 20)` | `selected_row <- sample(1:N, 20)` |
| `s_i <- X[selected_row, ]` | `s_i <- X[selected_row, ]` |
| `cor_i <- cor.test(s_i[, 1], s_i[, 2])` | `cor_i <- cor.test(s_i[, 1], s_i[, 2])` |
| `intervals[i, ] <- cor_i$conf.int[1:2]` | `intervals[i, ] <- cor_i$conf.int[1:2]` |
| `}` | `}` |
| `#` | `#` |
| `df <- intervals %>%` | `df <- intervals %>%` |
| `mutate(FLG = ifelse(Lower <= 0 & Upper >= 0, 1, 0)) %>%` | `mutate(FLG = ifelse(Lower <= 0 & Upper >= 0, 1, 0)) %>%` |
| `summarise(type1error = mean(FLG)) %>%` | `summarise(type1error = mean(FLG)) %>%` |
| `print()` | `print()` |
| `今回の例では，`r df$type1error*100`%の割合で正しく判断できていた。言い換えると，エラーが生じる割合は`r (1-df$type1error)*100`%だったので，タイプ1エラー確率を5%以下にするという目的はしっかり達成できていたことが確認できた。` | `In this instance, correct judgments were made at a rate of `r df$type1error*100`%. In other words, the rate at which errors occurred was `r (1-df$type1error)*100`%, confirming that the goal of keeping the Type 1 error probability below 5% was successfully achieved.` |
| `同様に，タイプ2エラーは，帰無仮説が正しくないときに帰無仮説を採択する確率だから，シミュレーションするなら次のようになる。まず母相関が0でない状況を作り出そう。今回は母相関が0.5であるとして，母集団分布を描いてみよう。` | `Similarly, a Type II error is the probability of accepting the null hypothesis when it is not correct. If we were to simulate this, it would go as follows. First, let's create a situation where the population correlation is not zero. For now, let's assume that the population correlation is 0.5 and try to plot the population distribution.` |
| `#| fig.height: 5` | `#| fig.height: 5` |
| `#| fig.width: 5` | `#| fig.width: 5` |
| `#| dev: "ragg_png"` | `#| dev: "ragg_png"` |
| `set.seed(12345)` | `set.seed(12345)` |
| `N <- 100000` | `N <- 100000` |
| `X <- mvrnorm(N,` | `X <- mvrnorm(N,` |
| `mu = c(0, 0),` | `mu = c(0, 0),` |
| `Sigma = matrix(c(1, 0.5, 0.5, 1), ncol = 2),` | `Sigma = matrix(c(1, 0.5, 0.5, 1), ncol = 2),` |
| `empirical = TRUE` | `empirical = TRUE` |
| `)` | `)` |
| `X %>%` | `X %>%` |
| `as.data.frame() %>%` | `as.data.frame() %>%` |
| `ggplot(aes(x = V1, y = V2)) +` | `ggplot(aes(x = V1, y = V2)) +` |
| `geom_point()` | `geom_point()` |
| `今度は，ここからサンプルサイズ20のデータセットを取り出し，検定することにしよう。検定の結果，有意になれば`1`，ならなければ`0`というオブジェクトを作って，判定の正しさを考えてみることにする。` | `Let's now extract a dataset of sample size 20 and proceed to test it. Based on the test result, we'll create an object that is '1' if it is significant, and '0' if it is not, and then consider the correctness of our decision.` |
| `iter <- 10000` | `iter <- 10000` |
| `judges <- c()` | `judges <- c()` |
| `for (i in 1:iter) {` | `for (i in 1:iter) {` |
| `selected_row <- sample(1:N, 20)` | `selected_row <- sample(1:N, 20)` |
| `s_i <- X[selected_row, ]` | `s_i <- X[selected_row, ]` |
| `cor_i <- cor.test(s_i[, 1], s_i[, 2])` | `cor_i <- cor.test(s_i[, 1], s_i[, 2])` |
| `judges <- c(judges, cor_i$p.value)` | `judges <- c(judges, cor_i$p.value)` |
| `}` | `}` |
| `df <- data.frame(p = samples) %>%` | `df <- data.frame(p = samples) %>%` |
| `mutate(FLG = ifelse(p <= 0.05, 1, 0)) %>%` | `mutate(FLG = ifelse(p <= 0.05, 1, 0)) %>%` |
| `summarise(` | `summarise(` |
| `sig = sum(FLG == 1),` | `sig = sum(FLG == 1),` |
| `non.sig = sum(FLG == 0),` | `non.sig = sum(FLG == 0),` |
| `type2error = non.sig / iter` | `type2error = non.sig / iter` |
| `) %>%` | `) %>%` |
| `print()` | `print()` |
| `今回は母相関が0.5であり，帰無仮説は棄却されて然るべきなのだが，有意でないと判断された割合が`r df$type2error*100`%あったことになる。心理学の研究などでは，この確率$\beta$が0.2未満，逆にいうと検出が0.8以上あることが望ましいとされているので，今回のこの事例では十分な件出力がなかった，と言えるだろう。` | `In this case, the correlation coefficient was 0.5, and the null hypothesis should have been rejected, but `r df$type2error*100`% of the cases were incorrectly deemed not significant. In psychological research, it is desirable to have this probability $\beta$ less than 0.2, or inversely, to have a detection rate of over 0.8. Therefore, it can be said that in this particular instance, there wasn't sufficient detection power.` |
| `もちろん実際には，母相関がどれぐらいなのかわからない。$0.3$なのかもしれないし，$-0.5$であるかもしれない。つまりタイプ2エラーは研究者が制御できるところではなく，せいぜい大きな相関が見込めそうな変数について標本を取ろうと心がけるだけである。` | `Of course, in reality, we do not know what the parent correlation might be. It could be $0.3$, or it could be $-0.5$. This means that Type II errors are not within the researcher's control, and at most, the researcher can strive to collect samples pertaining to variables where a large correlation is anticipated.` |
| `タイプ1,2エラーの確率は，サンプルサイズや効果量(ここでは母相関の大きさ)の関数である。サンプルサイズは研究者が決定することができるので，効果を見積もり，制御したいエラー確率の基準を決めて，合理的にサンプルサイズを決めるべきである。` | `The probability of Type 1 and Type 2 errors is a function of the sample size and effect size (in this case, the scale of the population correlation). As researchers can determine the sample size, they should form an estimate of the effect, decide on the standard for the error probability they want to control, and then reasonably determine the sample size.` |
| `## 練習問題；無相関検定の例` | `## Practice Problems: An Example of Correlation Test` |
| `1. 母相関が0の母集団から，サンプルサイズ10の標本を取り出して標本相関を見た時の標本分布を，乱数のヒストグラムで近似してみましょう。` | `1. Let's try to approximate the sampling distribution, through the use of a histogram of random numbers, when we observe the sample correlation from a population with a correlation coefficient of 0, by taking a sample with a size of 10.` |
| `2. 同じく，サンプルサイズ50の標本を取り出して標本相関を見た時の標本分布を，乱数のヒストグラムで近似してみましょう。サンプルサイズが20や10の時と比べてどういう違いがあるでしょうか。` | `2. Similarly, let's try to approximate the sampling distribution when observing the sample correlation of a sample size of 50, using a histogram of random numbers. How does this differ when compared to sample sizes of 20 or 10?` |
| `3. サンプルサイズ50の標本相関が$r=-0.3$のとき，統計的に有意と言えるでしょうか。`cor.test` をつかって検定し，検定結果と判断結果を記述してください。` | `3. Can we say that a sample correlation of $r=-0.3$ is statistically significant with a sample size of 50? Use `cor.test` to validate, and describe the testing outcomes and your decisions.` |
| `4. 標本相関が$r=-0.3$だとします。サンプルサイズが10,20,50,1000のとき，統計的に有意と言えるでしょうか。`cor.test`を使って検定し，検定結果を一覧にしてみましょう。ここから何がわかるでしょうか。` | `4. Let's suppose the sample correlation is $r=-0.3$. Would it be statistically significant if the sample sizes were 10, 20, 50, and 1000, respectively? Perform a test using `cor.test`, and summarize the results. What can we interpret from these findings?` |
| `5. 母相関が$\rho = -0.3$だったとします。サンプルサイズ20のとき，どの程度の検出力があると見込めるでしょうか。シミュレーションで近似してください。` | `5. Suppose the population correlation is $\rho = -0.3$. How much statistical power can we expect when the sample size is 20? Please approximate this using simulation.` |
