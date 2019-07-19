#!/bin/bash

[[ ! -f "/Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg" ] || sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
./buttler info
./buttler build-tap
./buttler upload
./buttler push