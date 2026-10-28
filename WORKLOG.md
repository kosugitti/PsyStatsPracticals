# PsyStatsPracticals WORKLOG

## 2026-06-05

### ch18「ベイズの観点から見た平均値差の検定」を新規追加（日英）＋ 英語版を米国綴りに統一

東大非常勤（D12）の「t検定・分散分析をベイズの観点から見直す＋意思決定（ROPE/BF/PPC）」回の主教材として新章を追加。

#### 新規ファイル（jp/ と en/ 両方）
- `chapter18.qmd` — 本文。`_quarto.yml` の chapters に ch17 の次として登録
- `bayes_ttest.stan` — 二群（t検定）。等分散の共通 sigma，generated quantities で `diff`/標準化効果量 `delta`/事後予測 `X_pred`
- `bayes_anova.stan` — 一要因 ANOVA。整然データ対応（idx で群参照），全体平均+効果（Σδ=0制約）+誤差，`X_pred`
- `ex_anova_bayes.csv` — 課題用データ（make_exercise_data チャンクが生成）
- 素材: `Labo/Work：出版/RRStudio` ch8（分散分析の組成）+ `psychometrics_syllabus/.../course_materials2/tex/x27_modeling3.tex`（Stan 3パラメータ化＋整然データ一般化）

#### ch18 の構成
- 検定→モデリング（ベイズは多重比較問題が生じない）
- 分散分析の組成 `x_ij = μ + δ_j + e_ij` をそのままデータ生成モデル `N(μ+δ_j, σ)` に読み直す
- 生Stan(cmdstanr) で二群→多群を推定，brms（contr.sum 効果コーディング）で答え合わせ（係数が delta と一致）
- 意思決定3道具: ROPE（`bayestestR::rope`）/ ベイズファクター（Savage-Dickey: brms `sample_prior="yes"` + `bayesfactor_parameters` + `hypothesis`，**事前/事後を重ねた density-ratio 図も追加**）/ 事後予測分布（モデル妥当性 `ppc_dens_overlay` ＋**データレベルの効果検証**=優越率・重複度(被覆率,`bayestestR::overlap`)・閾上率）
- 例データ: 学習法A/B/C（gm=60, eff=+8/+6/-14, sd=8, N=40, seed=1234）。A≈B（ROPE内72.6%, BF≈38で差なし支持, 重複度94.6%）, A・BともCと明確差（重複度23.7%）
- 可視化は `bayesplot::mcmc_areas/mcmc_intervals/ppc_dens_overlay` 中心
- 依存追加: `logspline`（Savage-Dickey に必要）。`BayesFactor::anovaBF` は eval:false で参考掲載（JASP同エンジン）
- **日本語図の文字化け対策**: Savage-Dickey 図のチャンクに `#| dev: "ragg_png"` + `theme(text=element_text(family="Hiragino Sans"))`。IPAexGothic は Newton 未インストールのため Hiragino Sans を使用（mac標準で確実）

#### 英語版を全章米国綴りに統一
- 既存 en は全章 British 綴り（modelling/-ise/colour 等）だったが，ユーザ指示で **American に統一**
- `/tmp/americanize.py`（curated 語マップ＋case保持＋自己テスト）で `chapter01-17/practices/afterword/install_guide/common/glossary.md` を一括変換
  - `modelling→modeling, -ise→-ize, colour→color, centre→center, neighbour→neighbor, judgement→judgment, grey→gray` 等
  - `analysis/analyses/exercise/revise/advise/premise/Kaiser/precise` 等の同綴り語は保持（コード内 British は全てコメントか dplyr/ggplot のエイリアス `summarise`/`colour`/`grey` で，識別子は無し→安全）
  - 変更は行単位の語置換のみ（302挿入/302削除で対称）
- ch18 は最初から American で英訳，`en/_quarto.yml` 登録

#### ビルド・デプロイ
- remote を HTTPS→**SSH** に変更（`git@github.com:kosugitti/PsyStatsPracticals.git`。Claude 経由 push のため）
- `.gitignore` に `jp/bayes_ttest`,`jp/bayes_anova`,`en/bayes_ttest`,`en/bayes_anova`（コンパイル済みバイナリ）を追記
- cycle 1（日本語版）: jp フルレンダリング → `docs/` 更新 → commit/push（`24b651d`）
- cycle 2（英語版）: en 米国綴り化＋ch18 → en フルレンダリング → `docs/en/` 更新 → commit/push（`bbbd053`）
- 両版とも `quarto render` 完走，ch18 レンダリングエラー痕跡 0

