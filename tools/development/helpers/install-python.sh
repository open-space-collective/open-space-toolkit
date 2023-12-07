#!/usr/bin/env bash

# Apache License 2.0

PYTHON_VERSION="3.11"

py_version=$(echo "${PYTHON_VERSION}" | sed 's/\.//')

project_directory="$(git rev-parse --show-toplevel)"
python_directory="${project_directory}/build/bindings/python/OpenSpaceToolkit*Py-python-package-${PYTHON_VERSION}"

pushd ${python_directory} > /dev/null

python${PYTHON_VERSION} -m pip install plotly pandas
python${PYTHON_VERSION} -m pip install git+https://github.com/lucas-bremond/cesiumpy.git#egg=cesiumpy
python${PYTHON_VERSION} -m pip install . --force-reinstall

popd > /dev/null

for dep in ${deps}
do

    echo "Installing ${dep} Python package..."

    dep_underscore=$(echo ${dep} | tr '-' '_' | sed 's/\/$//')

    python${PYTHON_VERSION} -m pip install /usr/local/share/${dep_underscore}-*-py${py_version}-*.whl --quiet --force-reinstall;

done
