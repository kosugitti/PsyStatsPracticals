# PsyStatsPracticals WORKLOG

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
