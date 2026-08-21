# PsyStatsPracticals — 心理学統計実習

## 概要

- 書籍タイトル: 「心理学統計実習」(Exercises in Psychological Statistics with R/RStudio)
- 著者: 小杉考司
- 公開URL: https://kosugitti.github.io/PsyStatsPracticals/
- 言語版: 日本語版 `jp/`, 英語版 `en/`
- 出版形式: Quarto Book（HTML + PDF + EPUB）
- リポジトリ: github.com/kosugitti/PsyStatsPracticals

## 利用先

- 専修大学 D8 心理学データ解析基礎（前期） — 一部参照（主教材はBasicBook3）
- 東大非常勤 D12 認知行動科学特論2（2026年度前期） — 主教材として使用。全13回のうち第2回以降の授業計画に組み込み済み（詳細: `~/Dropbox/01_教育/東大_認知行動科学特論2/CLAUDE.md`）

## フォルダ構成

- `jp/` — 日本語版 Quarto ソース（chapter01.qmd 〜 chapter17.qmd）
- `en/` — 英語版 Quarto ソース（2026-05-17 再構築。Phase 1 として ch01 翻訳済み）
- `docs/` — GitHub Pages 公開先（日本語版がルート，英語版が `docs/en/`）
- `common/`, `develop/` — 共通素材・開発用
- `translations/` — 旧翻訳作業ログ（2024年版・参照用）
- 各種 .csv — 演習用データ

### en/ の構成と運用

- `en/_quarto.yml`，`en/index.qmd`，`en/chapter*.qmd`，`en/references.qmd`
- `en/images/`，`en/styles.css`，`en/cover.png` は `jp/` から **実体コピー**（Quarto がレンダリング時にシンボリックリンクを再生成しようとして壊れるため symlink 不可。**これらは `docs/` へコピーされて配信される出力側のリソース**である）
- `en/myBiber.bib` は **`jp/` と同じく `../../../myBiber.bib` への相対 symlink**（2026-08-21 に実体コピーから変更）。**正本は `~/Dropbox/myBiber.bib` ただ1つで，複製は置かない。**bib はレンダリング時の入力であって出力に載らないので実体である理由がなく，実際 5/17 で凍結された複製が正本より36件少ないまま残っていた。`.gitignore` 済みで compile.sh が毎回張り直す
- 章を追加翻訳したら `en/_quarto.yml` の `chapters:` リストに足す（現在は ch01 のみ）
- 言語スイッチャーは両方の `_quarto.yml` の `book.sidebar.tools` に設定済み（サイドバーに translate アイコンが出る）
- 公開URL: 日本語版 `https://kosugitti.github.io/PsyStatsPracticals/`，英語版 `https://kosugitti.github.io/PsyStatsPracticals/en/`

### 翻訳方針

- 想定読者: 院生・研究者（学術英語，受動態・専門用語を厭わない）
- **綴りは米国式（American）に統一**（2026-06-05 に全章 British→American 変換済み。`modeling`/`-ize`/`color`/`center` 等）。新章翻訳時も American で書く。一括変換器は `/tmp/americanize.py`（curated 語マップ＋同綴り語保持。残したければリポジトリ内に移すこと）
- Rコードチャンクはそのまま，コメントのみ英訳。図中の日本語ラベルは当面そのまま（Phase完了後にまとめて差し替え）
- 引用文献は原則そのまま（日本語文献は原タイトル＋必要に応じて英訳併記）
- インストールガイドのリンクは英語資源（CRAN, Posit, R for Data Science, Homebrew）に置換

### Phase 計画

- Phase 1: ch01–05（R基礎）— **完了（2026-05-17）**
- Phase 2: ch06–10（推測統計基礎）— **完了（2026-05-17）**
- Phase 3: ch11–14（回帰・線形モデル）— **完了（2026-05-17）**
- Phase 4: ch15–17（多変量・ベイズ）+ install_guide + practices + afterword — **完了（2026-05-17）。テキスト全章の英訳完成**

### 用語集

- `en/common/glossary.md` に主要用語の日英対応を整備済み。新章翻訳時はまずここを参照し，足りない用語は逐次追記して一貫性を担保する

## 章構成（日本語版）

| 章 | タイトル | 語数目安 |
|---|---|---|
| ch01 | はじめようR/RStudio | 311 |
| ch02 | Rの基礎 | 679 |
| ch03 | Rによるデータハンドリング | 728 |
| ch04 | Rによるレポートの作成 | 1013 |
| ch05 | Rでプログラミング | 716 |
| ch06 | 確率とシミュレーション | 1596 |
| ch07 | 統計的仮説検定 | 915 |
| ch08 | 平均値差の検定 | 1232 |
| ch09 | 多群の平均値差の検定 | 880 |
| ch10 | 疑わしき研究実践とサンプルサイズ設計 | 1653 |
| ch11 | 重回帰分析の基礎 | 1040 |
| ch12 | ベイズ統計の活用 | 574 |
| ch13 | 線型代数の基礎 | 1267 |
| ch14 | 線型モデルの展開 | 3596 |
| ch15 | 多変量解析(その1) | 1933+ |
| ch16 | 多変量解析(その2) | 2863 |
| ch17 | ベイジアンモデリング | 1639 |
| ch18 | ベイズの観点から見た平均値差の検定 | — |
| install_guide | インストールガイド | — |

