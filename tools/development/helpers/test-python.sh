#!/usr/bin/env bash

# Apache License 2.0

test_directory="/app/build/bindings/python/OpenSpaceToolkit*Py-python-package-${OSTK_PYTHON_VERSION}/ostk/*/test"

pushd ${test_directory} > /dev/null

    uv run pytest -sv ${@} \
    || exit 1

popd > /dev/null
