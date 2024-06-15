#!/usr/bin/bash
source myenv/bin/activate

cp -rf ./docs ./docs_old
rm -rf ./docs
# Quarto
cd jp
echo '日本語版レンダリングします'
quarto render
mv -f ./docs ../

today=$(LANG="ja_JP.UTF-8" date)
git add --all
git commit -m "$today"
git push

