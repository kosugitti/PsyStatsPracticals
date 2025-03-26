#!/usr/bin/bash
source myenv/bin/activate

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