※ ch18（2026-06-05 追加）: t検定・分散分析をベイズで再構成し，ROPE・ベイズファクター（Savage-Dickey の事前/事後 density-ratio 可視化を含む）・事後予測分布（モデル妥当性＋データレベルの優越率/重複度/閾上率による効果検証）を解説。生Stan(`bayes_ttest.stan`/`bayes_anova.stan`)中心＋brmsで答え合わせ。素材は `Labo/Work：出版/RRStudio` ch8（分散分析の組成）と `psychometrics_syllabus/.../course_materials2/tex/x27_modeling3.tex`。日本語図は ragg_png + `family="Hiragino Sans"`（IPAexGothic 不在環境のため），`logspline` 依存追加。

## パッケージ運用

- 教材内のパッケージ呼び出しは全て `pacman::p_load(...)` で統一済（`library()` 不使用）
- `install_guide.qmd` に全30パッケージの一括インストールコードを掲載。同等のスクリプトは `~/Dropbox/setup_packages.R` にも配置
- `brms` はバックエンドを `cmdstanr` に統一（rstan非依存）。各章で `pacman::p_load(brms)` 直後に `options(brms.backend = "cmdstanr")` を入れている
- `cmdstanr` は CRAN ではなく Stan-dev r-universe から: `install.packages("cmdstanr", repos = c("https://stan-dev.r-universe.dev", "https://cloud.r-project.org"))`

## 改訂・執筆ToDo

### 英語版の図中日本語ラベル差し替え（2026-05-17 調査済，未着手）

en/ から参照される 12 枚の PNG のうち**5 枚に日本語が残存**。元素材（drawio 等）がないため，スクショ再撮または画像編集ソフトでのテキスト差し替えが必要。

| ファイル | 種別 | 修正対象 | 推定難度 |
|---|---|---|---|
| `01_RStudioStart.png` | RStudio スクショ＋手書き注釈 | 「領域1〜4；エディタ/コンソール/環境等/ファイル等」4箇所 | 中（注釈レイヤー差し替え） |
| `04_RMDknit.png` | ワークフロー図（イラスト風） | 「データ.csv」「Rのコード」「ブラウザで見るHTML」「MS Wordで見る DOCX」「あみ」5箇所 | 中（元データなしの可能性） |
| `04_QuartoRender.png` | 同上（Qmd版） | 「データ.csv」「RやPythonのコード」「ブラウザで見るHTML」「MS Wordで見る DOCX」「あみ」5箇所 | 中 |
| `04_RmdSample.png` | RStudio エディタのスクショ | YAML の `author: "小杉考司"` | 低（再撮影） |
| `04_coresspRmd.png` | エディタと出力HTMLを並べたスクショ | 左ペインの YAML 「小杉考司」＋右ペイン出力タイトル付近 | 低（再撮影） |

修正不要なPNG（7枚）: `01_PaneLayout.png`, `04_QmdSample.png`, `12_stan_install.png`, `15_efa_cfa.png`, `15_fa_pca.png`, `datacube.png`, `hlm_model.png`

drawio 編集源で日本語を含むもの（`multivariate_normal.drawio` / `multivariate_normal_3d.drawio`）はそもそも本文から参照されていないので無視可。`hlm_model.drawio` のページ名 "正規分布 (Normal Distribution)" は書き出し PNG に現れない。

実施方針案: 
1. ch04 のサンプルRmd/Qmd は実際にRStudio で英語名（"Koji Kosugi"）の YAML を作って撮り直す（最短 10〜20 分）
2. `01_RStudioStart.png` の注釈4箇所は Preview や GIMP でテキスト書き換え
3. `04_RMDknit.png` / `04_QuartoRender.png` のワークフロー図は，元データ（小杉氏のオリジナル）の所在を確認するか，新規に作り直す

### ch15 SEMセクション拡充（2026-04-22 着手）

現状 ch15 の構造方程式モデリング（SEM）は「確認的因子分析（CFA）の枠組み」として紹介されているのみで，SEM独自の応用トピックが抜けている。以下のサブセクション見出しを追加済み（中身は空）:

- `### SEMの応用`
  - `#### 媒介分析` — 間接効果・直接効果・総効果, Sobel vs bootstrap, lavaan の `a*b` 記法
  - `#### 多母集団同時分析` — 測定不変性（configural/metric/scalar/strict），`group.equal`
  - `#### 成長曲線モデル` — ランダム切片・傾きを潜在変数として扱う縦断モデル，ch14 HLMとの対比

各セクション内のTODOコメントに執筆方針を記載してある。本文執筆は後日。

