#!/bin/bash
# See https://medium.com/@nthgergo/publishing-gh-pages-with-travis-ci-53a8270e87db
set -o xtrace
set -o errexit

declare -r SSH_FILE="$(mktemp -u $HOME/.ssh/XXXXX)"
openssl aes-256-cbc \
    -K $encrypted_0e3c8325209d_key \
    -iv $encrypted_0e3c8325209d_iv \
    -in ".travis/travis-integration-key.enc" \
    -out "$SSH_FILE" -d

chmod 600 "$SSH_FILE" \
    && printf "%s\n" \
    "Host github.com" \
    "  IdentityFile $SSH_FILE" \
    "  LogLevel ERROR" >> ~/.ssh/config

# config
git config --global user.email "naosuke@ntt.dev"
git config --global user.name "Travis CI"

# deploy
mkdir -p tmp/01
mkdir -p tmp/02
mkdir -p tmp/03
mkdir -p tmp/04
cp README.md tmp/
cd 01
mv *.html assets images ../tmp/01
cd ../02
mv *.html assets images ../tmp/02
cd ../03
mv *.html assets images ../tmp/03
cd ../04
mv *.html images css script ../tmp/04
cd ../tmp
git init
git add :/
git commit -m "Automatic build by Travis CI"
git push git@github.com:${GITHUB_REPO}.git master:gh-pages -f
