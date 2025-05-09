#!/usr/bin/bash
source myenv/bin/activate

# 古いdocsディレクトリを削除
rm -rf docs

# Quarto
cd jp
echo '日本語版レンダリングします'
quarto render
cd ..
shopt -s dotglob
mv jp/docs/* docs/
shopt -u dotglob

today=$(LANG="ja_JP.UTF-8" date)
git add --all
git commit -m "$today"
git push

