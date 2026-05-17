# PsyStatsPracticals WORKLOG

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
