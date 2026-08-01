#!/usr/bin/env bash
# 日英両版のフルビルド → 検算 → コミット・プッシュ
#
# shebang は env 経由にしてある。macOS に /usr/bin/bash は無く（/bin/bash のみ），
# 元の #!/usr/bin/bash では ./compile.sh が bad interpreter で起動しなかった。
#
# 過去に踏んだ事故への対策が入っている。理解せずに削らないこと。
#
#   対策A: jp/ の myBiber.bib と jpa2.* は symlink だが，かつて絶対パスで張られていたため
#          もう一方のマシンでは切れていた。Dropbox は symlink そのものを同期するので，
#          絶対パスだと必ずどちらか一方で壊れる。**相対パスで張る**のが正解。
#   対策B: en/ のリソースは symlink 不可（Quarto がレンダリング時に再生成しようとして壊れる）。
#          旧版は末尾で en/styles.css を symlink に戻していたため，次回ビルドが必ず
#          symlink 状態から始まり事故が再発する構造だった。実体のまま維持する。
#   対策C: ビルド後に docs/en を前回コミットと突き合わせ，リソースが減っていたら
#          コミット・プッシュせずに中断する。壊れた状態を本番に出さないための最後の砦。
#   対策D: レンダリングが両方成功するまで公開中の docs/ を消さない。
#          旧版は先頭で rm -rf docs していたため，途中で失敗すると公開物が消えた。
#   対策E: jp/ en/ に残る他マシン製の Stan バイナリを削除する。rpath が焼き込まれており
#          別マシンでは「Fitting failed」で落ちる（2026-08-01のフルビルドで実際に踏んだ）。
#
# 環境変数:
#   COMPILE_PREPARE_ONLY=1  準備段階（対策A・B）まで実行して終了。動作確認用
#   COMPILE_VERIFY_ONLY=1   レンダリングせず，いまの docs/en を検算するだけ
#   COMPILE_NO_COMMIT=1     ビルドと検算まで行い，コミットもプッシュもしない
#   COMPILE_NO_PUSH=1       コミットまで行い push しない
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

# --- 前提の確認 ---
command -v quarto >/dev/null || { echo '中断: quarto が見つかりません'; exit 1; }
command -v Rscript >/dev/null || { echo '中断: Rscript が見つかりません'; exit 1; }
[ -f myenv/bin/activate ] || { echo '中断: myenv/bin/activate がありません'; exit 1; }

# --- 対策A: 参照ファイルの symlink を相対パスで張る ---
# これらは .gitignore 済みのローカル専用ファイルだが，Dropbox はリンク自体を同期する。
# 絶対パスで張ると /Users/<マシン名>/ が焼き込まれ，もう一方のマシンで必ず切れる。
# 相対パスならユーザ名に依存せず，同期を跨いでも成立する。
echo '== 参照ファイルの張り直し =='
link_rel() { # $1=リンクを置く場所 $2=相対ターゲット $3=絶対フォールバック
  local link="$1" rel="$2" abs="$3"
  ln -sfn "$rel" "$link"
  if [ -e "$link" ]; then return 0; fi
  # リポジトリを ~/Dropbox/Git/ 以外に置いた場合の逃げ道
  ln -sfn "$abs" "$link"
  [ -e "$link" ]
}
link_rel jp/myBiber.bib ../../../myBiber.bib "$HOME/Dropbox/myBiber.bib" ||
  { echo '中断: myBiber.bib の参照先が見つかりません'; exit 1; }
for x in bbx cbx dbx; do
  link_rel "jp/jpa2.$x" "../../biblatex-jpa2/biblatex/jpa2.$x" \
    "$HOME/Dropbox/Git/biblatex-jpa2/biblatex/jpa2.$x" ||
    { echo "中断: jpa2.$x の参照先が見つかりません"; exit 1; }
done
for f in jp/myBiber.bib jp/jpa2.bbx jp/jpa2.cbx jp/jpa2.dbx; do
  printf '  %-16s -> %s\n' "$(basename "$f")" "$(readlink "$f")"
