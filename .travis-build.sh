#!/bin/bash

[[ ! -f "/Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg" ]] || sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /

git config --global user.name "Buttler@TravisCI"
git config --global user.email buttler@travis-ci.org

export GIT_BRANCH="$TRAVIS_BRANCH"

./buttler info
./buttler build-tap
./buttler upload
./buttler push