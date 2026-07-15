#!/usr/bin/env bash

# Apache License 2.0

py_version=$(echo "${OSTK_PYTHON_VERSION}" | sed 's/\.//')

project_directory="$(git rev-parse --show-toplevel)"
python_directory="${project_directory}/build/bindings/python/OpenSpaceToolkit*Py-python-package-${OSTK_PYTHON_VERSION}"

pushd ${python_directory} > /dev/null

uv sync --all-extras
uv pip install "cesiumpy @ git+https://github.com/open-space-collective/cesiumpy@0.4.1" # TBR: after https://github.com/open-space-collective/open-space-toolkit/issues/183

popd > /dev/null

# Used in OSTk's linked mode
for dep in ${deps}
do

    echo "Installing ${dep} Python package..."

    dep_underscore=$(echo ${dep} | tr '-' '_' | sed 's/\/$//')

    uv pip install /usr/local/share/${dep_underscore}-*-cp${py_version}-*.whl --quiet --force-reinstall;

done
