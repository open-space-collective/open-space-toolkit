#!/usr/bin/env bash

# Apache License 2.0

py_version=$(echo "${OSTK_PYTHON_VERSION}" | sed 's/\.//')

project_directory="$(git rev-parse --show-toplevel)"
python_directory="${project_directory}/build/bindings/python/OpenSpaceToolkit*Py-python-package-${OSTK_PYTHON_VERSION}"

# Use the "global" pre-created venv
export VIRTUAL_ENV=${OSTK_VIRTUAL_ENV}

pushd ${python_directory} > /dev/null

uv pip install .

popd > /dev/null

# Used in OSTk's linked mode
for dep in ${deps}
do

    echo "Installing ${dep} Python package..."

    dep_underscore=$(echo ${dep} | tr '-' '_' | sed 's/\/$//')

    uv pip install /usr/local/share/${dep_underscore}-*-py${py_version}-*.whl --quiet --force-reinstall;

done
