#!/usr/bin/bash
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

# styles.cssをenディレクトリに戻す（symlinkなのでターゲットを更新しないように一旦削除→再リンク）
rm -f en/styles.css
ln -s ../jp/styles.css en/styles.css

today=$(LANG="ja_JP.UTF-8" date)
git add --all
git commit -m "$today"
git push
