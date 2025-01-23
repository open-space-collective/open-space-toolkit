#!/usr/bin/env bash

# Apache License 2.0

project_directory="$(git rev-parse --show-toplevel)"

pushd "${project_directory}" > /dev/null

    python${OSTK_PYTHON_VERSION} -m black --check --diff bindings/python/

eval "popd > /dev/null; exit $?" # eval so $? is still the exit code of python rather than popd
