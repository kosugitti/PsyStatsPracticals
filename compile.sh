#!/usr/bin/bash
source myenv/bin/activate
# 翻訳
echo $(date)
cd develop
echo '翻訳します'
python3 TransText.py
deactivate
cd ..
# Quarto
cd jp
echo '日本語版レンダリングします'
quarto render
cd ..

cd en
echo '英語版レンダリングします'
quarto render
cd ..

today=$(LANG="ja_JP.UTF-8" date)
git add --all
git commit -m "$today"
git push