done

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
  [ -L "$f" ] && { echo "  中断: $f が symlink のままです"; exit 1; }
  [ -e "$f" ] || { echo "  中断: $f がありません"; exit 1; }
done
echo "  en/ のリソースは実体（styles.css $(stat -f %z en/styles.css) bytes）"

# --- 対策E: 他マシンでコンパイルされた Stan バイナリを削除する ---
# cmdstan の実行ファイルは rpath をビルドしたマシンの絶対パスで焼き込むため，
# 別マシンでは @rpath/libtbb.dylib を解決できず「Fitting failed」で落ちる。
# .stan と同名の拡張子なし実行ファイルとして jp/ en/ に残るが git 管理外なので消してよい。
echo '== 他マシン製 Stan バイナリの掃除 =='
purged=0
for d in jp en; do
  for f in "$d"/*; do
    [ -f "$f" ] || continue
    case "$f" in *.*) continue ;; esac   # 拡張子つきは対象外
    if file -b "$f" | grep -q 'Mach-O'; then
      if [ -n "$(git ls-files "$f")" ]; then continue; fi   # 追跡下なら触らない
      rm -f "$f"; purged=$((purged + 1))
      echo "  削除: $f"
    fi
  done
done
if [ "$purged" -eq 0 ]; then echo '  残骸なし'; fi

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

# shellcheck disable=SC1091
source myenv/bin/activate

# --- 対策D: 両方のレンダリングが成功してから docs/ を差し替える ---
# 旧版は先頭で rm -rf docs していたため，途中で失敗すると公開物が消えた。
rm -rf jp/docs en/docs

echo '== 日本語版レンダリング =='
( cd jp && quarto render )
[ -d jp/docs ] || { echo '中断: jp/docs が生成されませんでした'; exit 1; }

# styles.css をソース側に戻す（レンダリングで出力側へ移るため）
[ -f jp/styles.css ] || cp jp/docs/styles.css jp/styles.css

echo '== 英語版レンダリング =='
( cd en && quarto render )
[ -d en/docs ] || { echo '中断: en/docs が生成されませんでした'; exit 1; }

echo '== docs/ の差し替え =='
rm -rf docs
mv jp/docs docs
mv en/docs docs/en

# --- 対策B(続き): en/styles.css は実体のまま維持する（symlink に戻さない） ---
cp -f docs/styles.css en/styles.css

# --- 対策B(続き): Quarto が取りこぼしたリソースを補う ---
# リンクを検出できなかったリソースは出力側へコピーされない。
echo '== リソースの補完 =='
mkdir -p docs/en/images
# 画像形式だけを補う。.drawio のような編集元ファイルは公開しない
for f in en/images/*.png en/images/*.jpg en/images/*.jpeg en/images/*.gif en/images/*.svg; do
  [ -e "$f" ] && { cp -n "$f" docs/en/images/ 2>/dev/null || true; }
done
for f in en/*.csv; do
  [ -e "$f" ] && { cp -n "$f" docs/en/ 2>/dev/null || true; }
done
for f in jp/*.csv; do
  [ -e "$f" ] && { cp -n "$f" docs/ 2>/dev/null || true; }
done
cp -f en/styles.css docs/en/styles.css

# --- 対策C: 検算に通ってから commit / push ---
echo '== ビルド結果の検算 =='
if ! verify_en; then
  echo ''
  echo '英語版のリソースが前回より減っています。壊れた状態を公開しないため，'
  echo 'コミット・プッシュせずに中断しました。docs/en を確認してください。'
  echo '復旧: git checkout HEAD -- docs'
  exit 1
fi

if [ -n "${COMPILE_NO_COMMIT:-}" ]; then
  echo 'COMPILE_NO_COMMIT のためコミットしません。git status で差分を確認してください'
  exit 0
fi

today=$(LANG="ja_JP.UTF-8" date)
git add --all
git commit -m "$today"

if [ -n "${COMPILE_NO_PUSH:-}" ]; then
  echo 'COMPILE_NO_PUSH のため push しません'
  exit 0
fi
git push
