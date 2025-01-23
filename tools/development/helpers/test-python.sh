#!/usr/bin/env bash

# Apache License 2.0

project_directory="$(git rev-parse --show-toplevel)"
test_directory="${project_directory}/bindings/python/test"

pushd "${test_directory}" > /dev/null

python${OSTK_PYTHON_VERSION} -m pytest -sv ${@}

eval "popd > /dev/null; exit $?" # eval so $? is still the exit code of python rather than popd
