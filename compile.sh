#!/usr/bin/bash
source myenv/bin/activate

# Quarto
cd jp
echo '日本語版レンダリングします'
quarto render
cd ..
cp -r jp/docs/* ../docs/jp/

echo '<!DOCTYPE html>
<html lang="en">
<head>
  <meta http-equiv="refresh" content="0; url=../index.html">
  <title>Redirecting...</title>
</head>
<body>
  <p>If you are not redirected automatically, follow this <a href="/docs/jp/index.html">link to the new location</a>.</p>
</body>
</html>' > docs/jp/docs/index.html
echo "Created redirecting index.html in docs/jp/docs/"

today=$(LANG="ja_JP.UTF-8" date)
git add --all
git commit -m "$today"
git push

