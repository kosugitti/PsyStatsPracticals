#!/usr/bin/bash
source myenv/bin/activate

# 古いdocsディレクトリを削除
rm -rf docs

# Quarto
cd jp
echo '日本語版レンダリングします'
quarto render
cd ..

# jp/docsディレクトリを一つ上の階層に移動
mv jp/docs docs

# styles.cssをjpディレクトリに戻す
cp docs/styles.css jp/styles.css

today=$(LANG="ja_JP.UTF-8" date)
git add --all
git commit -m "$today"
git push

