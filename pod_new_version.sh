#!/bin/bash
set -x
if ! $1 ; then
    echo "need a version number";
    exit 1;
fi
gcam "bump up version" && git push && git tag $1 && git push --tags && pod trunk push --allow-warnings
