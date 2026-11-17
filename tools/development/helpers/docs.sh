#!/bin/bash

# Apache License 2.0

set -e

project_directory="/app"
docs_directory="${project_directory}/docs"

pushd "${docs_directory}" > /dev/null

help() {
    echo "Usage: ./docs.sh"
    echo "Generate documentation for the project."
}

if [[ $1 == "--help" ]]; then
    help
    exit 0
fi

# Find and use the venv that was created when building the package.
package_directory=(${project_directory}/build/bindings/python/OpenSpaceToolkit*Py-python-package-${OSTK_PYTHON_VERSION})
export VIRTUAL_ENV="${package_directory[0]}/.venv"

uv pip install -r requirements.txt

if [[ $1 == "--notebooks" ]]; then
    # Deprecated: notebooks now live in each component repository (tutorials/python/notebooks)
    # and are referenced directly from its docs. Accepted for backward compatibility.
    echo "Warning: --notebooks is deprecated and ignored."
fi

uv run breathe-apidoc -o cpp_rst xml -g class

uv run sphinx-build -j $(nproc) -b html . _build/html

popd > /dev/null
