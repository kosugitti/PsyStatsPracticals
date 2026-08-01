#!/usr/bin/env bash
# 日英両版のフルビルド → 検算 → コミット・プッシュ
#
# shebang は env 経由にしてある。macOS に /usr/bin/bash は無く（/bin/bash のみ），
# 元の #!/usr/bin/bash では ./compile.sh が bad interpreter で起動しなかった。
#
# 過去に踏んだ事故への対策が入っている。理解せずに削らないこと。
#
#   対策A: jp/ の myBiber.bib と jpa2.* は /Users/<マシン名>/ 固定の symlink だったため，
#          別マシンでは切れたまま静かにビルドが進み，文献データベースを見失う。
#          $HOME 基準で毎回張り直し，解決しなければ中断する。
#   対策B: en/ のリソースは symlink 不可（Quarto がレンダリング時に再生成しようとして壊れる）。
#          旧版は末尾で en/styles.css を symlink に戻していたため，次回ビルドが必ず
#          symlink 状態から始まり事故が再発する構造だった。実体のまま維持する。
#   対策C: ビルド後に docs/en を前回コミットと突き合わせ，リソースが減っていたら
#          コミット・プッシュせずに中断する。壊れた状態を本番に出さないための最後の砦。
#
# 環境変数:
#   COMPILE_PREPARE_ONLY=1  準備段階（対策A・B）まで実行して終了。動作確認用
#   COMPILE_VERIFY_ONLY=1   レンダリングせず，いまの docs/en を検算するだけ
#   COMPILE_NO_PUSH=1       コミットまで行い push しない
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

# --- 対策A: マシン依存の symlink を $HOME 基準で張り直す ---
# これらは .gitignore 済みのローカル専用ファイル。実体は両マシンとも同じ相対位置にある。
echo '== 参照ファイルの張り直し =='
ln -sfn "$HOME/Dropbox/myBiber.bib" jp/myBiber.bib
for x in bbx cbx dbx; do
  ln -sfn "$HOME/Dropbox/Git/biblatex-jpa2/biblatex/jpa2.$x" "jp/jpa2.$x"
done
for f in jp/myBiber.bib jp/jpa2.bbx jp/jpa2.cbx jp/jpa2.dbx; do
  if [ ! -e "$f" ]; then
    echo "  中断: $f の参照先が見つかりません -> $(readlink "$f")"
    exit 1
  fi
done
echo '  jp/ の参照ファイルは解決した'

# --- 対策B: en/ のリソースを実体にする ---
# symlink になっているものだけ実体化する。既に実体のファイルは中身を触らない
# （en/myBiber.bib は英語版用に別管理されている可能性があるため上書きしない）。
echo '== 英語版リソースの実体化 =='
if [ -L en/styles.css ]; then
  rm -f en/styles.css
  cp jp/styles.css en/styles.css
  echo '  en/styles.css を symlink から実体に変換した'
fi
for f in en/styles.css en/myBiber.bib en/cover.png; do
  if [ -L "$f" ]; then echo "  中断: $f が symlink のままです"; exit 1; fi
  if [ ! -e "$f" ]; then echo "  中断: $f がありません"; exit 1; fi
done
echo "  en/ のリソースは実体（styles.css $(stat -f %z en/styles.css) bytes）"

if [ -n "${COMPILE_PREPARE_ONLY:-}" ]; then
  echo 'COMPILE_PREPARE_ONLY のため準備段階で終了'
  exit 0
fi

# --- 検算: 前回コミットと比べて docs/en のリソースが減っていないか ---
count_prev() { git ls-tree -r HEAD --name-only | grep -cE "$1" || true; }
count_now() { find docs/en -type f 2>/dev/null | grep -cE "$1" || true; }

verify_en() {
  local ng=0 pat prev now label
  for pat in '^docs/en/images/' '^docs/en/[^/]*\.csv$' '^docs/en/[^/]*\.html$'; do
    prev=$(count_prev "$pat"); now=$(count_now "$pat")
    case "$pat" in
      *images*) label='画像' ;;
      *csv*) label='データCSV' ;;
      *) label='HTML' ;;
    esac
    printf '  %-10s 前回 %3s → 今回 %3s' "$label" "$prev" "$now"
    if [ "$now" -lt "$prev" ]; then echo '   ← 減っている'; ng=1; else echo '   ok'; fi
  done
  if [ -L docs/en/styles.css ]; then
    echo '  docs/en/styles.css が symlink   ← 異常'; ng=1
  elif [ ! -s docs/en/styles.css ]; then
    echo '  docs/en/styles.css が無い・空   ← 異常'; ng=1
  else
    echo '  docs/en/styles.css は実体       ok'
  fi
  if [ ! -s docs/en/search.json ]; then
    echo '  docs/en/search.json が無い・空  ← 異常'; ng=1
  else
    echo '  docs/en/search.json あり        ok'
  fi
  return $ng
}

if [ -n "${COMPILE_VERIFY_ONLY:-}" ]; then
  echo '== 検算のみ =='
  if verify_en; then echo '検算: 問題なし'; exit 0; else echo '検算: 異常あり'; exit 1; fi
fi

source myenv/bin/activate

# 古いdocsディレクトリを削除
rm -rf docs

# Quarto: 日本語版
cd jp
echo '日本語版レンダリングします'
quarto render
cd ..

# jp/docsディレクトリを一つ上の階層に移動
mv jp/docs docs

# styles.cssをjpディレクトリに戻す
cp docs/styles.css jp/styles.css

# Quarto: 英語版
cd en
echo '英語版レンダリングします'
quarto render
cd ..

# en/docsディレクトリを docs/en に移動
mv en/docs docs/en

# --- 対策B(続き): en/styles.css を実体のまま戻す（symlink にしない） ---
cp -f docs/styles.css en/styles.css

# --- 対策B(続き): Quarto が取りこぼしたリソースを補う ---
# リンクが検出されなかったリソースは docs/en へコピーされない。
echo '== 英語版リソースの補完 =='
mkdir -p docs/en/images
cp -n en/images/* docs/en/images/ 2>/dev/null || true
for f in en/*.csv; do
  [ -e "$f" ] && { cp -n "$f" docs/en/ 2>/dev/null || true; }
done
cp -f en/styles.css docs/en/styles.css

# --- 対策C: 検算に通ってから commit / push ---
echo '== ビルド結果の検算 =='
if ! verify_en; then
  echo ''
  echo '英語版のリソースが前回より減っています。壊れた状態を公開しないため，'
  echo 'コミット・プッシュせずに中断しました。docs/en を確認してください。'
  echo '復旧: git checkout HEAD -- docs/en'
  exit 1
fi

today=$(LANG="ja_JP.UTF-8" date)
git add --all
git commit -m "$today"

if [ -n "${COMPILE_NO_PUSH:-}" ]; then
  echo 'COMPILE_NO_PUSH のため push しません'
  exit 0
fi
git push