### 画像ファイル名の整合（2026-04-22 完了）

ch15で参照していた画像のプレフィックスが過去の章番号 `14_` のままだったため，`15_` にリネーム済み:

- `14_fa_pca.png` → `15_fa_pca.png`
- `14_efa_cfa.png` → `15_efa_cfa.png`
- `14_pca_model.png` → `15_pca_model.png`

他の章のプレフィックスは現行章番号と一致している（確認済み）。

## レンダリング・デプロイ

- ローカル（日本語版のみ）: `cd jp && quarto render` で `jp/docs/` に出力
- ローカル（英語版のみ）: `cd en && quarto render` で `en/docs/` に出力
- 統合ビルド: `./compile.sh` が日英両方をレンダリングし `jp/docs → docs/`，`en/docs → docs/en/` に配置した上で git push まで実行
- GitHub Pages: `docs/` をpushすると自動反映（`main` ブランチの `/docs`）

### compile.sh の安全装置（2026-08-01 実装）

7/11に英語版の画像・CSVが本番で壊れた事故を受けて，3つの対策を組み込んである。
**理解せずに削らないこと。**

- **対策A**: `jp/myBiber.bib`・`en/myBiber.bib` と `jp/jpa2.{bbx,cbx,dbx}` は `.gitignore` 済みのローカル symlink。
  かつて `/Users/newton/` 固定だったため別マシンで4本とも切れており，文献データベースを
  見失ったまま静かにビルドが完走する状態だった。ビルド冒頭で `$HOME` 基準に張り直し，
  解決しなければ中断する
- **対策B**: `en/` の**出力に載るリソース**（`styles.css`・`cover.png`・`images/`）は
  symlink 不可。旧版は末尾で `en/styles.css` を symlink に戻していたため，次回ビルドが
  必ず symlink 状態から始まり事故が再発する構造だった。実体コピーで維持する。
  Quarto が取りこぼしたリソースの補完も行う。
  **`en/myBiber.bib` は 2026-08-21 に対象から外した**——レンダリングの入力であって
  `docs/` に載らないので実体である理由がなく，複製は正本から取り残されるだけである
  （実際 5/17 で凍結され36件足りない状態だった）。対策A が jp/ と同じ相対 symlink を張る
- **対策C**: ビルド後に `docs/en` の画像・データCSV・HTMLの件数を前回コミットと突き合わせ，
  減っていれば，または `styles.css` の symlink 化・`search.json` の欠落があれば，
  **コミットもプッシュもせず終了コード1で中断する**
- **対策D**: 日英どちらのレンダリングも成功してから `docs/` を差し替える。
  旧版は先頭で `rm -rf docs` していたため，途中で失敗すると公開中のサイトが消えた
- **対策E**: `jp/` `en/` に残る他マシン製の Stan バイナリを削除し，
  新たに生成されたものには `com.dropbox.ignored` 属性を付けて同期対象から外す

確認用の環境変数:

| 変数 | 挙動 |
|---|---|
| `COMPILE_PREPARE_ONLY=1` | 準備段階（対策A・B）まで実行して終了 |
| `COMPILE_VERIFY_ONLY=1` | レンダリングせず，いまの `docs/en` を検算するだけ |
| `COMPILE_NO_PUSH=1` | コミットまで行い push しない |

事故った時の復旧: `git checkout HEAD -- docs/en`

### マシン間の差異で踏みやすい罠

このリポジトリは Dropbox で2台に同期されている。**git 管理外のファイルも同期される**
ことが，いくつもの事故の原因になっている。

| 対象 | 何が起きるか | 対策 |
|---|---|---|
| `jp/myBiber.bib`, `en/myBiber.bib`, `jp/jpa2.*` | 絶対パスの symlink だと相手側で切れる。文献を見失ったまま静かに完走する | **相対パスで張る**（compile.sh が毎回張り直す） |
| `jp/`, `en/` の Stan バイナリ | rpath がビルドしたマシンの絶対パスで焼き込まれ，相手側では「Fitting failed」 | 削除＋`com.dropbox.ignored` で同期対象から外す |
| Quarto のバージョン | 生成物が版ごとに変わり，ビルドするマシンによって差分が往復する | 両マシンで版を揃える。**2026-08-01時点で両機とも 1.10.18 で一致** |
| cmdstan のバージョン | MCMCの数値が版差で動く。同期除外済みなので衝突は起きないが再現性には影響 | 揃えることが望ましい。**2026-08-01時点で両機とも 2.39.0 で一致** |

### freeze 未設定の影響

`_quarto.yml` に `freeze` の指定が無いため，`quarto render` は毎回すべてのチャンクを
再実行する。ch12/17/18 は brms・Stan の MCMC を含むのでフルビルドは重く，
数値も実行のたびに変動する。**軽微な文言修正のためにフルビルドを回すと，
1文字の修正に対して差分が過大になる**。該当箇所だけ `docs/` 側も直して
ソースと揃える運用でもよい（次回フルビルドでソースから再現される）。
