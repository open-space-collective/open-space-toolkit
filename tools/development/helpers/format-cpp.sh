#!/usr/bin/env bash

# Apache License 2.0

project_directory="$(git rev-parse --show-toplevel)"

pushd "${project_directory}" > /dev/null

    clang-format -i -style=file:thirdparty/clang/.clang-format $(find ~+ src/ include/ test/ bindings/python/src/ -name '*.cpp' -o -name '*.cxx' -o -name '*.hpp' -o -name '*.tpp') \
    || exit 1

popd > /dev/null
