#!/usr/bin/env bash

# Apache License 2.0

py_version=$(echo "${OSTK_PYTHON_VERSION}" | sed 's/\.//')

project_directory="$(git rev-parse --show-toplevel)"
python_directory="${project_directory}/build/bindings/python/OpenSpaceToolkit*Py-python-package-${OSTK_PYTHON_VERSION}"

pushd ${python_directory} > /dev/null

python${OSTK_PYTHON_VERSION} -m pip install plotly pandas
python${OSTK_PYTHON_VERSION} -m pip install git+https://github.com/open-space-collective/cesiumpy
python${OSTK_PYTHON_VERSION} -m pip install . --force-reinstall

popd > /dev/null

for dep in ${deps}
do

    echo "Installing ${dep} Python package..."

    dep_underscore=$(echo ${dep} | tr '-' '_' | sed 's/\/$//')

    python${OSTK_PYTHON_VERSION} -m pip install /usr/local/share/${dep_underscore}-*-py${py_version}-*.whl --quiet --force-reinstall;

done
