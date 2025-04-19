| 原文 | 翻訳 |
|---|---|
| `# 確率とシミュレーション` | `# Probability and Simulation` |
| `## 確率の考え方と使い所` | `## Understanding and Applications of Probability` |
| `統計と確率は密接な関係がある。` | `Statistics and probability have a close relationship.` |
| `まずデータをたくさん集めると，個々のケースでは見られない全体的な傾向が見られるようになり，それを表現するのに確率の考え方を使う，というのがひとつ。` | `Firstly, gathering a lot of data allows us to see overall trends that are not observable in individual cases. One way to express these trends is by using the concept of probability.` |
| `次にデータがそれほどたくさんなくとも，大きな全体の中から一部を取り出した標本Sampleと考えられるとき，標本は全体の性質をどのように反映しているかを考えることになる。ここで全体の傾向から一部を取り出した偶然性を表現するときに確率の考え方を使うことになる。` | `Next, even when there isn't much data, when we consider a selection taken from a larger whole as a sample, we contemplate how the sample reflects the properties of the whole. In this case, we will use the concept of probability to express the randomness of selecting a part from the overall tendency.` |
| `最後に，理論的・原理的に挙動がわかっている機械のようなものでも，現実的・実践的には系統だったズレが生じたり，偶然としか考えられない誤差が紛れ込むことがある。前者は機械の調整で対応できるが，後者は偶然が従う確率を考える必要がある。` | `Finally, even with machines that behave in predicted and principled ways, there may be consistent discrepancies or random errors that can only be perceived as incidental in a practical reality. The former can be addressed by adjusting the machine, but the latter requires considering the probabilities that randomness follows.` |
| `心理学は人間を対象に研究を行うが，あらゆる人間を一度に調べるわけにはいかないので，サンプルを取り出して調査したり実験したりする(第2のケース)。データサイエンスでは何万レコードというおおきなデータセットになるが，心理学の場合は数件から数十件しかないことも多い。また，心理学的傾向を理論立ててモデル化できたとしても，実際の行動には誤差が含まれている可能性が高い(第3のケース)。このことから，心理学で得られるデータは確率変数として考えられ，小標本から母集団の性質を推測する**推測統計**と共に利用される。` | `Psychology conducts research on humans, but since it's not possible to examine all individuals at once, we often collect samples and conduct surveys or experiments (the second case). In data science, the datasets frequently run into tens of thousands of records, but in the case of psychology, it is quite common to have only a few to dozens of records. Furthermore, even if we're able to theoretically model psychological tendencies, there are likely inaccuracies in actual behavior (the third case). From this, we can assume that data obtained in psychology can be thought of as random variables, and it is used in conjunction with **inferential statistics** to infer the characteristics of a population from a small sample.` |
| `厳密に数学的な意味での**確率**は，集合，積分，測度といった緻密な概念の積み重ねから定義される[^6.1]。ここではその詳細に分け入らず，単に「特定の結果が生じる可能性について，0から1の間の実数でその大小を表現したもの」とだけ理解しておいて欲しい。この定義からは，「全ての可能な組み合わせのうち当該事象の成立する割合」という解釈も成り立つし，「主観的に重みづけた真実味の強さに関する信念の度合い」という解釈も成り立つ。[^6.2]` | `In a mathematical sense, the concept of **probability** is defined based on the accumulation of intricate concepts like sets, integrals, and measures[^6.1]. We will not delve into details here; for the moment, we need to understand probability just as "a representation of the likelihood of a particular outcome occurring, expressed as a real number between 0 and 1". Under this definition, we can interpret probability as "the proportion of occurrences among all possible combinations". Additionally, it can also be interpreted as "the degree of belief about the strength of truth, subjectively weighted"[^6.2].` |
| `これまで学んできた確率は順列・組み合わせを全て書き出す退屈なもの，と思っていたかもしれないが，「十中八九まちがいないね(80-90%ほど確からしいと考えている)」という数字も確率の一種として扱えるので，非常に身近で適用範囲の広い概念である。理解を進めるポイントの1つとして，確率を面積として考えると良いかもしれない。ありうる状況の全体の空間に対して，事象の成立する程度がどの程度の面積がどの程度の割合であるかを表現したのが確率という量である，と考えるのである( @Hiraoka200910 は書籍の中で一貫して面積で説明している。この説明だと，条件付き確率などの理解がしやすい。)。` | `You might have thought that the probability you've learned so far is a tedious task of writing out all permutations and combinations. However, statements like "I'm pretty sure it's correct about 80-90% of the time," can also be treated as a kind of probability. Thus, probability is a very familiar concept with a wide range of applications.

One tip for advancing your understanding is to think of probability in terms of area. Imagine the entire space of all possible situations, and how the event occurs as a proportion of that space: this is the concept of probability. For example, Hiraoka (2009) consistently explains it in terms of area throughout his book. By using this explanation, it becomes easier to understand concepts like conditional probability.` |
| `[^6.1]: 詳しくは @Yoshida2021-02-25 , @Kono1999-05-01, @Sato1994-02-25 などを参照のこと。` | `[^6.1]: For more details, refer to sources such as @Yoshida2021-02-25, @Kono1999-05-01, @Sato1994-02-25.` |
| `[^6.2]: 前者の解釈は高校までの数学で学ぶ確率であり，頻度主義的確率と呼ばれることがある。一方後者の解釈は，降水確率X%のように日常でも使うものであり，主観確率と呼ばれることがある。こうした解釈の違いを，主義主張の対立であって数学的ではない，と批判する向きもあるが，実際コルモゴロフの公理はどちらの立場でも成立するように整えられており，筆者個人的にはユーザが理解しやすく計算できればどちらでも良いと考えている。` | `[^6.2]: The former interpretation, often referred to as frequency probability, is the type of probability you learn in mathematics up to high school. On the other hand, the latter interpretation, like a precipitation probability of X%, is often used in daily life and is sometimes called subjective probability. While some critics argue that these differences in interpretation are disputes of philosophical views rather than mathematical, in fact, Kolmogorov's axioms are set up to hold true from either standpoint. Personally, the author believes that either is fine as long as the user can easily understand and calculate it.` |
| `ただし注意して区別しておいて欲しいのが，確率変数とその実現値の違いである。データセットやスプレッドシートに含まれる値は，あくまでも**確率変数の実現値**というのであって，**確率変数**はその不確実な状態を有した変数そのものを指す言葉である。サイコロは確率変数だが，サイコロの出目は確率変数の実現値である。心理変数は確率変数だが，手に入れたデータはその実現値である。実現値を通じて変数の特徴を知り，全体を推測するという流れである。` | `However, it's crucial to clearly distinguish between probability variables and their realized values. Values included in datasets or spreadsheets are merely the **realized values** of probability variables, while **probability variables** refer to the variables themselves in their uncertain state. A die is a probability variable, whereas the number it lands on is the realized value of that probability variable. Psychological variables are probability variables, with any data obtained being their realized values. We learn about the characteristics of variables through these realized values and use them to make inferences about the broader picture.` |
| `目の前のデータを超えて，抽象的な実体で議論を進めることが難しく感じられるかもしれない。実は誰しもそうなのであって，確率の正確な理解は非常に難易度が高い。しかしRなど計算機言語に実装されている関数を通じて，より具体的に，操作しながら理解することで徐々に理解していこう。` | `You might find it challenging to discuss abstract entities beyond the data in front of you. In fact, it is tough for everyone, and understanding probabilities accurately is particularly difficult. However, through functions implemented in computer languages like R, we can gradually begin to understand these concepts in a more concrete and hands-on manner.` |
| `## 確率分布の関数` | `## Functions of Probability Distribution` |
| `確率変数の実現値は，**確率分布**に従う。確率分布とは，その実現値がどの程度生じやすいかを全て表した総覧であり，一般的に関数で表現される。実現値が連続的か離散的かによって名称が異なるが，連続的な確率分布関数は**確率密度関数(Probability Density Function)**，離散的な確率分布関数は**確率質量関数(Probability Mass Function)**という。` | `The realized values of a random variable follow a **probability distribution**. A probability distribution is a comprehensive overview that represents how likely each value is to occur and is typically expressed as a function. Although the names differ depending on whether the values are continuous or discrete, the function for a continuous probability distribution is known as a **probability density function** and for a discrete probability distribution, it's referred to as a **probability mass function**.` |
| `Rには最初から確率に関する関数がいくつか準備されている。最も有名な確率分布である**正規分布**について，次のような関数がある。` | `R provides several built-in functions related to probability from the outset. For the most famous probability distribution, the **normal distribution**, there are functions like the following.` |
| `# 標準のプロット関数，curve` | `# 標準のプロット関数，curve` |
| `curve(dnorm(x), from = -4, to = 4)` | `curve(dnorm(x), from = -4, to = 4)` |
| `#| dev: "ragg_png"` | `#| dev: "ragg_png"` |
| `# ggplot2を使ってカッコよく` | `# ggplot2を使ってカッコよく` |
| `pacman::p_load(tidyverse)` | `pacman::p_load(tidyverse)` |
| `data.frame(x = seq(-4, 4, by = 0.01)) %>%` | `data.frame(x = seq(-4, 4, by = 0.01)) %>%` |
| `mutate(y = dnorm(x)) %>%` | `mutate(y = dnorm(x)) %>%` |
| `ggplot(aes(x = x, y = y)) +` | `ggplot(aes(x = x, y = y)) +` |
| `geom_line() +` | `geom_line() +` |
| `theme_classic()` | `theme_classic()` |
| `ここで`dnorm`という関数を使っているが，`d`はDensity(確率密度)の頭文字であり，`norm`はNormal Distribution(正規分布)の一部である。このように，Rでは確率分布の名前を表す名称(ここでは`norm`)と，それに接頭文字ひとつ(`d`)で関数を構成する。この接頭文字は他に`p`,`q`,`r`があり，`dpois`(ポアソン分布poisson distributionの確率密度関数)，`pnorm`(正規分布normal distributionの累積分布関数),`rbinom`(二項分布binomial distributionからの乱数生成)のように使う。` | `Here, we're using a function called `dnorm`. The `d` stands for Density (probability density), and `norm` is short for Normal Distribution. In R, names of probability distributions (like `norm` here) are conveyed, followed by a prefix character (`d`) to compose a function. Other prefixes include `p`,`q`, and `r`, used as in `dpois` (the probability density function for a Poisson Distribution), `pnorm` (the cumulative distribution function for a Normal Distribution), or `rbinom` (generating random numbers from a Binomial Distribution).` |
| `ここでは正規分布を例に説明を続けよう。正規分布は平均$\mu$と標準偏差$\sigma$でその形状が特徴づけられる。これらの確率分布の特徴を表す数字のことを**母数 parameter**という。たとえば，次の3つの曲線はパラメータが異なる正規分布である。` | `Let's continue our discussion using the normal distribution as our example. A normal distribution is characterized by its mean (average) represented by $\mu$ and its standard deviation represented by $\sigma$. These figures, which characterize the properties of a probability distribution, are referred to as the **parameters**. For instance, the following three curves are normal distributions with different parameters.` |
| `#| dev: "ragg_png"` | `#| dev: "ragg_png"` |
| `data.frame(x = seq(-4, 4, by = 0.01)) %>%` | `data.frame(x = seq(-4, 4, by = 0.01)) %>%` |
| `mutate(` | `mutate(` |
| `y1 = dnorm(x, mean = 0, sd = 1),` | `y1 = dnorm(x, mean = 0, sd = 1),` |
| `y2 = dnorm(x, mean = 1, sd = 0.5),` | `y2 = dnorm(x, mean = 1, sd = 0.5),` |
| `y3 = dnorm(x, mean = -1, sd = 2)` | `y3 = dnorm(x, mean = -1, sd = 2)` |
| `) %>%` | `) %>%` |
| `pivot_longer(-x) %>%` | `pivot_longer(-x) %>%` |
| `ggplot(aes(x = x, y = value, color = name)) +` | `ggplot(aes(x = x, y = value, color = name)) +` |
| `geom_line()` | `geom_line()` |
| `平均は位置母数，標準偏差はスケール母数とも呼ばれ，分布の位置と幅を変えていることがわかる。言い換えると，データになるべく当てはまるように正規分布の母数を定めることもできるわけで，左右対称で単峰の分布という特徴があれば，正規分布でかなり様々なパターンを表せる。` | `The mean is also referred to as the location parameter, and the standard deviation is known as the scale parameter; they influence the position and range of the distribution, respectively. In other words, it is possible to determine the parameters of a normal distribution to best fit a given data set. If the data has the characteristic of being symmetrical and unimodal, a wide variety of patterns can be represented using a normal distribution.` |
| `さて，上の例で用いた関数はいずれも`d`を頭に持つ`dnorm`であり，確率分布の密度の高さを表現していた。では`p`や`q`が表すのは何であろうか。数値と図の例を示すので，その対応関係を確認してもらいたい。` | `Now, the functions we used in the above examples all start with `d`, as in `dnorm`, representing the height of the probability distribution density. But what do `p` and `q` depict? Let's go through some numerical and visual examples to understand their relationship.` |
| `# 累積分布関数` | `# 累積分布関数` |
| `pnorm(1.96, mean = 0, sd = 1)` | `pnorm(1.96, mean = 0, sd = 1)` |
| `# 累積分布の逆関数` | `# 累積分布の逆関数` |
| `qnorm(0.975, mean = 0, sd = 1)` | `qnorm(0.975, mean = 0, sd = 1)` |
| `数値で直感的にわかりにくい場合，次の図を見て確認しよう。`pnorm`関数はx座標の値を与えると，そこまでの面積(以下のコードで描かれる色付きの領域)すなわち確率を返す。`qnorm`関数は確率(=面積)を与えると，確率密度関数のカーブの下領域を積分してその値になるときのx座標の値を返す。` | `If numbers are intuitively hard to understand, let's check the following diagram. The `pnorm` function returns the area (i.e., probability, depicted as the colored region in the code below) up to a given x-coordinate value. The `qnorm` function, when given a probability (i.e., area), calculates the integral of the region under the probability density function curve and returns the x-coordinate value at which this total equates to the given probability.` |
| `# 描画` | `# 描画` |
| `prob <- 0.9` | `prob <- 0.9` |
| `## 全体の正規分布カーブ` | `## 全体の正規分布カーブ` |
| `df1 <- data.frame(x = seq(from = -4, 4, by = 0.01)) %>%` | `df1 <- data.frame(x = seq(from = -4, 4, by = 0.01)) %>%` |
| `mutate(y = dnorm(x, mean = 0, sd = 1))` | `mutate(y = dnorm(x, mean = 0, sd = 1))` |
| `## qnorm(0.975)までのデータ` | `## qnorm(0.975)までのデータ` |
| `df2 <- data.frame(x = seq(from = -4, qnorm(prob), by = 0.01)) %>%` | `df2 <- data.frame(x = seq(from = -4, qnorm(prob), by = 0.01)) %>%` |
| `mutate(y = dnorm(x, mean = 0, sd = 1))` | `mutate(y = dnorm(x, mean = 0, sd = 1))` |
| `## データセットの違いに注意` | `## データセットの違いに注意` |
| `ggplot() +` | `ggplot() +` |
| `geom_line(data = df1, aes(x = x, y = y)) +` | `geom_line(data = df1, aes(x = x, y = y)) +` |
| `geom_ribbon(data = df2, aes(x = x, y = y, ymin = 0, ymax = y), fill = "blue", alpha = 0.3) +` | `geom_ribbon(data = df2, aes(x = x, y = y, ymin = 0, ymax = y), fill = "blue", alpha = 0.3) +` |
| `## 以下装飾` | `## 以下装飾` |
| `geom_segment(` | `geom_segment(` |
| `aes(x = qnorm(prob), y = dnorm(qnorm(prob)), xend = qnorm(prob), yend = 0),` | `aes(x = qnorm(prob), y = dnorm(qnorm(prob)), xend = qnorm(prob), yend = 0),` |
| `arrow = arrow(length = unit(0.2, "cm")), color = "red"` | `arrow = arrow(length = unit(0.2, "cm")), color = "red"` |
| `)` | `)` |
| ``d`,`p`,`q`,`r`といった頭の文字は，他の確率分布関数にも付く。では次に`r`について説明しよう。` | `The initials such as `d`, `p`, `q`, `r` can also be applied to other probability distribution functions. Next, let's discuss about `r`.` |
| `## 乱数` | `## Random Numbers` |
| `乱数とは何であるかを説明するのは，「ランダムである(確率変数である)とは如何なることか」を説明するのと同じように難しい。` | `Explaining what random numbers are, is as challenging as explaining what it means to be random, or what a random variable is.` |
| `カンタンに説明するなら，規則性のない数列という意味である。` | `In simple terms, it refers to a sequence of numbers without any pattern.` |
| `しかし計算機はアルゴリズムに沿って正しく数値を計算するものだから，ランダムに，規則性がない数字を示すということは厳密にはあり得ない。` | `However, computers, which calculate numbers correctly according to algorithms, cannot strictly produce numbers randomly without any rules.` |
| `計算機が出す乱数は，乱数生成アルゴリズムに沿って出される数字であり，ランダムに見えて実は規則性があるので，疑似乱数というのが正しい。` | `The numbers produced by computers as random numbers are actually generated according to a random number generation algorithm. Although they appear random, they have an underlying regularity, so it is more appropriate to call them pseudorandom numbers.` |
| `とはいえ，人間が適当な数字を思いつきで誦じていく[^6.3]よりは，よほど規則性がない数列を出すので，疑似的とはいえ十分に役に立つ。` | `However, it's much more effective in producing an irregular sequence of numbers than if a person were to recite arbitrary numbers on their own[^6.3]. Although it is termed 'pseudo', it still serves its purpose excellently.` |
| `たとえばアプリなどで「ガチャ」を引くというのは，内部で乱数によって数値を出し，それに基づいてあたり・ハズレ等の判定をしている。他にも，RPGなどで攻撃する時に一定の確率で失敗するとか，一定の確率で「会心の一撃」を出すというのも同様である。ここで大事なのは，そうしたゲームへの実装において規則性のない数字に基づくプログラムにしたとしても，その統計的な性質，すなわち実現値の出現確率はある程度制御したいのである。` | `For instance, when you "draw a Gacha" in apps, a random number is internally generated to decide outcomes such as win or loss. Similarly, in RPGs, things like failing an attack at a certain probability or landing a "critical hit" are based on the same principle. What's important to understand here is that, even if you base a game's implementation on seemingly random numbers, you would still want to guide the statistical characteristics – in other words, the occurrence probability of the outcomes – to a certain degree.` |
| `[^6.3]: 厳密なエビデンスは示せないが，俗に「嘘のゴサンパチ」というように人間が適当に数字を述べると5,3,8が使われる率がチャンスレベルより高いと言われている。` | `[^6.3]: While it's not possible to provide rigorous evidence, it's commonly said in the saying 'the lie of 5, 3, 8', that humans often use the numbers 5, 3, and 8 more frequently than chance when casually stating numbers.` |
| `そこで，ある確率分布に基づく乱数を生成したい，ということになる。幸いにして，一様乱数(全ての実現値が等しい確率で生じる)を関数で変換することで，正規分布ほか様々な確率分布に従う乱数を作ることができる。Rにはその基本関数として幾つかの確率分布に従う乱数が実装されている。たとえば次のコードは，平均50，SD10の正規分布に従う乱数を10個出現させるものである。` | `So, let's say we want to create random numbers based on a certain probability distribution. Fortunately, by transforming uniform random numbers (all possible values occur with equal probability) with a function, we can generate random numbers that follow various probability distributions, including the normal distribution. R has implemented several such basic functions that allow for random numbers following different probability distributions. For example, the following code generates ten random numbers that follow a normal distribution with a mean of 50 and a standard deviation of 10.` |
| `rnorm(n = 10, mean = 50, sd = 10)` | `rnorm(n = 10, mean = 50, sd = 10)` |
| `たとえば諸君が心理統計の練習問題を作ろうとして，適当な数列が欲しければこのようにすれば良いかもしれない。しかし，同じ問題をもう一度作ろうとすると，乱数なのでまた違う数字が出てしまう。` | `For example, if you are trying to create practice problems for psychological statistics and need a suitable number sequence, you could do it this way. However, if you try to recreate the same problem, a different set of numbers will emerge because it's randomized.` |
| `rnorm(n = 10, mean = 50, sd = 10)` | `rnorm(n = 10, mean = 50, sd = 10)` |
| `疑似乱数に過ぎないのだから，再現性のある乱数を生じさせたいと思うかもしれない。そのような場合は，`set.seed`関数を使う。疑似乱数は内部の乱数生成の種(seed)から計算して作られているため，その数字を固定してやると同じ乱数が再現できる。` | `You might want to generate reproducible random numbers, since they're nothing more than pseudorandom numbers. In such cases, you can use the `set.seed` function. Pseudorandom numbers are calculated from the seed of the internal random number generator. Therefore, if we fix this number, the same random numbers can be reproduced.` |
| `# seedを指定` | `# seedを指定` |
| `set.seed(12345)` | `set.seed(12345)` |
| `rnorm(n = 3)` | `rnorm(n = 3)` |
| `# 同じseedを再設定` | `# 同じseedを再設定` |
| `set.seed(12345)` | `set.seed(12345)` |
| `rnorm(n = 3)` | `rnorm(n = 3)` |
| `### 乱数のつかいかた` | `### How to Use Random Numbers` |
| `乱数の使い方のひとつは，先に述べたように，プログラムが偶然による振る舞いをしているように仕掛けたいとき，ということだろう。` | `One use of random numbers, as previously mentioned, might be when you want to design your program to behave as if it's acting randomly.` |
| `実は他にも使い道がある。それは確率分布を具体的に知りたいときである。次に示すのは，標準正規分布から$n = 10,100,1000,10000$とした時のヒストグラムである。` | `In fact, there is another use. It comes in handy when you want to understand a probability distribution specifically. What we are going to show next are histograms generated from a standard normal distribution when we set $n = 10,100,1000,10000$.` |
| `rN10 <- rnorm(10)` | `rN10 <- rnorm(10)` |
| `rN100 <- rnorm(100)` | `rN100 <- rnorm(100)` |
| `rN1000 <- rnorm(1000)` | `rN1000 <- rnorm(1000)` |
| `rN10000 <- rnorm(10000)` | `rN10000 <- rnorm(10000)` |
| `data.frame(` | `data.frame(` |
| `N = c(` | `N = c(` |
| `rep(1, 10), rep(2, 100),` | `rep(1, 10), rep(2, 100),` |
| `rep(3, 1000), rep(4, 10000)` | `rep(3, 1000), rep(4, 10000)` |
| `),` | `),` |
| `X = c(rN10, rN100, rN1000, rN10000)` | `X = c(rN10, rN100, rN1000, rN10000)` |
| `) %>%` | `) %>%` |
| `mutate(N = as.factor(N)) %>%` | `mutate(N = as.factor(N)) %>%` |
| `ggplot(aes(x = X, fill = N)) +` | `ggplot(aes(x = X, fill = N)) +` |
| `# 縦軸を相対頻度に` | `# 縦軸を相対頻度に` |
| `geom_histogram(aes(y = ..density..)) +` | `geom_histogram(aes(y = ..density..)) +` |
| `facet_wrap(~N)` | `facet_wrap(~N)` |
| `これを見ると，最初の10個程度のヒストグラムは不規則な分布に見えるが，100,1000と増えるに従って徐々に正規分布の理論的形状に近似していくところがみて取れる。` | `Upon observing this, the first 10 or so histograms appear to have irregular distributions. However, as the number increases to 100, 1000 and so forth, you can clearly see that it gradually approximates the theoretical shape of the normal distribution.` |
| `Rにはポアソン分布や二項分布などに加え，統計に馴染みの深いt分布やF分布，$\chi^2$分布などの確率分布関数も実装されている。これらの分布はパラメタの値を聞いてもイメージしにくいところがあるかもしれないが，そのような時はパラメタを指定した上で乱数を大量に生成し，そのヒストグラムを描けば確率分布関数の形が眼に見えてくるため，より具体的に理解できるだろう。` | `R includes implementations of probability distribution functions like the Poisson distribution and binomial distribution, as well as those commonly used in statistics such as the t-distribution, F-distribution, and $\chi^2$ distribution. It might be a bit hard to picture these distributions just by considering their parameter values. But, during those times, one effective strategy is to generate a large number of random numbers specifying the parameters, and draw a histogram of them. This strategy will allow you to visually grasp the shape of the probability distribution function, leading to a more concrete understanding.` |
| `実際，ベイズ統計学が昨今隆盛している一つの理由は，計算機科学の貢献によるところが大きい。**マルコフ連鎖モンテカルロ法**(MCMC法)と呼ばれる乱数発生技術は，明確な名前を持たないモデルによって作られる事後分布からでも，乱数を生成できる技術である。この分布は解析的に示すことは困難であるが，そこから乱数を生成し，そのヒストグラムを見ることで，形状を可視化できるのである。` | `Indeed, one reason for the recent popularity of Bayesian statistics is the significant contributions from computer science. A random number generation technique called **Markov Chain Monte Carlo** (MCMC) can generate random numbers even from a posterior distribution created by a model without a clearly defined name. Although it is challenging to represent this distribution analytically, it is possible to visualize its shape by generating random numbers from it and observing the histogram.` |
| `また，この乱数利用法の利点は可視化だけではない。標準正規分布において，ある範囲の面積(=確率)が知りたいとする。たとえば，確率点-1.5から+1.5までの範囲の面積を求めたいとしよう。正規分布の数式はわかっているので，次のようにすればその面積は求められる。` | `Furthermore, visualization is not the only advantage of this random number usage method. Suppose you want to know the area (i.e., probability) in a certain range in the standard normal distribution. For example, assume you want to find the area within the range from probability point -1.5 to +1.5. Since we know the equation for the normal distribution, we can compute this area as follows.` |
| `$$ p = \int_{-1.5}^{+1.5} \frac{1}{\sqrt{2\pi}}e^{-\frac{x^2}{2}} dx $$` | `This equation represents the probability density function (PDF) of a normal distribution, which we denote by 'P'. This formula, $$ p = \int_{-1.5}^{+1.5} \frac{1}{\sqrt{2\pi}}e^{-\frac{x^2}{2}} dx $$, means that we're integrating the normal PDF (the part inside the integral) from -1.5 to +1.5. 

Basically, we're calculating the area (probability in this context) under the normal distribution curve from x=-1.5 to x=1.5. This gives us the probability that a random variable, which is normally distributed, falls within this range. 

If you're feeling a bit lost, don't worry! We'll be diving into this concept in much more detail in the following chapters.` |
| `もちろん我々は`pnorm`関数を知っているので，次のようにして数値解を得ることができる。` | `Of course, since we know about the `pnorm` function, we can obtain numerical solutions as follows.` |
| `pnorm(+1.5, mean = 0, sd = 1) - pnorm(-1.5, mean = 0, sd = 1)` | `pnorm(+1.5, mean = 0, sd = 1) - pnorm(-1.5, mean = 0, sd = 1)` |
| `同様のことは乱数を使って，次のように近似解を得ることができる。` | `You can also use random numbers to obtain approximate solutions in a similar way.` |
| `x <- rnorm(100000, mean = 0, sd = 1)` | `x <- rnorm(100000, mean = 0, sd = 1)` |
| `df <- data.frame(X = x) %>%` | `df <- data.frame(X = x) %>%` |
| `# 該当する範囲かどうかを判定する変数を作る` | `# 該当する範囲かどうかを判定する変数を作る` |
| `mutate(FLG = ifelse(X > -1.5 & X < 1.5, 1, 2)) %>%` | `mutate(FLG = ifelse(X > -1.5 & X < 1.5, 1, 2)) %>%` |
| `mutate(FLG = factor(FLG, labels = c("in", "out")))` | `mutate(FLG = factor(FLG, labels = c("in", "out")))` |
| `## 計算` | `## 計算` |
| `df %>%` | `df %>%` |
| `group_by(FLG) %>%` | `group_by(FLG) %>%` |
| `summarise(n = n()) %>%` | `summarise(n = n()) %>%` |
| `mutate(prob = n / 100000)` | `mutate(prob = n / 100000)` |
| `ここでは乱数を10,000個生成し，指定の範囲内に入るかどうか(入れば1,入らなければ2)を示すfactor型変数`FLG`を作った。この変数ごとに群分けして数を数え，総数で割ることで相対度数にする。確率は全体の中に占める相対的な面積の割合であり，今回当該領域の値が`0.866`と`pnorm`関数で算出した解とほぼ同等の値変えられている。` | `Here, we generated 10,000 random numbers and created a factor-type variable `FLG` that reflects whether or not they fall within a specified range (1 if they do, 2 if they don't). We grouped and counted according to this variable, then divided by the total count to obtain relative frequencies. Probabilities represent the proportion of relative area within the whole, and in this case, the value in the area of interest is roughly equivalent to the solution calculated with the `pnorm` function, which is `0.866`.` |
| `なお，次のようにすれば範囲の可視化も容易い。` | `Furthermore, visualizing the range can be easily done as follows.` |
| `## 可視化` | `## 可視化` |
| `df %>%` | `df %>%` |
| `ggplot(aes(x = X, fill = FLG)) +` | `ggplot(aes(x = X, fill = FLG)) +` |
| `geom_histogram(binwidth = 0.01)` | `geom_histogram(binwidth = 0.01)` |
| `繰り返すが，確率分布の形がイメージできなかったり，解析的にその式を書き表すことが困難であった場合でも，具体的な数値にすることでヒストグラムで可視化でき，また近似的に確率計算ができている。` | `Let me repeat, even if it is difficult to visualize the shape of the probability distribution, or to analytically write out its formula, you can visualize it in a histogram by converting it into concrete numbers, and also calculate probabilities approximately.` |
| `あくまでも近似に過ぎないのでその精度が信用できない，というひとは生成する乱数の数を10倍，100倍にすれば良い。昨今の計算機の計算能力において，その程度の増加はさほど計算料の負担にならない。複雑な積分計算が記述統計量(数え上げ)の問題になる点で，具体的に理解できるという利点は大きい。` | `Since these are merely approximations, anyone who doubts their accuracy can simply increase the number of randomly generated numbers by tenfold or a hundredfold. With the computational capacity of modern computers, such an increase would not significantly burden the calculation cost. In terms of complex integral calculations being translated into descriptive statistics (or counting problems), there's a tremendous advantage to understanding these concepts more concretely.` |
| `さらに思いを馳せてほしいのだが，心理学者は心理学実験や調査によって，データを得る。しかしそれらは個人差や誤差を考え，確率変数だとされている。目の前の数件から数十件のデータであっても，正規分布に従うと仮定して統計的処理をおこなう。これは「乱数によって生成したデータ」に対して行うとしても本質的には同じである。すなわち，調査実験を行う前に，乱数によってシミュレーションしておくことができるのである。調査実験の本番一発勝負をする前に，自分の取ろうとしているデータがどのような性質を持ちうるかを具体的に確かめておくことは重要な試みであろう。` | `I ask that you consider this further: psychologists obtain data through psychological experiments and surveys. However, considering individual differences and errors, these are considered to be random variables. Even if the data at hand are just a few to several cases, we assume they follow a normal distribution and conduct statistical processing. Essentially, this is the same even when dealing with data generated by random numbers. In other words, one can simulate using random numbers before conducting survey experiments. Before taking a leap into the real deal of survey experiments, it would be a worthwhile endeavor to validate concretely what properties the data you are trying to collect could possibly possess.` |
| `## 練習問題；乱数を用いて` | `## Practice Problem: Using Random Numbers` |
| `正規乱数を用いて，次の値を近似計算してみよう。なお設定や解析的に算出した「真の値」と少数以下2位までの精度が得られるように工夫しよう。` | `Let's try to approximate a value using normal random numbers. Keep in mind to configure in such a way that you can achieve an accuracy up to two decimal places compared to the analytically calculated 'true value'.` |
| `1. 平均100,標準偏差8の正規分布の期待値。なお連続確率変数の期待値は次の式で表されます。$$E[X] = \int_{-\infty}^{\infty} x f(x) \, dx$$ ここで$x$は確率変数を表し，$f(x)$は確率密度関数であり，確率密度関数の全定義域を積分することで得られます。正規分布の期待値は，平均パラメータに一致しますので，今回の真値は設定した$100$になります。` | `1. The expected value of a normal distribution with a mean of 100 and a standard deviation of 8. The expected value of a continuous random variable is expressed by the following formula: $$E[X] = \int_{-\infty}^{\infty} x f(x) \, dx$$ Here, $x$ represents the random variable and $f(x)$ represents the probability density function which is obtained by integrating over the entire domain of the probability density function. The expected value of a normal distribution matches the mean parameter, so the true value in this case is set to $100$.` |
| `2. 平均100,標準偏差3の正規分布の分散を計算してみよう。なお連続確率変数の分散は次の式で表されます。$$\sigma^2 = \int_{-\infty}^{\infty} (x - \mu)^2 f(x) \, dx$$ ここで$\mu$は確率変数の期待値であり，正規分布の分散は，標準偏差パラメータの二乗に一致しますので，今回の真値は$3^2 = 9$です。` | `2. Let's calculate the variance of a normal distribution with a mean of 100 and a standard deviation of 3. The variance of a continuous random variable is represented by the following equation: $$\sigma^2 = \int_{-\infty}^{\infty} (x - \mu)^2 f(x) \, dx$$ Here, $\mu$ is the expected value of the random variable, and the variance of the normal distribution matches the square of the standard deviation parameter, so the true value for this instance is $3^2 = 9$.` |
| `3. 平均65，標準偏差10の正規分布に従う確率変数$X$の，$90 < X < 110$の面積。解析的に計算した結果は次の通りです。` | `3. The area for the random variable $X$, which follows a normal distribution with a mean of 65 and a standard deviation of 10, lies between $90 < X < 110$. The result, calculated analytically, is as follows.` |
| `pnorm(108, mean = 65, sd = 10) - pnorm(92, mean = 65, sd = 10)` | `pnorm(108, mean = 65, sd = 10) - pnorm(92, mean = 65, sd = 10)` |
| `4. 平均10，標準偏差10の正規分布において，実現値が7以上になる確率。解析的に計算した結果は次の通りです。` | `4. The probability that the realized value will be 7 or higher in a normal distribution with a mean of 10 and a standard deviation of 10. The results calculated analytically are as follows.` |
| `1 - pnorm(7, mean = 10, sd = 10)` | `1 - pnorm(7, mean = 10, sd = 10)` |
| `5. 確率変数$X,Y$があります。$X$は平均10,SD10の正規分布，$Y$は平均5，SD8の正規分布に従うものとします。ここで，$X$と$Y$が独立であるとしたとき，和$Z=X+Y$の平均と分散が，もとの$X,Y$の平均の和，分散の和になっていることを，乱数を使って確認してください。` | `5. Let's consider two random variables, $X$ and $Y$. Assume that $X$ follows a normal distribution with an average of 10 and a standard deviation of 10, while $Y$ follows a normal distribution with an average of 5 and a standard deviation of 8. Here, assuming that $X$ and $Y$ are independent, verify using random numbers that the mean and variance of the sum $Z=X+Y$ are equal to the sum of the original means and variances of $X$ and $Y$.` |
| `## 母集団と標本` | `## Population and Sample` |
| `ここまで確率分布の性質を見るために乱数を利用する方法を見てきた。ここからは，推測統計学における確率分布の利用を考える。推測統計では，知りたい集団全体のことを**母集団population**，そこから得られた一部のデータを**標本sample**と呼ぶのであった。標本の統計量を使って，母集団の性質を推論するのが推測統計/統計的推測である。母集団の特徴を表す統計量は**母数parameter**と呼ばれ，母平均，母分散など「母」の字をつけて母集団の情報であることを示す。同様に，標本の平均や分散も計算できるが，この時は標本平均，標本分散など「標本」をつけて明示的に違いを強調することもある。` | `So far, we have seen how to use random numbers to understand the properties of probability distributions. From this point on, we will consider the use of probability distributions in inferential statistics. Recall that in inferential statistics, the entire group we want to know about is called the **population**, and a subset of data obtained from this group is referred to as a **sample**. The goal of inferential statistics, or statistical inference, is to use sample statistics to infer the properties of the population. 

Statistics that represent the characteristics of the population are called **parameters**, which indicate information about the population, such as the population mean or population variance, often referred to with the prefix 'population'. Similarly, we can calculate things like the sample mean or sample variance, and we often explicitly emphasize the difference by adding the word 'sample'.` |
| `乱数を使って具体的な例で見てみよう。ここに100人から構成される村があったとする。この村の人々の身長を測ってデータにしたとしよう。100個の適当な数字を考えるのは面倒なので，乱数で生成してこれに代える。` | `Let's look at a specific example using random numbers. Suppose there was a village composed of 100 people. Let's say we measured the heights of the people in this village and gathered data. Since it's troublesome to think of 100 suitable numbers, we'll generate them using random numbers instead.` |
| `set.seed(12345)` | `set.seed(12345)` |
| `# 100人分の身長データをつくる。小数点以下2桁を丸めた` | `# 100人分の身長データをつくる。小数点以下2桁を丸めた` |
| `Po <- rnorm(100, mean = 150, sd = 10) %>% round(2)` | `Po <- rnorm(100, mean = 150, sd = 10) %>% round(2)` |
| `print(Po)` | `print(Po)` |
| `この100人の村が母集団なので，母平均や母分散は次のようにして計算できる。` | `Since this village of 100 people represents the population, we can calculate the population mean and population variance as follows.` |
| `M <- mean(Po)` | `M <- mean(Po)` |
| `V <- mean((Po - M)^2)` | `V <- mean((Po - M)^2)` |
| `# 母平均` | `# 母平均` |
| `print(M)` | `print(M)` |
| `# 母分散` | `# 母分散` |
| `print(V)` | `print(V)` |
| `さて，この村からランダムに10人の標本を得たとしよう。ベクトルの前から10人でも良いが，Rにはサンプリングをする関数`sample`があるのでこれを活用する。` | `Now, let's assume we've obtained a random sample of 10 people from this village. You can take the first 10 people in the vector, but R has a `sample` function for sampling, which we can utilize.` |
| `s1 <- sample(Po, size = 10)` | `s1 <- sample(Po, size = 10)` |
| `s1` | `s1` |
| `この`s1`が手元のデータである。心理学の実験でデータを得る，というのはこのように全体に対してごく一部だけ取り出したものになる。このサンプルの平均や分散は標本平均，標本分散である。` | `Here, `s1` is the data we have at hand. When we gather data in a psychology experiment, it will typically be a small sample drawn from the overall population. The average and variance of this sample are referred to as the sample mean and sample variance.` |
| `m1 <- mean(s1)` | `m1 <- mean(s1)` |
| `v1 <- mean((s1 - mean(s1))^2)` | `v1 <- mean((s1 - mean(s1))^2)` |
| `# 標本平均` | `# 標本平均` |
| `print(m1)` | `print(m1)` |
| `# 標本分散` | `# 標本分散` |
| `print(v1)` | `print(v1)` |
| `今回，母平均は`r M`で標本平均は`r m1`である。実際に知りうる値は標本の値だけなので，標本平均`r m1`を得たら，母平均も`r m1`に近い値だろうな，と推測するのはおかしなことではないだろう。しかし標本平均は，標本の取り方によって毎回変わるものである。試しにもう一つ，標本をとったとしよう。` | `In this case, the population mean is `r M`, while the sample mean is `r m1`. Since the only values we are actually able to be aware of are the sample ones, it wouldn't be strange to hypothesize that if we obtain a sample mean of `r m1`, then the population mean is likely close to `r m1` as well. However, the sample mean changes every time, depending on how the samples are drawn. Let's try drawing another sample for comparison's sake.` |
| `s2 <- sample(Po, size = 10)` | `s2 <- sample(Po, size = 10)` |
| `s2` | `s2` |
| `m2 <- mean(s2)` | `m2 <- mean(s2)` |
| `v2 <- mean((s2 - mean(s2))^2)` | `v2 <- mean((s2 - mean(s2))^2)` |
| `# 標本平均その2` | `# 標本平均その2` |
| `print(m2)` | `print(m2)` |
| `今回の標本平均は`r m2`になった。このデータが得られたら，諸君は母平均が「`r m2`に近い値だろうな」と推測するに違いない。標本1の`r m1`と標本2の`r m2`を比べると，前者の方が正解`r M`に近い(その差はそれぞれ`r M-m1`と`r M-m2`である)。つまり，標本の取り方によっては当たり外れがあるということである。データをとって研究していても，仮説を支持する結果なのかそうでないのかは，こうした確率的揺らぎの下にある。` | `The sample mean obtained this time turned out to be `r m2`. Once you gather such data, it's safe to infer that the population mean is likely close to `r m2`. If we compare the sample 1 mean `r m1` with the sample 2 mean `r m2`, the former is closer to the correct answer `r M` (with the difference accounted for by `r M-m1` and `r M-m2`, respectively). In other words, depending on how the samples are collected, there may be some hit-or-miss variables. Even when collecting and researching data, whether the results support the hypothesis or not is subject to such probabilistic fluctuations.` |
| `つまり，**標本は確率変数であり，標本統計量も確率的に変わりうる**ものである。標本統計量でもって母数を推定するときは，標本統計量の性質や標本統計量が従う確率分布を知っておく必要がある。以下では母数の推定に望ましい性質を持つ推定量の望ましい性質をみていこう。` | `In other words, a **sample is a random variable, and sample statistics can also change probabilistically**. When estimating parameters using sample statistics, it is necessary to know the properties of the sample statistics and the probability distribution they follow. In the following, we will look at the desirable properties of estimators, which possess preferable characteristics for parameter estimation.` |
| `## 一致性` | `## Consistency` |
| `最も単純には，標本統計量が母数に近ければ近いほど，できれば一致してくれれば喜ばしい。先ほどの例では100人の村から10人しか取り出さなかったが，もし20人，30人とサンプルサイズが大きくなると母数に近づいていくことが予想できる。この性質のことを**一致性**consistencyといい，推定量が持っていてほしい性質のひとつである。幸い，標本平均は母平均に対して一致性を持っている。` | `In its simplest form, we would be pleased if the sample statistics were as close as possible to the population parameters, preferably matching them. In the previous example, we only took out 10 people from a village of 100, but it can be predicted that if the sample size increases to 20, 30, etc., it will get closer to the population parameter. This property is called **consistency**, and it's one of the desirable characteristics of an estimator. Fortunately, the sample mean has consistency with the population mean.` |
| `このことを確認してみよう。サンプルサイズを様々に変えて計算してみれば良い。例として，平均50,SD10の正規分布からサンプルサイズを2から1000まで増やしていくことにしよう。サンプルを取り出すことを，乱数生成に置き換えてその平均を計算していくこととする。` | `Let's try and confirm this. We just need to experiment by changing the sample size. For example, let's gradually increase the sample size from 2 to 1000, drawing from a normal distribution with a mean of 50 and a standard deviation of 10. We'll replace taking samples with random number generation, and compute the mean each time.` |
| `set.seed(12345)` | `set.seed(12345)` |
| `sample_size <- seq(from = 2, to = 1000, by = 10)` | `sample_size <- seq(from = 2, to = 1000, by = 10)` |
| `# 平均値を格納するオブジェクトを初期化` | `# 平均値を格納するオブジェクトを初期化` |
| `sample_mean <- rep(0, length(sample_size))` | `sample_mean <- rep(0, length(sample_size))` |
| `# 反復` | `# 反復` |
| `for (i in 1:length(sample_size)) {` | `for (i in 1:length(sample_size)) {` |
| `sample_mean[i] <- rnorm(sample_size[i], mean = 50, sd = 10) %>%` | `sample_mean[i] <- rnorm(sample_size[i], mean = 50, sd = 10) %>%` |
| `mean()` | `mean()` |
| `}` | `}` |
| `# 可視化` | `# 可視化` |
| `data.frame(size = sample_size, M = sample_mean) %>%` | `data.frame(size = sample_size, M = sample_mean) %>%` |
| `ggplot(aes(x = size, y = M)) +` | `ggplot(aes(x = size, y = M)) +` |
| `geom_point() +` | `geom_point() +` |
| `geom_line() +` | `geom_line() +` |
| `geom_hline(yintercept = 50, color = "red")` | `geom_hline(yintercept = 50, color = "red")` |
| `このようにサンプルサイズが増えていくにつれて，真値の50に近づいていくことが見て取れる。母集団分布の形状やパラメータ，サンプルサイズなどを変えて確認してみよう。` | `As you can see, as the sample size increases, we approach closer to the true value of 50. Try changing the shape of the population distribution, its parameters, or the sample size to further observe this phenomenon.` |
| `## 不偏性` | `## Unbiasedness` |
| `推定量は確率変数であり，確率分布でその性質を記述することができる。標本統計量の従う確率分布のことを**標本分布**と呼ぶが，標本分布の確率密度関数がわかっているなら，その期待値や分散も計算できるだろう。推定量の期待値(平均)が母数に一致することも，推定量の望ましい性質の一つであり，この性質のことを**不偏性**unbiasednessという。` | `An estimator is a random variable, and its nature can be described with a probability distribution. The probability distribution that the sample statistics follows is called the **sampling distribution**. If you know the probability density function of the sampling distribution, you should be able to calculate its expected value or variance. Another desirable property of an estimator is that its expected value (mean) matches the parameter. This property is referred to as **unbiasedness**.` |
| `心理統計を学ぶ時に初学者を苛立たせるステップの一つとして，分散の計算の時にサンプルサイズ$n$ではなく$n-1$で割る，という操作がある。これは不偏分散といって標本分散とは違うのだが，前者が不偏性を持っているのに対し，後者がそうでないからである。これを乱数を使って確認してみよう。` | `One of the steps that can frustrate beginners when learning psychological statistics is the operation of dividing by $n-1$ instead of the sample size $n$ when calculating variance. This is called unbiased variance, which is different from sample variance. The reason is that the former has an unbiased property whereas the latter does not. Let's verify this using random numbers.` |
| `平均50，SD10(母分散$10^2=100$)の母集団から，サンプルサイズ$n=20$の標本を繰り返し得る。これはサイズ20の乱数生成で行う。各標本に対して標本分散と不偏分散を計算し，その平均(標本統計量の期待値)を計算してみよう。` | `We can repeatedly draw a sample size of $n=20$ from a population with a mean of 50 and SD10 (population variance $10^2=100$). This is done by generating random numbers of size 20. For each sample, calculate the sample variance and unbiased variance and then compute their mean (the expected value of the sample statistic).` |
| `iter <- 5000` | `iter <- 5000` |
| `vars <- rep(0, iter)` | `vars <- rep(0, iter)` |
| `unbiased_vars <- rep(0, iter)` | `unbiased_vars <- rep(0, iter)` |
| `## 乱数の生成と計算` | `## 乱数の生成と計算` |
| `set.seed(12345)` | `set.seed(12345)` |
| `for (i in 1:iter) {` | `for (i in 1:iter) {` |
| `sample <- rnorm(n = 20, mean = 50, sd = 10)` | `sample <- rnorm(n = 20, mean = 50, sd = 10)` |
| `vars[i] <- mean((sample - mean(sample))^2)` | `vars[i] <- mean((sample - mean(sample))^2)` |
| `unbiased_vars[i] <- var(sample)` | `unbiased_vars[i] <- var(sample)` |
| `}` | `}` |
| `## 期待値` | `## 期待値` |
| `mean(vars)` | `mean(vars)` |
| `mean(unbiased_vars)` | `mean(unbiased_vars)` |
| `標本分散を計算したオブジェクト`vars`の平均すなわち期待値は`r mean(vars)`であり，設定した値(真値)の100からは幾分はなれている。これに対して，Rの埋め込み関数である`var`をつかった不偏分散の平均すなわち期待値は`r mean(unbiased_vars)`であり，母分散の推定量としてはこちらの方が好ましいことがわかる。このように標本分散にはバイアスが生じることがわかっているので，あらかじめバイアスを補正するために元の計算式を修正していたのである。この説明で，苛立ちを感じていた人の溜飲が下がればよいのだが。` | `The mean or expected value of the object `vars` that calculated the sample variance is `r mean(vars)`, which is somewhat away from the set value (true value) of 100. In contrast, the mean or expected value of the unbiased variance using `var`, which is an embedded function in R, is `r mean(unbiased_vars)`. From this, we find that it is more preferable to use this as an estimator of the population variance. It is known that a bias occurs in the sample variance, so the original calculation formula was modified in advance to correct this bias. Hopefully, this explanation eases the frustration some of you might have been feeling.` |
| `他にも推定量の望ましい性質として有効性efficacyがあるが，詳細は @kosugi2023 を参照してほしい。この本には正規分布以外の例や，相関係数など他の標本統計量の例なども載っているが，いずれも乱数生成による近似で理解を進めるものである。諸君も数理統計的な説明に疲れたなら，ぜひ参考にしてもらいたい。` | `There is another desirable characteristic of estimators, efficacy, but for more details, please refer to @kosugi2023. This book includes cases other than the normal distribution and examples of other sample statistics such as correlation coefficients, all of which are understood through approximation by random number generation. If students are tired of mathematical statistical explanations, they are encouraged to use this as a reference.` |
| `## 信頼区間` | `## Confidence Interval` |
| `標本統計量は確率変数であり，標本を取るたびに変わる。標本を取るときに入る確率的ゆらぎによるからで，標本平均は一致性，不偏性という望ましい性質を持ってはいるが，標本平均$=$母平均とはならない。` | `Sample statistics are random variables, changing each time we collect a sample. This change is due to the probabilistic fluctuations that occur when collecting a sample. Although the sample mean possesses desirable properties such as consistency and unbiasedness, it is not equal to the population mean.` |
| `標本平均という確率変数の実現値一点でもって，母平均を推測することは，母平均を推測する上ではほぼ確実に外れるギャンブルである。そこで母数に対してある幅でもって推定することを考えよう。` | `Estimating the population mean using one point of the realized value of a random variable, such as the sample mean, is almost certainly a gamble that misses when estimating the population mean. Therefore, let's think about estimating the population parameters within a certain range.` |
| `たとえば平均50，標準偏差10の標準正規分布を母集団分布とし，サンプルサイズ10の標本をとり，その標本平均を母平均の推定値としよう(点推定)。同時に，その推定値に少し幅を持たせ，たとえば標本平均$\pm 5$の**区間推定**をしたとする。この時，真値$0$を正しく推測できる確率を，反復乱数生成のシミュレーションで確かめてみよう。` | `For example, consider a standard normal distribution with a mean of 50 and a standard deviation of 10 as the population distribution. Let's draw a sample of size 10 from this distribution and use the sample mean as an estimate of the population mean (point estimation). At the same time, allow some range in this estimate. For instance, we might perform an **interval estimation** of the sample mean ± 5. Let's use a simulation of repeated random number generation to verify the probability of being able to correctly estimate the true value of $0$.` |
| `iter <- 10000` | `iter <- 10000` |
| `n <- 10` | `n <- 10` |
| `mu <- 50` | `mu <- 50` |
| `SD <- 10` | `SD <- 10` |
| `# 平均値を格納しておくオブジェクト` | `# 平均値を格納しておくオブジェクト` |
| `m <- rep(0,iter)` | `m <- rep(0,iter)` |
| `set.seed(12345)` | `set.seed(12345)` |
| `for (i in 1:iter) {` | `for (i in 1:iter) {` |
| `# サンプリングし，標本統計量を保存` | `# サンプリングし，標本統計量を保存` |
| `sample <- rnorm(n, mean = mu, sd = SD)` | `sample <- rnorm(n, mean = mu, sd = SD)` |
| `m[i] <- mean(sample)` | `m[i] <- mean(sample)` |
| `}` | `}` |
| `result.df <- data.frame(m = m) %>%` | `result.df <- data.frame(m = m) %>%` |
| `# 推定が一致するとTRUE,外れるとFALSEになる変数を作る` | `# 推定が一致するとTRUE,外れるとFALSEになる変数を作る` |
| `mutate(` | `mutate(` |
| `point_estimation = ifelse(m == mu, TRUE, FALSE),` | `point_estimation = ifelse(m == mu, TRUE, FALSE),` |
| `interval_estimation = ifelse(m - 5 <= mu & mu <= m + 5, TRUE, FALSE)` | `interval_estimation = ifelse(m - 5 <= mu & mu <= m + 5, TRUE, FALSE)` |
| `) %>%` | `) %>%` |
| `summarise(` | `summarise(` |
| `n1 = sum(point_estimation),` | `n1 = sum(point_estimation),` |
| `n2 = sum(interval_estimation),` | `n2 = sum(interval_estimation),` |
| `prob1 = mean(point_estimation),` | `prob1 = mean(point_estimation),` |
| `prob2 = mean(interval_estimation)` | `prob2 = mean(interval_estimation)` |
| `) %>% print()` | `) %>% print()` |
| `結果からわかるように，点推定値は一度も正しく母数を当てていない。これは当然で，実数でやる以上小数点以下どこかでズレてしまうことがあるからで，精度を無視すると一致することはあり得ないのである。これに対して幅を持った予測の場合は，`r iter`回の試行のうち`r result.df$n2`回はその区間内に真値を含んでおり，その正答率は`r result.df$prob2 * 100`%である。` | `As you can see from the results, the point estimate never correctly guesses the population parameter. This is to be expected, as there may be some deviation at some decimal point when dealing with real numbers, and it's impossible to match if we disregard precision. On the other hand, in the case of a prediction with a margin, the true value is included within that range `r result.df$n2` times out of `r iter` trials, and the accuracy rate is `r result.df$prob2 * 100`%.` |
| `区間推定において正答率を100%にするためには，その区間を無限に広げなければならない(母平均の推定の場合)。これは実質的に何も推定していないことに等しいので，5%程度の失敗を認めよう，95% の正答率で区間推定しようというのが習わしになっている。この区間のことを95%の**信頼区間**confidence intervalという。` | `In interval estimation, in order to make the accuracy rate 100%, that interval must be expanded infinitely (in the case of estimating the population mean). This is tantamount to essentially not estimating anything, so the standard practice is to allow for about a 5% failure rate and make interval estimates with a 95% accuracy rate. This interval is referred to as the 95% **confidence interval**.` |
| `### 正規母集団分布の母分散が明らかな場合の信頼区間` | `### Confidence Intervals When the Population Variation of a Normal Distribution is Known` |
| `上のシミュレーションを応用して，区間推定が正当する確率が95%になるまで区間を調整して行ってもよいが，さすがにそれは面倒なので，推測統計学によって明らかになっている性質を紹介しよう。` | `We could certainly take the simulation we learned above and keep adjusting the interval until the probability of producing a valid interval estimate reaches 95%. However, since that's quite cumbersome, let's introduce a characteristic revealed by inferential statistics.` |
| `母集団が正規分布に従い，その母平均が$\mu$，母分散が$\sigma^2$であることがわかっている場合，標本平均の従う分布は平均$\mu$, 分散$\frac{\sigma^2}{n}$(標準偏差$\frac{\sigma}{\sqrt{n}})$の正規分布であることがわかっている。` | `We know that if a population follows a normal distribution, and it's understood that the population mean is $\mu$ and the population variance is $\sigma^2$, then the distribution of the sample mean is known to be a normal distribution with a mean of $\mu$ and a variance of $\frac{\sigma^2}{n}$ (standard deviation of $\frac{\sigma}{\sqrt{n}}$).` |
| `標準正規分布の95%区間は，次の通り約$\pm 1.96$である。` | `The 95% interval of the standard normal distribution is approximately $\pm 1.96$.` |
| `# 両端から2.5%ずつ取り除くと` | `# 両端から2.5%ずつ取り除くと` |
| `qnorm(0.025)` | `qnorm(0.025)` |
| `qnorm(0.975)` | `qnorm(0.975)` |
| `これらを合わせると，標本平均が$\bar{X}$であったとき，95%信頼区間は標準偏差を1.96倍して，次のようになる。` | `When we combine these, we find that when the sample mean is $\bar{X}$, the 95% confidence interval can be found by multiplying the standard deviation by 1.96, as shown below.` |
| `$$ \bar{X} - 1.96 \frac{\sigma}{\sqrt{n}} \le \mu \le \bar{X} + 1.96 \frac{\sigma}{\sqrt{n}} $$` | `$$ \bar{X} - 1.96 \frac{\sigma}{\sqrt{n}} \le \mu \le \bar{X} + 1.96 \frac{\sigma}{\sqrt{n}} $$

This formula provides the confidence interval for a population mean (μ). Here, the population mean is estimated to be within this range, 95% of the time. 

In the provided equation:

- $\bar{X}$ is the sample mean,
- ${\sigma}$ is the population standard deviation,
- $n$ is the sample size.

So, the entire left-hand side of the equation $\bar{X} - 1.96 \frac{\sigma}{\sqrt{n}}$ represents the lower bound of the confidence interval, and the right-hand side $\bar{X} + 1.96 \frac{\sigma}{\sqrt{n}}$ represents the upper bound of the confidence interval.

1.96 is a constant derived from the normal distribution, signifying the margin whereby 95% of values lay around the mean. This metric is commonly used in statistics.

The term $\sqrt{n}$ under ${\sigma}$ indicates that as the sample size increases, the confidence interval becomes narrower, improving the estimate's precision. 

Overall, this equation enables us to forecast the true population mean from our sample data with a certain degree of confidence (95% in this case).` |
| `先ほどの数値例を応用して，これを確かめてみよう。95％ちかい割合で，区間内に真値が含んでいることがわかる。` | `Let's confirm this by applying the numerical examples provided earlier. We will find that in nearly 95% of cases, the true value is contained within the interval.` |
| `interval <- 1.96 * SD / sqrt(n)` | `interval <- 1.96 * SD / sqrt(n)` |
| `result.df2 <- data.frame(m = m) %>%` | `result.df2 <- data.frame(m = m) %>%` |
| `# 推定が一致するとTRUE,外れるとFALSEになる変数を作る` | `# 推定が一致するとTRUE,外れるとFALSEになる変数を作る` |
| `mutate(` | `mutate(` |
| `interval_estimation = ifelse(m - interval  <= mu & mu <= m + interval, TRUE, FALSE)` | `interval_estimation = ifelse(m - interval  <= mu & mu <= m + interval, TRUE, FALSE)` |
| `) %>%` | `) %>%` |
| `summarise(` | `summarise(` |
| `prob = mean(interval_estimation)` | `prob = mean(interval_estimation)` |
| `) %>% print()` | `) %>% print()` |
| `### 正規母集団分布の母分散が不明な場合の信頼区間` | `### Confidence Interval for Normal Population Distribution When Population Variance is Unknown` |
| `先ほどの例では母分散がわかっている場合の例であったが，母平均や母分散がわかっていれば推測する必要はないわけで，実践的には母分散がわからない場合の推定が必要になってくる。幸いにしてそのような場合，すなわち母分散を不偏分散(標本統計量)で置き換えた場合は，標本平均が自由度$n-1$のt分布に従うことがわかっている。(詳細は @kosugi2023 を参照)` | `In the previous example, we discussed the case when the population variance is known. However, if we know the population mean or variance, there's no need to estimate it. In practical terms, it becomes necessary to estimate when the population variance is unknown. Fortunately, in such cases, that is, when we replace the population variance with an unbiased variance (sample statistic), it is known that the sample mean follows a t-distribution with degrees of freedom $n-1$. (For more details, please reference @kosugi2023)` |
| `ただその場合，標準正規分布のように95%区間が$\pm 1.96$に限らず，サンプルサイズに応じてt分布の形が変わるから，それを考慮して以下の式で信頼区間を算出する。` | `In this case, however, just like the standard normal distribution, the 95% interval isn’t always $\pm 1.96$. This is because the shape of the t-distribution varies according to the sample size. Keeping this in mind, we use the following formula to calculate the confidence interval.` |
| `$$ \bar{X} + T_{0.025}\frac{U}{\sqrt{n}} \le \mu \le \bar{X} + T_{0.975}\frac{U}{\sqrt{n}} $$` | `This is not a Japanese text but a mathematical formula. Hence, no translation is needed. However, I can provide a simple explanation: 

This formula is used in statistics to create a confidence interval for the unknown population mean (µ) when the population standard deviation is not known. Here, "X bar" represents the sample mean, "T" refers to our test statistic value, "U" is an estimate of the standard error, and "n" stands for our sample size. Using this equation, we can estimate a range where the true population mean is likely to lie, with a certain level of confidence.` |
| `ここで$T_{0.025}$はt分布の2.5パーセンタイル，$T_{0.975}$は97.5パーセンタイルを指す。t分布は(平均が0であれば)左右対称なので，$T_{0.025}=-T_{0.975}$と考えても良い。また$U^2$は不偏分散である($U$はその平方根)。` | `Here, $T_{0.025}$ refers to the 2.5 percentile of the t-distribution, and $T_{0.975}$ refers to the 97.5 percentile. If the mean of the t-distribution is 0, it's considered as symmetric, so you could think of it as $T_{0.025}=-T_{0.975}$. Additionally, $U^2$ is the unbiased variance ($U$ is its square root).` |
| `これも乱数による近似計算で確認しておこう。同じく95％ちかい割合で，区間内に真値が含んでいることがわかる。` | `Let's also verify this using a probabilistic approximation with random numbers. Similarly, we can see that the true value is included within the interval nearly 95% of the time.` |
| `# シミュレーションの設定` | `# シミュレーションの設定` |
| `iter <- 10000` | `iter <- 10000` |
| `n <- 10` | `n <- 10` |
| `mu <- 50` | `mu <- 50` |
| `SD <- 10` | `SD <- 10` |
| `# 平均値を格納しておくオブジェクト` | `# 平均値を格納しておくオブジェクト` |
| `m <- rep(0,iter)` | `m <- rep(0,iter)` |
| `interval <- rep(0,iter)` | `interval <- rep(0,iter)` |
| `set.seed(12345)` | `set.seed(12345)` |
| `for (i in 1:iter) {` | `for (i in 1:iter) {` |
| `# サンプリングし，標本統計量を保存` | `# サンプリングし，標本統計量を保存` |
| `sample <- rnorm(n, mean = mu, sd = SD)` | `sample <- rnorm(n, mean = mu, sd = SD)` |
| `m[i] <- mean(sample)` | `m[i] <- mean(sample)` |
| `U <- sqrt(var(sample)) # sd(sample)でも同じ` | `U <- sqrt(var(sample)) # sd(sample)でも同じ` |
| `interval[i] <- qt(p=0.975,df=n-1) * U / sqrt(n)` | `interval[i] <- qt(p=0.975,df=n-1) * U / sqrt(n)` |
| `}` | `}` |
| `result.df <- data.frame(m = m,interval = interval) %>%` | `result.df <- data.frame(m = m,interval = interval) %>%` |
| `# 推定が一致するとTRUE,外れるとFALSEになる変数を作る` | `# 推定が一致するとTRUE,外れるとFALSEになる変数を作る` |
| `mutate(` | `mutate(` |
| `interval_estimation = ifelse(m - interval <= mu & mu <= m + interval, TRUE, FALSE)` | `interval_estimation = ifelse(m - interval <= mu & mu <= m + interval, TRUE, FALSE)` |
| `) %>%` | `) %>%` |
| `summarise(` | `summarise(` |
| `prob = mean(interval_estimation)` | `prob = mean(interval_estimation)` |
| `) %>% print()` | `) %>% print()` |
| `## 練習問題；推定量と区間推定` | `## Practice Problems: Estimators and Interval Estimates` |
| `1. 算術平均$M = \frac{1}{n}\sum x_i$が一致推定量であることが示されましたが，調和平均$HM = \frac{n}{\sum \frac{1}{x_i}}$や幾何平均$GM = (\prod x_i)^{\frac{1}{n}} = \exp(\frac{1}{n}\sum \log(x_i)))$はどうでしょうか。シミュレーションで確かめてみましょう。` | `1. We have shown that the arithmetic mean $M = \frac{1}{n}\sum x_i$ is a consistent estimator. But what about the harmonic mean $HM = \frac{n}{\sum \frac{1}{x_i}}$ or the geometric mean $GM = (\prod x_i)^{\frac{1}{n}} = \exp(\frac{1}{n}\sum \log(x_i)))$? Let's confirm this through simulation.` |
| `2. サンプルサイズ$n$が大きくなるほど，標本平均が母平均に近づくという性質は正規分布以外でも成立するでしょうか。自由度$\nu = 3$のt分布を使って，シミュレーションで確認してみましょう。なおt分布の乱数は`rt()`で生成でき，非心度パラメータ`ncp`を指定しなければその平均は0です。` | `2. Does the property that the sample mean approaches the population mean as the sample size $n$ increases hold true for distributions other than the normal distribution? Let's verify this using a simulation with the t-distribution, where the degrees of freedom $\nu = 3$. Note that random numbers for the t-distribution can be generated using `rt()`, and if the non-centrality parameter `ncp` is not specified, its mean is zero.` |
| `3. t分布の自由度$\nu$が極めて大きい時は，標準正規分布に一致することがわかっています。`rt()`関数を使って自由度が10,50,100のときの乱数を1000個生成し，ヒストグラムを書いてその形状を確認しましょう。また乱数の平均と標本標準偏差を計算し，標準正規分布に近づくことを確認しましょう。` | `3. We know that when the degrees of freedom $\nu$ of the t-distribution is extremely large, it conforms to the standard normal distribution. Let's use the `rt()` function to generate 1000 random numbers when the degrees of freedom are 10, 50, and 100, and plot a histogram to verify their shapes. Also, let's calculate the mean and sample standard deviation of the random numbers to confirm that they are approaching the standard normal distribution.` |
| `4. 平均が50，標準偏差が10の正規分布から1000個の乱数を生成し，その標本平均の95%信頼区間を計算してください。` | `4. Please generate 1000 random numbers from a normal distribution with a mean of 50 and a standard deviation of 10, and then calculate the 95% confidence interval of their sample mean.` |
| `5. 平均が100，標準偏差が15の正規分布から抽出された標本について，サンプルサイズを10，100，1000と変えたときの標本平均の95%信頼区間の幅を比較してください。` | `5. Please compare the widths of the 95% confidence intervals for sample means when the sample sizes are 10, 100, and 1000, drawn from a normal distribution with a mean of 100 and a standard deviation of 15.` |
