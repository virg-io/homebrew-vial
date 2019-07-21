#!/bin/bash

[[ ! -f "/Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg" ]] || sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /

git config --global user.name "Buttler@TravisCI"
git config --global user.email "buttler@travis-ci.org"

GIT_ORIGIN_URI_OLD="$(git remote get-url origin)"
GIT_ORIGIN_URI_NEW="$(echo "$GIT_ORIGIN_URI_OLD" | sed -E 's~https://github.com/|(ssh\://)?git@github.com\:~https://'"$GITHUB_USERNAME:$GITHUB_TOKEN"'@github.com/~g')"

echo "Rewriting git origin to use token: $GIT_ORIGIN_URI_OLD -> $GIT_ORIGIN_URI_NEW"

git remote set-url origin "$GIT_ORIGIN_URI_NEW"

export GIT_BRANCH="$TRAVIS_BRANCH"

./buttler info
./buttler build-tap
./buttler upload
./buttler push