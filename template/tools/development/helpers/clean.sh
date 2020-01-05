#!/bin/bash

################################################################################################################################################################

# @project        Open Space Toolkit
# @file           tools/development/helpers/clean.sh
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

project_directory="$(git rev-parse --show-toplevel)"

pushd "${project_directory}" > /dev/null

rm -rf ./build/*
rm -rf ./bin/*.exe
rm -rf ./bin/*.test
rm -rf ./bin/*.test-*
rm -rf ./docs/html
rm -rf ./docs/latex
rm -rf ./lib/*.so
rm -rf ./lib/*.so.*

popd > /dev/null

################################################################################################################################################################
