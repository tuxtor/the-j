#!/bin/bash

cd build/output

rm -Rf cv
git clone --depth=1 https://github.com/tuxtor/resume.git cv

ls -Ra
rm -Rf cv/.git
rm -Rf cv/.gitignore
ls -Ra
