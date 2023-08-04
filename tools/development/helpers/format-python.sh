#!/usr/bin/env bash

# Apache License 2.0

project_directory="$(git rev-parse --show-toplevel)"

pushd "${project_directory}" > /dev/null

    python3.11 -m black --line-length=90 bindings/python/

popd > /dev/null
