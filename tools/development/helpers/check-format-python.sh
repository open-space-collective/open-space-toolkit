#!/usr/bin/env bash

# Apache License 2.0

pushd "${PYTHON_WD}" > /dev/null

    uv run black --check --diff . \
    || exit 1

popd > /dev/null