#### 罠（要注意）
- **Dropbox CloudStorage 上で `rm -rf docs; mv jp/docs docs` を行うと，Dropbox が新 `docs/` を競合コピー化する**（`docs (Kosugi Koji の競合コピー YYYY-MM-DD)`）。jp ビルドで発生。中身は無事なので競合コピーを `docs/` にリネームして復旧。en ビルド（`docs/en` のみ差し替え）では発生せず

#### 次の作業
- なし（両版デプロイ済み）。GitHub Pages 反映後に表示確認

#### 残TODO（未着手）
- **en/images/ の5枚に日本語ラベル残存**（`01_RStudioStart.png`/`04_RMDknit.png`/`04_QuartoRender.png`/`04_RmdSample.png`/`04_coresspRmd.png`）。元素材なし，再撮影か画像編集で対応。詳細は `CLAUDE.md`「英語版の図中日本語ラベル差し替え」節を参照。
- ch15 SEMセクション3節（媒介分析/多母集団同時分析/成長曲線モデル）の本文執筆（スケルトンのみ，2026-04-22 着手）

## 2026-05-17

### 英語版 (`en/`) の再構築・Phase 1 着手

- 2024年に `en/` → `docs/en/` と動いた後 2025-03-26 commit c0fa06c で削除されていた英語版を再構築開始
- 想定読者: 院生・研究者（学術英語）
- 公開URLは日本語版を不変，英語版を `/en/` サブパスに置く方針

#### 作成ファイル
- `en/_quarto.yml` — Quarto book 設定（HTML のみ，PDF/EPUB は当面なし）。`book.sidebar.tools` で「日本語版」リンク
- `en/index.qmd` — Preface
- `en/chapter01.qmd` — "Getting Started with R/RStudio" 翻訳（インストールガイドのリンクは英語資源に置換）
- `en/references.qmd` — `myBiber.bib` を bibliography に
- `en/.gitignore` — Quarto 自動生成（`.quarto/`, `_freeze`）
- 共有アセットは `jp/` から **実体コピー**: `images/`, `styles.css`, `myBiber.bib`, `cover.png`
  - 当初 symlink で構成したが Quarto がレンダリング時に symlink の相対パスを `docs/` 出力先で再構成しようとして壊れるため断念

#### 既存ファイルの更新
- `jp/_quarto.yml` — `book.sidebar.tools` に「English version」リンク追加（`en/index.html` への相対リンク）
- `compile.sh` — 日本語版に続いて英語版もレンダリングし `en/docs` → `docs/en` に配置するステップ追加
- `CLAUDE.md` — `en/` 構成・翻訳方針・Phase 計画を追記

#### 検証
- `cd en && quarto render` で 3 ファイル (index/chapter01/references) が `en/docs/` に出力されることを確認
- `cd jp && quarto render index.qmd` で言語スイッチャー（translate アイコン）が両 HTML に出ることを確認
- 統合ビルド（compile.sh）の検証は未完，ユーザ側で実行予定

#### 次の作業
- Phase 1 残: ch02–05 の翻訳
- 用語集 (`en/common/glossary.md`) の整備（用語の一貫性担保）
- 図中の日本語ラベル差し替えは Phase 完了後にまとめて

### Phase 1 完走 (同日続き)

- `en/common/glossary.md` 新規作成: R/プログラミング基礎，データ型，尺度・記述統計，データハンドリング，文書・可視化の5カテゴリで日英対応を整備
- 翻訳完了:
  - `en/chapter02.qmd` "R Fundamentals" (オブジェクト・型・ベクトル・行列・リスト・データフレーム・CSV読込)
  - `en/chapter03.qmd` "Data Wrangling in R" (tidyverse・パイプ・select/filter/mutate・long/wide・group_by)
  - `en/chapter04.qmd` "Authoring Reports in R" (Rmd/Quarto・ggplot2・facet・patchwork・theme)
  - `en/chapter05.qmd` "Programming in R" (代入・for/while・if-else・関数定義)
