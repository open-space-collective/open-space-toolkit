#!/usr/bin/env bash

# Apache License 2.0

project_directory="$(git rev-parse --show-toplevel)"

pushd "${project_directory}" > /dev/null

find ./build -mindepth 1 -delete

rm -rf ./bin/*.exe
rm -rf ./bin/*.test
rm -rf ./bin/*.test-*
rm -rf ./docs/html
rm -rf ./docs/latex
rm -rf ./docs/xml
rm -rf ./docs/_build
rm -rf ./docs/_autosummary
rm -rf ./docs/_notebooks
rm -rf ./docs/cpp_rst
rm -rf ./lib/*.so
rm -rf ./lib/*.so.*

popd > /dev/null
