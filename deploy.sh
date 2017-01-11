#!/bin/bash
# See https://medium.com/@nthgergo/publishing-gh-pages-with-travis-ci-53a8270e87db
# set -o errexit

# config
git config --global user.email "nobody@nobody.org"
git config --global user.name "Travis CI"

# build
npm run build

# deploy
mkdir tmp
mv *.html assets tmp
cd tmp
git init
git add *.html assets
git commit -m "Automatic build by Travis CI"
git push git@github.com:${GITHUB_REPO}.git master:gh-pages-test -f
