#!/bin/bash

set -o errexit -o nounset

rev=$(git rev-parse --short HEAD)

cd build/jbake

git init
git config user.name "Víctor Orozco"
git config user.email "tuxtor@shekalug.org"

git remote add upstream "https://tuxtor@github.com/tuxtor/the-j.git"
git fetch upstream
git reset upstream/gh-pages

echo "vorozco.com" > CNAME

touch .

git add -A .
git commit -m "rebuild pages at ${rev}"
git push -q upstream HEAD:gh-pages