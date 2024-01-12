#!/usr/bin/env bash

# Apache License 2.0

project_directory="$(git rev-parse --show-toplevel)"

pushd "${project_directory}" > /dev/null

if [[ -z ${1} ]]; then
    ./bin/*.validation
else
    ./bin/*.validation --gtest_filter=${1}
fi

popd > /dev/null