- `en/_quarto.yml` の `chapters:` に ch02-05 追加
- `en/` に `Baseball.csv`, `Baseball2022.csv` を `jp/` から実体コピー（ch02/ch03/ch04 演習で参照）
- `cd en && quarto render` でフル book ビルド成功（7ファイル: index/ch01-05/references）
- `docs/index.html` のサイドバーに全章タイトルが英語で表示されることを確認

### Phase 2 完走 (同日続き)

- `en/common/glossary.md` に「Probability and inference」「Hypothesis testing」の2セクションを追加（推測統計用語50項目）
- 翻訳完了:
  - `en/chapter06.qmd` "Probability and Simulation" (確率分布関数, 乱数, 母集団/標本, 一致性/不偏性, 信頼区間)
  - `en/chapter07.qmd` "Null Hypothesis Significance Testing" (NHST基本ロジック, 相関係数の検定, タイプ1/2エラー)
  - `en/chapter08.qmd` "Tests of Mean Differences" (一標本/二標本/対応のあるt検定, Welch補正, 効果量Cohen's d, 検定の方向性)
  - `en/chapter09.qmd` "Multi-group Tests of Mean Differences" (一元配置/二元配置ANOVA, 球状性, anovakun, GG補正)
  - `en/chapter10.qmd` "QRPs and Sample-Size Planning" (検定の繰り返し, Bonferroni, N増し, 事前登録, 非心分布によるサンプルサイズ設計)
- `en/_quarto.yml` の `chapters:` に ch06-10 追加
- `en/` に `ex_anova1.csv`, `ex_anova2.csv` を `jp/` から実体コピー（ch09 演習で参照）
- `cd en && quarto render` でフル book ビルド成功（12ファイル: index/ch01-10/references）
- サイドバーに全章の英語タイトルが表示されることを確認

### Phase 3 完走 (同日続き)

- `en/common/glossary.md` に「Regression and linear models」「Linear algebra」「Bayesian statistics」の3セクションを追加（約90項目）
- 翻訳完了:
  - `en/chapter11.qmd` "Multiple Regression" (回帰の基礎，残差と正規性，偏回帰係数，多重共線性，VIF，階層的回帰，サンプルサイズ設計)
  - `en/chapter12.qmd` "Bayesian Statistics in Practice" (ベイズの定理，MCMC，brms，事前分布，Rhat/ESS，EAP/MED/MAP)
  - `en/chapter13.qmd` "Foundations of Linear Algebra" (スカラー/ベクトル/行列，演算，逆行列，固有値分解，スペクトル分解，PCAの基礎)
  - `en/chapter14.qmd` "Extensions of the Linear Model" (GLM→GLMM→HLM展開: ロジスティック回帰，ポアソン回帰，ランダム切片/傾き，2レベルHLM，野球データ事例)
- `en/_quarto.yml` の `chapters:` に ch11-14 追加
- `en/` に `ex_regression1.csv`, `ex_regression2.csv`, `ex_regression3.csv` を `jp/` から実体コピー
- `cd en && quarto render` でフル book ビルド成功（16ファイル: index/ch01-14/references）

#### Phase 3 の難所メモ

- **ch14 が3596語と最長**: GLM/GLMM/HLM展開を一気に進めるため，ロジスティック回帰のロジット導出，Poisson回帰のリンク関数，ランダム切片vsランダム傾きの違い，2レベルHLMのcross-level interaction，ICC，事後予測チェックまで一貫した英語で記述
- **「ANOVA Within/Between」用語**: 英語版では within-subjects / between-subjects design に統一（repeated-measures も併記）
- **ch12 brms出力の固有名詞**: `Bulk-ESS`, `Rhat`, `lprior`, `lp__` などはコード出力に出るのでそのまま英訳せず説明文で補足
- **ch13 行列演算記法**: 太字ベクトル/行列の数式は LaTeX のまま，関数説明は表でまとめ
- **ch11 yoshidaMRA 引用部**: 日本心理学会オンラインシンポジウム情報を脚注で英訳保持
- **HLM model diagram (`images/hlm_model.png`)**: 図中の日本語ラベルは当面そのまま (Phase 4完了後に一括差し替え)

### 仕上げ — 図ラベル英語化・PDF/EPUB 有効化・引用キー修正 (同日続き)

- ch16 シミュレーションデータのカラム名を英語化（`食品/衣料品/書籍/電子機器/旅行/消費者ID`→`food/clothing/books/electronics/travel/consumer_id`，都市名10件・`都市1/都市2/類似度/参加者ID`→`Tokyo,Osaka,...`/`city1/city2/similarity/participant_id`，性格項目10件・`外向性1〜開放性2`→`Extra1〜Open2`）
- `en/_quarto.yml` に `downloads: [pdf, epub]` を追加し，PDF（ltjsbook + lualatex）と EPUB 出力を有効化（日本語データ文字列・ラーメンレビュー等が残るため lualatex 必須）
- `en/index.qmd` の「Translation status」バナーを「Edition note」に変更
- 引用キー `@Nagata.kentei` → `@BA33892274`（永田・吉田 1997 『統計的多重比較法の基礎』）を jp/en の chapter09 で修正
- 図中日本語残存調査: 5枚に修正必要（ch01 + ch04 のスクショ/ワークフロー図）。詳細とTODOは CLAUDE.md「英語版の図中日本語ラベル差し替え」に記載
- フルレンダリング検証成功: 全 22 HTML + PDF 8.8MB + EPUB 5.1MB

### Phase 4 完走 (同日続き) — 英訳完成

- `en/common/glossary.md` に「Multivariate analysis」「Bayesian modelling (advanced)」セクション追加（約60項目）
- 翻訳完了:
  - `en/chapter15.qmd` "Multivariate Analysis I"（多変量解析全体像，Cattellのデータキューブ，EFA，CFA/SEM，IRT 1PL/2PL/GRM）
  - `en/chapter16.qmd` "Multivariate Analysis II"（距離行列ベース：階層的/k-means/fuzzy-c-means/GMMクラスタリング，バイクラスタリング，計量/非計量MDS。共頻行列ベース：テキストマイニング。偏相関ベース：ネットワーク分析）
  - `en/chapter17.qmd` "Bayesian Modelling"（Stan基礎，分散推定モデル，欠測補正，IRT，捕獲再捕獲，変化点検出，ゼロ過剰負の二項分布）
  - `en/install_guide.qmd`，`en/practices.qmd`，`en/afterword.qmd`
- `en/_quarto.yml` の `chapters:` に全章を追加
- `en/` に Stan ファイル群（gyudon10/missing_corr/irt2pl/recapture/change_point/zero_inflated_negbinom）と `myWeights.csv` をコピー
- `cd en && quarto render` で全 22 ファイル成功（index, ch01-17, practices, references, afterword, install_guide）

**テキスト全章英訳完成。Phase 1-4 すべて完了。**

#### Phase 4 の難所メモ

- **ch15 IRT セクション**: `exametrika` パッケージ著者の小杉先生本人によるテキストなので，著者性を維持しつつ第三者視点で英訳
- **ch16 「神エクセル」言及**: 前章 (ch03) で既に英訳済みだったので冗長な再説明は避け，関連箇所のみ簡潔に
- **ch16 バイクラスタリングの行列定義**: 数式は LaTeX のまま，フィルタ行列の数値例（0.864, 0.760 等）もそのまま保持
- **ch16 京都ラーメン例**: 日本語テキストマイニングの実例として日本語原文の Stan/R コードはそのまま保持（コメントのみ英訳）
- **ch17 Stan コードのコメント**: コードチャンク内のコメントは英訳，Stan 構文・関数名はそのまま
- **ch17 「七人の科学者」「飛行機を再捕獲する」**: Lee201709 の英訳タイトル "The seven scientists" / "Recapturing aeroplanes" を採用
- **ch17 ohtani 言及**: 「大谷翔平選手が異常」を脚注で "Shohei Ohtani is an exception" に
- **practices.qmd 最終課題3問**: Haebara200206 引用ページ番号も保持

#### 翻訳メモ（Phase 2 以降の留意点）

- 想定読者は院生・研究者なので，受動態と専門用語を厭わない。文化固有の事例（神エクセル等）には脚注で背景を補う
- 図のキャプション内 R コードの `labs()` 日本語タイトルは英語化済（ch04）。本文中の図ラベル日本語残しは Phase 4 完了後に一括差し替え
- 引用キーはそのまま，日本語文献の英訳併記は当面しない方針
- CSV データファイルは `jp/` の実体コピーで運用。`compile.sh` 走らせた時に上書きされる懸念はないが，`jp/` の CSV を編集する際は `en/` 側も忘れず更新

## 2026-04-22

### ch15 SEMセクションの枠組み追加
- SEMがCFAの一節として埋もれていた問題を踏まえ、`### SEMの応用` セクションを新設(中身空・TODOコメント付き)
  - `#### 媒介分析` — 間接効果・直接効果、Sobel vs bootstrap、lavaan `a*b` 記法
  - `#### 多母集団同時分析` — 測定不変性4段階、`group.equal`、ΔCFI/ΔRMSEA
  - `#### 成長曲線モデル` — 縦断モデル、ch14 HLMとの対比
- 本文執筆は後日

### 画像ファイル名の整合
- ch15で参照していた `images/14_*.png` を `15_*.png` にリネーム (過去の章番号の名残)
  - 14_fa_pca.png → 15_fa_pca.png
  - 14_efa_cfa.png → 15_efa_cfa.png
  - 14_pca_model.png → 15_pca_model.png (chapter15.qmdからは未参照)
- chapter15.qmd 内の画像パス参照も更新

### その他
- CLAUDE.md(プロジェクトルート)新規作成: 概要、章構成、ToDo(SEMセクション拡充、画像整合履歴)を記載
- chapter01.qmd: CRANパッケージ件数を 379,525件→23,512件、調査日 2025/04/18→2026/04/02 に更新(先行変更を取り込み)
- book全体を quarto render で再生成(HTML/PDF/EPUB)。jpa2.bbx のTeXパスエラーは ~/Library/texmf/tex/latex/biblatex-jpa2/ にスタイル一式を配置して解決

### .gitignore 整備
- TeXビルド一時ファイル (`*.aux`, `*.log`, `*.bcf`, `*.blg`, `*.bbl`, `*.toc`, `*.out`, `*.synctex.gz`, `*.run.xml` など) を除外
- Quartoキャッシュ (`**/.quarto/`, `_freeze/`) を除外
- Stanコンパイル済みバイナリ (change_point, gyudon10, irt2pl, missing_corr, recapture, zero_inflated_negbinom) を除外
- 既追跡のバイナリ群・index.log を `git rm --cached` で追跡から除外
- 履歴クリーンアップは見送り (Dropbox同期下 `.git/` でのfilter-repoはリスクが高いため)

### コミット
- 76def37 ch15: SEM応用セクション見出し追加・画像ファイル名を15_に整合
- 4803e3c ch15 + book全体再レンダリング + chapter01.qmdパッケージ件数更新 (142ファイル、4906行挿入)
- f4ab1f2 .gitignore整備: TeXログ・Stanバイナリ・Quartoキャッシュを追跡から除外

### 次回への引き継ぎ
- SEM応用セクション3つ(媒介分析、多母集団同時分析、成長曲線モデル)の本文執筆
- TeXビルド時の参考文献警告 (`Citeproc: citation Nagata.kentei not found`) の解消

## 2026-04-28

### パッケージ整理・install_guide章追加
- 教材内で利用される全パッケージ30種を抽出し，一括インストール用スクリプト `setup_packages.R` を作成
  - 配置: `~/.claude/setup_packages.R` および `~/Dropbox/setup_packages.R`
  - 構成: 1行目で `pacman` 導入，以降カテゴリ別に `pacman::p_load()` で30個ロード
- 先生が `jp/install_guide.qmd` を作成しscript内容を埋め込み，`_quarto.yml` に登録(末尾)

### library() → pacman::p_load 統一
- 教材内3箇所のみ `library()` 違反があり修正:
  - chapter15.qmd:344 `library(ggplot2)` + chapter15.qmd:345 `library(patchwork)` → `pacman::p_load(ggplot2, patchwork)` に統合
  - chapter15.qmd:661 `library(lavaanPlot)` → `pacman::p_load(lavaanPlot)`
- 全章で `library()` 残存ゼロを確認

### brmsバックエンドをcmdstanrに統一
- R 4.6.0 アップグレード後 `pkgbuild` 欠落で `rstan` ビルド失敗→`brms` がチェーンで落ちる問題発覚
- 解決: `pacman::p_load(brms)` 直後に `options(brms.backend = "cmdstanr")` を追加
  - chapter12.qmd: 1箇所
  - chapter14.qmd: 1箇所(line 259直後)
- `cmdstanr` は CRAN ではなく Stan-dev r-universe から導入: `install.packages("cmdstanr", repos = c("https://stan-dev.r-universe.dev", "https://cloud.r-project.org"))`
- CmdStan本体は既存 (`~/.cmdstan/cmdstan-2.37.0`) を流用

### symlink張り替え (Pythagoras→Newton)
- `jp/jpa2.bbx`, `jp/jpa2.cbx`, `jp/jpa2.dbx` が `/Users/pythagoras/...` 絶対パスでbroken
- Newton側 `~/Dropbox/Git/biblatex-jpa2/biblatex/jpa2.*` に張り替え
- これらは `.gitignore` 対象でローカル環境依存のため，リポジトリには影響なし

### コミット
- f41a42b install_guide章追加・brmsバックエンドをcmdstanrに統一(book全体再レンダリング含む)

### 次回への引き継ぎ
- (継続) SEM応用セクション3つの本文執筆
- (継続) Citeproc警告 `Nagata.kentei not found` 解消

## 2026-07-11

### chapter17 項目反応モデルの確率の添字修正
- IRTモデルのベルヌーイ確率が `p_i` になっていたのを `p_{ij}` に修正（式直前で $Y_{ij}$ と二重添字で定義しており，確率は個人$i$と項目$j$両方に依存するため）
  - `jp/chapter17.qmd` 345-346行: 2箇所
  - `en/chapter17.qmd` 342-343行: 2箇所
- `./compile.sh` で日英両版ビルド→GitHub Pages 反映

### compile.sh 英語版レンダリングのリソース欠落事故（発見・当座復旧）
- compile.sh 実行後のコミット(3094f7d4)で，英語版ビルドが `docs/en/` に画像12枚・データCSV12本・search.json をコピーせず削除，`docs/en/styles.css` をsymlink化していた
  - 英語版の ch01/04/12/14/15 が `images/*.png` を参照しているため，このままだと英語版サイトの画像・データが壊れる状態だった。日本語版(docs/直下)は無傷
- 原因の疑い: `en/styles.css` が `../jp/styles.css` へのsymlinkのまま残っており，Quartoのレンダリング（CLAUDE.md記載の「symlinkだと壊れる」現象）でリソースコピーが崩れた
- 当座対応: 直前コミット db4f7b0b から `docs/en` 配下の削除・型変更ファイル26件を復元し，styles.cssを実ファイルに戻してコミット(1b1f157)・push。英語版サイト復旧確認済み

### コミット
- 3094f7d4 compile.sh自動コミット（chapter17 p_ij修正＋全章再レンダリング。※en/リソース欠落を含む）
- 1b1f157 英語版ビルドが落としたdocs/enリソースを復元

### 次回への引き継ぎ
- (新規・要検討) compile.sh の英語版リソース欠落の恒久対策。レンダリング前に en/styles.css 等を実体コピーで保証する，または compile.sh に docs/en の画像・CSV枚数チェックを入れる。次に compile.sh を無対策で回すと再発の恐れ
- (継続) SEM応用セクション3つの本文執筆
- (継続) Citeproc警告 `Nagata.kentei not found` 解消
- (継続) en/images/ 5枚の日本語ラベル差し替え

## CLAUDE.mdからの退避 (2026-07-17)

ホーム索引(~/Dropbox/CLAUDE.md)のステータスセル圧縮時の退避(退避時点の全文):

日英両版デプロイ済(ch01-18+付録，全章米国綴り統一)。東大D12で主教材使用中。※compile.shの英語版レンダリングにdocs/enの画像・CSV・search.jsonを落としstyles.cssをsymlink化する既知バグあり(要en/styles.css実体化・詳細memory)。残TODO: compile.sh恒久対策，en/images/ 5枚の日本語ラベル差し替え，ch15 SEMセクション3節(媒介分析/多母集団同時分析/成長曲線モデル)本文執筆。詳細→Git/PsyStatsPracticals/{CLAUDE,WORKLOG}.md

## CLAUDE.mdからの退避 (2026-08-01)

ホーム索引(~/Dropbox/CLAUDE.md)のステータスセル圧縮時の退避(退避時点の全文)。この時点で未実行だったフルビルドは2026-08-01に実行済み。

> 日英両版デプロイ済，東大D12で主教材使用中。**compile.shの恒久対策は完了**(en/styles.cssを実体化＋jp/のsymlinkを$HOME基準へ＋ビルド後の検算でリソース減少時はpushを止める，shebangも/usr/bin/bash→env bashへ修正)。ただし**フルビルド自体は未実行**なので次回回すとき要確認。ch12の課題データリンク切れ(ex_regression3.csv)も修正・公開済。残=en画像5枚差し替え・ch15 SEM3節執筆。

## 2026-10-25 日本語版の全面校閲を反映・公開

校閲報告=`~/Dropbox/MobileTemp/PsyStatsPracticals校閲_20261024/校閲報告.md`。先生と一問一答(第1〜27問)で方針を決めて反映した。

### 決めた表記方針
- 正規分布の尺度は標準偏差・太字は`\boldsymbol`・転置はプライム・標本分散$s^2$/不偏分散$\hat\sigma^2$
- 用語: 線型・被説明変数(回帰の文脈。実験計画の従属変数/独立変数は残す)・受検者・多変量正規分布・分散共分散行列・変量効果・本文は標準偏差(表とコードはSD)・R Markdown・GitHub・Stan
- **ベイズの区間は「確信区間」**(ETIのときは初出に(ETI)を添える。Kruschkeの基準の文は「95% HDI」)。EAP/MAPは初出に規約の訳語(事後平均値/事後確率最大値)
- 課題文はです・ます調。漢字/仮名のゆれと読者への呼びかけ(諸君・あなた)は触らない。口語(〜してる等)は授業の味として残す
- 「分散分析の組成」(ch18)は先生の言い回しとして残す

### やったこと
- 数式・事実の誤り，全角記号の一括置換(0件に)，誤字脱字・不自然な表現(ch01〜18・practices・afterword)，用語の統一
- 出力との照合: ch14:1041(Team:Position の ICC も負)・ch14:278(EAP と最尤のずれの説明)・ch15:164(inline R 化)・ch15:191/223(第一因子は E1〜E5+A3,A5。簡便法コードも E1,E2 を逆転に)・ch18:417(重複度は約4分の1)
- **ch15 の因子分析は set.seed がなく geominQ の解がビルドごとに変わっていた**→`set.seed(123)`を追加(2回ビルドで一致を確認)
- `.gitignore` に `{jp,en}/missing_corr_lkj` を追加(未登録だと compile.sh の git add --all で Stan バイナリがコミットされる)
- チャンク名の綴り修正で docs の図ファイル名が変わった(hierarchical clustering・textmining_example・twomodels)

### コミット(すべて push 済み)
- b474208 / 0d924de / 50439f9 / 3cc07c4(ソース) → 9625933(compile.sh のフルビルド。英語版の検算 ok・エラー出力の件数は前回と同じ)

### 次回への引き継ぎ
- **anovakun の版番号(ch09:39・42)は 11/2 の ANOVA君 4.9.0 公開後に更新**
- 今回直さなかったもの: ch12:101「前回に倣って」→「前章」，ch15:64 の同趣旨の三度目の繰り返し，ch12:70「代表値」(MCMC の1点と EAP を同じ語で呼んでいる)，ch10・ch17 の「結果変数」，practices の「からなります」等の文体
- 手打ちの数値は再実行で動く(freeze 未設定)。今回照合して一致したもの: ch07:109，ch15:162・532，ch18 の ROPE・BF・閾上率
- 英語版(en/)には今回の修正は未反映(事実の誤り・数値の修正は英語版にも波及させるべきもの)
- PDF/ePub の統合時に「Duplicate note reference」警告が出る(各章で脚注[^1]から振っているため。既存)

## 2026-10-26〜27 校閲の残りを日英に反映・英語版の野球データを大リーグに差し替え

### やったこと
- jp の校閲の残り(db23b05): ch12:101 前回→前章，ch12 で MCMC の1点を指す「代表値」→「MCMCサンプル」(14か所)，ch17:439，ch10:178・ch17:377 の「結果変数」，ch15:64 の三度目の繰り返しを1文に，ch15:596 の文体
- en へ反映(36b0a59): jp の校閲のうち数式・事実・数値・コードの修正を全章へ。Stan も揃えた(`missing_corr.stan` の mu の制約・`bayes_ttest.stan` の delta→d・`missing_corr_lkj.stan` を jp からコピー)
- 取りこぼしの修正(7839753): jp ch13:343 固有値分解の X→U，ch14:998 会期式→回帰式，ch18:113 delta→d。en は ch04 Greys・ch17 flavored・ch07 summarise・ch15:285/325 の誤訳・ch11:204 の重複節
- **en の野球データを NPB から MLB に差し替え**(3cdbf86)。出典は R パッケージ `Lahman` 14.0.0(CC BY-SA 3.0)。年俸表が2016年までなので2011〜2016年。列= Year, Name, team(2016年の愛称を franchID ごとに。Angels は特別扱い), league, salary(千ドル), bats, throws, height(cm), weight(kg), position(守備試合数最多で Pitcher/Catcher/Infielder/Outfielder), Games, AtBats, Hit, HR, Win, Lose, Save。血液型は無し
  - ch02 演習は `Baseball2016.csv`(Win/Lose の欠測を999)，ch03 演習は2016年・ヤンキース・ア・リーグの球団名から League2・salary_m，ch04 は血液型→position
  - ch14 は2016年の野手。ICC は inline R(`sprintf("%.3f")`)で −0.052/0.123/0.000。演習は2014〜2016年の投手(Hold は削除)
  - ch17 のゼロ過剰は2016年のナ・リーグ(2022年まで DH なし)。脚注[^12]を AL/NL と DH の説明に。θ0.23・μ58.9・φ0.57・0安打28.7%
  - en のコードの `summarize(` を `summarise(` に統一(jp に合わせる・19か所)
- **案4: 読者が Lahman から自分で CSV を作る形に変更**(a2ef08c)。先生の判断=ファイルの読み込みは練習させたいがデータはパッケージのものが分かりやすい
  - `en/make_baseball.R`(英語コメント・`pacman::p_load(Lahman, dplyr, readr, stringr)`)を ch02 でダウンロードして1回 `source()`。紙の本向けに `source("https://kosugitti.github.io/PsyStatsPracticals/en/make_baseball.R")` も併記。本の描画時は include: FALSE のチャンクで手元のスクリプトを実行して CSV を作る
  - ch14・ch17 の CSV へのリンクを外し「第2章で作成」と明記。install_guide に Lahman を追加
  - CSV は compile.sh の補完で docs/en にも置かれたまま(本文からはリンクしない。パッケージを入れられない読者の予備)
- `.gitignore` に `_work/`(4ec286d)。秘書セッションが MobileTemp から MLB の試作(`_work/mlb_data/`)を移したときのもの。中身は試作で本番は `en/make_baseball.R`
- ビルド: 8dce935・0c9800d・e37a14c。検算は毎回 画像13/CSV12/HTML23 で ok，エラー出力の件数は前回と同じ。**すべて push 済み**(最後は 4ec286d)

### 踏んだ罠
- **en の Stan 実行ファイルが消えて ch17 が「Model not compiled」で止まる**(10/26 に2回・10/27 に1回)。1つずつ `Rscript -e "cmdstanr::cmdstan_model('X.stan', force_recompile = TRUE)"` でコンパイルし `xattr -w com.dropbox.ignored 1 X` を付けると通る。原因は未特定
- `cd en && quarto render chapter02.qmd` は1章だけでなく本全体を `en/` 直下に描き始める(output-dir の docs に入らない)。止めたら出たファイルを個別に消す。試すときも compile.sh を使う
- 途中で止めた compile.sh は `en/docs`・`jp/docs` を残す(次の compile.sh が消すので放置でよい)

### 次回への引き継ぎ
- **anovakun の版番号(ch09:39・42)は 11/2 の ANOVA君 4.9.0 公開後に更新**
- KDP で英語版を売る案(先生が検討中・作業の指示はまだ)。要るもの=図の日本語ラベル(en のコードの ch04・ch14・ch16・ch17 と画像5枚)，紙の本用の PDF の設定，版の管理。紙では URL の `source()` に頼る形になる
