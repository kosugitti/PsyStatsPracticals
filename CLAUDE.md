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
- `en/` — 英語版
- `jp/docs/`, `en/docs/` — HTML出力（GitHub Pages公開）
- `common/`, `develop/` — 共通素材・開発用
- `translations/` — 翻訳作業ログ
- 各種 .csv — 演習用データ

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

## 改訂・執筆ToDo

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

- ローカル: `cd jp && quarto render` で `jp/docs/` に出力
- GitHub Pages: `docs/` をpushすると自動反映
- `compile.sh` にビルド一式のスクリプトあり
