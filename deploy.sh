#!/bin/bash
# See https://medium.com/@nthgergo/publishing-gh-pages-with-travis-ci-53a8270e87db
set -o xtrace
set -o errexit

declare -r SSH_FILE="$(mktemp -u $HOME/.ssh/XXXXX)"
openssl aes-256-cbc \
    -K $encrypted_ad39244f6d19_key \
    -iv $encrypted_ad39244f6d19_iv \
    -in ".travis/github_deploy_key.enc" \
    -out "$SSH_FILE" -d

chmod 600 "$SSH_FILE" \
    && printf "%s\n" \
    "Host github.com" \
    "  IdentityFile $SSH_FILE" \
    "  LogLevel ERROR" >> ~/.ssh/config

# config
git config --global user.email "rintyo_@hotmail.com"
git config --global user.name "Travis CI"

# deploy
mkdir -p tmp/01
mkdir -p tmp/02
cp README.md tmp/
cd 01
mv *.html assets images ../tmp/01
cd ../02
mv *.html assets images ../tmp/02
cd ../tmp
git init
git add :/
git commit -m "Automatic build by Travis CI"
git push git@github.com:${GITHUB_REPO}.git master:gh-pages -f
