#!/usr/bin/env bash

# Apache License 2.0

pushd "${PYTHON_WD}" > /dev/null

    uv run black . \
    || exit 1

popd > /dev/null
