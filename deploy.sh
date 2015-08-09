#!/bin/bash

set -o errexit -o nounset

rev=$(git rev-parse --short HEAD)

cd build/jbake

git clone https://github.com/tuxtor/resume.git cv

ls -Ra
rm -Rf cv/.git
ls -Ra

git init
git config user.name "Víctor Orozco"
git config user.email "tuxtor@shekalug.org"

git remote add upstream "https://08a15a298d2049a8334855f5c7fb935410270cce@github.com/tuxtor/the-j.git"
git fetch upstream
git reset upstream/gh-pages

echo "vorozco.com" > CNAME

touch .

git add -A .
git commit -m "rebuild pages at ${rev}"
git push -q upstream HEAD:gh-pages