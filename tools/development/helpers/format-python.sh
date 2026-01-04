#!/usr/bin/env bash

# Apache License 2.0

project_directory="$(git rev-parse --show-toplevel)"

pushd "${project_directory}" > /dev/null

    "${OSTK_VIRTUAL_ENV}/bin/python" -m black bindings/python/ \
    || exit 1

popd > /dev/null
